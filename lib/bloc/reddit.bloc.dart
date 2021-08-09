import 'dart:convert';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/secrets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

class RedditController extends GetxController {
  RxList feedPosts = [].obs;
  RxMap<String, dynamic> options = {
    'after': '',
    'listing': 'hot',
    'subreddit': 'frontpage',
    'subscribed': [],
    'time': 'week',
  }.obs;

  /// Gets the initial posts for the subreddit stored in the options map.
  /// Returns a bool so a FutureBuilder knows when it's finished.
  Future<bool> getInitPosts({required int limit}) async {
    // Setting after option to empty so first page is returned.
    this.options['after'] = '';

    var posts = await _getPosts(limit, this.options);
    feedPosts.value = posts;

    return true;
  }

  /// Adds posts to the [feedPosts] list after the last pagination page.
  void getNextPosts({required int limit}) async {
    var posts = await _getPosts(limit, this.options);

    posts.removeWhere((post) => feedPosts.contains(post));
    feedPosts.addAll(posts);
  }

  /// Returns the [score] int as a concatinated String (e.g. 3000 => "3k").
  /// Anything that's less than 4 digits long returns as a unconcatinated String.
  String getScoreString(int score) {
    if (score.isGreaterThan(999)) {
      String str = score.toString();
      return '${str.substring(0, str.length - 3)}k';
    } else {
      return score.toString();
    }
  }

  /// Fetches the subreddits for the logged in user.
  Future<bool> getUserSubreddits() async {
    HTTP.Response resp = await _get('/subreddits/mine/subscriber');

    Map<String, dynamic> _json = jsonDecode(resp.body);
    List subreddits = _json['data']['children']
        .map((s) => Subreddit.fromJson(s['data']))
        .toList();

    this.options['subscribed'] = subreddits;
    return true;
  }
}

Future<HTTP.Response> _get(String endpoint) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getString('access_token') != null;

  // Requests need to be made to different URl dependeding on auth state.
  String baseUrl = isLoggedIn ? 'oauth.reddit.com' : 'www.reddit.com';

  Map<String, String> headers = {
    'User-Agent': userAgent,
  };

  // Add bearer auth to header if token exists.
  if (isLoggedIn) {
    headers['Authorization'] = 'bearer ${prefs.getString('access_token')}';
  }

  Uri url = Uri.parse('https://$baseUrl$endpoint');
  HTTP.Response resp = await HTTP.get(url, headers: headers);

  return resp;
}

Future _getPosts(int limit, Map<String, dynamic> options) async {
  HTTP.Response resp;

  // Fetch the default route json if subreddit is 'frontpage'.
  if (options['subreddit'] == 'frontpage') {
    resp = await _get(
      '/.json' +
          '?limit=$limit' +
          '&after=${options['after']}', // [after] param being empty returns first page.
    );
  } else {
    resp = await _get(
      '/r/${options['subreddit']}/' +
          '${options['listing']}.json' +
          '?limit=$limit' +
          '&t=${options['time']}' +
          '&after=${options['after']}', // [after] param being empty returns first page.
    );
  }

  Map<String, dynamic> _json = jsonDecode(resp.body);
  options['after'] = _json['data']['after'];

  List posts = _json['data']['children']
      .map((p) => RedditPost.fromJson(p['data']))
      .toList();

  return posts;
}

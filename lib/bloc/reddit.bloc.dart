import 'dart:convert';
import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/secrets.dart';
import 'package:http/http.dart' as HTTP;
import 'package:shared_preferences/shared_preferences.dart';

class RedditController extends GetxController {
  Future<Map<String, dynamic>> getPosts({
    required String after,
    required int limit,
    required String listing,
    required String subreddit,
    required String time,
  }) async {
    HTTP.Response resp;

    // Fetch the default route json if subreddit is 'frontpage'.
    if (subreddit == 'frontpage') {
      resp = await _get(
        '/.json' +
            '?limit=$limit' +
            '&after=$after', // [after] param being empty returns first page.
      );
    } else {
      resp = await _get(
        '/r/$subreddit/' +
            '$listing.json' +
            '?limit=$limit' +
            '&t=$time' +
            '&after=$after', // [after] param being empty returns first page.
      );
    }

    Map<String, dynamic> _json = jsonDecode(resp.body);
    List posts = _json['data']['children']
        .map((p) => RedditPost.fromJson(p['data']))
        .toList();

    final Map<String, dynamic> response = {
      'after': _json['data']['after'],
      'posts': posts
    };

    return response;
  }

  Future<List<dynamic>> getPostComments({
    required String subreddit,
    required String postId,
  }) async {
    HTTP.Response _resp = await _get('/r/$subreddit/comments/$postId');
    List<dynamic> _json = jsonDecode(_resp.body);

    print('Loaded post: $subreddit $postId');

    final List<dynamic> repliesJson = _json[1]['data']['children'];
    repliesJson.removeWhere((e) => e['kind'] == 'more');

    final List<dynamic> comments = repliesJson
        .map(
          (s) => Comment.fromJson(s['data']),
        )
        .toList();

    return comments;
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
  Future getUserSubreddits() async {
    try {
      // TODO: Add pagination handling as better solution
      HTTP.Response _resp = await _get('/subreddits/mine/subscriber?limit=500');

      Map<String, dynamic> _json = jsonDecode(_resp.body);
      List subreddits = _json['data']['children']
          .map((s) => Subreddit.fromJson(s['data']))
          .toList();

      subreddits.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );

      return subreddits;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<dynamic>> searchSubreddits({required String query}) async {
    final HTTP.Response _resp = await _get('/subreddits/search?q=$query');

    Map<String, dynamic> _json = jsonDecode(_resp.body);

    List filteredSubs = _json['data']['children'];
    filteredSubs.removeWhere((f) => f['data']['subreddit_type'] == 'private');

    List subreddits =
        filteredSubs.map((s) => Subreddit.fromJson(s['data'])).toList();

    return subreddits;
  }

  Future<bool> subscribe(String subredditFullName) async {
    final HTTP.Response _resp = await _post(
      '/api/subscribe?sr=$subredditFullName&action=sub&skip_initial_defaults=true',
      null,
    );

    if (_resp.statusCode == 200) {
      await this.getUserSubreddits();
    }

    return _resp.statusCode == 200;
  }

  Future<bool> unsubscribe(String subredditFullName) async {
    final FrontpageController frontpage = Get.find();

    final HTTP.Response _resp = await _post(
      '/api/subscribe?sr=$subredditFullName&action=unsub',
      null,
    );

    if (_resp.statusCode == 200) {
      frontpage.subscriptions
          .removeWhere((s) => s.fullName == subredditFullName);
    }

    return _resp.statusCode == 200;
  }
}

Future<HTTP.Response> _get(String endpoint) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  HTTP.Response resp;
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
  resp = await HTTP.get(url, headers: headers);

  if (resp.statusCode == 401) {
    final AuthController auth = Get.find();
    await auth.refreshAuthToken();
    resp = await HTTP.get(url, headers: headers);
  }

  print(prefs.getString('access_token'));
  return resp;
}

Future<HTTP.Response> _post(String endpoint, Map? body) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  HTTP.Response _resp;
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

  if (body != null) {
    _resp = await HTTP.post(url, headers: headers, body: body);
  } else {
    _resp = await HTTP.post(url, headers: headers);
  }

  if (_resp.statusCode == 401) {
    final AuthController auth = Get.find();
    await auth.refreshAuthToken();
    _resp = await HTTP.get(url, headers: headers);
  }

  return _resp;
}

import 'dart:convert';
import 'package:fluddit/models/index.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as HTTP;

class RedditController extends GetxController {
  RxList feedPosts = [].obs;
  RxMap<String, dynamic> options = {
    'after': '',
    'listing': 'hot',
    'subreddit': 'popular',
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
}

Future _getPosts(int limit, Map<String, dynamic> options) async {
  String postUrl = 'https://www.reddit.com/r/${options['subreddit']}/' +
      '${options['listing']}.json' +
      '?limit=$limit' +
      '&t=${options['time']}' +
      '&after=${options['after']}'; // after param being empty returns first page.

  Uri url = Uri.parse(postUrl);
  HTTP.Response resp = await HTTP.get(url);

  Map<String, dynamic> parsedResp = jsonDecode(resp.body);
  options['after'] = parsedResp['data']['after'];

  var posts = parsedResp['data']['children']
      .map((p) => RedditPost.fromJson(p['data']))
      .toList();

  return posts;
}

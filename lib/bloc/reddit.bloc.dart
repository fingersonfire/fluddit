import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as HTTP;

class RedditController extends GetxController {
  TextEditingController userController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  RxString subreddit = 'popular'.obs;
  RxString listing = 'hot'.obs;
  RxList feedPosts = [].obs;
  String after = '';

  void getSubredditPosts({
    required int limit,
    String time = 'week',
  }) async {
    try {
      Uri url = Uri.parse(
        'https://www.reddit.com/r/${this.subreddit.value}/${this.listing.value}.json?limit=$limit&t=$time&t=$time',
      );
      HTTP.Response resp = await HTTP.get(url);

      Map<String, dynamic> parsedResp = jsonDecode(resp.body);
      after = parsedResp['data']['after'];

      List<dynamic> posts = parsedResp['data']['children']
          .map((p) => RedditPost.fromJson(p['data']))
          .toList();

      feedPosts.value = posts;
      after = parsedResp['data']['after'];
    } catch (e) {}
  }

  String getScoreString(int score) {
    if (score.isGreaterThan(999)) {
      String str = score.toString();
      return '${str.substring(0, str.length - 3)}k';
    } else {
      return score.toString();
    }
  }

  void getNextPosts({
    required int limit,
    String time = 'week',
  }) async {
    Uri url = Uri.parse(
      'https://www.reddit.com/r/${this.subreddit.value}/${this.listing.value}.json?limit=$limit&t=$time&after=$after',
    );
    HTTP.Response resp = await HTTP.get(url);

    Map<String, dynamic> parsedResp = jsonDecode(resp.body);

    List<dynamic> posts = parsedResp['data']['children']
        .map((p) => RedditPost.fromJson(p['data']))
        .toList();

    posts.removeWhere((post) => feedPosts.contains(post));

    feedPosts.addAll(posts);
    after = parsedResp['data']['after'];
  }
}

class RedditPost {
  final String author;
  final bool saved;
  final int score;
  final bool stickied;
  final String subreddit;
  final String thumbnail;
  final String title;

  RedditPost({
    required this.author,
    required this.saved,
    required this.score,
    required this.stickied,
    required this.subreddit,
    required this.thumbnail,
    required this.title,
  });

  factory RedditPost.fromJson(Map<String, dynamic> json) {
    return RedditPost(
      author: json['author'],
      saved: json['saved'],
      score: json['score'],
      stickied: json['stickied'],
      subreddit: json['subreddit'],
      thumbnail: json['thumbnail'],
      title: json['title'],
    );
  }
}

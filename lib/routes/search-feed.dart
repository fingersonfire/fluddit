import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/feed/post.list.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchFeed extends StatelessWidget {
  SearchFeed({Key? key, required this.subreddit}) : super(key: key);

  final Subreddit subreddit;

  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.indigo[300],
        brightness: Brightness.dark,
        centerTitle: true,
        title: Column(
          children: [
            Text(subreddit.name),
          ],
        ),
        actions: [
          SubscribeButton(subreddit: subreddit),
        ],
      ),
      body: FeedPosts(),
    );
  }
}

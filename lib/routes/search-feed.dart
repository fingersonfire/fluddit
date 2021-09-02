import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/feed/post.list.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchFeed extends StatelessWidget {
  SearchFeed({Key? key, required this.subreddit}) : super(key: key);

  final Subreddit subreddit;

  final ComponentController component = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Obx(
          () => AppBar(
            backgroundColor: Color(component.accentColor.value),
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
        ),
      ),
      body: FeedPosts(),
    );
  }
}

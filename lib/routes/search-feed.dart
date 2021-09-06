import 'package:fluddit/components/feed/post.list.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';

class SearchFeed extends StatelessWidget {
  const SearchFeed({Key? key, required this.subreddit}) : super(key: key);

  final Subreddit subreddit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Theme.of(context).accentColor,
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

import 'package:fluddit/bloc/reddit.bloc.dart';
import 'package:fluddit/routes/feed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(RedditController());
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'fluddit',
      home: Scaffold(
        body: Feed(
          listing: 'hot',
          subreddit: 'flutter',
        ),
      ),
    );
  }
}

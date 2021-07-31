import 'package:fluddit/bloc/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar topAppBar(
  RedditController reddit,
) {
  return AppBar(
    toolbarHeight: 35,
    backgroundColor: Colors.indigo[300],
    brightness: Brightness.dark,
    centerTitle: true,
    title: Obx(() => Text(reddit.subreddit.value)),
    leading: Container(),
  );
}

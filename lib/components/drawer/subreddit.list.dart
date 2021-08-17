import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';

class SubredditList extends StatelessWidget {
  SubredditList({Key? key}) : super(key: key);

  final FrontpageController frontpage = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Obx(
        () => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: List<Widget>.generate(
                frontpage.subscriptions.length,
                (i) {
                  final Subreddit subreddit =
                      frontpage.subscriptions[i] as Subreddit;
                  return SubredditButton(subreddit: subreddit);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

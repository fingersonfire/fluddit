import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';

class SubredditButton extends StatelessWidget {
  const SubredditButton({Key? key, required this.subreddit}) : super(key: key);

  final Subreddit subreddit;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Row(
        children: [
          Icon(Icons.android_rounded),
          Text(subreddit.name),
        ],
      ),
      onPressed: () {
        final RedditController reddit = Get.find();

        reddit.options['subreddit'] = subreddit.name;
        reddit.getInitPosts(limit: 50);
        Get.back();
      },
    );
  }
}

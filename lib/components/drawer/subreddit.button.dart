import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/drawer/subreddit.icon.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/routes/index.dart';
import 'package:flutter/material.dart';

class SubredditButton extends StatelessWidget {
  SubredditButton({Key? key, required this.subreddit}) : super(key: key);

  final Subreddit subreddit;

  final SubredditController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Row(
        children: [
          SubredditIcon(subreddit: subreddit),
          Text(subreddit.name),
        ],
      ),
      onPressed: () {
        controller.name.value = subreddit.name;
        Get.back();
        Get.to(() => SubredditView(subreddit: subreddit));
      },
    );
  }
}

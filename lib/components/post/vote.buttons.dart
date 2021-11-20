import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';

class PostVoteButtons extends StatelessWidget {
  PostVoteButtons({Key? key, required this.postIndex}) : super(key: key);

  final int postIndex;

  final ComponentController component = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    // Will prevent user from clicking buttons while API call is made
    bool isClickable = true;

    return Obx(
      () => Row(
        children: [
          IconButton(
            onPressed: () {
              final Post post = reddit.posts[postIndex];
              replyDialog(context, post.fullName, post.id, post.title);
            },
            icon: const Icon(
              Icons.reply_outlined,
            ),
            iconSize: 20,
          ),
          IconButton(
            iconSize: 20,
            onPressed: () async {
              if (isClickable) {
                isClickable = false;
                await reddit.voteOnPost(reddit.posts[postIndex].fullName, -1);
              }
              isClickable = true;
            },
            icon: Icon(
              Icons.arrow_downward_outlined,
              color: reddit.posts[postIndex].vote == -1
                  ? Colors.purple[300]
                  : Theme.of(context).iconTheme.color,
            ),
          ),
          Text(
            reddit.posts[postIndex].getScoreString(),
          ),
          IconButton(
            iconSize: 20,
            onPressed: () async {
              if (isClickable) {
                isClickable = false;
                await reddit.voteOnPost(
                  reddit.posts[postIndex].fullName,
                  1,
                );
              }
              isClickable = true;
            },
            icon: Icon(
              Icons.arrow_upward_outlined,
              color: reddit.posts[postIndex].vote == 1
                  ? Colors.orange[300]
                  : Theme.of(context).iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }
}

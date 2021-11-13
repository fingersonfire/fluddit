import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/post/reply/reply.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';

class VoteButtons extends StatelessWidget {
  VoteButtons({
    Key? key,
    required this.commentIndex,
    required this.postIndex,
  }) : super(key: key);

  final int commentIndex;
  final int postIndex;

  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    final Comment comment = reddit.posts[postIndex].comments[commentIndex];

    // Will prevent user from clicking buttons while API call is made
    bool isClickable = true;

    return Row(
      children: [
        IconButton(
          onPressed: () {
            replyDialog(
              context,
              comment.fullName,
              reddit.posts[postIndex].id,
              comment.body,
            );
          },
          icon: const Icon(Icons.reply_outlined),
          iconSize: 20,
        ),
        IconButton(
          iconSize: 20,
          onPressed: () async {
            if (isClickable) {
              isClickable = false;
              await reddit.voteOnComment(commentIndex, postIndex, -1);
            }
            isClickable = true;
          },
          icon: Icon(
            Icons.arrow_downward_outlined,
            color: comment.vote == -1 ? Colors.purple[300] : Colors.white,
          ),
        ),
        Text(
          comment.score.toString(),
        ),
        IconButton(
          iconSize: 20,
          onPressed: () async {
            if (isClickable) {
              isClickable = false;
              await reddit.voteOnComment(commentIndex, postIndex, 1);
            }
            isClickable = true;
          },
          icon: Icon(
            Icons.arrow_upward_outlined,
            color: comment.vote == 1 ? Colors.orange[300] : Colors.white,
          ),
        ),
      ],
    );
  }
}

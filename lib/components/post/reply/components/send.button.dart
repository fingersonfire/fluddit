import 'package:fluddit/bloc/reddit.bloc.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SendCommentButton extends StatelessWidget {
  SendCommentButton({
    Key? key,
    required this.fullName,
    required this.postId,
    required this.textController,
  }) : super(key: key);

  final String fullName;
  final String postId;
  final RedditController reddit = Get.find();
  final TextEditingController textController;

  void _postComment() async {
    final Post post = reddit.posts.singleWhere((p) => p.id == postId);

    reddit.commentOnPost(
      post.subreddit,
      post.id,
      fullName,
      textController.text,
    );
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _postComment,
      icon: const Icon(
        Icons.send,
        color: Color(0xFF2e3440),
      ),
    );
  }
}

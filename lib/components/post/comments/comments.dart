import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';

class CommentContent extends StatelessWidget {
  CommentContent({Key? key, required this.post}) : super(key: key);

  final Post post;

  final ComponentController component = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() {
        if (post.commentsLoaded) {
          if (post.comments.length < 1) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 75,
              child: Center(
                child: Text('No comments'),
              ),
            );
          } else {
            return CommentList(postId: post.id);
          }
        } else {
          reddit.getPostComments(
            subreddit: post.subreddit,
            postId: post.id,
          );
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 75,
            child: LoadingIndicator(),
          );
        }
      }),
    );
  }
}

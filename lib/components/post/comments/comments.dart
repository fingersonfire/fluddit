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
    return Obx(
      () {
        final postIndex = reddit.posts.indexWhere((p) => p.id == post.id);
        if (reddit.posts[postIndex].commentsLoaded) {
          if (reddit.posts[postIndex].comments.isEmpty) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 75,
              child: const Center(
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
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 75,
            child: const LoadingIndicator(),
          );
        }
      },
    );
  }
}

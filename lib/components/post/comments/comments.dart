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
        final postIndex = reddit.posts.indexWhere((p) => p.id == post.id);
        if (reddit.posts[postIndex].commentsLoaded) {
          if (reddit.posts[postIndex].comments.length < 1) {
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
            subreddit: reddit.posts[postIndex].subreddit,
            postId: reddit.posts[postIndex].id,
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

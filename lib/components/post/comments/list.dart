import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:flutter/material.dart';

class CommentList extends StatelessWidget {
  CommentList({Key? key, required this.postId}) : super(key: key);

  final String postId;
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    final index = reddit.posts.indexWhere((p) => p.id == postId);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(reddit.posts[index].comments.length, (i) {
          return Container(
            margin: EdgeInsets.only(
              left: (reddit.posts[index].comments[i].level * 10).toDouble(),
              top: 2,
            ),
            child: CommentTile(
              commentIndex: i,
              postIndex: index,
            ),
          );
        }),
      ),
    );
  }
}

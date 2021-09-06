import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:flutter/material.dart';

class CommentList extends StatelessWidget {
  CommentList({Key? key}) : super(key: key);

  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(reddit.postComments.length, (i) {
          return Container(
            margin: EdgeInsets.only(
              left: (reddit.postComments[i].level * 10).toDouble(),
              top: 2,
            ),
            child: CommentTile(index: i),
          );
        }),
      ),
    );
  }
}

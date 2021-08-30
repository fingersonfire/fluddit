import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/bloc/reddit.bloc.dart';
import 'package:fluddit/components/post/vote.buttons.dart';
import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  TitleBar({Key? key, required this.postIndex}) : super(key: key);

  final int postIndex;

  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 15, right: 15),
      width: MediaQuery.of(context).size.width,
      height: 115,
      color: Theme.of(context).cardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              reddit.posts[postIndex].title,
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  'u/${reddit.posts[postIndex].author}',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              PostVoteButtons(postIndex: postIndex),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  TitleBar({Key? key, required this.postIndex}) : super(key: key);

  final int postIndex;

  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      width: MediaQuery.of(context).size.width,
      color: Theme.of(context).cardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reddit.posts[postIndex].title,
            softWrap: true,
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // profileDialog(username: reddit.posts[postIndex].author);
                },
                child: Text(
                  'u/${reddit.posts[postIndex].author}',
                  style: const TextStyle(fontSize: 12),
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

import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  CommentTile({Key? key, required this.index}) : super(key: key);

  final int index;

  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              width: 2.0,
              color: Theme.of(context).accentColor,
            ),
          ),
          color: reddit.postComments[index].level.isEven
              ? Colors.white10
              : Colors.transparent,
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${reddit.postComments[index].body}',
              softWrap: true,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'u/${reddit.postComments[index].author}',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
                VoteButtons(index: index),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

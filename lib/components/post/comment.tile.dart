import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';

class CommentTile extends StatelessWidget {
  CommentTile({
    Key? key,
    required this.level,
    required this.comment,
  }) : super(key: key);

  final int level;
  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: level > 10 && comment.replies.length > 0
          ? EdgeInsets.only(left: 10, right: 10, top: 10)
          : EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(width: 2.0, color: Colors.indigo.shade300),
        ),
        color: level.isEven ? Colors.white10 : Colors.transparent,
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${comment.body}',
            softWrap: true,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'u/${comment.author}',
              style: TextStyle(
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

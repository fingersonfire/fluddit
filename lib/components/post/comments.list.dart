import 'package:fluddit/components/post/comment.tile.dart';
import 'package:flutter/material.dart';

class CommentList extends StatelessWidget {
  CommentList({Key? key, required this.comments}) : super(key: key);

  final List<dynamic> comments;

  @override
  Widget build(BuildContext context) {
    final commentList =
        getCommentList(context: context, comments: comments, list: []);
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: commentList,
      ),
    );
  }
}

List<Widget> getCommentList({
  required BuildContext context,
  required List<dynamic> comments,
  required List<Widget> list,
  int level = 0,
}) {
  for (var comment in comments) {
    list.add(
      Container(
        margin: EdgeInsets.only(
          left: (level * 10).toDouble(),
          top: 2,
        ),
        child: CommentTile(
          level: level,
          comment: comment,
        ),
      ),
    );
    if (level < 11) {
      list = getCommentList(
        context: context,
        comments: comment.replies,
        list: list,
        level: level + 1,
      );
    } else {
      list.add(
        Container(
          margin: EdgeInsets.only(
            left: (level * 10).toDouble(),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(width: 2.0, color: Colors.indigo.shade300),
              ),
              color: level.isEven ? Colors.white10 : Colors.transparent,
            ),
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Continue thread ...',
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      );
    }
  }

  return list;
}

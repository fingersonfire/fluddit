import 'package:flutter/material.dart';

class CommentList extends StatelessWidget {
  CommentList({Key? key, required this.comments}) : super(key: key);

  final List<dynamic> comments;

  @override
  Widget build(BuildContext context) {
    final commentList = getCommentList(comments: comments, list: []);
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
  required List<dynamic> comments,
  required List<Widget> list,
  level = 0,
}) {
  for (var comment in comments) {
    list.add(
      Container(
        margin: EdgeInsets.only(
          left: (level * 10).toDouble(),
        ),
        child: Container(
          padding: EdgeInsets.all(10),
          color: Colors.blueGrey[800],
          width: 325,
          child: Text(
            '${comment.body}',
            softWrap: true,
          ),
        ),
      ),
    );
    list = getCommentList(
      comments: comment.replies,
      list: list,
      level: ++level,
    );
  }

  return list;
}

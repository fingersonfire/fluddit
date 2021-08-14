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
        child: Container(
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
        ),
      ),
    );
    if (level < 11) {
      list = getCommentList(
        context: context,
        comments: comment.replies,
        list: list,
        level: ++level,
      );
    } else {
      list.add(
        Container(
          margin: EdgeInsets.only(
            left: (level * 10).toDouble(),
          ),
          child: Container(
            // padding: EdgeInsets.all(5),
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

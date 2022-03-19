import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/routes/web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CommentTile extends StatelessWidget {
  CommentTile({
    Key? key,
    required this.commentIndex,
    required this.postIndex,
  }) : super(key: key);

  final int commentIndex;
  final int postIndex;

  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: (reddit.posts[postIndex].comments[commentIndex].level * 10)
            .toDouble(),
        top: 2,
      ),
      padding: const EdgeInsets.only(left: 10, top: 10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 2.0,
            color: Theme.of(context).primaryColor,
          ),
        ),
        color: reddit.posts[postIndex].comments[commentIndex].level.isEven
            ? Colors.white10
            : Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownBody(
            data: reddit.posts[postIndex].comments[commentIndex].body,
            onTapLink: (String text, String? url, String other) {
              Get.to(() => WebPage(url: (url ?? '')));
            },
            styleSheet: MarkdownStyleSheet(
              blockquoteDecoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'u/${reddit.posts[postIndex].comments[commentIndex].author}',
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ),
              // const Expanded(child: SizedBox()),
              VoteButtons(
                commentIndex: commentIndex,
                postIndex: postIndex,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

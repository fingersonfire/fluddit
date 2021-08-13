import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';

class TitleBar extends StatefulWidget {
  TitleBar({Key? key, required this.post}) : super(key: key);

  final RedditPost post;
  final RedditController reddit = Get.find();

  @override
  _TitleBarState createState() => _TitleBarState();
}

class _TitleBarState extends State<TitleBar> {
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
              widget.post.title,
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
                  'u/${widget.post.author}',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    iconSize: 20,
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_upward_outlined,
                    ),
                  ),
                  Text(
                    widget.reddit.getScoreString(widget.post.score),
                  ),
                  IconButton(
                    iconSize: 20,
                    onPressed: () {},
                    icon: Icon(Icons.arrow_downward_outlined),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

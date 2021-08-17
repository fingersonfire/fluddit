import 'package:fluddit/models/index.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:flutter/material.dart';

class WebThumbnail extends StatelessWidget {
  const WebThumbnail({Key? key, required this.post}) : super(key: key);

  final RedditPost post;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ConditionalWidget(
          condition: post.thumbnail != 'default' && post.thumbnail != '',
          trueWidget: Container(
            width: 75,
            height: 75,
            child: Opacity(
              opacity: .5,
              child: Image.network(
                post.thumbnail,
                fit: BoxFit.cover,
              ),
            ),
          ),
          falseWidget: Container(),
        ),
        Center(
          child: Icon(Icons.link_outlined),
        ),
      ],
    );
  }
}

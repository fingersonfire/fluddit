import 'package:fluddit/components/post/video.content.dart';
import 'package:fluddit/components/post/web.content.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';

class ContentBox extends StatelessWidget {
  ContentBox({
    Key? key,
    required this.constraints,
    required this.post,
  }) : super(key: key);

  final BoxConstraints constraints;
  final RedditPost post;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: constraints.maxHeight - 115,
      child: getContent(post),
    );
  }
}

Widget getContent(RedditPost post) {
  if (post.isSelf) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Text(
          post.selfText,
          softWrap: true,
        ),
      ),
    );
  } else if (post.isVideo) {
    return VideoContent(url: '${post.url}/DASH_1080.mp4');
  } else if (post.domain == 'i.redd.it') {
    return Image.network(
      '${post.url}',
      fit: BoxFit.cover,
    );
  } else {
    return WebContent(url: '${post.url}');
  }
}

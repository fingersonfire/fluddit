import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:flutter/material.dart';

class WebThumbnail extends StatelessWidget {
  const WebThumbnail({Key? key, required this.post}) : super(key: key);

  final RedditPost post;

  @override
  Widget build(BuildContext context) {
    return DefaultThumbnail(
      contentIcon: Icon(Icons.link_outlined),
      post: post,
    );
  }
}

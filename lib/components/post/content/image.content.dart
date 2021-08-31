import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';

class ImageContent extends StatelessWidget {
  const ImageContent({Key? key, required this.post}) : super(key: key);

  final RedditPost post;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InteractiveViewer(
        child: Image.network(
          post.domain == 'imgur.com' ? '${post.url}.jpg' : post.url ?? '',
        ),
      ),
    );
  }
}

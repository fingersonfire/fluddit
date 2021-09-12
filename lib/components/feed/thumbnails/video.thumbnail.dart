import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:flutter/material.dart';

class VideoThumbnail extends StatelessWidget {
  const VideoThumbnail({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return DefaultThumbnail(
      contentIcon: Icon(Icons.play_arrow_outlined),
      post: post,
    );
  }
}

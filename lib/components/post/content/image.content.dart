import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/routes/image.dart';
import 'package:flutter/material.dart';

class ImageContent extends StatelessWidget {
  const ImageContent({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    String url =
        post.domain == 'imgur.com' ? '${post.url}.jpg' : post.url ?? '';
    return GestureDetector(
      onTap: () {
        displayImageViewer(url);
      },
      child: CachedNetworkImage(
        imageUrl: url,
        placeholder: (context, string) {
          return const LoadingIndicator();
        },
      ),
    );
  }
}

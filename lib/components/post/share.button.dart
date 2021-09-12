import 'package:fluddit/bloc/index.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class SharePostButton extends StatelessWidget {
  SharePostButton({Key? key}) : super(key: key);

  final ComponentController component = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final post = reddit.posts[component.carouselIndex.value];
        Share.share(
          'https://www.reddit.com/r/${post.subreddit}/${post.id}',
        );
      },
      icon: Icon(
        Icons.share_outlined,
        color: Color(0xFF2e3440),
      ),
    );
  }
}

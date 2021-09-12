import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';

class SavePostButton extends StatelessWidget {
  SavePostButton({Key? key}) : super(key: key);

  final ComponentController component = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        onPressed: () {
          reddit.savePost(component.carouselIndex.value);
        },
        icon: Obx(
          () {
            final int carouselIndex = component.carouselIndex.value;
            final RedditPost post = reddit.posts[carouselIndex];

            if (post.saved) {
              return Icon(
                Icons.bookmark_remove_outlined,
                color: Color(0xFF2e3440),
              );
            } else {
              return Icon(
                Icons.bookmark_outline_outlined,
                color: Color(0xFF2e3440),
              );
            }
          },
        ),
      ),
    );
  }
}

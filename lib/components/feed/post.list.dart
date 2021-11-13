import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:flutter/material.dart';

class FeedPosts extends StatelessWidget {
  FeedPosts({Key? key}) : super(key: key);

  final ComponentController component = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Obx(
        () => ListView.builder(
          itemCount: reddit.posts.length + 1,
          itemBuilder: (context, i) {
            if (i < reddit.posts.length) {
              return PostTile(post: reddit.posts[i]);
            } else {
              if (reddit.posts.isNotEmpty && reddit.after.value != '') {
                reddit.getNextPosts();
              }

              if (reddit.posts.isNotEmpty && reddit.after.value == '') {
                return Container();
              } else {
                return const SizedBox(
                  height: 75,
                  child: LoadingIndicator(),
                );
              }
            }
          },
        ),
      ),
    );
  }
}

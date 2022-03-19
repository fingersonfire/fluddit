import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/constants.dart';
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
        () => RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () async {
            reddit.getFeedPosts(reddit.name.value);
          },
          child: ListView.builder(
            itemCount: reddit.feedPosts.length + 1,
            itemBuilder: (context, i) {
              if (i < reddit.feedPosts.length) {
                return PostTile(
                  post: reddit.feedPosts[i],
                  posts: Posts.feed,
                );
              } else {
                if (reddit.feedPosts.isNotEmpty && reddit.after.value != '') {
                  reddit.getNextPosts();
                }

                if (reddit.feedPosts.isNotEmpty && reddit.after.value == '') {
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
      ),
    );
  }
}

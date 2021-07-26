import 'package:fluddit/bloc/reddit.bloc.dart';
import 'package:fluddit/components/post.tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Feed extends StatelessWidget {
  Feed({
    Key? key,
    required this.listing,
    required this.subreddit,
  }) : super(key: key);

  RedditController c = Get.find();

  final String listing;
  final String subreddit;

  @override
  Widget build(BuildContext context) {
    c.getSubredditPosts(
      sub: subreddit,
      listing: listing,
      limit: 50,
    );
    return Container(
        child: Obx(
      () => ListView.builder(
        itemCount: c.feedPosts.length + 1,
        itemBuilder: (context, i) {
          if (i < c.feedPosts.length) {
            RedditPost post = c.feedPosts[i];
            return PostTile(post: post);
          } else {
            c.getNextPosts(
              sub: subreddit,
              listing: listing,
              limit: 25,
            );
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    ));
  }
}

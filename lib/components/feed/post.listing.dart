import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/routes/post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostListing extends StatelessWidget {
  PostListing({Key? key, required this.post}) : super(key: key);

  final RedditPost post;

  final RedditController reddit = Get.find();
  final ComponentController component = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(
        //   () => PostView(post: post),
        //   transition: Transition.rightToLeft,
        // );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: Theme.of(context).cardColor,
        ),
        margin: EdgeInsets.all(5),
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title),
                  Text(
                    'r/${post.subreddit} | ${post.author}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                    ),
                    height: 75,
                    width: 75,
                    child: component.getPostThumbnail(post),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

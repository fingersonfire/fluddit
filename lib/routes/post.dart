import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PostView extends StatelessWidget {
  PostView({Key? key, required this.post}) : super(key: key);

  final RedditPost post;

  final FrontpageController frontpageC = Get.find();
  final SubredditController subredditC = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.indigo[300],
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (frontpageC.posts.contains(post)) {
              final int postIndex = frontpageC.posts.indexOf(post);

              return CarouselSlider(
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: constraints.maxHeight,
                  viewportFraction: 1,
                  initialPage: postIndex,
                ),
                items: List.generate(
                  frontpageC.posts.length,
                  (i) {
                    final post = frontpageC.posts[i];
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // Content
                          ContentBox(constraints: constraints, post: post),
                          // Title
                          TitleBar(post: post),
                          // Comments
                          CommentContent(post: post),
                        ],
                      ),
                    );
                  },
                ),
              );
            } else {
              final int postIndex = subredditC.posts.indexOf(post);

              return CarouselSlider(
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  height: constraints.maxHeight,
                  viewportFraction: 1,
                  initialPage: postIndex,
                ),
                items: List.generate(
                  subredditC.posts.length,
                  (i) {
                    final post = subredditC.posts[i];
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // Content
                          ContentBox(constraints: constraints, post: post),
                          // Title
                          TitleBar(post: post),
                          // Comments
                          CommentContent(post: post),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

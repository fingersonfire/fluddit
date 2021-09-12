import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';

class PostView extends StatelessWidget {
  PostView({Key? key, required this.post}) : super(key: key);

  final Post post;

  final ComponentController component = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        toolbarHeight: 50,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Color(0xFF2e3440),
          ),
        ),
        actions: [
          SavePostButton(),
          SharePostButton(),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final int postIndex = reddit.posts.indexOf(post);

            return CarouselSlider(
              options: CarouselOptions(
                enableInfiniteScroll: false,
                height: constraints.maxHeight,
                initialPage: postIndex,
                onPageChanged: component.onCarouselPageUpdate,
                viewportFraction: 1,
              ),
              items: List.generate(
                reddit.posts.length,
                (i) {
                  final post = reddit.posts[i];
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // Content
                        ContentBox(constraints: constraints, post: post),
                        // Title
                        TitleBar(
                          postIndex: i,
                        ),
                        // Comments
                        CommentContent(post: post),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

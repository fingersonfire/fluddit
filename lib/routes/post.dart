import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/widgets/back.button.dart';
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
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        toolbarHeight: 50,
        leading: const NavBackButton(),
        actions: <Widget>[
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
                        SizedBox(
                          height: constraints.maxHeight,
                          child: Column(
                            children: [
                              Expanded(
                                child: ContentBox(
                                  constraints: constraints,
                                  post: post,
                                ),
                              ),
                              TitleBar(
                                postIndex: i,
                              ),
                            ],
                          ),
                        ),
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

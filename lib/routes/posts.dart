import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/widgets/back.button.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';

class PostView extends StatefulWidget {
  const PostView({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final ComponentController component = Get.find();
  final RedditController reddit = Get.find();

  late int initialIndex;
  late PageController pageController;

  @override
  void initState() {
    initialIndex = reddit.posts.indexOf(widget.post);
    pageController = PageController(
      initialPage: initialIndex,
      viewportFraction: 1,
    );

    reddit.getPostComments(
      subreddit: widget.post.subreddit,
      postId: widget.post.id,
    );

    super.initState();
  }

  Widget getComment(BuildContext context, int commentIndex, int postIndex) {
    if (!reddit.posts[postIndex].commentsLoaded) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 75,
        child: const LoadingIndicator(),
      );
    } else if (reddit.posts[postIndex].comments.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 75,
        child: const Center(
          child: Text('No comments'),
        ),
      );
    } else {
      return CommentTile(
        commentIndex: commentIndex,
        postIndex: postIndex,
      );
    }
  }

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
            return Obx(() {
              return PageView.builder(
                controller: pageController,
                onPageChanged: (index) {
                  component.onCarouselPageUpdate(index);

                  reddit.getPostComments(
                    subreddit: reddit.posts[index].subreddit,
                    postId: reddit.posts[index].id,
                  );
                },
                itemCount: reddit.posts.length,
                itemBuilder: (context, postIndex) {
                  return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: reddit.posts[postIndex].comments.isEmpty
                        ? 2
                        : reddit.posts[postIndex].comments.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ContentWidget(
                          constraints: constraints,
                          post: reddit.posts[postIndex],
                          postIndex: postIndex,
                        );
                      }

                      return getComment(
                        context,
                        --index,
                        postIndex,
                      );
                    },
                  );
                },
              );
            });
          },
        ),
      ),
    );
  }
}

class ContentWidget extends StatefulWidget {
  const ContentWidget({
    Key? key,
    required this.constraints,
    required this.post,
    required this.postIndex,
  }) : super(key: key);

  final BoxConstraints constraints;
  final Post post;
  final int postIndex;

  @override
  ContentWidgetState createState() {
    return ContentWidgetState();
  }
}

class ContentWidgetState extends State<ContentWidget>
    with AutomaticKeepAliveClientMixin {
  final ComponentController component = Get.find();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: widget.constraints.maxHeight,
      child: Column(
        children: [
          Expanded(
            child: ContentBox(
              constraints: widget.constraints,
              post: widget.post,
            ),
          ),
          TitleBar(
            postIndex: widget.postIndex,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

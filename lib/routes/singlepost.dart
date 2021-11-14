import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/widgets/back.button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SinglePostView extends StatelessWidget {
  SinglePostView({Key? key, required this.postId}) : super(key: key);

  final String postId;

  final PostController post = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        toolbarHeight: 50,
        leading: const NavBackButton(),
        actions: const <Widget>[],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return FutureBuilder(
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // Content
                        ContentBox(
                            constraints: constraints, post: post.single.value),
                        // Title
                        Container(
                          padding: const EdgeInsets.only(
                            top: 15,
                            left: 15,
                            right: 15,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 115,
                          color: Theme.of(context).cardColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.single.value.title,
                                softWrap: true,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'u/${post.single.value.author}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  // PostVoteButtons(postIndex: postIndex),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Comments
                        CommentContent(post: post.single.value),
                      ],
                    ),
                  );
                }
                return const LoadingIndicator();
              },
              future: reddit.getPost(postId),
            );
          },
        ),
      ),
    );
  }
}

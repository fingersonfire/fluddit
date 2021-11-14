import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
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
        actions: [],
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
                          padding:
                              EdgeInsets.only(top: 15, left: 15, right: 15),
                          width: MediaQuery.of(context).size.width,
                          height: 115,
                          color: Theme.of(context).cardColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  post.single.value.title,
                                  softWrap: true,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      'u/${post.single.value.author}',
                                      style: TextStyle(fontSize: 12),
                                    ),
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
                return LoadingIndicator();
              },
              future: reddit.getPost(postId),
            );
          },
        ),
      ),
    );
  }
}

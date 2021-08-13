import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostView extends StatelessWidget {
  PostView({Key? key, required this.post}) : super(key: key);

  final RedditPost post;

  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    print(post.id);
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Content
                  ContentBox(constraints: constraints, post: post),
                  // Title
                  TitleBar(
                    post: post,
                  ),
                  // Comments
                  Container(
                    child: FutureBuilder(
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return CommentList(comments: snapshot.data);
                        }
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.indigo[300],
                            ),
                          ),
                        );
                      },
                      future: reddit.getPostComments(
                        subreddit: post.subreddit,
                        postId: post.id,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

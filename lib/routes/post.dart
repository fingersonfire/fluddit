import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostView extends StatelessWidget {
  const PostView({Key? key, required this.post}) : super(key: key);

  final RedditPost post;

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
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: Center(
                      child: Text('Comments not yet implemented'),
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

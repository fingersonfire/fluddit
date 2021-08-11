import 'package:fluddit/bloc/reddit.bloc.dart';
import 'package:fluddit/components/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Feed extends StatelessWidget {
  Feed({Key? key}) : super(key: key);

  final RedditController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            color: Colors.transparent,
            child: Obx(
              () => ListView.builder(
                itemCount: c.feedPosts.length + 1,
                itemBuilder: (context, i) {
                  if (i < c.feedPosts.length) {
                    return PostTile(post: c.feedPosts[i]);
                  } else {
                    if (c.feedPosts.length > 1) {
                      c.getNextPosts(
                        limit: 25,
                      );
                    }
                    return Container(
                      height: 75,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      future: c.getInitPosts(limit: 50),
    );
  }
}

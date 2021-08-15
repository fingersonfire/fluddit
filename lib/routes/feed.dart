import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/bloc/reddit.bloc.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/components/top.appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

class Feed extends StatelessWidget {
  Feed({Key? key}) : super(key: key);

  final ComponentController comp = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            key: scaffoldKey,
            bottomNavigationBar: bottomAppBar(
              comp,
              reddit,
              scaffoldKey,
            ),
            appBar: topAppBar(context, reddit),
            body: Container(
              color: Colors.transparent,
              child: Obx(
                () => ListView.builder(
                  itemCount: reddit.feedPosts.length + 1,
                  itemBuilder: (context, i) {
                    if (i < reddit.feedPosts.length) {
                      return PostTile(post: reddit.feedPosts[i]);
                    } else {
                      if (reddit.feedPosts.length > 1) {
                        reddit.getNextPosts(
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
            ),
            drawer: subredditsDrawer(),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      future: Future.wait(
          [reddit.getInitPosts(limit: 50), reddit.getUserSubreddits()]),
    );
  }
}

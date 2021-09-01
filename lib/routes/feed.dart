import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/feed/post.list.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/routes/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

class Feed extends StatelessWidget {
  Feed({Key? key}) : super(key: key);

  final ComponentController component = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Obx(
                () => AppBar(
                  backgroundColor: Color(component.accentColor.value),
                  brightness: Brightness.dark,
                  centerTitle: true,
                  title: Column(
                    children: [
                      Text(reddit.name.value),
                    ],
                  ),
                  actions: [
                    reddit.name.value != 'frontpage'
                        ? SubscribeButton(subreddit: reddit.subreddit)
                        : Container(),
                  ],
                  leading: Container(),
                ),
              ),
            ),
            key: scaffoldKey,
            body: FeedPosts(),
            bottomNavigationBar: BottomNavBar(
              scaffoldKey: scaffoldKey,
            ),
            drawer: SubredditDrawer(),
          );
        }
        return LoadingView();
      },
      future: Future.wait([
        reddit.getInitPosts('frontpage'),
        reddit.getSubscriptions(),
      ]),
    );
  }
}

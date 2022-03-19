import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/feed/post.list.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/routes/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class Feed extends StatelessWidget {
  Feed({Key? key}) : super(key: key);

  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Obx(
                () => AppBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarBrightness: Brightness.light,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarColor: Colors.transparent,
                  ),
                  centerTitle: true,
                  title: Column(
                    children: [
                      Text(
                        reddit.name.value,
                        style: const TextStyle(
                          color: Color(0xFF2e3440),
                        ),
                      ),
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
            drawer: const SubredditDrawer(),
          );
        }
        return const LoadingView();
      },
      future: reddit.initFeed(),
    );
  }
}

import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/routes/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

class Frontpage extends StatelessWidget {
  Frontpage({Key? key}) : super(key: key);

  final ComponentController component = Get.find();
  final FrontpageController frontpage = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 50,
              backgroundColor: Colors.indigo[300],
              brightness: Brightness.dark,
              centerTitle: true,
              title: Column(
                children: [
                  Text('frontpage'),
                ],
              ),
              // This removes the menu botton from the top bar
              leading: Container(),
            ),
            key: scaffoldKey,
            body: Container(
              color: Colors.transparent,
              child: Obx(
                () => ListView.builder(
                  itemCount: frontpage.posts.length + 1,
                  itemBuilder: (context, i) {
                    if (i < frontpage.posts.length) {
                      return PostTile(post: frontpage.posts[i]);
                    } else {
                      if (frontpage.posts.length > 1) {
                        frontpage.getNextPosts();
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
            bottomNavigationBar: BottomAppBar(
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        component.openDrawer(scaffoldKey);
                      }),
                  Spacer(),
                  IconButton(
                    onPressed: () async {
                      await frontpage.getInitPosts();
                    },
                    icon: Icon(Icons.refresh_outlined),
                  ),
                  IconButton(
                      icon: Icon(Icons.search_outlined),
                      onPressed: () {
                        Get.to(() => SearchView());
                      }),
                ],
              ),
            ),
            drawer: subredditsDrawer(),
          );
        }
        return LoadingView();
      },
      future: Future.wait([
        frontpage.getInitPosts(),
        frontpage.getSubscriptions(),
      ]),
    );
  }
}

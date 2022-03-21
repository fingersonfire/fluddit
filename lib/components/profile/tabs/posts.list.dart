import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/constants.dart';
import 'package:flutter/material.dart';

class UserPostsTab extends StatelessWidget {
  UserPostsTab({Key? key}) : super(key: key);

  final UserController user = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          ListView.builder(
            itemCount: user.posts.length + 1,
            itemBuilder: (context, i) {
              if (i < user.posts.length) {
                return PostTile(
                  disableTopPadding: i == 0,
                  post: user.posts[i],
                  posts: Posts.user,
                );
              } else {
                if (user.posts.isNotEmpty && user.after.value != '') {
                  // reddit.getNextPosts();
                }

                if (user.posts.isNotEmpty && user.after.value == '') {
                  return Container();
                } else {
                  return const SizedBox(
                    height: 75,
                    child: LoadingIndicator(),
                  );
                }
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).bottomAppBarColor,
                    Theme.of(context).bottomAppBarColor.withOpacity(.9),
                    Theme.of(context).bottomAppBarColor.withOpacity(0),
                  ],
                ),
              ),
              height: MediaQuery.of(context).viewPadding.bottom,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ],
      ),
    );
  }
}

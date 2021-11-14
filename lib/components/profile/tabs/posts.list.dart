import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/bloc/user.bloc.dart';
import 'package:fluddit/components/index.dart';
import 'package:flutter/material.dart';

class UserPostsTab extends StatelessWidget {
  UserPostsTab({Key? key}) : super(key: key);

  final UserController user = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: user.posts.length + 1,
        itemBuilder: (context, i) {
          if (i < user.posts.length) {
            return PostTile(
              post: user.posts[i],
              width: MediaQuery.of(context).size.width - 155,
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
    );
  }
}

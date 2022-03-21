import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/components/profile/components/comment.dart';
import 'package:flutter/material.dart';

class UserCommentsTab extends StatelessWidget {
  UserCommentsTab({Key? key}) : super(key: key);

  final RedditController reddit = Get.find();
  final UserController user = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          ListView.builder(
            itemCount: user.comments.length + 1,
            itemBuilder: (context, i) {
              if (i < user.comments.length) {
                return CommentWidget(comment: user.comments[i]);
              } else {
                if (user.comments.isNotEmpty && user.commentAfter.value != '') {
                  user.getAdditionalComments(reddit.userName.value);
                }

                if (user.comments.isNotEmpty && user.commentAfter.value == '') {
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

import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/bloc/reddit.bloc.dart';
import 'package:fluddit/components/profile/tabs/comments.list.dart';
import 'package:fluddit/components/profile/tabs/posts.list.dart';
import 'package:flutter/material.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({Key? key}) : super(key: key);

  @override
  _ProfileContentState createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  final UserController user = Get.find();

  int index = 0;

  void changeIndex(int i) {
    setState(() {
      index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            child: Text(
              'u/${user.username.value}',
              style: const TextStyle(
                fontSize: 26,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: () {
                  changeIndex(0);
                },
                child: Icon(
                  Icons.article_rounded,
                  color: index == 0
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).iconTheme.color,
                ),
              ),
              MaterialButton(
                onPressed: () {
                  changeIndex(1);
                },
                child: Icon(
                  Icons.question_answer_rounded,
                  color: index == 1
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).iconTheme.color,
                ),
              ),
              // MaterialButton(
              //   onPressed: () {
              //     changeIndex(2);
              //   },
              //   child: Icon(
              //     Icons.bookmark_rounded,
              //     color: index == 2
              //         ? Theme.of(context).primaryColor
              //         : Theme.of(context).iconTheme.color,
              //   ),
              // ),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: index,
              children: [
                UserPostsTab(),
                UserCommentsTab(),
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

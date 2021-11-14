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
  final RedditController reddit = Get.find();

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
              reddit.userName.value,
              style: const TextStyle(fontSize: 26),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: () {
                  changeIndex(0);
                },
                child: const Icon(Icons.article_rounded),
              ),
              MaterialButton(
                onPressed: () {
                  changeIndex(1);
                },
                child: const Icon(Icons.question_answer_rounded),
              ),
              MaterialButton(
                onPressed: () {
                  changeIndex(2);
                },
                child: const Icon(Icons.bookmark_rounded),
              ),
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

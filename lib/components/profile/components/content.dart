import 'package:fluddit/bloc/index.dart';
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
          AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            leading: const SizedBox(),
            centerTitle: true,
            elevation: 0,
            title: Text(
              'u/${user.username.value}',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            primary: false,
            actions: [
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Icon(
                    Icons.people_alt,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Container(
            color: Theme.of(context).backgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '${user.linkKarma}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Post Karma',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${user.commentKarma}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Comment Karma',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 5),
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

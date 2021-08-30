import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';

class SubredditList extends StatelessWidget {
  SubredditList({Key? key}) : super(key: key);

  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Obx(
        () => SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Divider(),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: MaterialButton(
                    child: Text(
                      'frontpage',
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    onPressed: () {
                      if (reddit.name.value != 'frontpage') {
                        reddit.getInitPosts('frontpage');
                      }
                      Get.back();
                    },
                  ),
                ),
                Divider(),
                ...List<Widget>.generate(
                  reddit.subscriptions.length,
                  (i) {
                    final Subreddit subreddit =
                        reddit.subscriptions[i] as Subreddit;
                    return SubredditButton(subreddit: subreddit);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

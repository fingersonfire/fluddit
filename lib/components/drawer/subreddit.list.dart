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
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: TextButton(
                  child: Text(
                    'frontpage',
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () {
                    final RedditController reddit = Get.find();

                    reddit.options['subreddit'] = 'frontpage';
                    reddit.getInitPosts(limit: 50);
                    Get.back();
                  },
                ),
              ),
              Divider(),
              ...List<Widget>.generate(
                reddit.options['subscribed'].length,
                (i) {
                  final Subreddit subreddit =
                      reddit.options['subscribed'][i] as Subreddit;
                  return SubredditButton(subreddit: subreddit);
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

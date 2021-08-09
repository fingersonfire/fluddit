import 'package:fluddit/bloc/reddit.bloc.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/routes/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Drawer subredditsDrawer() {
  final RedditController reddit = Get.find();

  return Drawer(
    child: Column(
      children: [
        Expanded(
          child: Container(
            child: Container(
              color: Colors.transparent,
              child: Obx(
                () => ListView.builder(
                  itemCount: reddit.options['subscribed'].length,
                  itemBuilder: (context, i) {
                    final Subreddit subreddit =
                        reddit.options['subscribed'][i] as Subreddit;

                    return TextButton(
                      onPressed: () {
                        reddit.options['subreddit'] = subreddit.name;
                        reddit.feedPosts.clear();
                        reddit.getInitPosts(limit: 50);
                        Get.back();
                      },
                      child: Text(subreddit.name),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.black87,
          height: 50,
          width: 305,
          child: TextButton(
            onPressed: () {
              Get.back();
              Get.to(() => WebLogin());
            },
            child: Text(
              'Sign In',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    ),
  );
}

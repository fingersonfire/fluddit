import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
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
          child: GlowingOverscrollIndicator(
            color: Theme.of(context).primaryColor,
            axisDirection: AxisDirection.down,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Divider(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: MaterialButton(
                      child: const Text(
                        'frontpage',
                        style: TextStyle(
                          fontSize: 20,
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
                  const Divider(),
                  ...List<Widget>.generate(
                    reddit.subscriptions.length,
                    (i) {
                      return SubredditButton(
                        subreddit: reddit.subscriptions[i],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

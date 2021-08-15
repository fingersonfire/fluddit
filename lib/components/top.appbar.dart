import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/widgets/conditional.widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar topAppBar(
  BuildContext context,
  RedditController reddit,
) {
  return AppBar(
    toolbarHeight: 50,
    backgroundColor: Colors.indigo[300],
    brightness: Brightness.dark,
    centerTitle: true,
    title: Obx(
      () => Column(
        children: [
          Text(reddit.options['subreddit']),
        ],
      ),
    ),
    actions: [
      Container(
        child: Obx(() {
          return ConditionalWidget(
            condition: reddit.options['subreddit'] == 'frontpage',
            trueWidget: Container(),
            falseWidget: ConditionalWidget(
              condition: reddit.options['subscribed']
                      .where((s) => s.name == reddit.options['subreddit'])
                      .length >
                  0,
              trueWidget: IconButton(
                onPressed: () {},
                icon: Icon(Icons.remove_outlined),
              ),
              falseWidget: IconButton(
                onPressed: () {},
                icon: Icon(Icons.add_outlined),
              ),
            ),
          );
        }),
      ),
    ],
    leading: Container(),
  );
}

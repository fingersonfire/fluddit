import 'package:fluddit/bloc/index.dart';
import 'package:flutter/material.dart';

BottomAppBar bottomAppBar(
  ComponentController comp,
  RedditController reddit,
  scaffoldKey,
) {
  return BottomAppBar(
    child: Row(
      children: [
        IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              comp.openDrawer(scaffoldKey);
            }),
        Spacer(),
        IconButton(
          onPressed: () {
            reddit.feedPosts.clear();
            reddit.getSubredditPosts(
              limit: 50,
            );
          },
          icon: Icon(Icons.refresh_outlined),
        ),
        IconButton(icon: Icon(Icons.search_outlined), onPressed: () {}),
      ],
    ),
  );
}

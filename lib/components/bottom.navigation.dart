import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/feed/sorting/sort.modal.dart';
import 'package:fluddit/routes/index.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key, required this.scaffoldKey}) : super(key: key);

  final scaffoldKey;

  final ComponentController component = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                component.openDrawer(scaffoldKey);
              }),
          Spacer(),
          IconButton(
            onPressed: () async {
              await reddit.getInitPosts(reddit.name.value);
            },
            icon: Icon(Icons.refresh_outlined),
          ),
          IconButton(
            onPressed: () {
              sortDialog(context);
            },
            icon: Icon(Icons.sort),
          ),
          IconButton(
              icon: Icon(Icons.search_outlined),
              onPressed: () {
                Get.to(() => SearchView());
              }),
        ],
      ),
    );
  }
}

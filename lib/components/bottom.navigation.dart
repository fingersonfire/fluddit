import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/feed/sorting/sort.modal.dart';
import 'package:fluddit/routes/index.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key, required this.scaffoldKey}) : super(key: key);

  final GlobalKey scaffoldKey;

  final ComponentController component = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                component.openDrawer(scaffoldKey);
              }),
          const Spacer(),
          IconButton(
            onPressed: () async {
              await reddit.getInitPosts(reddit.name.value);
            },
            icon: const Icon(Icons.refresh_outlined),
          ),
          IconButton(
            onPressed: () {
              sortDialog(context);
            },
            icon: const Icon(Icons.sort),
          ),
          Obx(
            () => Visibility(
              visible: reddit.userName.isNotEmpty,
              child: IconButton(
                icon: const Icon(Icons.search_outlined),
                onPressed: () {
                  Get.to(() => const SearchView());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

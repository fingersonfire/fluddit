import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ComponentController extends GetxController {
  void openDrawer(scaffoldKey) {
    if (!scaffoldKey.currentState.isDrawerOpen) {
      scaffoldKey.currentState.openDrawer();
    }
  }

  void closeDrawer(scaffoldKey) {
    if (scaffoldKey.currentState.isDrawerOpen) {
      scaffoldKey.currentState.closeDrawer();
    }
  }

  Widget getPostThumbnail(RedditPost post) {
    if (post.isSelf) {
      return Center(
        child: Text('Tt'),
      );
    } else if (post.isVideo) {
      return VideoThumbnail(post: post);
    } else if (post.domain == 'i.redd.it') {
      return ImageThumbnail(post: post);
    } else {
      return WebThumbnail(post: post);
    }
  }
}

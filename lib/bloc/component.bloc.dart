import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ComponentController extends GetxController {
  RxInt accentColor = 0.obs;
  RxBool isDarkMode = true.obs;

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

  void displaySnackbar(String message) {
    if (!(Get.isSnackbarOpen ?? false)) {
      Get.snackbar(
        'Alert',
        message,
        isDismissible: true,
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
      );
    }
  }

  Widget getPostThumbnail(RedditPost post) {
    if (post.isSelf) {
      return Center(
        child: Text('Tt'),
      );
    } else if (post.isVideo) {
      return VideoThumbnail(post: post);
    } else if (isImage(post.url) || post.domain == 'imgur.com') {
      return ImageThumbnail(post: post);
    } else if (post.isGallery) {
      return GalleryThumbnail(post: post);
    } else {
      return WebThumbnail(post: post);
    }
  }

  bool isImage(String? url) {
    final String parsedUrl = url ?? '';
    return parsedUrl.endsWith('jpg') ||
        parsedUrl.endsWith('png') ||
        parsedUrl.endsWith('gif');
  }
}

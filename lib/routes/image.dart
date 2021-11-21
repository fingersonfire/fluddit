import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

displayImageViewer(String url) async {
  Get.bottomSheet(
    ImageView(url: url),
    isScrollControlled: true,
    enableDrag: false,
    barrierColor: Colors.black87,
    ignoreSafeArea: false,
  );
}

class ImageView extends StatelessWidget {
  const ImageView({Key? key, required this.url}) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.download_rounded,
              size: 30,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return InteractiveViewer(
            child: CachedNetworkImage(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              imageUrl: url,
            ),
          );
        },
      ),
      // body: Center(
      //   child: InteractiveViewer(
      //     child: CachedNetworkImage(
      //       imageUrl: url,
      //     ),
      //   ),
      // ),
    );
  }
}

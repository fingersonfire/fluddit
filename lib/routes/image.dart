import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

displayImageViewer(String id, String url) async {
  Get.bottomSheet(
    ImageView(id: id, url: url),
    isScrollControlled: true,
    enableDrag: false,
    barrierColor: Colors.black87,
    ignoreSafeArea: false,
  );
}

class ImageView extends StatelessWidget {
  const ImageView({
    Key? key,
    required this.id,
    required this.url,
  }) : super(key: key);

  final String id;
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
            onPressed: () async {
              StreamController<bool> downloadStatus = StreamController<bool>();
              Stream<bool> stream = downloadStatus.stream.asBroadcastStream();

              SnackBar snackBar = SnackBar(
                backgroundColor: Colors.transparent,
                content: SnackbarContent(
                  stream: stream,
                ),
                duration: const Duration(seconds: 60),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Directory? dir;

              if (Platform.isAndroid) {
                dir = Directory('/storage/emulated/0/Pictures/fluddit');

                if (!(await dir.exists())) {
                  await dir.create(recursive: true);
                }
              } else {
                dir = await getApplicationDocumentsDirectory();
              }
              http.Response resp = await http.get(Uri.parse(url));

              String extension = url.split('.').last;
              File file = File('${dir.path}/$id.$extension');

              await file.writeAsBytes(resp.bodyBytes);
              await Future.delayed(const Duration(seconds: 1));

              downloadStatus.sink.add(true);
              await Future.delayed(const Duration(seconds: 2));

              ScaffoldMessenger.of(context).clearSnackBars();
              downloadStatus.close();
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
    );
  }
}

class SnackbarContent extends StatelessWidget {
  const SnackbarContent({Key? key, required this.stream}) : super(key: key);

  final Stream<bool> stream;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).bottomAppBarColor,
      height: 50,
      width: MediaQuery.of(context).size.width * .95,
      child: Center(
        child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return Text(
                'Download finished',
                style: Theme.of(context).textTheme.bodyText2,
              );
            } else {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Download in progress',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageView extends StatelessWidget {
  ImageView({Key? key, required this.src}) : super(key: key);

  final String src;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.indigo[300],
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 40,
        width: MediaQuery.of(context).size.width,
        child: Image.network(
          src,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

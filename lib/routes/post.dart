import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostView extends StatelessWidget {
  const PostView({Key? key}) : super(key: key);

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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Content
                  Container(
                    height: constraints.maxHeight - 110,
                    // alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: constraints.maxHeight - 110,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.blue[400],
                          ),
                          Container(
                            height: constraints.maxHeight - 110,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.green[400],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Title
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 110,
                    color: Colors.red[400],
                  ),
                  // Comments
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 500,
                    color: Colors.yellow[300],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

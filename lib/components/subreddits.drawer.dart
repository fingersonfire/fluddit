import 'package:fluddit/routes/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Drawer subredditsDrawer() {
  return Drawer(
    child: Column(
      children: [
        Expanded(
          child: Container(),
        ),
        Container(
          color: Colors.black87,
          height: 50,
          width: 305,
          child: TextButton(
            onPressed: () {
              Get.back();
              Get.to(() => WebLogin());
            },
            child: Text(
              'Sign In',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    ),
  );
}

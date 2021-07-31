import 'package:fluddit/bloc/reddit.bloc.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void loginDialog() {
  final RedditController c = Get.find();

  Get.defaultDialog(
    title: 'Login',
    titlePadding: EdgeInsets.only(top: 25, bottom: 10),
    content: Column(
      children: [
        InputField(
          controller: c.userController,
          fieldLabel: 'Username',
        ),
        InputField(
          controller: c.passwordController,
          fieldLabel: 'Password',
          isPassword: true,
        ),
      ],
    ),
    barrierDismissible: true,
    radius: 20.0,
    confirm: Container(
      margin: EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        onPressed: () {},
        child: Container(
          margin: EdgeInsets.all(10),
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    ),
  );
}

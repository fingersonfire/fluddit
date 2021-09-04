import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  AccountButton({Key? key}) : super(key: key);

  final ComponentController component = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      child: Obx(
        () => Container(
          color: Color(component.accentColor.value),
          width: 300,
          height: 45,
          child: Center(
            child: Text(
              reddit.userName.value,
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ),
      ),
      onPressed: () {
        Get.back();
        profileDialog();
      },
    );
  }
}

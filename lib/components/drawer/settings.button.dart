import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/routes/index.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  SettingsButton({Key? key}) : super(key: key);

  final ComponentController component = Get.find();
  final RedditController reddit = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      height: 40,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        child: Obx(
          () => Container(
            color: Color(component.accentColor.value),
            width: 150,
            height: 45,
            child: Center(
              child: Icon(
                Icons.settings_outlined,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        onPressed: () {
          Get.to(() => Settings());
        },
      ),
    );
  }
}

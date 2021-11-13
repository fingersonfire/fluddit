import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/routes/index.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      height: 40,
      child: MaterialButton(
        padding: EdgeInsets.zero,
        child: Container(
          color: Theme.of(context).primaryColor,
          width: 150,
          height: 45,
          child: const Center(
            child: Icon(
              Icons.settings_outlined,
              color: Colors.black87,
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

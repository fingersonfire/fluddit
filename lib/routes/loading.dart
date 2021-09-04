import 'package:fluddit/bloc/index.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  LoadingView({Key? key}) : super(key: key);

  final ComponentController component = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => CircularProgressIndicator(
            color: Color(component.accentColor.value),
          ),
        ),
      ),
    );
  }
}

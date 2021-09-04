import 'package:fluddit/bloc/index.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  LoadingIndicator({Key? key}) : super(key: key);

  final ComponentController component = Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(
        () => CircularProgressIndicator(
          color: Color(component.accentColor.value),
        ),
      ),
    );
  }
}

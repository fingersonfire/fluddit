import 'package:fluddit/bloc/index.dart';
import 'package:flutter/material.dart';

class ColorButton extends StatelessWidget {
  ColorButton({Key? key, required this.color}) : super(key: key);

  final int color;
  final ComponentController component = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        component.updateAccentColor(color);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Color(color),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ConditionalWidget extends StatelessWidget {
  ConditionalWidget({
    Key? key,
    required this.condition,
    required this.trueWidget,
    required this.falseWidget,
  }) : super(key: key);

  final bool condition;
  final Widget trueWidget;
  final Widget falseWidget;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return trueWidget;
    } else {
      return falseWidget;
    }
  }
}

import 'package:flutter/material.dart';

class FormatButtons extends StatelessWidget {
  const FormatButtons({Key? key, required this.insertText}) : super(key: key);

  final Function insertText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            insertText(insert: '****', positionFromEnd: 2);
          },
          icon: Icon(
            Icons.format_bold,
          ),
        ),
        IconButton(
          onPressed: () {
            insertText(insert: '**', positionFromEnd: 1);
          },
          icon: Icon(
            Icons.format_italic,
          ),
        ),
        IconButton(
          onPressed: () {
            insertText(insert: '~~~~', positionFromEnd: 2);
          },
          icon: Icon(
            Icons.format_strikethrough,
          ),
        ),
        IconButton(
          onPressed: () {
            insertText(insert: '[text](link)');
          },
          icon: Icon(
            Icons.link,
          ),
        ),
        IconButton(
          onPressed: () {
            insertText(insert: '>!!<', positionFromEnd: 2);
          },
          icon: Icon(Icons.visibility_off),
        ),
      ],
    );
  }
}

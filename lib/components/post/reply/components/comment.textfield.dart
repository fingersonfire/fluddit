import 'package:flutter/material.dart';

class CommentInput extends StatelessWidget {
  const CommentInput({
    Key? key,
    required this.textController,
  }) : super(key: key);

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextField(
        controller: textController,
        cursorColor: Theme.of(context).primaryColor,
        maxLines: 15,
        decoration: InputDecoration(
          filled: true,
          enabledBorder: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class QuoteButton extends StatelessWidget {
  const QuoteButton({
    Key? key,
    required this.insertText,
    required this.quoteText,
  }) : super(key: key);

  final Function insertText;
  final String quoteText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10, right: 10),
          child: IconButton(
            onPressed: () {
              insertText(insert: '> $quoteText');
            },
            icon: Icon(
              Icons.format_quote,
              size: 35,
            ),
          ),
        ),
      ],
    );
  }
}

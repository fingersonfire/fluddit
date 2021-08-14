import 'package:flutter/material.dart';

class SubredditIcon extends StatelessWidget {
  SubredditIcon({
    Key? key,
    this.image = const AssetImage('lib/assets/redditIcon.png'),
  }) : super(key: key);

  final image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: 30,
      height: 30,
      child: CircleAvatar(
        backgroundImage: image,
        backgroundColor: Colors.white24,
      ),
    );
  }
}

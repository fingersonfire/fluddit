import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/widgets/index.dart';
import 'package:flutter/material.dart';

class DefaultThumbnail extends StatelessWidget {
  DefaultThumbnail({
    Key? key,
    required this.contentIcon,
    required this.post,
  }) : super(key: key);

  final Icon contentIcon;
  final Post post;

  final ComponentController component = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ConditionalWidget(
          condition: post.thumbnail == 'nsfw' || post.thumbnail == 'spoiler',
          trueWidget: Opacity(
            opacity: .5,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.redAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          falseWidget: ConditionalWidget(
            condition: component.isImage(post.thumbnail),
            falseWidget: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).backgroundColor,
                    Theme.of(context).cardColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            trueWidget: SizedBox(
              width: 75,
              height: 75,
              child: Opacity(
                opacity: .5,
                child: Image.network(
                  post.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: contentIcon,
        ),
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluddit/models/subreddit.model.dart';
import 'package:fluddit/widgets/conditional.widget.dart';
import 'package:flutter/material.dart';

class SubredditIcon extends StatelessWidget {
  const SubredditIcon({Key? key, required this.subreddit}) : super(key: key);

  final Subreddit subreddit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 30,
      height: 30,
      child: ConditionalWidget(
        condition: subreddit.icon == '',
        trueWidget: const SubredditPlaceholderIcon(),
        falseWidget: CachedNetworkImage(
          imageUrl: subreddit.icon.replaceAll('&amp;', '&'),
          imageBuilder: (context, imageProvider) => CircleAvatar(
            backgroundImage: imageProvider,
            backgroundColor: Colors.white24,
          ),
          placeholder: (context, url) => const SubredditPlaceholderIcon(),
          errorWidget: (context, url, error) =>
              const SubredditPlaceholderIcon(),
        ),
      ),
    );
  }
}

class SubredditPlaceholderIcon extends StatelessWidget {
  const SubredditPlaceholderIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundImage: AssetImage('lib/assets/redditIcon.png'),
      backgroundColor: Colors.white24,
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/drawer/subreddit.icon.dart';
import 'package:fluddit/models/index.dart';
import 'package:flutter/material.dart';

class SubredditButton extends StatelessWidget {
  const SubredditButton({Key? key, required this.subreddit}) : super(key: key);

  final Subreddit subreddit;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      child: Row(
        children: [
          subreddit.icon == ''
              ? SubredditIcon()
              : CachedNetworkImage(
                  imageUrl: subreddit.icon.replaceAll('&amp;', '&'),
                  imageBuilder: (context, imageProvider) => Container(
                    child: SubredditIcon(image: imageProvider),
                  ),
                  placeholder: (context, url) => SubredditIcon(),
                  errorWidget: (context, url, error) => SubredditIcon(),
                ),
          Text(subreddit.name),
        ],
      ),
      onPressed: () {
        final RedditController reddit = Get.find();

        reddit.options['subreddit'] = subreddit.name;
        reddit.getInitPosts(limit: 50);
        Get.back();
      },
    );
  }
}

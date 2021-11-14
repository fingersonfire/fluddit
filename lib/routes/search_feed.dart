import 'package:fluddit/components/feed/post.list.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/models/index.dart';
import 'package:fluddit/widgets/back.button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchFeed extends StatelessWidget {
  const SearchFeed({Key? key, required this.subreddit}) : super(key: key);

  final Subreddit subreddit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Theme.of(context).primaryColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              subreddit.name,
              style: const TextStyle(
                color: Color(0xFF2e3440),
              ),
            ),
          ],
        ),
        leading: const NavBackButton(),
        actions: [
          SubscribeButton(subreddit: subreddit),
        ],
      ),
      body: FeedPosts(),
    );
  }
}

import 'package:fluddit/bloc/reddit.bloc.dart';
import 'package:fluddit/routes/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:get/get.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  RedditController c = Get.put(RedditController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.dark,
      theme: NordTheme.light(),
      darkTheme: NordTheme.dark(),
      title: 'fluddit',
      home: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              IconButton(icon: Icon(Icons.menu), onPressed: () {}),
              Spacer(),
              IconButton(
                onPressed: () {
                  c.getSubredditPosts(
                    sub: 'flutter',
                    listing: 'hot',
                    limit: 50,
                  );
                },
                icon: Icon(Icons.refresh_outlined),
              ),
              IconButton(icon: Icon(Icons.search_outlined), onPressed: () {}),
            ],
          ),
        ),
        appBar: AppBar(
          toolbarHeight: 35,
          backgroundColor: Colors.indigo[300],
          brightness: Brightness.dark,
          centerTitle: true,
          title: Text('Frontpage'),
          leading: Container(),
        ),
        body: Feed(
          listing: 'hot',
          subreddit: 'flutter',
        ),
        drawer: Drawer(),
      ),
    );
  }
}

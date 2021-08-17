import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/routes/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:http/http.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final AuthController auth = Get.put(AuthController());
  final ComponentController comp = Get.put(ComponentController());
  final RedditController reddit = Get.put(RedditController());
  final FrontpageController frontpage = Get.put(FrontpageController());
  final SubredditController subreddit = Get.put(SubredditController());

  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.dark,
      theme: NordTheme.light(),
      darkTheme: NordTheme.dark(),
      title: 'fluddit',
      home: FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Frontpage();
          }
          return LoadingView();
        },
        future: auth.refreshAuthToken(),
      ),
    );
  }
}

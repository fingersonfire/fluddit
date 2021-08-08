import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/components/top.appbar.dart';
import 'package:fluddit/routes/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:get/get.dart';

GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final AuthController auth = Get.put(AuthController());
  final ComponentController comp = Get.put(ComponentController());
  final RedditController reddit = Get.put(RedditController());

  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.dark,
      theme: NordTheme.light(),
      darkTheme: NordTheme.dark(),
      title: 'fluddit',
      home: Scaffold(
        key: scaffoldKey,
        bottomNavigationBar: bottomAppBar(
          comp,
          reddit,
          scaffoldKey,
        ),
        appBar: topAppBar(reddit),
        body: Feed(),
        drawer: subredditsDrawer(),
      ),
    );
  }
}

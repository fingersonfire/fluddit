import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/routes/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';

void main() {
  _loadBlocs();
  runApp(App());
}

class App extends StatelessWidget {
  final AuthController auth = Get.find();
  final ComponentController component = Get.find();

  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.dark,
      theme: NordTheme.light(),
      darkTheme: NordTheme.dark(),
      title: 'fluddit',
      home: FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Feed();
          }
          return LoadingView();
        },
        future: auth.refreshAuthToken(),
      ),
    );
  }
}

void _loadBlocs() {
  Get.put<AuthController>(AuthController());
  Get.put<ComponentController>(ComponentController());
  Get.put<RedditController>(RedditController());
}

import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/routes/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  // Calling this as the binding needs to be initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await _initStorage();

  _loadBlocs();
  runApp(App());
}

class App extends StatelessWidget {
  final AuthController auth = Get.find();
  final GetStorage box = GetStorage();

  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      theme: box.read('darkMode')
          ? NordTheme.dark().copyWith(
              primaryColor: Color(int.parse(box.read('accent_color'))),
            )
          : NordTheme.light().copyWith(
              primaryColor: Color(int.parse(box.read('accent_color'))),
            ),
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

Future<void> _initStorage() async {
  await GetStorage.init();
  GetStorage().writeIfNull('accent_color', '0xffb48ead');
  GetStorage().writeIfNull('darkMode', true);
}

void _loadBlocs() {
  Get.put<AuthController>(AuthController());
  Get.put<ComponentController>(ComponentController());
  Get.put<RedditController>(RedditController());
}

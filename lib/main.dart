import 'dart:io';

import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/constants.dart';
import 'package:fluddit/routes/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // Calling this as the binding needs to be initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await _initStorage();

  _loadBlocs();
  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final AuthController auth = Get.find();
  final UserController user = Get.find();

  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      theme: box.read('darkMode') ? darkTheme : lightTheme,
      title: 'fluddit',
      home: FutureBuilder(
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (box.read('access_token') != null) {
              user.getUserInfo();
            }
            return Feed();
          }

          return const LoadingView();
        },
        future: auth.refreshAuthToken(),
      ),
    );
  }
}

Future<void> _initStorage() async {
  Directory dir = await getApplicationSupportDirectory();
  GetStorage('GetStorage', dir.path);

  await GetStorage.init();
  GetStorage().writeIfNull('accent_color', '0xffb48ead');
  GetStorage().writeIfNull('darkMode', true);
  GetStorage().writeIfNull('autoMute', false);
}

void _loadBlocs() {
  Get.put<AuthController>(AuthController());
  ComponentController component =
      Get.put<ComponentController>(ComponentController());
  Get.put<PostController>(PostController());
  Get.put<RedditController>(RedditController());
  Get.put<UserController>(UserController());

  component.autoMute.value = GetStorage().read('autoMute');
}

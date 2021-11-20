import 'package:flutter/material.dart';
import 'package:flutter_nord_theme/flutter_nord_theme.dart';
import 'package:get_storage/get_storage.dart';

ThemeData darkTheme = NordTheme.dark().copyWith(
  primaryColor: Color(int.parse(GetStorage().read('accent_color'))),
  textTheme: NordTheme.dark().textTheme.copyWith(
        headline2: const TextStyle(
          color: Color(0xffd8dee9),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headline4: const TextStyle(
          color: Color(0xffeceff4),
          fontSize: 18,
        ),
      ),
);

ThemeData lightTheme = NordTheme.light().copyWith(
  primaryColor: Color(int.parse(GetStorage().read('accent_color'))),
  textTheme: NordTheme.light().textTheme.copyWith(
        headline2: const TextStyle(
          color: Color(0xff3b4252),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headline4: const TextStyle(
          color: Color(0xff2e3440),
          fontSize: 18,
        ),
      ),
);

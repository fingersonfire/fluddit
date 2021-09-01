import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);

  final ComponentController component = Get.find();
  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Obx(
          () => AppBar(
            backgroundColor: Color(component.accentColor.value),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 20),
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Accent Color:',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 22),
              ),
            ),
            Container(
              height: 90,
              width: MediaQuery.of(context).size.width,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 5,
                children: <Widget>[
                  ColorButton(color: 0xffb48ead),
                  ColorButton(color: 0xffd08770),
                  ColorButton(color: 0xffa3be8c),
                  ColorButton(color: 0xffebcb8b),
                  ColorButton(color: 0xffbf616a),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, left: 20),
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Dark Theme:',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 22),
              ),
            ),
            Obx(
              () => Container(
                margin: EdgeInsets.only(left: 10),
                child: Switch(
                  activeColor: Color(component.accentColor.value),
                  value: component.isDarkMode.value,
                  onChanged: (darkMode) {
                    if (darkMode) {
                      component.isDarkMode.value = true;
                      Get.changeThemeMode(ThemeMode.dark);
                    } else {
                      component.isDarkMode.value = false;
                      Get.changeThemeMode(ThemeMode.light);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
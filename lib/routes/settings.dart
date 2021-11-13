import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

class Settings extends StatelessWidget {
  Settings({Key? key}) : super(key: key);

  final GetStorage box = GetStorage();
  final ComponentController component = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
        toolbarHeight: 50,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Color(0xFF2e3440),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20, left: 20),
              width: MediaQuery.of(context).size.width,
              child: const Text(
                'Accent Color:',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 22),
              ),
            ),
            SizedBox(
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
              margin: const EdgeInsets.only(top: 20, left: 20),
              width: MediaQuery.of(context).size.width,
              child: const Text(
                'Dark Theme:',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 22),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10),
              child: Switch(
                activeColor: Theme.of(context).primaryColor,
                value: box.read('darkMode'),
                onChanged: component.updateThemeMode,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

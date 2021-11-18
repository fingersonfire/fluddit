import 'package:fluddit/bloc/index.dart';
import 'package:fluddit/components/index.dart';
import 'package:fluddit/widgets/back.button.dart';
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
        leading: const NavBackButton(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15, left: 20),
              width: MediaQuery.of(context).size.width,
              child: const Text(
                'Theme Settings',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 24),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, left: 20),
              width: MediaQuery.of(context).size.width,
              child: const Text(
                'Accent Color:',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(
              height: 75,
              width: MediaQuery.of(context).size.width,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                physics: const NeverScrollableScrollPhysics(),
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
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text(
                    'Dark Theme:',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 18),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Divider(
                thickness: 2,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 20, bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: const Text(
                'Content Settings',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 24),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: const Text(
                    'Auto-mute videos:',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Obx(
                    () => Switch(
                      activeColor: Theme.of(context).primaryColor,
                      value: component.autoMute.value,
                      onChanged: component.updateAutoMute,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

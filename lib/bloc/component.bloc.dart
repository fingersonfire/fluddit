import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComponentController extends GetxController {
  void openDrawer(scaffoldKey) {
    if (!scaffoldKey.currentState.isDrawerOpen) {
      scaffoldKey.currentState.openDrawer();
    }
  }

  void closeDrawer(scaffoldKey) {
    if (scaffoldKey.currentState.isDrawerOpen) {
      scaffoldKey.currentState.closeDrawer();
    }
  }
}

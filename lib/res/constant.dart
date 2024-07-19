import 'package:flutter/material.dart';

class AppConstants {
  static late double screenWidth;
  static late double screenHeight;
  static late double appBarHeight;

  static void init(BuildContext context) {
    // Initialize screenWidth using MediaQuery
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    appBarHeight = kToolbarHeight;
  }
}

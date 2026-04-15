import 'package:flutter/material.dart';

class AppscreenUtil {
  AppscreenUtil._();
  static late double screenWidth;
  static late double screenHeight;

  static late double scaleWidth;
  static late double scaleHeight;
  static late double scaleText;

  static double designWidth = 375;
  static double designHeight = 812;
   
  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;

    scaleWidth = screenWidth / designWidth;
    scaleHeight = scaleHeight / designHeight;
    scaleText = scaleWidth;
  }

  static double w(double width) => width * scaleWidth;
  static double h(double height) => height * scaleHeight;
  static double sp(double size) => size * scaleText;
}
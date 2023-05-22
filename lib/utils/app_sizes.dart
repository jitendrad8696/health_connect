import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSizes {
  static late double height10, width10;

  static mediaQueryHeightWidth() {
    height10 = Get.mediaQuery.size.height * 0.0119;
    width10 = Get.mediaQuery.size.width * 0.0119 * 2.05;
  }

  static EdgeInsets horizontalPadding20 =
      EdgeInsets.symmetric(horizontal: width10 * 2, vertical: 0);
}

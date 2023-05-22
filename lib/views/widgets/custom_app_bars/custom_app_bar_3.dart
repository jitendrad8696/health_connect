import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_connect/const/color_const.dart';
import 'package:health_connect/const/font_const.dart';
import 'package:health_connect/const/string_const.dart';
import 'package:health_connect/utils/app_sizes.dart';

AppBar appBar3 = AppBar(
  automaticallyImplyLeading: false,
  elevation: 0,
  centerTitle: true,
  toolbarHeight: AppSizes.height10 * 7,
  backgroundColor: ColorConst.primaryColor,
  systemOverlayStyle: const SystemUiOverlayStyle().copyWith(
    statusBarColor: ColorConst.primaryColor,
  ),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(AppSizes.height10 * 3),
    ),
  ),
  title: Text(
    StringConst.appTitle,
    style: TextStyle(
      fontFamily: FontConst.nunitoSans,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.width10 * 2.8,
      letterSpacing: 1.6,
    ),
  ),
);

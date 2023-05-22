import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_connect/const/color_const.dart';
import 'package:health_connect/const/image_const.dart';
import 'package:health_connect/utils/app_sizes.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppSizes.mediaQueryHeightWidth();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle()
        .copyWith(statusBarColor: ColorConst.primaryColor));

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            ImageConst.error,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}

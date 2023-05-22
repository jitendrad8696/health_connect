import 'package:flutter/material.dart';
import 'package:health_connect/const/image_const.dart';
import 'package:health_connect/utils/app_sizes.dart';
import 'package:health_connect/views/widgets/custom_app_bars/custom_app_bar_1.dart';
import 'package:lottie/lottie.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppSizes.mediaQueryHeightWidth();

    return Scaffold(
      appBar: appBar1,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(ImageConst.json1),
          ],
        ),
      ),
    );
  }
}

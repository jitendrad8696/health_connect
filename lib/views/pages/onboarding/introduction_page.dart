import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect/const/color_const.dart';
import 'package:health_connect/const/image_const.dart';
import 'package:health_connect/const/string_const.dart';
import 'package:health_connect/utils/app_sizes.dart';
import 'package:health_connect/views/pages/onboarding/onboarding_page.dart';
import 'package:health_connect/views/widgets/custom_app_bars/custom_app_bar_1.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppSizes.mediaQueryHeightWidth();
    return Scaffold(
      backgroundColor: ColorConst.whiteColor,
      appBar: appBar1,
      body: IntroductionScreen(
        done: Icon(Icons.arrow_forward,
            size: AppSizes.height10 * 4, color: ColorConst.primaryColor),
        next: Icon(Icons.arrow_forward,
            size: AppSizes.height10 * 4, color: ColorConst.primaryColor),
        pages: [
          PageViewModel(
            decoration: const PageDecoration(imageFlex: 2),
            image: Lottie.asset(ImageConst.json1),
            title: StringConst.introductionScreenString1.toUpperCase(),
            body: '',
          ),
          PageViewModel(
            decoration: const PageDecoration(imageFlex: 2),
            image: Lottie.asset(ImageConst.json2),
            title: StringConst.introductionScreenString2.toUpperCase(),
            body: '',
          ),
          PageViewModel(
            decoration: const PageDecoration(imageFlex: 2),
            image: Lottie.asset(ImageConst.json3),
            title: StringConst.introductionScreenString3.toUpperCase(),
            body: '',
          ),
        ],
        onDone: () {
          Get.to(() => const OnboardingPage());
        },
      ),
    );
  }
}

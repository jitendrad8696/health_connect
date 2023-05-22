import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect/const/color_const.dart';
import 'package:health_connect/const/image_const.dart';
import 'package:health_connect/const/string_const.dart';
import 'package:health_connect/utils/app_sizes.dart';
import 'package:health_connect/views/pages/onboarding/sign_in_page.dart';
import 'package:health_connect/views/pages/onboarding/sign_up_page.dart';
import 'package:health_connect/views/widgets/custom_app_bars/custom_app_bar_1.dart';
import 'package:health_connect/views/widgets/custom_buttons/custom_button_1.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar1,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                color: ColorConst.whiteColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(ImageConst.json1),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: AppSizes.horizontalPadding20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton1(
                      text: StringConst.getStarted,
                      buttonColor: ColorConst.primaryColor,
                      textColor: ColorConst.whiteColor,
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        Get.to(() => SignUpPage());
                      },
                    ),
                    SizedBox(height: AppSizes.height10 * 2.5),
                    CustomButton1(
                      text: StringConst.gotAnAccount,
                      buttonColor: ColorConst.secondaryColor,
                      textColor: ColorConst.whiteColor,
                      onTap: () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        Get.to(() => SignInPage());
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

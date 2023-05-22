import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect/const/color_const.dart';
import 'package:health_connect/const/string_const.dart';
import 'package:health_connect/services/auth.dart';
import 'package:health_connect/utils/app_sizes.dart';
import 'package:health_connect/utils/no_leading_space_formatter.dart';
import 'package:health_connect/utils/no_leading_trailing_space_formatter.dart';
import 'package:health_connect/views/widgets/custom_app_bars/custom_app_bar_3.dart';
import 'package:health_connect/views/widgets/custom_buttons/custom_button_1.dart';
import 'package:health_connect/views/widgets/custom_text_form_fields/custom_text_form_field_1.dart';
import 'package:health_connect/views/widgets/custom_titles/custom_title_1.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final AuthController _controller = Get.find();

  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _rePassController = TextEditingController();

  void onTap(BuildContext context) async {
    if (_key.currentState!.validate()) {
      FocusManager.instance.primaryFocus!.unfocus();
      await _controller.createUser(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar3,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: AppSizes.horizontalPadding20,
            child: Column(
              children: [
                SizedBox(height: AppSizes.height10),
                const CustomTitle1(text: StringConst.emailSignup),
                SizedBox(height: AppSizes.height10 * 2),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _key,
                  child: Column(
                    children: [
                      CustomTextFormField1(
                        controller: _emailController,
                        maxLines: 1,
                        hintText: StringConst.enterYourEmail,
                        validator: (val) {
                          if (GetUtils.isEmail(val!)) {
                            return null;
                          } else {
                            return StringConst.validEmail;
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [NoLeadingTrailingSpaceFormatter()],
                        obscureText: false,
                      ),
                      SizedBox(height: AppSizes.height10 * 2),
                      CustomTextFormField1(
                        controller: _passController,
                        maxLines: 1,
                        hintText: StringConst.enterYourDesiredPassword,
                        validator: (val) {
                          if (GetUtils.isLengthGreaterOrEqual(val!, 8)) {
                            return null;
                          } else {
                            return StringConst.validPassword;
                          }
                        },
                        keyboardType: TextInputType.visiblePassword,
                        inputFormatters: [NoLeadingSpaceFormatter()],
                        obscureText: true,
                      ),
                      SizedBox(height: AppSizes.height10 * 2),
                      CustomTextFormField1(
                        controller: _rePassController,
                        maxLines: 1,
                        hintText: StringConst.reEnterYourPassword,
                        validator: (val) {
                          if (val! == _passController.text) {
                            return null;
                          } else {
                            return StringConst.reValidPassword;
                          }
                        },
                        keyboardType: TextInputType.visiblePassword,
                        inputFormatters: [NoLeadingSpaceFormatter()],
                        obscureText: true,
                      ),
                      SizedBox(height: AppSizes.height10 * 2)
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.height10 * 2),
                CustomButton1(
                  text: StringConst.finishSignup,
                  buttonColor: ColorConst.primaryColor,
                  textColor: ColorConst.whiteColor,
                  onTap: () {
                    onTap(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

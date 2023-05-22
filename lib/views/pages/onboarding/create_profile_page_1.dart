import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect/const/color_const.dart';
import 'package:health_connect/const/string_const.dart';
import 'package:health_connect/controllers/create_profile_controller.dart';
import 'package:health_connect/utils/app_sizes.dart';
import 'package:health_connect/utils/no_leading_trailing_space_formatter.dart';
import 'package:health_connect/views/pages/onboarding/avatar_choose_page.dart';
import 'package:health_connect/views/pages/onboarding/create_profile_page_2.dart';
import 'package:health_connect/views/widgets/custom_app_bars/custom_app_bar_3.dart';
import 'package:health_connect/views/widgets/custom_buttons/custom_button_1.dart';
import 'package:health_connect/views/widgets/custom_text_form_fields/custom_text_form_field_1.dart';
import 'package:health_connect/views/widgets/custom_titles/custom_title_1.dart';

class CreateProfilePage1 extends StatelessWidget {
  CreateProfilePage1({Key? key}) : super(key: key);

  final _controller = Get.put(CreateProfileController());

  final _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  void onTap() {
    if (_key.currentState!.validate()) {
      FocusManager.instance.primaryFocus!.unfocus();
      _controller.updateUserName(_nameController.text.trim());
      _controller.updateUserPhoneNumber(_phoneController.text.trim());
      _controller.updatePinCode(_pinCodeController.text.trim());
      Get.to(() => CreateProfilePage2());
    }
  }

  void onTap2() {
    FocusManager.instance.primaryFocus!.unfocus();
    Get.to(() => AvatarChoosePage());
  }

  @override
  Widget build(BuildContext context) {
    AppSizes.mediaQueryHeightWidth();
    return Scaffold(
      appBar: appBar3,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          reverse: true,
          child: Padding(
            padding: AppSizes.horizontalPadding20,
            child: Column(
              children: [
                SizedBox(height: AppSizes.height10),
                const CustomTitle1(text: StringConst.createProfile),
                SizedBox(height: AppSizes.height10 * 2),
                GestureDetector(
                  onTap: onTap2,
                  child: Stack(
                    children: [
                      Center(
                        child: Obx(
                          () => Image.asset(
                            _controller.avatarImageConstURL(),
                            height: AppSizes.height10 * 10,
                          ),
                        ),
                      ),
                      Positioned(
                        left: AppSizes.width10 * 20.5,
                        top: AppSizes.height10 * 6.7,
                        child: CircleAvatar(
                          backgroundColor: ColorConst.primaryColor,
                          radius: AppSizes.height10 * 1.5,
                          child: Icon(
                            Icons.create_rounded,
                            size: AppSizes.height10 * 2,
                            color: ColorConst.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.height10 * 2),
                Form(
                  key: _key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      CustomTextFormField1(
                        controller: _nameController,
                        maxLines: 1,
                        hintText: StringConst.chooseUserName,
                        validator: (val) {
                          if (GetUtils.isUsername(val!)) {
                            return null;
                          } else {
                            return StringConst.chooseValidUserName;
                          }
                        },
                        keyboardType: TextInputType.name,
                        inputFormatters: [NoLeadingTrailingSpaceFormatter()],
                        obscureText: false,
                      ),
                      SizedBox(height: AppSizes.height10 * 2),
                      CustomTextFormField1(
                        controller: _phoneController,
                        maxLines: 1,
                        hintText: StringConst.enterYourPhone,
                        validator: (val) {
                          if (GetUtils.isPhoneNumber(val!)) {
                            return null;
                          } else {
                            return StringConst.enterValidPhoneNumber;
                          }
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [NoLeadingTrailingSpaceFormatter()],
                        obscureText: false,
                      ),
                      SizedBox(height: AppSizes.height10 * 2),
                      CSCPicker(
                        showStates: true,
                        showCities: true,
                        flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                        onCountryChanged: (value) {
                          _controller.updateCountryValue(value);
                        },
                        onStateChanged: (value) {
                          _controller.updateStateValue(value.toString());
                        },
                        onCityChanged: (value) {
                          _controller.updateCityValue(value.toString());
                        },
                      ),
                      SizedBox(height: AppSizes.height10 * 2),
                      CustomTextFormField1(
                        controller: _pinCodeController,
                        maxLines: 1,
                        hintText: StringConst.enterYourPinCode,
                        validator: (val) {
                          if (GetUtils.isLengthEqualTo(val!, 6)) {
                            return null;
                          } else {
                            return StringConst.enterValidPinCode;
                          }
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [NoLeadingTrailingSpaceFormatter()],
                        obscureText: false,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.height10 * 4),
                CustomButton1(
                  text: StringConst.continueButtonString,
                  buttonColor: ColorConst.primaryColor,
                  textColor: ColorConst.whiteColor,
                  onTap: onTap,
                ),
                SizedBox(height: AppSizes.height10 * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

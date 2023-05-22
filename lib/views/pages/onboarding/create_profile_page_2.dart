import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:health_connect/const/color_const.dart';
import 'package:health_connect/const/string_const.dart';
import 'package:health_connect/controllers/create_profile_controller.dart';
import 'package:health_connect/main.dart';
import 'package:health_connect/services/auth.dart';
import 'package:health_connect/services/db/db_1.dart';
import 'package:health_connect/utils/app_sizes.dart';
import 'package:health_connect/utils/no_leading_trailing_space_formatter.dart';
import 'package:health_connect/views/pages/home/home.dart';
import 'package:health_connect/views/widgets/custom_app_bars/custom_app_bar_3.dart';
import 'package:health_connect/views/widgets/custom_buttons/custom_button_1.dart';
import 'package:health_connect/views/widgets/custom_text_form_fields/custom_text_form_field_1.dart';
import 'package:health_connect/views/widgets/custom_titles/custom_title_1.dart';

class CreateProfilePage2 extends StatelessWidget {
  CreateProfilePage2({Key? key}) : super(key: key);

  final _controller = Get.put(CreateProfileController());

  final _key = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();

  void onTap(BuildContext context) async {
    if (_key.currentState!.validate()) {
      FocusManager.instance.primaryFocus!.unfocus();
      _controller.updateAge(int.parse(_ageController.text.trim()));
      DbController1 controller1 = DbController1();
      await controller1.saveUserInfo(context);
      navigatorKey.currentState!.pop();
      AuthController authController = Get.find();
      await authController.getUserInfo();
      Get.offAll(() => const HomePage());
    }
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
                Form(
                  key: _key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      CustomTextFormField1(
                        controller: _ageController,
                        maxLines: 1,
                        hintText: StringConst.enterYourAge,
                        validator: (val) {
                          if (GetUtils.isNumericOnly(val!)) {
                            return null;
                          } else {
                            return StringConst.enterValidAge;
                          }
                        },
                        keyboardType: TextInputType.number,
                        inputFormatters: [NoLeadingTrailingSpaceFormatter()],
                        obscureText: false,
                      ),
                      SizedBox(height: AppSizes.height10 * 2),
                      MaleOrFemaleDropDown(
                        value: null,
                        onChanged: (String? value) {
                          _controller.updateGender(value.toString());
                        },
                        hint: StringConst.selectGender,
                        validator: (val) {
                          return val == null ? StringConst.selectGender : null;
                        },
                      ),
                      SizedBox(height: AppSizes.height10 * 2),
                      BloodGroupDropDown(
                          value: null,
                          hint: StringConst.selectBloodGroup,
                          onChanged: (String? value) {
                            _controller.updateBloodGroup(value.toString());
                          },
                          validator: (val) {
                            return val == null
                                ? StringConst.selectBloodGroup
                                : null;
                          }),
                      SizedBox(height: AppSizes.height10 * 2),
                      WannaDonateDropDown(
                          value: null,
                          onChanged: (String? value) {
                            if (value.toString() == 'Yes') {
                              _controller.updateWantToDonate(true);
                            } else {
                              _controller.updateWantToDonate(false);
                            }
                          },
                          hint: StringConst.wannaDonate,
                          validator: (val) {
                            return val == null ? StringConst.wannaDonate : null;
                          }),
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.height10 * 4),
                CustomButton1(
                  text: StringConst.continueButtonString,
                  buttonColor: ColorConst.primaryColor,
                  textColor: ColorConst.whiteColor,
                  onTap: () {
                    onTap(context);
                  },
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

class MaleOrFemaleDropDown extends StatelessWidget {
  final String? value;
  final String hint;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const MaleOrFemaleDropDown({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.hint,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      validator: validator,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConst.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConst.primaryColor),
        ),
      ),
      value: value,
      items: <String>['Male', 'Female']
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                    color: ColorConst.blackColor,
                    fontSize: AppSizes.width10 * 1.7),
              ),
            ),
          )
          .toList(),
      hint: Text(
        hint,
        style: TextStyle(fontSize: AppSizes.width10 * 1.67),
      ),
      onChanged: onChanged,
    );
  }
}

class BloodGroupDropDown extends StatelessWidget {
  final String? value;
  final String hint;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const BloodGroupDropDown({
    Key? key,
    required this.value,
    required this.hint,
    required this.onChanged,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      validator: validator,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConst.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConst.primaryColor),
        ),
      ),
      value: value,
      items: <String>[
        'A +',
        'A -',
        'B +',
        'B -',
        'AB +',
        'AB -',
        'O +',
        'O -',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
                color: ColorConst.blackColor, fontSize: AppSizes.width10 * 1.7),
          ),
        );
      }).toList(),
      hint: Text(hint),
      onChanged: onChanged,
    );
  }
}

class WannaDonateDropDown extends StatelessWidget {
  final String? value;
  final String hint;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const WannaDonateDropDown({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.hint,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      validator: validator,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConst.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConst.primaryColor),
        ),
      ),
      value: value,
      items: <String>['Yes', 'No']
          .map<DropdownMenuItem<String>>(
            (String value) => DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                    color: ColorConst.blackColor,
                    fontSize: AppSizes.width10 * 1.7),
              ),
            ),
          )
          .toList(),
      hint: Text(
        hint,
        style: TextStyle(fontSize: AppSizes.width10 * 1.67),
      ),
      onChanged: onChanged,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_connect/const/color_const.dart';
import 'package:health_connect/utils/app_sizes.dart';

class CustomTextFormField1 extends StatelessWidget {
  const CustomTextFormField1({
    Key? key,
    required this.controller,
    required this.maxLines,
    required this.hintText,
    required this.validator,
    required this.keyboardType,
    required this.inputFormatters,
    required this.obscureText,
  }) : super(key: key);
  final TextEditingController controller;
  final int maxLines;
  final String? Function(String?)? validator;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      inputFormatters: inputFormatters,
      textCapitalization: TextCapitalization.sentences,
      maxLines: maxLines,
      validator: validator,
      obscureText: obscureText,
      cursorColor: ColorConst.primaryColor,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: ColorConst.primaryColor,
            width: AppSizes.width10 * 0.2,
          ),
        ),
      ),
    );
  }
}

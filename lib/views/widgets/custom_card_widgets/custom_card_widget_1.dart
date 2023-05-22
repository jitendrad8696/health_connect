import 'package:flutter/material.dart';
import 'package:health_connect/const/color_const.dart';
import 'package:health_connect/const/font_const.dart';
import 'package:health_connect/utils/app_sizes.dart';

class CustomCardWidget1 extends StatelessWidget {
  const CustomCardWidget1({
    Key? key,
    required this.color,
    required this.text,
    required this.image,
    required this.onPressed,
  }) : super(key: key);
  final Color color;
  final String text;
  final Image image;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: AppSizes.height10 * 15,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: ColorConst.greyColor.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                child: image,
              ),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontConst.nunitoSans,
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.height10 * 1.8,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

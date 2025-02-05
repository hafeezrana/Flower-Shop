import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/get_helper.dart';

class MyTextButton extends StatelessWidget {
  MyTextButton({
    required this.title,
    required this.onPressed,
    this.titleColor,
    this.backgroundColor,
    this.borderColor,
    this.fontSize,
    super.key,
  });

  void Function()? onPressed;
  String? title;
  double? fontSize;
  Color? titleColor;
  Color? backgroundColor;

  Color? borderColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.only(top: 15),
      child: SizedBox(
        height: 35.h,
        width: 200.w,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? ConstColors.buttonColor,
            elevation: 10,
            padding: const EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor ?? Colors.transparent),
              borderRadius: BorderRadius.circular(40.0),
            ),
            textStyle: TextStyle(color: Theme.of(Get.context!).primaryColor),
          ),
          onPressed: onPressed,
          child: Text(
            title ?? '',
            style: TextStyle(
              fontSize: fontSize ?? 14.sp,
              fontFamily: 'Cairo',
              color: titleColor ?? ConstColors.whiteColor,
              // fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}

class MyTextButton2 extends StatelessWidget {
  MyTextButton2({
    required this.title,
    required this.onPressed,
    this.titleColor,
    this.backgroundColor,
    this.borderColor,
    this.fontSize,
    super.key,
  });

  void Function()? onPressed;
  String? title;
  double? fontSize;
  Color? titleColor;
  Color? backgroundColor;
  Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: SizedBox(
        height: 50,
        width: Get.width * 0.5,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            elevation: 8,
            padding: const EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor ?? Colors.transparent),
              borderRadius: BorderRadius.circular(40.0),
            ),
            textStyle: TextStyle(color: Theme.of(Get.context!).primaryColor),
          ),
          onPressed: onPressed,
          child: Text(
            title ?? '',
            style: TextStyle(
              fontSize: fontSize ?? 20.sp,
              fontFamily: 'Cairo',
              color: titleColor ?? Theme.of(Get.context!).primaryColor,
              // fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }
}

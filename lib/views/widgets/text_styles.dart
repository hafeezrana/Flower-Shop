import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flowershop/utils/colors_const.dart';

class MyTextStyles {
  static const extraSmallText = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: ConstColors.swatch5,
    // fontFamily: 'Lato Thin',
  );
  static const smallText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
    // fontFamily: 'Madimi one',
  );
  static const mediumText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Colors.black,

    // fontFamily: 'Madimi One',
  );
  static const mediumL = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: ConstColors.black,
    // fontFamily: 'Madimi One',
  );

  static const largeText = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: ConstColors.grey,
    // fontFamily: 'Madimi One',
  );
  static const extraLargeText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: ConstColors.swatch5,
    // fontFamily: 'Madimi One',
  );
}

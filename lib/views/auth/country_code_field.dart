import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:flutter/services.dart';
import 'package:flowershop/utils/colors_const.dart';

class CountryCodeField extends StatelessWidget {
  CountryCodeField(
      {this.controller,
      this.onCountryChanged,
      this.validator,
      this.label,
      this.onChanged,
      super.key});
  String? label;
  TextEditingController? controller;
  void Function(PhoneNumber)? onChanged;
  void Function(Country)? onCountryChanged;
  FutureOr<String?> Function(PhoneNumber?)? validator;

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      validator: validator != null ? validator! : (value) => null,
      onCountryChanged:
          onCountryChanged != null ? onCountryChanged! : (country) {},
      style: TextStyle(
        // fontFamily: 'myflutterapp.ttf',
        fontSize: 12.sp,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      // inputFormatters: [
      //   LengthLimitingTextInputFormatter(11),
      //   FilteringTextInputFormatter.digitsOnly,
      //   TextInputFormatter.withFunction((oldValue, newValue) {
      //     String inputText = newValue.text;
      //
      //     if (inputText.isNotEmpty && inputText[0] != '7') {
      //       return oldValue;
      //     }
      //
      //     RegExp repeatedPattern = RegExp(r'(\d)\1{5,}');
      //     if (repeatedPattern.hasMatch(inputText)) {
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         const SnackBar(
      //           content: Text("قمت بتكرار نفس الرقم أكثر من 5 مرات متتالية"),
      //           backgroundColor: Colors.blueAccent,
      //           behavior: SnackBarBehavior.floating,
      //           duration: Duration(seconds: 3),
      //         ),
      //       );
      //
      //       return oldValue;
      //     }
      //
      //     return newValue;
      //   }),
      // ],
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: true,
        isDense: true,
        // focusColor: Colors.grey,
        // contentPadding: EdgeInsets.all(6.sp),
        errorStyle: const TextStyle(
          // fontFamily: 'Cairo',
          color: Colors.red,
          fontSize: 12,
        ),
        // errorText: controller!.text.isNotEmpty ? '' : 'Please enter number',
        fillColor: ConstColors.whiteColor,
        label: Center(child: Text(label ?? '')),
        labelStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          borderSide: BorderSide(
            color: Color.fromRGBO(240, 240, 240, 1),
            width: 3.0,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          borderSide: BorderSide(
            color: Color.fromRGBO(240, 240, 240, 1),
            width: 1,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          borderSide: BorderSide(
            color: Color.fromRGBO(240, 240, 240, 1),
            width: 1,
          ),
        ),
      ),
      initialCountryCode: 'IQ',
      onChanged: (phone) {
        String? phoneNumber = phone.number;

        if (controller != null && phoneNumber != null) {
          controller!.text = phoneNumber;
        }

        if (onChanged != null) {
          onChanged!(phone);
        }
      },
    );
  }
}

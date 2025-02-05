import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowershop/utils/colors_const.dart';

class ReusableTextField extends StatelessWidget {
  ReusableTextField({
    this.textDirection,
    this.controller,
    this.onChanged,
    this.label,
    this.prefixIcon,
    this.maxLines,
    this.minLines,
    this.keyBoardType,
    this.isEnable,
    this.onTap,
    this.onFieldSubmitted,
    this.focusNode,
    this.validator,
    this.suffixIcon,
    this.disableBorder,
    super.key,
  });

  TextDirection? textDirection;
  TextEditingController? controller;
  void Function(String)? onChanged;
  void Function(String)? onFieldSubmitted;
  void Function()? onTap;
  String? Function(String?)? validator;
  String? label;
  IconData? prefixIcon;
  Widget? suffixIcon;
  bool? isEnable;
  FocusNode? focusNode;
  bool? disableBorder;
  int? maxLines;
  int? minLines;
  TextInputType? keyBoardType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: disableBorder == false ? 50 : null,
      child: TextFormField(
        key: key,
        enabled: isEnable,
        focusNode: focusNode,
        validator: validator,
        controller: controller,
        onChanged: onChanged,
        minLines: minLines,
        onFieldSubmitted: onFieldSubmitted,
        maxLines: maxLines,
        keyboardType: keyBoardType,
        style: const TextStyle(
          // fontFamily: 'Cairo',
          color: Colors.black,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,

          // isDense: true,
          suffixIcon: suffixIcon,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          errorStyle: const TextStyle(
            // fontFamily: 'Cairo',
            color: Colors.red,
            fontSize: 12,
          ),
          fillColor: ConstColors.whiteColor,
          label: Center(child: Text(label ?? '')),
          labelStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(24.0),
            ),
            borderSide: BorderSide(
              color: Color.fromRGBO(240, 240, 240, 1),
              width: 3.0,
            ),
          ),
          enabledBorder: disableBorder == true
              ? const OutlineInputBorder(borderSide: BorderSide.none)
              : const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.0)),
                  borderSide: BorderSide(color: Colors.white, width: 1),
                ),
          disabledBorder: disableBorder == true
              ? const OutlineInputBorder(borderSide: BorderSide.none)
              : const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.0)),
                  borderSide: BorderSide(color: Colors.black54, width: 1),
                ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          enabled: true,
          focusedBorder: disableBorder == true
              ? const OutlineInputBorder(borderSide: BorderSide.none)
              : const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.0)),
                  borderSide: BorderSide(color: ConstColors.grey, width: 1),
                ),
        ),
      ),
    );
  }
}

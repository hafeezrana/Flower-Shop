import 'package:flutter/material.dart';

import '../../utils/colors_const.dart';

class ReusableDropDown extends StatelessWidget {
  ReusableDropDown(
      {required this.value,
      required this.items,
      this.hintText,
      required this.onChanged,
      this.disableBorder,
      super.key});

  dynamic value;
  List<DropdownMenuItem<dynamic>>? items;
  void Function(dynamic)? onChanged;
  String? hintText;
  bool? disableBorder;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<dynamic>(
          value: value,
          hint: Text(hintText ?? ''),
          isDense: true,
          isExpanded: true,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.all(8),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              borderSide: BorderSide(
                color: Color.fromRGBO(240, 240, 240, 1),
                width: 3.0,
              ),
            ),
            enabledBorder: disableBorder == true
                ? const OutlineInputBorder(borderSide: BorderSide.none)
                : const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.black54, width: 1),
                  ),
            disabledBorder: disableBorder == true
                ? const OutlineInputBorder(borderSide: BorderSide.none)
                : const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.black54, width: 1),
                  ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            enabled: true,
            focusedBorder: disableBorder == true
                ? const OutlineInputBorder(borderSide: BorderSide.none)
                : OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(color: Colors.black54, width: 1),
                  ),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

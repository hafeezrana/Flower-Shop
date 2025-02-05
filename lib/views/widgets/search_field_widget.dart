import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;
  final TextEditingController? controller;
  final bool autoFocus;

  const SearchField({
    Key? key,
    this.onChanged,
    this.hintText = "Search...",
    this.controller,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: controller,
        autofocus: autoFocus,
        onFieldSubmitted: onChanged,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          fillColor: Colors.green.shade500,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: controller != null && controller!.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    controller?.clear();
                    if (onChanged != null) {
                      onChanged!('');
                    }
                  },
                )
              : null,
        ),
      ),
    );
  }
}

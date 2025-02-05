import 'package:flutter/material.dart';

class AppNav {
  static pushAndRemoveUntil(context, Widget page) {
    return Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (c) => page), (route) => false);
  }

  static push(context, Widget page) {
    return Navigator.push(context, MaterialPageRoute(builder: (c) => page));
  }

  static pushReplacemend(BuildContext context, Widget page) {
    return Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return page;
      },
    ));
  }
}

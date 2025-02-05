import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ShowToast {
  static msg(String msg) {
    return Fluttertoast.showToast(msg: msg);
  }

  static loader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  static waveDot() {
    return LoadingAnimationWidget.waveDots(
      color: Colors.white,
      size: 40,
    );
  }
}

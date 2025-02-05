import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Get {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Get screen width
  static double get width =>
      MediaQuery.of(navigatorKey.currentContext!).size.width;

  /// Get screen height
  static double get height =>
      MediaQuery.of(navigatorKey.currentContext!).size.height;

  /// Get the stored BuildContext safely
  static BuildContext get context => navigatorKey.currentContext!;
}

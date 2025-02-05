import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppPreferences {
  static SharedPreferences? _pref;

  static const fcmToken = 'fcmToken';
  static const phoneNum = 'phoneNum';
  static const uFullName = 'userFullName';
  static const isLoggedIn = 'isLoggedIn';
  static const newUser = 'newUser';
  static const pendingOrder = 'pending_order';
  static const languageCode = 'LanguageCode';

  static const themeStatus = "THEMESTATUS";

  static const userId = 'userId';

  static Future initializeSharedPrefs() async {
    _pref = await SharedPreferences.getInstance();
  }

  static Future setString(String key, String value) async {
    await _pref?.setString(key, value);
  }

  static Future setBoolean(String key, bool value) async {
    await _pref?.setBool(key, value);
  }

  static Future setInt(String key, int value) async {
    await _pref?.setInt(key, value);
  }

  static String getString(String key) {
    String? value = _pref?.getString(key);
    return value ?? '';
  }

  static int? getInt(String key) {
    int? value = _pref?.getInt(key);
    return value;
  }

  static bool? getBool(String key) {
    bool? value = _pref?.getBool(key);
    return value ?? false;
  }

  static Future setStringList(String key, List<String> value) async {
    await _pref?.setStringList(key, value);
  }

  static List<String> getStringList(String key) {
    List<String>? entries = _pref?.getStringList(key);
    return entries ?? [];
  }

  static Future<bool> clearPreferences() async {
    final cleared = await _pref!.clear();
    return cleared;
  }

  static Future<bool> removeKey(String key) async {
    final remove = await _pref!.remove(key);
    return remove;
  }
}

/// Animated loading GIF
loadingRole() {
  return Center(
    child: Image(
      height: 300.h,
      width: 300.w,
      image: const AssetImage('img/loading.gif'),
    ),
  );
}

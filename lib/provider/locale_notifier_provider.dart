import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/utils/get_helper.dart';

final localeProvider = StateProvider<Locale>((ref) {
  return const Locale('en');
});

final textDirectionProvider = Provider<TextDirection>((ref) {
  final locale = ref.watch(localeProvider);

  return locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
});

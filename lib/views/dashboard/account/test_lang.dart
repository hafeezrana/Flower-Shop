import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TestLangScreen extends StatelessWidget {
  const TestLangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr()), // Translated app title
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('login'.tr()), // Translated login text
            const SizedBox(height: 20),
            Text('create_new_acc'.tr()), // Translated sign-up text
            const SizedBox(height: 20),
            Text('full_name'.tr()), // Translated full name text
            const SizedBox(height: 20),
            Text('phone_no'.tr()), // Translated phone number text
          ],
        ),
      ),
    );
  }
}

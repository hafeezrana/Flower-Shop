import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/provider/locale_notifier_provider.dart';
import 'package:flowershop/services/fcm_notification_service.dart';
import 'package:flowershop/utils/app_preferences.dart';
import 'package:flowershop/views/dashboard/btm_navbar_view.dart';
import 'package:flowershop/views/widgets/app_navigator.dart';

class LanguageSelector extends ConsumerStatefulWidget {
  const LanguageSelector({super.key});

  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends ConsumerState<LanguageSelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('language'.tr()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final newLocale = const Locale('en');
                await context.setLocale(newLocale);
                ref.watch(localeProvider.notifier).state = newLocale;
                ref.read(selectedViewIndexProvider.notifier).state = 0;

                setState(() {});
                AppNav.push(context, const MainView());
              },
              child: const Text('English'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newLocale = Locale('ar');
                await context.setLocale(newLocale);
                ref.watch(localeProvider.notifier).state = newLocale;
                ref.read(selectedViewIndexProvider.notifier).state = 0;

                setState(() {});
                AppNav.push(context, const MainView());
              },
              child: const Text('العربية'),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     final token = AppPreferences.getString(AppPreferences.fcmToken);
            //     FCMService.sendPushNotification(
            //         fcmToken: token, title: "Hello ", body: "Hellp Body");
            //   },
            //   child: const Text('Send NOtification'),
            // ),
          ],
        ),
      ),
    );
  }
}

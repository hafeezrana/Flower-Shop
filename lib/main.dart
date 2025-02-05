import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flowershop/provider/locale_notifier_provider.dart';
import 'package:flowershop/services/lang_service.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flowershop/utils/app_preferences.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/connectivity.dart';
import 'package:flowershop/views/splash.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'utils/get_helper.dart';
import 'utils/key_consts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppPreferences.initializeSharedPrefs();
  await EasyLocalization.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConsts.supabaseUrl,
    anonKey: SupabaseConsts.supabaseAnnonKey,
  );

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    Phoenix(
      child: ProviderScope(
        child: EasyLocalization(
          supportedLocales: const [
            Locale('en'), // English
            Locale('ar'), // Arabic
          ],
          path: 'assets/translations',
          useOnlyLangCode: true,
          saveLocale: true,
          fallbackLocale: const Locale('en'),
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final direction = ref.watch(textDirectionProvider);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Directionality(
          textDirection: direction,
          child: MaterialApp(
            title: 'Kadi Flowers',
            navigatorKey: Get.navigatorKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,

            // Set text direction based on locale
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: ConstColors.swatch1),
              useMaterial3: true,
            ),
            home: const ConnectivityWrapper(
              child: SplashView(),
            ),
          ),
        );
      },
    );
  }
}

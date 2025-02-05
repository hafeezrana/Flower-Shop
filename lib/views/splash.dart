import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flowershop/provider/auth/auth_notifier.dart';
import 'package:flowershop/services/fcm_notification_service.dart';

import 'package:flowershop/utils/app_preferences.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/connectivity.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/views/auth/authentication_view.dart';
import 'package:flowershop/views/dashboard/btm_navbar_view.dart';
import 'package:flowershop/views/preview.dart';
import 'package:flowershop/views/widgets/app_navigator.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    checkConnectivity();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // Initialize app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _initializeApp() async {
    await ref.read(authStateProvider.notifier).getUserInfo();
    await ref.watch(fcmServiceProvider).initialize();
    ref.read(authStateProvider.notifier).updateFcmToken();
    await _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    ref.read(selectedViewIndexProvider.notifier).state = 0;
    final isLoggedIn = AppPreferences.getBool(AppPreferences.isLoggedIn);
    final isOldUser = AppPreferences.getBool(AppPreferences.newUser);
    final userId = ref.read(authStateProvider).user?.id;
    bool connection = await checkConnectivity();

    if (!mounted) return;
    if (connection) {
      if (isOldUser == null || !isOldUser) {
        AppPreferences.clearPreferences();
        await AppNav.pushReplacemend(context, Preview());
      } else if (isLoggedIn! && userId != null) {
        await AppNav.pushReplacemend(context, const MainView());
      } else {
        AppPreferences.clearPreferences();
        await AppNav.pushReplacemend(context, AuthenticationView());
      }
    } else {
      AppNav.push(context, NoConnectionView());
    }
  }

  Future<bool> checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    return connectivityResult.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.other);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstColors.swatch2,
      body: SafeArea(
        child: Container(
          height: Get.height,
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated logo
              FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  'assets/images/logo.png',
                  color: Colors.red,
                  height: 120,
                ),
              ),

              const SizedBox(height: 24),

              // // Loading indicator or error message
              // initializationState.when(
              //   loading: () => const CircularProgressIndicator(
              //     valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              //   ),
              //   error: (error, _) => Text(
              //     'Error initializing app: ${error.toString()}',
              //     style: const TextStyle(color: Colors.red),
              //     textAlign: TextAlign.center,
              //   ),
              //   data: (_) => const SizedBox.shrink(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flowershop/provider/auth/auth_notifier.dart';
import 'package:flowershop/utils/app_preferences.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/views/auth/pin_otp_view.dart';
import 'package:flowershop/views/dashboard/btm_navbar_view.dart';
import '../widgets/alert_dialogue.dart';
import '../widgets/app_navigator.dart';

class CodeVerificationPage extends ConsumerStatefulWidget {
  CodeVerificationPage({super.key});

  @override
  ConsumerState<CodeVerificationPage> createState() =>
      _CodeVerificationPageState();
}

class _CodeVerificationPageState extends ConsumerState<CodeVerificationPage>
    with SingleTickerProviderStateMixin {
  String smsCode = '';
  final smsCodeController = TextEditingController();
  int timerStart = 30;
  Timer? _timer;
  late AnimationController _controller;
  bool canResend = false;
  bool isVerifying = false;

  void startCountDown() {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (timerStart == 0) {
          timer.cancel();
          canResend = true;
        } else {
          timerStart--;
        }
      });
    });
  }

  void verifyCode(String value) {
    final authState = ref.watch(authStateProvider);

    if (authState.otpCode == value &&
        smsCodeController.text == authState.otpCode) {
      setState(() => isVerifying = true);

      // Set login status before navigation
      AppPreferences.setBoolean(AppPreferences.isLoggedIn, true).then((_) {
        AppNav.pushAndRemoveUntil(context, const MainView());
      });
    } else {
      if (mounted) {
        setState(() {
          smsCodeController.clear();
          isVerifying = false;
        });
        MyDialogue.showMsg("invalid_otp".tr());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this, value: 0.1);

    // Start countdown in the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        startCountDown();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    // Cancel timer first
    _timer?.cancel();
    _timer = null;

    // Then dispose controllers
    _controller.dispose();
    // smsCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authPro = ref.watch(authStateProvider.notifier);

    return WillPopScope(
      onWillPop: () async {
        // Cancel timer and cleanup before popping
        _timer?.cancel();
        return true;
      },
      child: Scaffold(
        backgroundColor: ConstColors.swatch1,
        body: Container(
          padding: const EdgeInsets.all(10),
          height: Get.height,
          width: Get.width,
          decoration: const BoxDecoration(
            color: ConstColors.swatch1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'enter_otp'.tr(),
                style: const TextStyle(
                  color: ConstColors.deepGrey,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              ReusablePinCodeField(
                pinFieldController: smsCodeController,
                onCompleted: (value) => verifyCode(value),
              ),
              const SizedBox(height: 10),
              if (!canResend)
                Text(
                  '$timerStart',
                  style: TextStyle(
                    fontSize: 26.sp,
                    color: Colors.red,
                  ),
                )
              else
                GestureDetector(
                  onTap: !isVerifying
                      ? () async {
                          if (!mounted) return;
                          setState(() {
                            timerStart = 30;
                            canResend = false;
                            if (smsCodeController.hasListeners) {
                              smsCodeController.clear();
                            }
                          });
                          startCountDown();
                          await authPro.verifyWhatsApp();
                        }
                      : null,
                  child: Text(
                    'otp_not_received'.tr(),
                    style: const TextStyle(
                      color: ConstColors.deepGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

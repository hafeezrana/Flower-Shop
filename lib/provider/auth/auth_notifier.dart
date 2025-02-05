import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/provider/auth/auth_state.dart';
import 'package:flowershop/repositories/auth_repository.dart';
import 'package:flowershop/utils/app_preferences.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:flowershop/views/widgets/app_navigator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../views/auth/otp_verification_view.dart';

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, UserAuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(repository);
});

// StateNotifier
class AuthStateNotifier extends StateNotifier<UserAuthState> {
  final AuthRepository _repository;

  AuthStateNotifier(this._repository) : super(UserAuthState());

  Future<void> createUser(Map<String, dynamic> data) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final user = await _repository.createUser(data);
      if (user != null) {
        final otpCode = await _repository.verifyPhoneViaWhatsApp(
          fullName: user.fullName!,
          phoneNo: user.phoneNo!,
        );
        state = state.copyWith(user: user, isLoading: false, otpCode: otpCode);
        await AppNav.push(Get.context, CodeVerificationPage());
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> login(String phoneNo) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final user = await _repository.login(phoneNo);
      if (user != null) {
        final otpCode = await _repository.verifyPhoneViaWhatsApp(
          fullName: user.fullName!,
          phoneNo: user.phoneNo!,
        );
        state = state.copyWith(user: user, isLoading: false, otpCode: otpCode);
        await AppNav.push(Get.context, CodeVerificationPage());
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      ShowToast.msg(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updateFcmToken() async {
    try {
      await _repository.updateFcmToken();
    } catch (e) {
      ShowToast.msg(e.toString());
    }
  }

  Future<void> deleteAccount() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _repository.deleteAccount();
      state = UserAuthState();
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      ShowToast.msg(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
      state = UserAuthState();
    } catch (e) {
      ShowToast.msg(e.toString());
    }
  }

  Future<dynamic> verifyWhatsApp() async {
    try {
      state = state.copyWith(isLoading: true, otpCode: null);
      final fullName = AppPreferences.getString(AppPreferences.uFullName);
      final phoneNumber = AppPreferences.getString(AppPreferences.phoneNum);

      final otpCode = await _repository.verifyPhoneViaWhatsApp(
          resend: true, phoneNo: phoneNumber, fullName: fullName);

      state = state.copyWith(isLoading: false, otpCode: otpCode);
    } catch (e) {
      ShowToast.msg(e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getUserInfo() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final user = await _repository.getUserInfo();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      // ShowToast.msg(e.toString());
    }
  }
}

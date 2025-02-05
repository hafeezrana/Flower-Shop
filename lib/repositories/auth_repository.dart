import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/model/userdata.dart';
import 'package:flowershop/utils/app_preferences.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/utils/network_helper.dart';
import 'package:flowershop/utils/request_handler.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:flowershop/views/auth/otp_verification_view.dart';
import 'package:flowershop/views/splash.dart';
import 'package:flowershop/views/widgets/app_navigator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase;
  final RequestHandler _requestHandler;

  AuthRepository({
    required SupabaseClient supabase,
    required RequestHandler requestHandler,
  })  : _supabase = supabase,
        _requestHandler = requestHandler;

  Future<UserData?> createUser(Map<String, dynamic> data) async {
    return await _requestHandler.execute<UserData?>(
      request: () async {
        try {
          // Check if the user already exists based on phone number
          final userExists = await _supabase
              .from('profiles')
              .select()
              .eq('phone_no', data['phone_no'])
              .limit(1);

          if (userExists.isNotEmpty) {
            final existingUser = userExists.first;

            if (existingUser['status'] == 0) {
              // Reactivate user account
              final response = await _supabase
                  .from('profiles')
                  .update({'status': 1, 'full_name': data['full_name']})
                  .eq('id', existingUser['id'])
                  .select()
                  .single();

              final user = UserData.fromJson(response);
              print('userExists: ${user.fullName}');

              await _saveUserData(user);
              return user;
            } else {
              ShowToast.msg('User already exists');
              return null;
            }
          } else {
            // Insert new user
            final response =
                await _supabase.from('profiles').insert(data).select().single();

            final user = UserData.fromJson(response);
            print('userExist 2: ${user.phoneNo}');

            await _saveUserData(user);
            return user;
          }
        } catch (e) {
          print('Error in createUser: $e');
          ShowToast.msg('Something went wrong. Please try again.');
          return null;
        }
      },
    );
  }

  Future<UserData?> login(String phoneNo) async {
    return await _requestHandler.execute<UserData?>(
      request: () async {
        final response = await _supabase
            .from('profiles')
            .select()
            .eq('phone_no', phoneNo)
            .eq('status', 1);

        if (response.isEmpty) {
          ShowToast.msg('User not found');
        } else {
          final user = UserData.fromJson(response.first);

          await _saveUserData(user);

          return user;
        }
      },
    );
  }

  Future<void> updateFcmToken() async {
    return await _requestHandler.execute(
      request: () async {
        final token = AppPreferences.getString(AppPreferences.fcmToken);
        final userId = AppPreferences.getInt(AppPreferences.userId);
        if (userId == null) {
          debugPrint('User ID not found');
        } else {
          await _supabase
              .from('profiles')
              .update({'token': token}).eq('id', userId);
        }
      },
    );
  }

  Future<void> deleteAccount() async {
    return await _requestHandler.execute(
      request: () async {
        final userId = AppPreferences.getInt(AppPreferences.userId);
        if (userId == null) {
          ShowToast.msg('User ID not found');
        } else {
          final response = await _supabase
              .from('profiles')
              .update({'status': 0})
              .eq('id', userId)
              .select('id');
          print("delete acc: $response");

          if (response.first['id'] == userId) {
            await logout();
          }
        }
      },
    );
  }

  Future<void> logout() async {
    await AppPreferences.clearPreferences();
    AppNav.pushAndRemoveUntil(Get.context, const SplashView());
  }

  Future<UserData?> getUserInfo() async {
    return await _requestHandler.execute<UserData?>(
      request: () async {
        final userId = AppPreferences.getInt(AppPreferences.userId);
        if (userId == null) {
          debugPrint('User ID not found');
        } else {
          final response = await _supabase
              .from('profiles')
              .select()
              .eq('id', userId)
              .eq('status', 1);

          return UserData.fromJson(response.first);
        }
      },
    );
  }

  // Private helper methods
  Future<void> _saveUserData(UserData user) async {
    await AppPreferences.setInt(AppPreferences.userId, user.id!.toInt());
    await AppPreferences.setString(AppPreferences.phoneNum, user.phoneNo!);
    await AppPreferences.setString(AppPreferences.uFullName, user.fullName!);
  }

  Future<String?> verifyPhoneViaWhatsApp({
    required String phoneNo,
    required String fullName,
    bool resend = false,
  }) async {
    const String apiUrl =
        'https://waapi.app/api/v1/instances/7974/client/action/send-message';
    const String apiKey = 'gLVljroKS3yfidd70RtQS6zCJIpSWrHuSNxeS8vSb2f0820b';

    final String verificationCode = _generateVerificationCode();

    final response = await ApiCalls.post(
      url: apiUrl,
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'chatId': '$phoneNo@c.us',
        'message': _generateWhatsAppMessage(fullName, verificationCode),
      }),
    );

    if (response['data']['status'] != 'success') {
      ShowToast.msg(
          response['data']['message'] ?? 'WhatsApp verification failed');
    } else {
      await AppPreferences.setBoolean(AppPreferences.newUser, true);
      await updateFcmToken();
      return verificationCode;
    }
  }

  String _generateVerificationCode() {
    return (1000 + Random().nextInt(9999 - 1000)).toString();
  }

  String _generateWhatsAppMessage(String fullName, String code) {
    return '''أهلاً بك *$fullName*
رمز التحقق الخاص بك هو: *$code*
هذه الدردشة متاحة للإجابة على استفساراتك على مدار الساعة
شكراً 🌹''';
  }

  String removeLeadingZero(String input) {
    if (input.isNotEmpty && (input.startsWith('0') || input.startsWith('+'))) {
      return input.substring(1);
    }
    return input;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    supabase: Supabase.instance.client,
    requestHandler: RequestHandler(),
  );
});

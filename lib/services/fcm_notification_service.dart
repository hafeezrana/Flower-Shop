import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/utils/app_preferences.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/utils/network_helper.dart';

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final GlobalKey<NavigatorState> navigatorKey;

  FCMService({required this.navigatorKey});

  /// Initialize FCM service and set up all necessary handlers
  Future<void> initialize() async {
    try {
      // Request permissions and get initial token
      await _requestPermission();
      final token = await _getFCMToken();

      // Set up notification handlers
      _setupForegroundNotificationHandler();
      _setupBackgroundNotificationHandler();
      _setupTokenRefreshHandler();

      debugPrint('FCM Service initialized successfully. Token: $token');
    } catch (e) {
      debugPrint('Error initializing FCM service: $e');
      rethrow;
    }
  }

  /// Request notification permissions
  Future<void> _requestPermission() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      debugPrint(
          'Notification permission status: ${settings.authorizationStatus}');
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
      rethrow;
    }
  }

  /// Get FCM token and store it
  Future<String?> _getFCMToken() async {
    try {
      final fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        await AppPreferences.setString(AppPreferences.fcmToken, fcmToken);
        debugPrint('FCM Token stored successfully: $fcmToken');
      } else {
        debugPrint('Failed to get FCM token');
      }
      return fcmToken;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      rethrow;
    }
  }

  /// Handle foreground notifications
  void _setupForegroundNotificationHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Foreground notification received:');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Body: ${message.notification?.body}');
      debugPrint('Data: ${message.data}');
      ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
          content: Text('Notifiacation: ${message.notification?.title}')));

      // Show in-app notification dialog
      _showNotificationDialog(message, Get.context);
    }).onError((error) {
      debugPrint('Error in foreground notification handler: $error');
    });
  }

  /// Set up background message handler
  void _setupBackgroundNotificationHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessageHandler);
  }

  /// Handle token refresh
  void _setupTokenRefreshHandler() {
    FirebaseMessaging.instance.onTokenRefresh.listen((String fcmToken) async {
      debugPrint('FCM Token refreshed: $fcmToken');
      try {
        await AppPreferences.setString(AppPreferences.fcmToken, fcmToken);
        // Here you might want to send the new token to your backend
      } catch (e) {
        debugPrint('Error handling token refresh: $e');
      }
    }).onError((error) {
      debugPrint('Error in token refresh handler: $error');
    });
  }

  /// Show in-app notification dialog
  void _showNotificationDialog(RemoteMessage message, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message.notification?.title ?? 'Notification'),
            content:
                Text(message.notification?.body ?? 'You have a new message'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  static const String _serverKey =
      'ya29.a0AXeO80R8t_j2_P7MVXqrDkEypog2i6Frk13UbwPggprr34jl9GVgphGzP7FsEGg6hT46uOgCLxuJBK7X8xruQNiZpEuoY90OuZnbpEajj7Xx4w3x_ZBanmVe1UuwqZ4j_7dHOvhvV1X3v1ptmFjBY-eR-6wnsi3ymAD9XElZaCgYKAVYSAQ4SFQHGX2Micx1Cch-VRgBa1dltaZjKaw0175';
  static const String _fcmUrl =
      'https://fcm.googleapis.com/v1/projects/kadi-flowers/messages:send';

  // Send notification to a specific device
  static Future<bool> sendPushNotification({
    required String fcmToken,
    required String title,
    required String body,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_serverKey',
      };

      final notification = {
        "message": {
          "token": fcmToken,
          "notification": {"body": body, "title": title},
        }
      };

      final response = await ApiCalls.post(
        url: _fcmUrl,
        headers: headers,
        body: jsonEncode(notification),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == 1) {
          print('Notification sent successfully');
          return true;
        }
      }

      print('Failed to send notification. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    } catch (e) {
      print('Error sending notification: $e');
      return false;
    }
  }
}

/// Background message handler (must be a top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint('Background notification received:');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Data: ${message.data}');
}

/// Provider for FCMService
final fcmServiceProvider = Provider<FCMService>((ref) {
  final navigatorKey = GlobalKey<NavigatorState>();
  return FCMService(navigatorKey: navigatorKey);
});

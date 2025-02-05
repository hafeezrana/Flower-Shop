import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestHandler {
  /// Executes a request with a loader and handles exceptions
  Future<T?> execute<T>({
    required Future<T> Function() request,
  }) async {
    T? result;

    try {
      // Execute the request
      result = await request();

      // Log and notify success
      log('Success: $result');
    } catch (e) {
      // Handle exceptions
      _handleException(e);
    } finally {
      //
    }

    return result;
  }

  /// Handles exceptions and displays user friendly messages
  void _handleException(dynamic error) {
    if (error is PostgrestException) {
      log('PostgrestException: ${error.message}');
      ShowToast.msg(error.message);
    } else {
      log('Unexpected error: $error');
      // ShowToast.msg("An unexpected error occurred. Please try again.");
    }
  }
}

final requestHandlerProvider =
    Provider<RequestHandler>((ref) => RequestHandler());

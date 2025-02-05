import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/model/order.dart';
import 'package:flowershop/services/fcm_notification_service.dart';
import 'package:flowershop/utils/app_preferences.dart';
import 'package:flowershop/utils/request_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  final RequestHandler _requestHandler;
  final SupabaseClient _supabase;

  OrderRepository(this._requestHandler, this._supabase);
  Future<dynamic> addOrder({required Order order}) async {
    final getToken = AppPreferences.getString(AppPreferences.fcmToken);
    final name = AppPreferences.getString(AppPreferences.uFullName);
    print('order data: ${order.toJson()}');

    // Insert product in database
    final orderResponse = await _supabase
        .from('orders')
        .insert(order.toJson())
        .select('id , order_number')
        .single();
    print('orderres: $orderResponse');

    if (order.cartItems != null && order.cartItems!.isNotEmpty) {
      for (var cartItem in order.cartItems!) {
        final cartResponse = await _supabase.from('orderitems').insert(
            {'order_id': orderResponse['id'], ...cartItem.toJson()}).select();
        // print('cart resp: $cartResponse');
      }
    }

    if (order.bouquet != null) {
      final bouquetIdResponse = await _supabase
          .from('custombouquet')
          .insert(order.bouquet!.toJson())
          .select('id')
          .single();
      // print('bouquet resp: $bouquetIdResponse');

      if (order.bouquet!.bouquetItems!.isNotEmpty) {
        for (var bouquetItem in order.bouquet!.bouquetItems!) {
          final cartResponse = await _supabase.from('orderbouquetitems').insert(
              {'bouquet_id': bouquetIdResponse['id'], ...bouquetItem.toJson()});
          // print('bouquet resp: $cartResponse');
        }
      }
    }
    if (orderResponse['order_number'] != null) {
      FCMService.sendPushNotification(
          fcmToken: getToken,
          title: "Order Submitted Successfully",
          body:
              "Dear $name, Your order #${orderResponse['order_number']} has been submitted successfully. Please enjoy Kadi Flowers. Thank you!");
    }
  }

  Future<List<Order>> getOrders() async {
    final userID = AppPreferences.getInt(AppPreferences.userId);

    final orderResponse =
        await _supabase.from('orders').select().eq('user_id', userID!);
    final orders = orderResponse.map((val) => Order.fromJson(val)).toList();

    return orders;
  }

  Future<List<Map<String, dynamic>>> getRawOrder() async {
    final userID = AppPreferences.getInt(AppPreferences.userId);

    final orderResponse =
        await _supabase.from('orders').select().eq('user_id', userID!);
    print('orders: $orderResponse');
    // final orders = orderResponse.map((val) => Order.fromJson(val)).toList();
    // print('orders add: ${orders.first.address}');

    return orderResponse;
  }
}

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(
      ref.read(requestHandlerProvider), Supabase.instance.client);
});

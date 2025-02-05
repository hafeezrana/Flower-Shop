import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flowershop/model/order.dart';
import 'package:flowershop/provider/cart/cart_notifier.dart';
import 'dart:math';

import 'package:flowershop/provider/order/order_state.dart';
import 'package:flowershop/repositories/order_repository.dart';
import 'package:flowershop/utils/app_preferences.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:flowershop/views/dashboard/btm_navbar_view.dart';
import 'package:flowershop/views/widgets/app_navigator.dart';

class OrderProvider extends StateNotifier<OrderState> {
  OrderRepository orderRepository;
  OrderProvider(this.orderRepository) : super(OrderState());

  createOrder(Order order) {
    try {
      state = state.copyWith(isLoading: true);
      orderRepository.addOrder(order: order);
      ShowToast.msg('Order has been created successfully');
      AppPreferences.removeKey(AppPreferences.pendingOrder);
      AppNav.pushAndRemoveUntil(Get.context, const MainView());
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  getOrders() async {
    try {
      state = state.copyWith(isLoading: true);
      final orders = await orderRepository.getOrders();
      ShowToast.msg('Order retrieved successfull');
      state = state.copyWith(orders: orders, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  getRawOrders() async {
    try {
      state = state.copyWith(isLoading: true);
      final orders = await orderRepository.getRawOrder();
      ShowToast.msg('Order retrieved successfull');
      state = state.copyWith(ordersRaw: orders, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  generateOrderNumber() {
    try {
      state = state.copyWith(isLoading: true);

      const prefix = 'KF';

      // Generate 7 random digits
      String randomDigits;
      final now = DateTime.now();
      randomDigits =
          '${now.day.toString().padLeft(2, '0')}${now.month.toString().padLeft(2, '0')}${now.year.toString().substring(2)}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';

      state = state.copyWith(orderNumber: "$prefix$randomDigits");
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final orderStateProvider =
    StateNotifierProvider<OrderProvider, OrderState>((ref) {
  final orderRepository = ref.read(orderRepositoryProvider);
  return OrderProvider(orderRepository);
});

import 'package:flowershop/model/order.dart';

class OrderState {
  final String? orderNumber;
  final bool isLoading;
  final String? error;
  final List<Order>? orders;
  final List<Map<String, dynamic>>? ordersRaw;

  OrderState({
    this.orders,
    this.ordersRaw,
    this.orderNumber,
    this.isLoading = false,
    this.error,
  });

  OrderState copyWith({
    String? orderNumber,
    bool? isLoading,
    List<Order>? orders,
    final List<Map<String, dynamic>>? ordersRaw,
    String? error,
  }) {
    return OrderState(
      ordersRaw: this.ordersRaw ?? ordersRaw,
      orders: orders ?? this.orders,
      orderNumber: orderNumber ?? this.orderNumber,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

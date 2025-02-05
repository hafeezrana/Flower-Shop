import 'package:flowershop/model/cart_item.dart';

class CartState {
  final List<CartItem> cartItems;
  final double totalPrice;
  final bool isLoading;
  final String? error;

  CartState({
    this.cartItems = const [],
    this.isLoading = false,
    this.totalPrice = 0.0,
    this.error,
  });

  CartState copyWith({
    List<CartItem>? cartItems,
    double? totalPrice,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      totalPrice: totalPrice ?? this.totalPrice,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/model/cart_item.dart';
import 'package:flowershop/provider/cart/cart_state.dart';
import 'package:flowershop/utils/toast.dart';

class CartNotifierProvider extends StateNotifier<CartState> {
  CartNotifierProvider() : super(CartState());

  void addItemToCart(CartItem item) {
    state = state.copyWith(isLoading: true);
    try {
      final existingItemIndex =
          state.cartItems.indexWhere((e) => e.id == item.id);
      if (existingItemIndex != -1) {
        // Item already exists, increase its quantity
        increaseQuantity(state.cartItems[existingItemIndex]);
      } else {
        // Item doesn't exist, add it to the cart
        state = state.copyWith(
          cartItems: [...state.cartItems, item],
          isLoading: false,
          error: null,
        );
      }
      _calculatePrice(); // Update the total price
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void removeCartItem(CartItem item) {
    state = state.copyWith(isLoading: true);
    try {
      final items =
          state.cartItems.where((element) => element.id != item.id).toList();
      state = state.copyWith(cartItems: items, isLoading: false, error: null);
      _calculatePrice(); // Update the total price
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearCart() {
    try {
      state = state.copyWith(cartItems: [], totalPrice: 0.0, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void increaseQuantity(CartItem item) {
    state = state.copyWith(isLoading: true);
    try {
      final items = state.cartItems.map((e) {
        if (e.id == item.id) {
          if (e.quantity! <= 4) {
            return e.copyWith(quantity: e.quantity! + 1);
          } else {
            ShowToast.msg('You can only add 5 items at a time');
          }
        }
        return e;
      }).toList();
      state = state.copyWith(cartItems: items, isLoading: false, error: null);
      _calculatePrice(); // Update the total price
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void decreaseQuantity(CartItem item) {
    state = state.copyWith(isLoading: true);
    try {
      final items = state.cartItems
          .map((e) {
            if (e.id == item.id) {
              if (e.quantity! > 1) {
                return e.copyWith(quantity: e.quantity! - 1);
              } else {
                removeCartItem(item);
                return null; // Remove the item completely
              }
            }
            return e;
          })
          .whereType<CartItem>()
          .toList();
      state = state.copyWith(cartItems: items, isLoading: false, error: null);
      _calculatePrice(); // Update the total price
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void _calculatePrice() {
    try {
      double total = 0;
      for (var item in state.cartItems) {
        total += item.price! * item.quantity!.toDouble();
      }
      state = state.copyWith(totalPrice: total);
    } catch (e) {
      log('Error calculating price: ${e.toString()}');
      state = state.copyWith(error: e.toString());
    }
  }
}

final cartProvider =
    StateNotifierProvider<CartNotifierProvider, CartState>((ref) {
  return CartNotifierProvider();
});

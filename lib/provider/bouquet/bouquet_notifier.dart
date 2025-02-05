import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/model/cart_item.dart';
import 'package:flowershop/model/custom_bouquet.dart';
import 'package:flowershop/provider/bouquet/custom_bouquet_state.dart';
import 'package:flowershop/provider/cart/cart_state.dart';
import 'package:flowershop/utils/toast.dart';

class CustomBouquetNotifierProvider extends StateNotifier<CustomBouquetState> {
  CustomBouquetNotifierProvider() : super(CustomBouquetState());

  void addItemToBouquet(BouquetItem item) {
    state = state.copyWith(isLoading: true);
    try {
      final existingItemIndex =
          state.bouquetItems.indexWhere((e) => e.id == item.id);
      if (existingItemIndex != -1) {
        // Item already exists, increase its quantity
        increaseQuantity(state.bouquetItems[existingItemIndex]);
      } else {
        // Item doesn't exist, add it to the cart
        state = state.copyWith(
          bouquetItems: [...state.bouquetItems, item],
          isLoading: false,
          error: null,
        );
      }
      _calculatePrice(); // Update the total price
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void removeBouquetItem(BouquetItem item) {
    state = state.copyWith(isLoading: true);
    try {
      final items =
          state.bouquetItems.where((element) => element.id != item.id).toList();
      state =
          state.copyWith(bouquetItems: items, isLoading: false, error: null);
      _calculatePrice(); // Update the total price
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearCart() {
    try {
      state = state.copyWith(bouquetItems: [], totalPrice: 0.0, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void increaseQuantity(BouquetItem item) {
    state = state.copyWith(isLoading: true);
    try {
      final items = state.bouquetItems.map((e) {
        if (e.id == item.id) {
          if (e.quantity! <= 4) {
            return e.copyWith(quantity: e.quantity! + 1);
          } else {
            ShowToast.msg('You can only add 5 items at a time');
          }
        }
        return e;
      }).toList();
      state =
          state.copyWith(bouquetItems: items, isLoading: false, error: null);
      _calculatePrice(); // Update the total price
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void decreaseQuantity(BouquetItem item) {
    state = state.copyWith(isLoading: true);
    try {
      final items = state.bouquetItems
          .map((e) {
            if (e.id == item.id) {
              if (e.quantity! > 1) {
                return e.copyWith(quantity: e.quantity! - 1);
              } else {
                removeBouquetItem(item);
                return null; // Remove the item completely
              }
            }
            return e;
          })
          .whereType<BouquetItem>()
          .toList();
      state =
          state.copyWith(bouquetItems: items, isLoading: false, error: null);
      _calculatePrice(); // Update the total price
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void _calculatePrice() {
    try {
      double total = 0;
      for (var item in state.bouquetItems) {
        total += item.totalPrice! * item.quantity!.toDouble();
      }
      state = state.copyWith(totalPrice: total);
    } catch (e) {
      log('Error calculating price: ${e.toString()}');
      state = state.copyWith(error: e.toString());
    }
  }
}

final bouquetProvider =
    StateNotifierProvider<CustomBouquetNotifierProvider, CustomBouquetState>(
        (ref) {
  return CustomBouquetNotifierProvider();
});

import 'package:flowershop/model/cart_item.dart';
import 'package:flowershop/utils/request_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartRepository {
  final RequestHandler _requestHandler;
  // final SupabaseClient _supabase;

  CartRepository(
    this._requestHandler,
    // this._supabase
  );

  Future<void> addCartItem(CartItem item) async {
    List<CartItem> cartItems = [];
    cartItems.add(item);
  }
}

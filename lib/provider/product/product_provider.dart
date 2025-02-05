import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/provider/product/product_notifier.dart';
import 'package:flowershop/provider/product/product_state.dart';
import 'package:flowershop/repositories/product_repository.dart';

final productStateNotifierProvider =
    StateNotifierProvider<ProductStateNotifier, ProductState>((ref) {
  final repository = ref.read(productRepositoryProvider);
  return ProductStateNotifier(repository);
});

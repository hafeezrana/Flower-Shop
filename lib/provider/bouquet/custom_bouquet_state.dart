import 'package:flowershop/model/custom_bouquet.dart';

class CustomBouquetState {
  final List<BouquetItem> bouquetItems;
  final double totalPrice;
  final bool isLoading;
  final String? error;

  CustomBouquetState({
    this.bouquetItems = const [],
    this.isLoading = false,
    this.totalPrice = 0.0,
    this.error,
  });

  CustomBouquetState copyWith({
    List<BouquetItem>? bouquetItems,
    double? totalPrice,
    bool? isLoading,
    String? error,
  }) {
    return CustomBouquetState(
      bouquetItems: bouquetItems ?? this.bouquetItems,
      totalPrice: totalPrice ?? this.totalPrice,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

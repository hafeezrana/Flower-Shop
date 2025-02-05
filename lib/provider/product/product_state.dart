import 'package:flowershop/model/categeory.dart';
import 'package:flowershop/model/product.dart';

class ProductState {
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final List<Product> popularProducts;
  final List<Product> otherProducts;
  final List<ProductCategory> categories;
  final List<ProductCategory> categoriesWithProducts;
  final bool isLoading;
  final String? error;

  ProductState({
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.popularProducts = const [],
    this.otherProducts = const [],
    this.categories = const [],
    this.categoriesWithProducts = const [],
    this.isLoading = false,
    this.error,
  });

  ProductState copyWith({
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    List<Product>? popularProducts,
    List<Product>? otherProducts,
    List<ProductCategory>? categories,
    List<ProductCategory>? categoriesWithProducts,
    bool? isLoading,
    String? error,
  }) {
    return ProductState(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      popularProducts: popularProducts ?? this.popularProducts,
      otherProducts: otherProducts ?? this.otherProducts,
      categories: categories ?? this.categories,
      categoriesWithProducts:
          categoriesWithProducts ?? this.categoriesWithProducts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

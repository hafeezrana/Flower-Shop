import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flowershop/provider/product/product_state.dart';
import 'package:flowershop/repositories/product_repository.dart';
import 'package:flowershop/utils/toast.dart';

class ProductStateNotifier extends StateNotifier<ProductState> {
  final ProductRepository _repository;

  ProductStateNotifier(this._repository) : super(ProductState());

  // Fetch All Products
  Future<void> fetchAllProducts() async {
    state = state.copyWith(isLoading: true);
    try {
      final products = await _repository.fetchAllProducts();
      state =
          state.copyWith(allProducts: products, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Fetch on Filtered/Category wise products for Dashboard View/ Categories
  Future<void> fetchFilteredProducts(
      {num? categoryID, String? searchQuery}) async {
    state = state.copyWith(isLoading: true, filteredProducts: []);
    try {
      final filteredProducts = await _repository.fetchFilteredProducts(
          categoryID: categoryID, query: searchQuery);
      state = state.copyWith(
          filteredProducts: filteredProducts.isNotEmpty ? filteredProducts : [],
          isLoading: false,
          error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchPopularProducts(
      {num? categoryID, String? searchQuery}) async {
    state = state.copyWith(isLoading: true, popularProducts: []);
    try {
      final popularProducts = await _repository.fetchPopularProducts();
      state = state.copyWith(
          popularProducts: popularProducts.isNotEmpty ? popularProducts : [],
          isLoading: false,
          error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchOtherProducts() async {
    state = state.copyWith(isLoading: true);
    try {
      final otherProducts = await _repository.fetchOtherProducts();
      state = state.copyWith(
          otherProducts: otherProducts.isNotEmpty ? otherProducts : [],
          isLoading: false,
          error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Enlist All Categories
  Future<void> fetchCategories() async {
    state = state.copyWith(isLoading: true);
    try {
      final categories = await _repository.fetchCategories();
      state =
          state.copyWith(categories: categories, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Fetch All Categories along all products
  Future<void> fetchCategoriesWithProducts() async {
    state = state.copyWith(isLoading: true);
    try {
      final categoriesWithProducts =
          await _repository.fetchCategoriesWithProducts();
      state = state.copyWith(
          categoriesWithProducts: categoriesWithProducts,
          isLoading: false,
          error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // Add Product customise bouquets
  Future<void> addProduct(
      {required Map<String, dynamic> productData, XFile? imageFile}) async {
    state = state.copyWith(isLoading: true);
    try {
      final newProduct = await _repository.addProduct(
          productData: productData, imageFile: imageFile);

      // Add new producT to existing list
      final updatedProducts = [...state.allProducts, newProduct];

      state = state.copyWith(
          allProducts: updatedProducts, isLoading: false, error: null);

      //  Show success message
      ShowToast.msg('Product Added Successfully');
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> updateProduct(
      int productId, Map<String, dynamic> updateData) async {
    state = state.copyWith(isLoading: true);
    try {
      final updatedProduct =
          await _repository.updateProduct(productId, updateData);

      // Update the specific product in the list
      final updatedProducts = state.allProducts.map((product) {
        return product.id == productId ? updatedProduct : product;
      }).toList();

      state = state.copyWith(
          allProducts: updatedProducts, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

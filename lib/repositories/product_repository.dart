import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flowershop/model/categeory.dart';
import 'package:flowershop/model/product.dart';
import 'package:flowershop/utils/request_handler.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository {
  final RequestHandler _requestHandler;
  final SupabaseClient _supabase;

  ProductRepository(this._requestHandler, this._supabase);

  Future<Product> addProduct(
      {required Map<String, dynamic> productData, XFile? imageFile}) async {
    // Handle image upload if it is provided
    if (imageFile != null) {
      final Uint8List avatarFile = await imageFile.readAsBytes();
      final path = '${DateTime.now().millisecondsSinceEpoch}-${imageFile.name}';

      final publicPath = await _supabase.storage.from('products').uploadBinary(
            path,
            avatarFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      productData['image_url'] = publicPath;
    }

    // Insert product in database
    final response =
        await _supabase.from('products').insert(productData).select().single();

    return Product.fromJson(response);
  }

  Future<List<Product>> fetchAllProducts() async {
    final products = await _requestHandler.execute(
      request: () async {
        final response = await _supabase.from('products').select();
        if (response.isNotEmpty) {
          return response.map((val) => Product.fromJson(val)).toList();
        }
      },
    );
    return products!;
  }

  Future<List<Product>> fetchFilteredProducts(
      {num? categoryID, String? query}) async {
    final products = await _requestHandler.execute(
      request: () async {
        var queryBuilder = _supabase.from('products').select();

        // Apply filter for categoryID if provided
        if (categoryID != null) {
          queryBuilder = queryBuilder.eq('category_id', categoryID);
        }

        // Apply filter for category_name if query is provided
        if (query != null && query.isNotEmpty) {
          queryBuilder = queryBuilder.ilike('title', '%$query%');
        }
        if (categoryID == null && query == null) {
          queryBuilder = queryBuilder.ilike('category_name', 'Popular');
        }

        // Execute the query
        final response = await queryBuilder;

        if (response.isNotEmpty) {
          return response.map((val) => Product.fromJson(val)).toList();
        }
      },
    );
    return products!;
  }

  Future<List<Product>> fetchPopularProducts() async {
    final products = await _requestHandler.execute(
      request: () async {
        var response = await _supabase
            .from('products')
            .select()
            .ilike('category_name', '%Popular%');

        if (response.isNotEmpty) {
          return response.map((val) => Product.fromJson(val)).toList();
        }
      },
    );
    return products!;
  }

  Future<List<Product>> fetchOtherProducts() async {
    final products = await _requestHandler.execute(
      request: () async {
        var response = await _supabase
            .from('products')
            .select()
            .ilike('category_name', '%Others%');

        // Execute the query

        print('other products: $response');

        if (response.isNotEmpty) {
          return response.map((val) => Product.fromJson(val)).toList();
        }
      },
    );
    return products!;
  }

  Future<List<ProductCategory>> fetchCategories() async {
    final data = await _requestHandler.execute(
      request: () async {
        final response = await _supabase.from('categories').select();
        if (response.isNotEmpty) {
          return response.map((val) => ProductCategory.fromJson(val)).toList();
        } else {
          ShowToast.msg('No flower found');
        }
      },
    );
    return data!;
  }

  Future<List<ProductCategory>> fetchCategoriesWithProducts() async {
    final data = await _requestHandler.execute(
      request: () async {
        final response = await _supabase.from('categories').select('''
          *,
          products:products(*)
          ''');
        if (response.isNotEmpty) {
          return response.map((val) => ProductCategory.fromJson(val)).toList();
        }
      },
    );
    return data!;
  }

  Future<Product> updateProduct(int id, Map<String, dynamic> updateData) async {
    final response = await _supabase
        .from('products')
        .update(updateData)
        .eq('id', id)
        .select()
        .single();

    return Product.fromJson(response);
  }
}

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(
      ref.read(requestHandlerProvider), Supabase.instance.client);
});

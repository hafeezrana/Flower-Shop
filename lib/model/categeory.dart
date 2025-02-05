import 'package:flowershop/model/product.dart';

class ProductCategory {
  ProductCategory({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.createdAt,
    this.products,
  });

  ProductCategory.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    createdAt = json['created_at'];
    products = json['products'] != null
        ? List<Product>.from(json['products'].map((x) => Product.fromJson(x)))
        : null;
  }
  num? id;
  String? name;
  String? description;
  String? imageUrl;
  String? createdAt;
  List<Product>? products;
  ProductCategory copyWith({
    num? id,
    String? name,
    String? description,
    String? imageUrl,
    String? createdAt,
  }) =>
      ProductCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        createdAt: createdAt ?? this.createdAt,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['image_url'] = imageUrl;
    map['created_at'] = createdAt;
    return map;
  }
}

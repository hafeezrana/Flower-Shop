class Product {
  Product({
    this.id,
    this.createdAt,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.quantity,
    this.productId,
    this.categoryName,
    this.color,
  });

  Product.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['created_at'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    imageUrl = json['image_url'];
    quantity = json['quantity'];
    categoryName = json['category_name'];
    productId = json['product_id'];
    color = json['color'];
  }
  num? id;
  String? createdAt;
  String? title;
  String? description;
  num? price;
  String? imageUrl;
  num? quantity;
  num? productId;
  String? color;
  String? categoryName;
  Product copyWith({
    num? id,
    String? createdAt,
    String? title,
    String? description,
    num? price,
    String? imageUrl,
    num? quantity,
    num? productId,
    String? color,
  }) =>
      Product(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        quantity: quantity ?? this.quantity,
        productId: productId ?? this.productId,
        color: color ?? this.color,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['created_at'] = createdAt;
    map['title'] = title;
    map['description'] = description;
    map['price'] = price;
    map['image_url'] = imageUrl;
    map['quantity'] = quantity;
    map['category_name'] = categoryName;
    map['product_id'] = productId;
    map['color'] = color;
    return map;
  }
}

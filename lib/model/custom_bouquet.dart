import 'package:flowershop/model/product.dart';

class BouquetItem {
  int id;
  double? totalPrice;
  String? title;
  int? bouquetId;
  String? imageUrl;
  String? receiverName;
  String? message;
  int? quantity;

  BouquetItem(
      {required this.id,
      this.title,
      this.receiverName,
      this.bouquetId,
      this.message,
      this.quantity,
      this.imageUrl,
      this.totalPrice});
  BouquetItem copyWith({
    int? id,
    double? totalPrice,
    String? receiverName,
    String? message,
    String? imageUrl,
    String? title,
    int? quantity,
  }) {
    return BouquetItem(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      receiverName: receiverName ?? this.receiverName,
      message: message ?? this.message,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'price': totalPrice,
      'image_url': imageUrl, // Assuming Product class has toJson()
      'receiver_name': receiverName,
      'message': message,
      'title': title,
      'quantity': quantity,
    };
  }

  // Create a BouquetItem object from a JSON map
  factory BouquetItem.fromJson(Map<String, dynamic> json) {
    return BouquetItem(
      id: json['product_id'],
      totalPrice: json['price'],
      imageUrl: json['image_url'],
      receiverName: json['receiver_name'],
      message: json['message'],
      title: json['title'],
      quantity: json['quantity'],
    );
  }
}

class Bouquet {
  String? title;
  int? orderId;
  List<BouquetItem>? bouquetItems;

  Bouquet({this.title, this.orderId, this.bouquetItems});

  // Convert a Bouquet object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      // 'order_id': orderId,
      'bouquet_items': bouquetItems
          ?.map((item) => item.toJson())
          .toList(), // Convert list of BouquetItem to JSON
    };
  }

  // Create a Bouquet object from a JSON map
  factory Bouquet.fromJson(Map<String, dynamic> json) {
    return Bouquet(
      orderId: json['order_id'],
      title: json['title'],
      bouquetItems: json['bouquet_items'] != null
          ? (json['bouquet_items'] as List)
              .map((item) => BouquetItem.fromJson(item))
              .toList() // Convert JSON to list of BouquetItem
          : null,
    );
  }
}

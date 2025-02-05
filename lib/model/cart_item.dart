import 'package:flowershop/model/product.dart';
import 'custom_bouquet.dart';

class CartItem {
  int id;
  int? orderID;
  String? receiverName;
  String? title;
  String? imageUrl;
  String? message;
  int? quantity;
  num? price;
  int? selectedColor;

  CartItem({
    required this.id,
    this.receiverName,
    this.orderID,
    this.message,
    this.quantity,
    this.price,
    this.selectedColor,
    this.imageUrl,
    this.title,
  });

  // Add the copyWith method
  CartItem copyWith(
      {int? id,
      String? receiverName,
      int? orderID,
      String? message,
      int? quantity,
      int? selectedColor,
      int? price,
      String? title,
      String? imageUrl}) {
    return CartItem(
      id: id ?? this.id,
      orderID: orderID ?? this.orderID,
      receiverName: receiverName ?? this.receiverName,
      message: message ?? this.message,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      selectedColor: selectedColor ?? this.selectedColor,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'receiver_name': receiverName,
      'order_id': orderID,
      'message': message,
      'quantity': quantity,
      'price': price,
      'selected_color': selectedColor,
      'title': title,
      'image_url': imageUrl,
    };
  }

  // Create a Gift object from a JSON map
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['product_id'],
      receiverName: json['receiver_name'],
      message: json['message'],
      quantity: json['quantity'],
      orderID: json['order_id'],
      price: json['price'],
      selectedColor: json['selected_color'],
      title: json['title'],
      imageUrl: json['image_url'],
    );
  }
}

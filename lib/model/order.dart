import 'package:flowershop/model/cart_item.dart';
import 'package:flowershop/model/payment.dart';

import 'custom_bouquet.dart';

class Order {
  double? totalPrice;
  double? deliveryPrice;
  String? phoneNo;
  String? orderNumber;
  String? address;
  String? latitude;
  String? longitude;
  int? userID;
  int? paymentStatus;
  List<CartItem>? cartItems;
  Bouquet? bouquet;
  PaymentDetail? paymentDetail;

  Order({
    this.totalPrice,
    this.phoneNo,
    this.deliveryPrice,
    this.orderNumber,
    this.address,
    this.latitude,
    this.longitude,
    this.userID,
    this.paymentStatus,
    this.cartItems,
    this.bouquet,
    this.paymentDetail,
  });

  // Convert an Order object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'total_price': totalPrice,
      'phone_no': phoneNo,
      'delivery_price': deliveryPrice,
      'order_number': orderNumber,
      'address': address,
      'user_id': userID,
      'payment_status': paymentStatus,
      "latitude": latitude,
      'longitude': longitude,
      'cart_items': cartItems
          ?.map((item) => item.toJson())
          .toList(), // Convert list of CartItem to JSON
      'bouquet': bouquet?.toJson(), // Convert Bouquet to JSON
      'payment_detail':
          paymentDetail?.toJson(), // Convert PaymentDetail to JSON
    };
  }

  // Create an Order object from a JSON map
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      totalPrice: json['total_price'],
      phoneNo: json['phone_no'],
      deliveryPrice: json['delivery_price'],
      orderNumber: json['order_number'],
      address: json['address'],
      userID: json['user_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      paymentStatus: json['payment_status'],
      bouquet:
          json['bouquet'] != null ? Bouquet.fromJson(json['bouquet']) : null,
      cartItems: json['cart_items'] != null
          ? (json['cart_items'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList() // Convert JSON to list of CartItem
          : null,
    );
  }
}

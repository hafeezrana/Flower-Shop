class PaymentDetail {
  String id;
  String country;
  String currency;
  String amount;
  String timeStamp;
  String orderNumber;
  String userId;

  PaymentDetail({
    required this.id,
    required this.country,
    required this.currency,
    required this.amount,
    required this.timeStamp,
    required this.orderNumber,
    required this.userId,
  });

  // Convert a PaymentDetail object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      'currency': currency,
      'amount': amount,
      'timeStamp': timeStamp,
      'orderNumber': orderNumber,
      'userId': userId,
    };
  }

  // Create a PaymentDetail object from a JSON map
  factory PaymentDetail.fromJson(Map<String, dynamic> json) {
    return PaymentDetail(
      id: json['id'],
      country: json['country'],
      currency: json['currency'],
      amount: json['amount'],
      timeStamp: json['timeStamp'],
      orderNumber: json['orderNumber'],
      userId: json['userId'],
    );
  }
}

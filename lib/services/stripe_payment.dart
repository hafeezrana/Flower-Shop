// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:flowershop/utils/key_consts.dart';
// import 'package:flowershop/views/widgets/alert_dialogue.dart';
//
// class SubscriptionService {
//   Map<String, dynamic>? paymentIntent;
//
//   Future<void> makeStripePayment({
//     required String amount,
//     required String pkgId,
//   }) async {
//     try {
//       String stripeSecretKey = PayKeyConsts.stripeSecretKey;
//       paymentIntent = await createPaymentIntent(amount, 'USD', stripeSecretKey);
//       // print('stripe secret key: $stripeSecretKey');
//       var gpay = const PaymentSheetGooglePay(
//           merchantCountryCode: "UK", currencyCode: "USA", testEnv: true);
//
//       //STEP 2: Initialize Payment Sheet
//       await Stripe.instance
//           .initPaymentSheet(
//               paymentSheetParameters: SetupPaymentSheetParameters(
//             paymentIntentClientSecret:
//                 paymentIntent!['client_secret'], //Gotten from payment intent
//             style: ThemeMode.light,
//             merchantDisplayName: 'tester',
//             googlePay: gpay,
//           ))
//           .then((value) {});
//
//       //STEP 3: Display Payment sheet
//       displayPaymentSheet(amount, pkgId);
//     } catch (err) {
//       print(err);
//     }
//   }
//
//   displayPaymentSheet(String amount, String pkgId) async {
//     try {
//       var context = Get.context!;
//       await Stripe.instance.presentPaymentSheet().then((value) {
//         print(" stripeResponse : $paymentIntent");
//         var trsId = paymentIntent!['id'];
//
//         if (trsId != null) {
//           MyDialogue.showMsg("\$$amount has been successfully paid!",
//               onPressed: () => Navigator.pop(context));
//           // var sub = Provider.of<SubscriptionProvider>(context, listen: false);
//           // sub.setPackage(transactionId: trsId, packageId: pkgId);
//
//           paymentIntent = null;
//           // Appnav.pushReplacemend(context, const SplashScreen());
//         }
//
//         print('$amount successfully paid!');
//       }).onError((error, stackTrace) {
//         throw Exception(error);
//       });
//     } on StripeException catch (e) {
//       print('Error is:---> $e');
//       AlertDialog(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.cancel,
//                   color: Colors.red,
//                 ),
//                 Text("Payment Failed"),
//               ],
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       print('$e');
//     }
//   }
//
//   createPaymentIntent(
//       String amount, String currency, String stripeSecretKey) async {
//     var totalAmount = (double.parse(amount) * 100).toInt();
//
//     try {
//       Map<String, dynamic> body = {
//         'amount': '$totalAmount',
//         'currency': currency,
//       };
//
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization': 'Bearer $stripeSecretKey',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       var data = json.decode(response.body);
//
//       print('datas: $data');
//       return data;
//     } catch (err) {
//       throw Exception(err.toString());
//     }
//   }
// }

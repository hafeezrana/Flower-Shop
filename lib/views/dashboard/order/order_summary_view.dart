import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flowershop/model/order.dart';
import 'package:flowershop/provider/bouquet/bouquet_notifier.dart';
import 'package:flowershop/provider/cart/cart_notifier.dart';
import 'package:flowershop/provider/order/order_notifier.dart';
import 'package:flowershop/repositories/order_repository.dart';
import 'package:flowershop/utils/app_preferences.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:flowershop/views/dashboard/btm_navbar_view.dart';
import 'package:flowershop/views/widgets/text_styles.dart';

class OrderSummaryView extends ConsumerStatefulWidget {
  OrderSummaryView({required this.order, super.key});
  Order order;

  @override
  ConsumerState createState() => _OrderSummaryViewState();
}

class _OrderSummaryViewState extends ConsumerState<OrderSummaryView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((as) async {});

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = ref.watch(orderStateProvider);

    final order = widget.order;

    double totalPrice = order.deliveryPrice! + order.totalPrice!;

    return Scaffold(
      backgroundColor: ConstColors.swatch1,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'order_summary'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.pink.shade100,
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: ConstColors.whiteColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'personal_information'.tr(),
                    style:
                        MyTextStyles.largeText.copyWith(color: ConstColors.red),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'name'.tr(),
                        style: MyTextStyles.mediumText,
                      ),
                      SizedBox(
                        width: Get.width * 0.6,
                        child: Text(
                          AppPreferences.getString(AppPreferences.uFullName),
                          style: MyTextStyles.smallText,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'phone_no'.tr(),
                        style: MyTextStyles.mediumText,
                      ),
                      SizedBox(
                        width: Get.width * 0.6,
                        child: Text(
                          widget.order.phoneNo ?? '',
                          style: MyTextStyles.smallText,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'address'.tr(),
                        style: MyTextStyles.mediumText,
                      ),
                      SizedBox(
                        width: Get.width * 0.6,
                        child: Text(
                          order.address ?? '',
                          style: MyTextStyles.smallText,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  if (order.bouquet != null &&
                      order.bouquet!.bouquetItems != null)
                    Column(
                      children: [
                        Text(
                          'bouquet_card_title'.tr(),
                          style: MyTextStyles.largeText
                              .copyWith(color: ConstColors.red),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: Get.width * 0.25,
                              child: Text(
                                'title'.tr(),
                                textAlign: TextAlign.center,
                                style: MyTextStyles.mediumText,
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.2,
                              child: Text(
                                'quantity'.tr(),
                                textAlign: TextAlign.center,
                                style: MyTextStyles.mediumText,
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.22,
                              child: Text(
                                'per_item_price'.tr(),
                                textAlign: TextAlign.center,
                                style: MyTextStyles.smallText
                                    .copyWith(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: order.bouquet?.bouquetItems?.length,
                            itemBuilder: (context, index) {
                              final bouquet =
                                  order.bouquet?.bouquetItems![index];
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: Get.width * 0.25,
                                        child: Text(
                                          bouquet!.title!,
                                          textAlign: TextAlign.center,
                                          style: MyTextStyles.extraSmallText
                                              .copyWith(
                                                  color: ConstColors.grey),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.2,
                                        child: Text(
                                          bouquet.quantity.toString() ?? '',
                                          textAlign: TextAlign.center,
                                          style: MyTextStyles.smallText,
                                        ),
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.24,
                                        child: Text(
                                          bouquet.totalPrice.toString(),
                                          textAlign: TextAlign.center,
                                          style: MyTextStyles.smallText,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // const Divider(),
                                ],
                              );
                            }),
                        const SizedBox(height: 10),
                        const Divider(),
                      ],
                    ),
                  Column(
                    children: [
                      Text(
                        'items_info'.tr(),
                        style: MyTextStyles.largeText
                            .copyWith(color: ConstColors.red),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: Get.width * 0.25,
                            child: Text(
                              'title'.tr(),
                              textAlign: TextAlign.center,
                              style: MyTextStyles.mediumText,
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.2,
                            child: Text(
                              'quantity'.tr(),
                              textAlign: TextAlign.center,
                              style: MyTextStyles.mediumText,
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.2,
                            child: Text(
                              'color'.tr(),
                              textAlign: TextAlign.center,
                              style: MyTextStyles.mediumText,
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.22,
                            child: Text(
                              'per_item_price'.tr(),
                              textAlign: TextAlign.center,
                              style: MyTextStyles.smallText
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: order.cartItems!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.25,
                                    child: Text(
                                      order.cartItems![index].title!,
                                      textAlign: TextAlign.center,
                                      style: MyTextStyles.extraSmallText
                                          .copyWith(color: ConstColors.grey),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.2,
                                    child: Text(
                                      order.cartItems![index].quantity
                                              .toString() ??
                                          '',
                                      textAlign: TextAlign.center,
                                      style: MyTextStyles.smallText,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.22,
                                    child: Center(
                                      child: Container(
                                        height: 18,
                                        width: 18,
                                        margin: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: order.cartItems![index]
                                                      .selectedColor !=
                                                  null
                                              ? Color(order.cartItems![index]
                                                  .selectedColor!)
                                              : ConstColors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.24,
                                    child: Text(
                                      order.cartItems![index].price
                                              .toString() ??
                                          '',
                                      textAlign: TextAlign.center,
                                      style: MyTextStyles.smallText,
                                    ),
                                  ),
                                ],
                              ),
                              // const Divider(),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'items_price'.tr(),
                        style: MyTextStyles.mediumText,
                      ),
                      Text(
                        '\$${order.totalPrice?.toStringAsFixed(2)}',
                        style: MyTextStyles.mediumText.copyWith(
                          color: ConstColors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'delivery_price'.tr(),
                        style: MyTextStyles.mediumText,
                      ),
                      Text(
                        '\$${order.deliveryPrice?.toStringAsFixed(2)}',
                        // '\$${order.deliveryPrice?.toStringAsFixed(2)}',
                        style: MyTextStyles.mediumText.copyWith(
                          color: ConstColors.black,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'total_price'.tr(),
                        style: MyTextStyles.mediumText,
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: MyTextStyles.mediumL.copyWith(
                          color: ConstColors.red,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            orderProvider.isLoading
                ? ShowToast.loader()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        ///  Pay Amount
                        ref.watch(cartProvider.notifier).clearCart();
                        ref.watch(bouquetProvider.notifier).clearCart();

                        ///Move to Home Page
                        ref.read(selectedViewIndexProvider.notifier).state = 0;

                        await ref
                            .watch(orderStateProvider.notifier)
                            .createOrder(widget.order);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        '${'pay_now'.tr()} \$${totalPrice.toStringAsFixed(2)}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

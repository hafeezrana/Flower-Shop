import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flowershop/model/cart_item.dart';
import 'package:flowershop/model/product.dart';
import 'package:flowershop/provider/cart/cart_notifier.dart';
import 'package:flowershop/provider/product/product_provider.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/views/dashboard/product/product_detail_view.dart';
import 'package:flowershop/views/widgets/app_navigator.dart';
import 'package:flowershop/views/widgets/cached_network_images.dart';
import 'package:flowershop/views/widgets/text_styles.dart';

class CartCard extends ConsumerWidget {
  CartCard({required this.item, super.key});

  CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: GestureDetector(
        onTap: () {
          final product = ref.read(productStateNotifierProvider);
          product.filteredProducts.forEach((val) {
            if (val.id == item.id) {
              AppNav.push(context, ProductDetailView(product: val));
            }
          });
        },
        child: Card(
            color: Colors.white,
            elevation: 1,
            shadowColor: ConstColors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: NetworkImageWidget(
                    height: 80,
                    width: 80,
                    imageUrl: item.imageUrl ?? '',
                  ),
                ),
                SizedBox(
                  width: Get.width * 0.72,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.width * 0.4,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title ?? '',
                                  style: MyTextStyles.mediumText),
                              const SizedBox(height: 4),
                              Text('● ${item.quantity}',
                                  style: MyTextStyles.smallText),
                              Row(
                                children: [
                                  Text('\$${item.price?.toStringAsFixed(2)}',
                                      style: MyTextStyles.smallText
                                          .copyWith(color: ConstColors.red)),
                                  const SizedBox(width: 6),
                                  if (item.selectedColor != null)
                                    Container(
                                      height: 18,
                                      width: 18,
                                      margin: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Color(item.selectedColor!),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .removeCartItem(item);
                              },
                              child: const Icon(
                                Icons.delete,
                                size: 20,
                                color: ConstColors.red,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    ref
                                        .read(cartProvider.notifier)
                                        .decreaseQuantity(item);
                                  },
                                  icon: const Icon(Icons.remove,
                                      color: Colors.pink),
                                ),
                                Text(
                                  item.quantity!.toString(),
                                  style: MyTextStyles.mediumL,
                                ),
                                IconButton(
                                  onPressed: () {
                                    ref
                                        .read(cartProvider.notifier)
                                        .increaseQuantity(item);
                                  },
                                  icon:
                                      const Icon(Icons.add, color: Colors.pink),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

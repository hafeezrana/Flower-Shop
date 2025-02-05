import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flowershop/model/cart_item.dart';
import 'package:flowershop/model/custom_bouquet.dart';
import 'package:flowershop/model/product.dart';
import 'package:flowershop/provider/bouquet/bouquet_notifier.dart';
import 'package:flowershop/provider/cart/cart_notifier.dart';
import 'package:flowershop/provider/product/product_provider.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/views/dashboard/product/product_detail_view.dart';
import 'package:flowershop/views/widgets/app_navigator.dart';
import 'package:flowershop/views/widgets/cached_network_images.dart';
import 'package:flowershop/views/widgets/text_styles.dart';

class BouquetCard extends ConsumerWidget {
  BouquetCard({required this.item, super.key});

  BouquetItem item;

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              width: Get.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: Get.width * 0.52,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('''${item.title}''' ?? '',
                              style: MyTextStyles.mediumText),
                          const SizedBox(height: 4),
                          Text('● ${item.quantity}',
                              style: MyTextStyles.smallText),
                          Text('\$${item.totalPrice?.toStringAsFixed(2)}',
                              style: MyTextStyles.mediumText
                                  .copyWith(color: ConstColors.red)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref
                                .read(bouquetProvider.notifier)
                                .removeBouquetItem(item);
                          },
                          child: const Icon(
                            Icons.delete,
                            size: 20,
                            color: ConstColors.red,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/model/product.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/views/dashboard/cart/widgets/product_bottom_sheet.dart';
import 'package:flowershop/views/dashboard/product/product_detail_view.dart';
import 'app_navigator.dart';
import 'text_styles.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard(
      {required this.product, required this.isBouquet, super.key});

  final Product product;
  final bool isBouquet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: !isBouquet
          ? () {
              AppNav.push(
                context,
                ProductDetailView(product: product),
              );
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: ConstColors.swatch1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(6),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(product.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${product.price?.toStringAsFixed(2)}',
                          style: MyTextStyles.smallText),
                      GestureDetector(
                        onTap: () {
                          // Show the bottom sheet when the cart icon is tapped
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return ProductBottomSheet(
                                  isBouquet: isBouquet,
                                  product: product); // Pass the product
                            },
                          );
                        },
                        child: const Icon(
                          Icons.add_shopping_cart_outlined,
                          size: 18,
                          color: ConstColors.grey,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

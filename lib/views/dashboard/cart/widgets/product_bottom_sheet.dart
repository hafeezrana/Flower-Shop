import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flowershop/model/cart_item.dart';
import 'package:flowershop/model/custom_bouquet.dart';
import 'package:flowershop/model/product.dart';
import 'package:flowershop/provider/bouquet/bouquet_notifier.dart';
import 'package:flowershop/provider/cart/cart_notifier.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:flowershop/views/widgets/add_to_cart_button.dart';
import 'package:flowershop/views/widgets/cached_network_images.dart';
import 'package:flowershop/views/widgets/text_styles.dart';

class ProductBottomSheet extends ConsumerStatefulWidget {
  final Product product;
  bool isBouquet;

  ProductBottomSheet({Key? key, required this.isBouquet, required this.product})
      : super(key: key);

  @override
  ConsumerState<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends ConsumerState<ProductBottomSheet> {
  int quantity = 1; // Default quantity

  void _increaseQuantity() {
    setState(() {
      if (quantity < 5) {
        quantity++;
      } else {
        ShowToast.msg('You can only add 5 items at a time');
      }
    });
  }

  void _decreaseQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
      }
    });
  }

  void _addToCart() {
    if (widget.isBouquet) {
      final bouquetNotifier = ref.read(bouquetProvider.notifier);
      final item = BouquetItem(
        id: widget.product.id!.toInt(),
        totalPrice: widget.product.price?.toDouble(),
        title: widget.product.title,
        imageUrl: widget.product.imageUrl,
        quantity: quantity,
      );
      bouquetNotifier.addItemToBouquet(item);
    } else {
      final cartNotifier = ref.read(cartProvider.notifier);
      final item = CartItem(
        id: widget.product.id!.toInt(),
        title: widget.product.title,
        imageUrl: widget.product.imageUrl,
        price: widget.product.price,
        quantity: quantity,
      );
      cartNotifier.addItemToCart(item);
    }
    Navigator.pop(context); // Close the bottom sheet
    if (widget.isBouquet) {
      ShowToast.msg('${widget.product.title} added to Bouquet');
    } else {
      ShowToast.msg('${widget.product.title} added to cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: Get.width * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.title ?? 'No Name',
                      style:
                          MyTextStyles.largeText.copyWith(color: Colors.black),
                    ),
                    const SizedBox(height: 8),

                    // Product Price
                    Text('\$${widget.product.price ?? 0}',
                        style: MyTextStyles.mediumText),
                    const SizedBox(height: 16),

                    // Product Details
                    Text(widget.product.description ?? '..',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: MyTextStyles.smallText),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              NetworkImageWidget(
                imageUrl: widget.product.imageUrl ?? '',
                width: Get.width * 0.3,
                height: 140,
              ),
            ],
          ),
          // Quantity Controls
          Container(
            width: Get.width * 0.3,
            decoration: BoxDecoration(
                color: ConstColors.whiteColor.withOpacity(0.4),
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _decreaseQuantity,
                  icon: const Icon(Icons.remove),
                ),
                Text(quantity.toString(),
                    style:
                        MyTextStyles.largeText.copyWith(color: Colors.black)),
                IconButton(
                  onPressed: _increaseQuantity,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Add to Cart Button
          AddToCartButton(onPressed: _addToCart)
        ],
      ),
    );
  }
}

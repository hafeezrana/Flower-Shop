import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/provider/product/product_state.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:flowershop/views/widgets/product_card.dart';
import 'package:flowershop/views/widgets/text_styles.dart';

import 'product_detail_view.dart';

class ProductsGridsView extends ConsumerWidget {
  ProductsGridsView({required this.productState, super.key});

  ProductState productState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return productState.isLoading
        ? ShowToast.loader()
        : productState.filteredProducts.isEmpty
            ? Center(
                child: Column(
                  children: [
                    const Text(
                      'No Item Found',
                      style: MyTextStyles.largeText,
                    ),
                    Image.asset('assets/images/vt_popup_img.png'),
                  ],
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: productState.filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = productState.filteredProducts[index];
                  return ProductCard(product: product, isBouquet: false);
                },
              );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/model/categeory.dart';
import 'package:flowershop/provider/product/product_provider.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:flowershop/views/dashboard/product/products_grids.dart';
import 'package:flowershop/views/widgets/product_card.dart';
import 'package:flowershop/views/widgets/text_styles.dart';

class CategoriesDetailView extends ConsumerStatefulWidget {
  CategoriesDetailView({required this.category, super.key});
  ProductCategory category;
  ConsumerState createState() => _CategoriesDetailViewWidgetState();
}

class _CategoriesDetailViewWidgetState
    extends ConsumerState<CategoriesDetailView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final pNotifier = ref.watch(productStateNotifierProvider.notifier);
      pNotifier.fetchFilteredProducts(categoryID: widget.category.id);
      pNotifier.fetchOtherProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productStateNotifierProvider);

    return Scaffold(
      backgroundColor: ConstColors.swatch1,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.category.name ?? '',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: ConstColors.whiteColor),
        backgroundColor: Colors.pink.shade100,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.6),
        child: productState.isLoading
            ? ShowToast.loader()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 8),
                    ProductsGridsView(productState: productState),
                    SizedBox(
                        height: productState.filteredProducts.length <= 2
                            ? 100
                            : 50),
                    if (productState.otherProducts.isNotEmpty)
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Explore More',
                                style: MyTextStyles.largeText
                                    .copyWith(color: Colors.black),
                              ),
                              SizedBox(
                                height: 240,
                                width: double.infinity,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: productState.otherProducts!.length,
                                  itemBuilder: (context, index) {
                                    final product =
                                        productState.otherProducts![index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                          height: 180,
                                          width: 200,
                                          child: ProductCard(
                                              isBouquet: false,
                                              product: product)),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                  ],
                ),
              ),
      ),
    );
    // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    // floatingActionButton:
  }
}

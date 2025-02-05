import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/model/categeory.dart';
import 'package:flowershop/provider/product/product_provider.dart';
import 'package:flowershop/services/location_service.dart';
import 'package:flowershop/utils/app_preferences.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:flowershop/views/widgets/app_navigator.dart';
import 'package:flowershop/views/widgets/product_card.dart';
import 'package:flowershop/views/widgets/text_styles.dart';
import '../widgets/search_field_widget.dart';
import 'product/create_custom_bouque_view.dart';
import 'product/products_grids.dart';

class HomeView extends ConsumerStatefulWidget {
  HomeView({super.key});

  ProductCategory? selectedCategory;

  _HomeViewWidgetState createState() => _HomeViewWidgetState();
}

class _HomeViewWidgetState extends ConsumerState<HomeView> {
  String? userName;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      userName = AppPreferences.getString(AppPreferences.uFullName);
      final pNotifier = ref.watch(productStateNotifierProvider.notifier);
      pNotifier.fetchOtherProducts();
      pNotifier.fetchPopularProducts();
      pNotifier.fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(productStateNotifierProvider.notifier);
    final productState = ref.watch(productStateNotifierProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      backgroundColor: ConstColors.swatch1,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location and Cart Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width * 0.75,
                      child: Text(
                        '${'greeting'.tr()}, $userName',
                        style:
                            MyTextStyles.extraLargeText.copyWith(fontSize: 22),
                      ),
                    ),
                    const Icon(
                      Icons.notifications_active_rounded,
                      color: ConstColors.orangeColor,
                      size: 35,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // DIY Bouquet Card
                productState.isLoading
                    ? ShowToast.loader()
                    : Column(
                        children: [
                          Container(
                            width: double.infinity,
                            // width: Get.width * 0.9,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'bouquet_card_title'.tr(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('bouquet_card_description'.tr()),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    AppNav.push(context,
                                        const CreateCustomBouquetView());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: Text('make_now'.tr()),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          SearchField(
                            hintText: 'search'.tr(),
                            onChanged: (val) {
                              provider.fetchFilteredProducts(
                                  searchQuery: val.toLowerCase().trim());
                            },
                          ),
                          const SizedBox(height: 10),
                          if (productState.categories.isNotEmpty)
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: productState.categories.length,
                                itemBuilder: (context, index) {
                                  final category =
                                      productState.categories[index];
                                  final isSelected =
                                      selectedCategory?.id == category.id;
                                  return GestureDetector(
                                    onTap: () {
                                      if (isSelected) {
                                        // Deselect the category
                                        ref
                                            .read(selectedCategoryProvider
                                                .notifier)
                                            .state = null;
                                        ref
                                            .read(productStateNotifierProvider)
                                            .filteredProducts
                                            .clear();
                                        // provider.fetchFilteredProducts();
                                      } else {
                                        // Select the new category
                                        ref
                                            .read(selectedCategoryProvider
                                                .notifier)
                                            .state = category;
                                        provider.fetchFilteredProducts(
                                            categoryID: category.id);
                                      }
                                    },
                                    child: Container(
                                      width: 100,
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.red.shade100
                                            : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: category.imageUrl!,
                                            height: 40,
                                            width: 50,
                                          ),
                                          Text(
                                            category.name!,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 12),
                          if (productState.filteredProducts.isNotEmpty)
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    selectedCategory?.name ?? '',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 240,
                                    width: double.infinity,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          productState.filteredProducts.length,
                                      itemBuilder: (context, index) {
                                        final product = productState
                                            .filteredProducts[index];
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
                          const SizedBox(height: 12),
                          if (productState.popularProducts.isNotEmpty)
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'most_popular'.tr(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 240,
                                    width: double.infinity,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          productState.popularProducts.length,
                                      itemBuilder: (context, index) {
                                        final product =
                                            productState.popularProducts[index];
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
                          const SizedBox(height: 12),
                          if (productState.otherProducts.isNotEmpty)
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'explore_more'.tr(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 240,
                                    width: double.infinity,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          productState.otherProducts!.length,
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
                        ],
                      ),
                // Bottom Navigation Bar Space
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final selectedCategoryProvider = StateProvider<ProductCategory?>((ref) {
  return null;
});

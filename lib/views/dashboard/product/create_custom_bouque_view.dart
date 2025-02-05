import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flowershop/model/cart_item.dart';
import 'package:flowershop/model/categeory.dart';
import 'package:flowershop/model/custom_bouquet.dart';
import 'package:flowershop/model/order.dart';
import 'package:flowershop/model/product.dart';
import 'package:flowershop/provider/bouquet/bouquet_notifier.dart';
import 'package:flowershop/provider/cart/cart_notifier.dart';
import 'package:flowershop/provider/product/product_provider.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:flowershop/views/dashboard/order/order_summary_view.dart';
import 'package:flowershop/views/dashboard/home.dart';
import 'package:flowershop/views/dashboard/product/product_detail_view.dart';
import 'package:flowershop/views/widgets/add_to_cart_button.dart';
import 'package:flowershop/views/widgets/app_navigator.dart';
import 'package:flowershop/views/widgets/cached_network_images.dart';
import 'package:flowershop/views/widgets/text_button.dart';
import 'package:flowershop/views/widgets/text_styles.dart';

import '../../widgets/product_card.dart';

class CreateCustomBouquetView extends ConsumerStatefulWidget {
  const CreateCustomBouquetView({super.key});

  @override
  ConsumerState createState() => _CreateCustomBouqueViewState();
}

class _CreateCustomBouqueViewState
    extends ConsumerState<CreateCustomBouquetView> {
  final receiverNameController = TextEditingController();
  final messageController = TextEditingController();

  Product? selectedProduct;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .watch(productStateNotifierProvider.notifier)
          .fetchFilteredProducts(searchQuery: 'Flower');
      ref.read(productStateNotifierProvider.notifier).fetchCategories();
    });
  }

  Order order = Order();
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(productStateNotifierProvider.notifier);
    final productState = ref.watch(productStateNotifierProvider);
    final selectedCategory = ref.watch(selectedCBCategoryProvider);

    return Scaffold(
      backgroundColor: ConstColors.swatch1,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'bouquet_card_title'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.pink.shade100,
        iconTheme: const IconThemeData(color: Colors.pink),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: Get.height * 0.1,
                  width: Get.width,
                  child: Center(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        // final isSelected = selectedCategory?.id == index;
                        return GestureDetector(
                          onTap: () {
                            // Select the new category
                            ref
                                .read(selectedCBCategoryProvider.notifier)
                                .state = category;
                            provider.fetchFilteredProducts(
                                searchQuery: category.name);
                          },
                          child: Container(
                            width: Get.width * 0.22,
                            margin: const EdgeInsets.only(right: 4, left: 4),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: selectedCategory!.id == index
                                  ? Colors.red.shade100
                                  : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  category.description!,
                                  style: const TextStyle(fontSize: 25),
                                ),
                                Text(
                                  category.name!,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                selectedCategory!.id != 3
                    ? productState.isLoading
                        ? ShowToast.loader()
                        : productState.filteredProducts.isEmpty
                            ? Text('No ${selectedCategory.name} found')
                            : SizedBox(
                                height: Get.height * 0.3,
                                width: double.infinity,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      productState.filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    final product =
                                        productState.filteredProducts[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                          height: 180,
                                          width: 200,
                                          child: ProductCard(
                                            product: product,
                                            isBouquet: true,
                                          )),
                                    );
                                  },
                                ),
                              )
                    : Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ConstColors.orangeColor.withOpacity(0.2),
                              border: Border.all(color: ConstColors.grey),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'receiver_name'.tr(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextField(
                                    maxLines: 1,
                                    controller: receiverNameController,
                                    decoration: InputDecoration(
                                      hintText: 'receiver_name'.tr(),
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade400),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.person,
                                        color: Colors.pink.shade200,
                                      ),
                                      contentPadding: const EdgeInsets.all(16),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'message_on_card'.tr(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextField(
                                    maxLines: 3,
                                    controller: messageController,
                                    decoration: InputDecoration(
                                      hintText: 'write_message'.tr(),
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade400),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.note_alt,
                                        color: Colors.pink.shade200,
                                      ),
                                      contentPadding: const EdgeInsets.all(16),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: TextButton(
                                      child: Text(
                                        'Add',
                                        style: MyTextStyles.mediumL
                                            .copyWith(color: Colors.blue),
                                      ),
                                      onPressed: () {
                                        final items = ref
                                            .watch(bouquetProvider)
                                            .bouquetItems;
                                        if (items.isNotEmpty) {
                                          items.first = BouquetItem(
                                              id: items.first.id,
                                              message: messageController.text,
                                              receiverName:
                                                  receiverNameController.text);
                                        } else {
                                          ShowToast.msg(
                                              'Please select item first');
                                        }
                                      }),
                                ),

                                // When to Send Section
                              ],
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: Get.height * 0.15),
                if (ref.watch(bouquetProvider).bouquetItems.isNotEmpty)
                  Container(
                    height: Get.height * 0.25,
                    width: Get.width * 0.9,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: ConstColors.grey,
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            itemCount:
                                ref.watch(bouquetProvider).bouquetItems.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final bouquet = ref
                                  .watch(bouquetProvider)
                                  .bouquetItems[index];
                              return GestureDetector(
                                onTap: () {
                                  ref
                                      .watch(bouquetProvider.notifier)
                                      .removeBouquetItem(bouquet);
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: Get.width * 0.20,
                                      margin: const EdgeInsets.only(
                                          right: 4, left: 4),
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          NetworkImageWidget(
                                              height: 50,
                                              width: Get.width * 0.18,
                                              imageUrl: bouquet.imageUrl ?? ''),
                                          SizedBox(
                                            width: Get.width * 0.18,
                                            child: Text(
                                              bouquet.title ?? '',
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.clear,
                                      color: ConstColors.red,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Text(
                            '= \$${ref.watch(bouquetProvider).totalPrice.toStringAsFixed(2)}'),
                        const SizedBox(),
                        MyTextButton(
                          title: 'proceed_checkout'.tr(),
                          onPressed: _proceedToCheckOut,
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _proceedToCheckOut() {
    final items = ref.watch(bouquetProvider).bouquetItems;
    if (items.isNotEmpty) {
      order.bouquet?.bouquetItems = items;
      Navigator.pop(context);
      ShowToast.msg('Bouquet has been added to the cart');
    }
    // if(order.BouquetItems!.isNotEmpty){
    //   AppNav.push(context, OrderSummaryView(order: order));
    //
    // }
  }
}

List<ProductCategory> categories = [
  ProductCategory(id: 0, name: 'Flower', description: '🥀'),
  ProductCategory(id: 1, name: 'Ribbon', description: '🎀️'),
  ProductCategory(id: 2, name: 'Wrapping', description: '🎁'),
  ProductCategory(id: 3, name: 'Message', description: '📝'),
];

final selectedCBCategoryProvider = StateProvider<ProductCategory?>((ref) {
  return categories.first;
});

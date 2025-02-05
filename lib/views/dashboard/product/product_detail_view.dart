import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flowershop/model/cart_item.dart';
import 'package:flowershop/model/product.dart';
import 'package:flowershop/provider/cart/cart_notifier.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:flowershop/views/widgets/add_to_cart_button.dart';
import 'package:flowershop/views/widgets/app_navigator.dart';
import 'package:flowershop/views/widgets/image_detail_view.dart';
import 'package:flowershop/views/widgets/text_styles.dart';

class ProductDetailView extends ConsumerStatefulWidget {
  final Product product;
  const ProductDetailView({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<ProductDetailView> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends ConsumerState<ProductDetailView> {
  int quantity = 1; // Default quantity
  final receiverNameController = TextEditingController();
  final messageController = TextEditingController();

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

  List<int> colorValues = [];

  void _addToCart() {
    final cartNotifier = ref.read(cartProvider.notifier);
    final selectedColor = ref.read(selectedColorProvider);
    final item = CartItem(
      id: widget.product.id!.toInt(),
      title: widget.product.title,
      imageUrl: widget.product.imageUrl,
      selectedColor: selectedColor,
      price: widget.product.price,
      message: messageController.text,
      receiverName: receiverNameController.text,
      quantity: quantity,
    );
    cartNotifier.addItemToCart(item);
    ShowToast.msg('${widget.product.title} added to cart');
  }

  extractColors() {
    if (widget.product.color != null && widget.product.color!.isNotEmpty) {
      List<String> colors = widget.product.color!.split(', ');
      colorValues = colors.map((value) => int.parse(value)).toList();
      print('e color : $colorValues');
      return colorValues;
    }
  }

  @override
  void initState() {
    extractColors();
    super.initState();
  }

  @override
  void dispose() {
    receiverNameController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = ref.watch(checkBoxProvider);
    final selectedColor = ref.watch(selectedColorProvider);
    return Scaffold(
      backgroundColor: ConstColors.swatch1,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image and Back Button
              Stack(
                children: [
                  // Product Image
                  GestureDetector(
                    onTap: () {
                      AppNav.push(context,
                          ImageDetailView(url: widget.product.imageUrl!));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        image: DecorationImage(
                          image: NetworkImage(widget.product.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Back Button
                  Positioned(
                    top: 16,
                    // left: 16,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.9),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              spreadRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ]),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
              // Product Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Get.width * 0.65,
                          child: Text(
                            widget.product.title!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '\$${widget.product.price?.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink.shade400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 60,
                          width: Get.width * 0.4,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: colorValues.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  ref
                                      .watch(selectedColorProvider.notifier)
                                      .state = colorValues[index];
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 27,
                                      width: 27,
                                      margin: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Color(colorValues[index]),
                                      ),
                                    ),
                                    if (selectedColor == colorValues[index])
                                      Icon(
                                        Icons.check,
                                        color: Color(colorValues[index]),
                                      )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
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
                                  style: MyTextStyles.largeText
                                      .copyWith(color: Colors.black)),
                              IconButton(
                                onPressed: _increaseQuantity,
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Text(
                      widget.product.description.toString(),
                      style: const TextStyle(
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: Get.width * 0.8,
                          child: Text(
                            'send_gift_note'.tr(),
                            style: MyTextStyles.largeText.copyWith(
                              fontStyle: FontStyle.italic,
                              color: ConstColors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          child: Checkbox(
                            value: isSelected,
                            onChanged: (v) {
                              ref.read(checkBoxProvider.notifier).state = v!;
                            },
                          ),
                        )
                      ],
                    ),

                    // Message on Card Section
                    const SizedBox(height: 16),

                    if (isSelected)
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
                                  hintText: 'message'.tr(),
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade400),
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
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade400),
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

                            // When to Send Section
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AddToCartButton(
          onPressed: _addToCart,
        ),
      ),
    );
  }
}

final checkBoxProvider = StateProvider<bool>((ref) {
  return false;
});

final selectedColorProvider = StateProvider<int?>((ref) {
  return null;
});

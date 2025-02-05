import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/provider/product/product_provider.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:flowershop/views/dashboard/categories/category_detail_view.dart';
import 'package:flowershop/views/widgets/app_navigator.dart';
import 'package:flowershop/views/widgets/cached_network_images.dart';
import 'package:flowershop/views/widgets/text_styles.dart';

class CategoriesView extends ConsumerStatefulWidget {
  CategoriesView({super.key});

  _CategoriesViewWidgetState createState() => _CategoriesViewWidgetState();
}

class _CategoriesViewWidgetState extends ConsumerState<CategoriesView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.watch(productStateNotifierProvider.notifier).fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesPro = ref.watch(productStateNotifierProvider);

    return Scaffold(
      backgroundColor: ConstColors.swatch1,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'categories'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.pink.shade100,
      ),
      body: categoriesPro.isLoading
          ? ShowToast.loader()
          : ListView.builder(
              shrinkWrap: true,
              itemCount: categoriesPro.categories.length,
              itemBuilder: (context, index) {
                final category = categoriesPro.categories[index];
                return InkWell(
                  onTap: () {
                    AppNav.push(
                      context,
                      CategoriesDetailView(category: category),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    padding: const EdgeInsets.all(2),
                    margin: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 16),
                    decoration: BoxDecoration(
                      color: ConstColors.whiteColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: NetworkImageWidget(
                            imageUrl: category.imageUrl!,
                            boxFit: BoxFit.cover,
                            width: double.infinity,
                            height: 150,
                          ),
                        ),
                        Text(category.name!,
                            style: MyTextStyles.mediumL
                                .copyWith(fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

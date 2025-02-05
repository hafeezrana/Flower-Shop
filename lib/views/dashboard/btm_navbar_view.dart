import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/provider/bouquet/bouquet_notifier.dart';
import 'package:flowershop/provider/cart/cart_notifier.dart';

import 'package:flowershop/services/location_service.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/views/dashboard/categories/categories_view.dart';
import 'package:flowershop/views/dashboard/home.dart';
import 'account/account_view.dart';
import 'cart/cart_view.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  final _controller = PageController(initialPage: 0);

  List<Widget> _buildScreens() {
    return [
      HomeView(),
      CategoriesView(),
      CartView(),
      AccountView(),
    ];
  }

  @override
  void initState() {
    Future.microtask(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(selectedViewIndexProvider);

    return Material(
      child: Scaffold(
        body: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children: _buildScreens(),
          onPageChanged: (value) {
            ref.read(selectedViewIndexProvider.notifier).state = value;
          },
        ),
        bottomNavigationBar: _bottomNavBar(),
      ),
    );
  }

  final gradientColors = [
    ConstColors.grey,
    ConstColors.swatch4,
  ];

  Widget _bottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: ConstColors.grey,
            blurRadius: 4,
            offset: Offset(0, -4),
          ),
        ],
        color: ConstColors.swatch1,
      ),
      padding: const EdgeInsets.only(top: 4, bottom: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _iconButton(ref, icon: Icons.home_filled, index: 0),
          _iconButton(ref, icon: Icons.category_outlined, index: 1),
          _iconButton(ref, icon: Icons.shopping_cart_outlined, index: 2),
          _iconButton(ref, icon: Icons.person_outline, index: 3),
        ],
      ),
    );
  }

  Widget _iconButton(WidgetRef ref,
      {required IconData icon, required int index}) {
    final selectedIndex = ref.watch(selectedViewIndexProvider);
    final cartPro = ref.watch(cartProvider);
    final bouquetPro = ref.watch(bouquetProvider);

    return GestureDetector(
      onTap: () {
        _controller.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selectedIndex == index
              ? ConstColors.buttonColor.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            index == 2
                ? Badge.count(
                    count: bouquetPro.bouquetItems.isNotEmpty
                        ? 1 + cartPro.cartItems.length
                        : 0 + cartPro.cartItems.length,
                    child: Icon(
                      icon,
                      size: selectedIndex == index ? 27 : 22,
                      color: selectedIndex == index
                          ? ConstColors.buttonColor
                          : ConstColors.grey,
                    ),
                  )
                : Icon(
                    icon,
                    size: selectedIndex == index ? 27 : 22,
                    color: selectedIndex == index
                        ? ConstColors.buttonColor
                        : ConstColors.grey,
                  ),
            const SizedBox(height: 4),
            AnimatedOpacity(
              opacity: selectedIndex == index ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                height: 4,
                width: 4,
                decoration: BoxDecoration(
                  color: ConstColors.buttonColor,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final selectedViewIndexProvider = StateProvider<int>((ref) {
  return 0;
});

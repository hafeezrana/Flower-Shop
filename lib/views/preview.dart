import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/get_helper.dart';

import 'package:flowershop/views/widgets/text_styles.dart';

import 'auth/authentication_view.dart';
import 'widgets/app_navigator.dart';

class Preview extends ConsumerWidget {
  Preview({super.key});

  final PageController pageController = PageController();
  int selectedIndex = 0;

  Widget myContainer(String title, String pathImg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: Get.width * 0.8,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: MyTextStyles.extraLargeText.copyWith(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
        ),
        Image.asset(pathImg),
        const SizedBox(height: 10),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);
    PageController controller = PageController();

    final pages = [
      myContainer(
          'Get Gifts For Your Loved Ones', 'assets/images/vt_popup_img.png'),
      myContainer('Customise your own Bucket', 'assets/images/bouquet/1.png'),
      myContainer(
          'Flowers of All Categories and Smell', 'assets/images/bouquet/2.png'),
    ];
    return Scaffold(
      backgroundColor: ConstColors.swatch1,
      body: PageView.builder(
        // controller: pageController,
        itemCount: pages.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return pages[selectedIndex];
        },
        onPageChanged: (index) {
          selectedIndex = index;

          ref.watch(currentIndexProvider.notifier).state = index;
          pageController.animateToPage(selectedIndex,
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceInOut);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          height: 140,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                height: 30,
                child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, idx) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 25,
                          width: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: idx == currentIndex
                                ? ConstColors.red
                                : ConstColors.blueSky,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  if (ref.watch(currentIndexProvider.notifier).state < 2) {
                    ref.watch(currentIndexProvider.notifier).state++;
                    selectedIndex++;
                  } else {
                    AppNav.pushReplacemend(context, AuthenticationView());
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'get_started'.tr(),
                      style:
                          MyTextStyles.largeText.copyWith(color: Colors.black),
                    ),
                    const SizedBox(width: 20),
                    Card(
                      elevation: 20,
                      shadowColor: ConstColors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const CircleAvatar(
                        backgroundColor: ConstColors.deepBlueColor,
                        radius: 25,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: ConstColors.whiteColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

final currentIndexProvider = StateProvider<int>((ref) => 0);

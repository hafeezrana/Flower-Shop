import 'package:flutter/material.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/colors_const.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ConstColors.blueSky,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ListTileShimmer(),
            SizedBox(height: 30),
            ButtonShimmer(),
            ButtonShimmer2(),
            Shimmer.fromColors(
              baseColor: ConstColors.skyColor.withOpacity(0.2),
              highlightColor: Color(0xff7D88E7),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                width: Get.width * 0.5,
                height: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListTileShimmer extends StatelessWidget {
  const ListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      // baseColor: Colors.grey.shade300,
      // highlightColor: Colors.grey.shade100,
      baseColor: ConstColors.skyColor.withOpacity(0.2),
      highlightColor: Color(0xff7D88E7),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            radius: 30.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: Get.width * 0.6,
                height: 20.0,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Container(
                width: Get.width * 0.3,
                height: 12.0,
                color: Colors.white,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ButtonShimmer extends StatelessWidget {
  const ButtonShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ConstColors.blueSky.withOpacity(0.2),
      highlightColor: Color(0xff7D88E7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            height: Get.height * 0.16,
            width: Get.width * 0.4,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            height: Get.height * 0.2,
            width: Get.width * 0.4,
          ),
        ],
      ),
    );
  }
}

class ButtonShimmer2 extends StatelessWidget {
  const ButtonShimmer2({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: ConstColors.blueSky.withOpacity(0.2),
      highlightColor: Color(0xff7D88E7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            height: Get.height * 0.2,
            width: Get.width * 0.4,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            height: Get.height * 0.16,
            width: Get.width * 0.4,
          ),
        ],
      ),
    );
  }
}

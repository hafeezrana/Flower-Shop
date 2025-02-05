import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/model/order.dart';
import 'package:flowershop/provider/auth/auth_notifier.dart';
import 'package:flowershop/provider/order/order_notifier.dart';
import 'package:flowershop/utils/app_preferences.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:flowershop/views/dashboard/account/test_lang.dart';
import 'package:flowershop/views/dashboard/order/order_summary_view.dart';
import 'package:flowershop/views/dashboard/order/order_list_view.dart';
import 'package:flowershop/views/widgets/alert_dialogue.dart';
import 'package:flowershop/views/widgets/app_navigator.dart';

import 'help_support.dart';
import 'language_selector.dart';

class AccountView extends ConsumerStatefulWidget {
  AccountView({super.key});

  _LanguageSelectorState createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends ConsumerState<AccountView> {
  @override
  String? orderData;

  @override
  Widget build(BuildContext context) {
    final authStatePro = ref.watch(authStateProvider);
    final data = AppPreferences.getString(AppPreferences.pendingOrder);
    if (data != null && data.isNotEmpty) {
      orderData = data;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ConstColors.swatch1,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.12,
                    left: MediaQuery.of(context).size.width * 0.5 - 60,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset('assets/images/bouquet/11.png'
                            // backgroundImage:
                            //     AssetImage('assets/images/profile.jpg'),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // User Name
              Text(
                authStatePro.user?.fullName ?? "",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),

              const SizedBox(height: 5),

              // Email
              Text(
                authStatePro.user?.phoneNo ?? "",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 5),

              // Info Tiles
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // _buildInfoTile(Icons.person, "Username", "johndoe123"),
                    // const SizedBox(height: 10),
                    // _buildInfoTile(
                    //     Icons.edit, ConstColors.orangeColor, "Edit Info",
                    //     onTap: () {
                    //   AppNav.push(context, const TestLangScreen());
                    // }),
                    _buildInfoTile(
                        Icons.help, ConstColors.blueColor, "help_support".tr(),
                        onTap: () {
                      AppNav.push(context, const SupportScreen());
                    }),

                    const SizedBox(height: 10),
                    _buildInfoTile(
                        Icons.language, ConstColors.black, "language".tr(),
                        onTap: () {
                      AppNav.push(Get.context, const LanguageSelector());
                    }),
                    const SizedBox(height: 10),
                    // _buildInfoTile(Icons.subscriptions, "Subscription Plans",
                    //     onTap: () => ()),
                    // const SizedBox(height: 10),

                    _buildInfoTile(
                        Icons.list, ConstColors.orangeColor, "order_list".tr(),
                        onTap: () async {
                      ref.watch(orderStateProvider.notifier).getRawOrders();
                      AppNav.push(context, const OrderView());
                    }),
                    const SizedBox(height: 10),
                    _buildInfoTile(
                        Icons.pending, ConstColors.green, "pending_order".tr(),
                        iconTrailing: orderData != null
                            ? Icons.circle_rounded
                            : null, onTap: () async {
                      final order = await _initializeOrder();
                      if (order != null) {
                        AppNav.push(context, OrderSummaryView(order: order));
                      } else {
                        ShowToast.msg("There is no pending order");
                      }
                    }),
                    // const SizedBox(height: 10),
                    // _buildInfoTile(Icons.location_on, "Location", onTap: () {}),
                    const SizedBox(height: 10),
                    _buildInfoTile(
                        Icons.delete, ConstColors.red, "account_delete".tr(),
                        onTap: () async {
                      MyDialogue.showAlertDialog(
                        context: context,
                        onConfirm: () async {
                          await ref
                              .watch(authStateProvider.notifier)
                              .deleteAccount();
                        },
                      );
                    }),
                    const SizedBox(height: 10),
                    _buildInfoTile(
                      Icons.logout,
                      ConstColors.red.withOpacity(0.4),
                      "log_out".tr(),
                      onTap: () async {
                        await ref.watch(authStateProvider.notifier).logout();
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, Color iconColor, String title,
      {required onTap, IconData? iconTrailing}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: iconColor),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (iconTrailing != null) Icon(iconTrailing, color: ConstColors.red)
          ],
        ),
      ),
    );
  }

  Future<Order?> _initializeOrder() async {
    try {
      final orderJson =
          await AppPreferences.getString(AppPreferences.pendingOrder);
      if (orderJson.isNotEmpty) {
        final orderData = jsonDecode(orderJson);
        return Order.fromJson(orderData);
      }
    } catch (e) {
      log("e: ${e.toString()}");
    }

    print('order: $orderData');
    return null;
  }
}

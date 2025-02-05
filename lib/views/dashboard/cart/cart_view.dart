import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart' as el;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flowershop/model/custom_bouquet.dart';
import 'package:flowershop/model/order.dart';
import 'package:flowershop/provider/bouquet/bouquet_notifier.dart';
import 'package:flowershop/provider/cart/cart_notifier.dart';
import 'package:flowershop/provider/order/order_notifier.dart';
import 'package:flowershop/services/location_service.dart';
import 'package:flowershop/utils/app_preferences.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/utils/key_consts.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:flowershop/views/dashboard/cart/widgets/bouquet_card.dart';
import 'package:flowershop/views/test.dart';
import 'package:flowershop/views/widgets/app_navigator.dart';
import 'package:flowershop/views/widgets/cached_network_images.dart';
import 'package:flowershop/views/widgets/text_styles.dart';
import 'package:place_picker_google/place_picker_google.dart';

import 'widgets/cart_card.dart';
import '../order/order_summary_view.dart';

class CartView extends ConsumerStatefulWidget {
  CartView({super.key});

  _CartViewWidgetState createState() => _CartViewWidgetState();
}

class _CartViewWidgetState extends ConsumerState<CartView> {
  LocationResult? locationResult;
  Order order = Order();

  @override
  void initState() {
    Future.microtask(() {
      ref.watch(locationProvider).getCurrentLocation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartPro = ref.watch(cartProvider);
    final bouquetPro = ref.watch(bouquetProvider);
    double? deliveryPrice;
    double totalPrice = cartPro.totalPrice + bouquetPro.totalPrice;

    return Scaffold(
      backgroundColor: ConstColors.swatch1,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'cart'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.pink.shade100,
      ),
      body: cartPro.isLoading
          ? ShowToast.loader()
          : cartPro.cartItems.isEmpty && bouquetPro.bouquetItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/vt_popup_img.png'),
                      Text(
                        'no_item_found'.tr(),
                        style: MyTextStyles.largeText,
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      if (bouquetPro.bouquetItems.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.white,
                            elevation: 1,
                            shadowColor: ConstColors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  'bouquet_card_title'.tr(),
                                  style: MyTextStyles.largeText
                                      .copyWith(color: ConstColors.black),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: bouquetPro.bouquetItems.length,
                                  itemBuilder: (context, index) {
                                    final item = bouquetPro.bouquetItems[index];
                                    return BouquetCard(item: item);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (cartPro.cartItems.isNotEmpty)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: cartPro.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartPro.cartItems[index];
                            return CartCard(item: item);
                          },
                        ),
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
      bottomNavigationBar: cartPro.cartItems.isNotEmpty ||
              bouquetPro.bouquetItems.isNotEmpty
          ? Container(
              height: 180,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: ConstColors.grey,
                    blurRadius: 4,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'total_price'.tr(),
                        style: MyTextStyles.mediumL,
                      ),
                      Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: MyTextStyles.largeText.copyWith(
                          color: ConstColors.red,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'address'.tr(),
                        style: MyTextStyles.mediumL,
                      ),
                      SizedBox(
                        width: Get.width * 0.7,
                        child: TextButton(
                          onPressed: () async {
                            await showPlacePicker(context, ref);
                          },
                          child: Text(
                            locationResult?.latLng != null
                                ? locationResult!.formattedAddress.toString()
                                : 'choose_location'.tr(),
                            textAlign: TextAlign.end,
                            style: MyTextStyles.mediumText.copyWith(
                                color: locationResult?.latLng != null
                                    ? ConstColors.grey
                                    : ConstColors.blueColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        ref
                            .watch(orderStateProvider.notifier)
                            .generateOrderNumber();
                        final orderNumber =
                            ref.watch(orderStateProvider).orderNumber;

                        if (orderNumber != null &&
                            locationResult != null &&
                            (cartPro.cartItems.isNotEmpty ||
                                bouquetPro.bouquetItems.isNotEmpty)) {
                          deliveryPrice = await ref
                              .watch(locationProvider)
                              .calculateDistanceWithPrice(
                                centerPoint:
                                    const LatLng(30.0794098, 71.4018878),
                                currentLocation: locationResult!.latLng!,
                                pricePerKM: 500,
                              );

                          if (deliveryPrice != null) {
                            order.userID =
                                AppPreferences.getInt(AppPreferences.userId);

                            order.orderNumber = orderNumber;
                            order.totalPrice = totalPrice;
                            order.cartItems = cartPro.cartItems;
                            order.paymentStatus = 0;
                            order.phoneNo = AppPreferences.getString(
                                AppPreferences.phoneNum);
                            order.deliveryPrice = deliveryPrice;
                            order.latitude =
                                locationResult!.latLng?.latitude.toString();
                            order.longitude =
                                locationResult!.latLng?.longitude.toString();
                            order.address = locationResult!.formattedAddress;
                            if (bouquetPro.bouquetItems.isNotEmpty) {
                              order.bouquet = Bouquet(
                                  bouquetItems: bouquetPro.bouquetItems);
                            }
                            // order.bouquet?.bouquetItems = bouquetPro.bouquetItems;
                            final encodedJson = jsonEncode(order.toJson());
                            AppPreferences.setString(
                                AppPreferences.pendingOrder, encodedJson);
                            AppPreferences.getString(
                                AppPreferences.pendingOrder);

                            AppNav.push(
                                context, OrderSummaryView(order: order));
                          }
                        } else {
                          ShowToast.msg('incomplete_order_information'.tr());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'proceed_checkout'.tr(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  showPlacePicker(BuildContext context, WidgetRef ref) async {
    try {
      final locPro = await ref.watch(locationProvider).getCurrentLocation();
      AppNav.push(
          context,
          PlacePicker(
            mapsBaseUrl: "https://maps.googleapis.com/maps/api/",
            usePinPointingSearch: true,
            apiKey: Platform.isAndroid
                ? GoogleMapKeyConsts.googleMapKey
                : GoogleMapKeyConsts.googleMapKey,
            onPlacePicked: (LocationResult result) {
              setState(() {
                locationResult = result;
              });
              Navigator.of(context).pop();
            },
            enableNearbyPlaces: false,
            showSearchInput: true,
            initialLocation: LatLng(locPro?.latitude ?? 30.0794098,
                locPro?.longitude ?? 71.4018878),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            searchInputConfig: const SearchInputConfig(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              autofocus: false,
              textDirection: TextDirection.ltr,
            ),
            searchInputDecorationConfig: const SearchInputDecorationConfig(
              hintText: "Search for a building, street or ...",
            ),
            // selectedPlaceWidgetBuilder: (ctx, state, result) {
            //   return const SizedBox.shrink();
            // },
            autocompletePlacesSearchRadius: 150,
          ));
    } catch (e) {
      ShowToast.msg('Error: $e');
    }
  }
}

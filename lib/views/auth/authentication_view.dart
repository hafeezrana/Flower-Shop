import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/provider/auth/auth_notifier.dart';
import 'package:flowershop/repositories/auth_repository.dart';

import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:flowershop/views/auth/country_code_field.dart';
import 'package:flowershop/views/auth/signup_view.dart';

import 'package:flowershop/views/dashboard/btm_navbar_view.dart';

import 'package:flowershop/views/widgets/app_navigator.dart';
import 'package:flowershop/views/widgets/text_button.dart';

class AuthenticationView extends ConsumerWidget {
  AuthenticationView({super.key});

  final phoneNumController = TextEditingController();
  String countryCode = '+964';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepo = ref.watch(authRepositoryProvider);
    final authPro = ref.watch(authStateProvider.notifier);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: ConstColors.swatch1,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image.asset(
                //   'assets/images/bouquet/5.png',
                //   scale: 1,
                //   // color: ConstColors.deepBlueColor,
                // ),
                CountryCodeField(
                    label: "phone_number".tr(),
                    controller: phoneNumController,
                    onCountryChanged: (country) {
                      countryCode = country.dialCode;
                    },
                    validator: (phone) {
                      if (phone == null || phone.number.isEmpty) {
                        return 'valid_phone_number'.tr();
                      }
                      if (phone.number.length < 10) {
                        // Adjust length as per country
                        return 'valid_phone_number'.tr();
                      }
                      return null;
                    }),
                const SizedBox(height: 30),
                authState.isLoading
                    ? ShowToast.loader()
                    : MyTextButton(
                        title: 'login'.tr(),
                        backgroundColor: ConstColors.buttonColor,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final phNum = countryCode + phoneNumController.text;
                            final fixedNum = authRepo.removeLeadingZero(phNum);
                            await authPro.login(fixedNum);
                          }
                        },
                      ),
                const SizedBox(height: 50),
                InkWell(
                  onTap: () {
                    AppNav.push(context, SignUpView());
                  },
                  child: Text('create_new_account'.tr()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

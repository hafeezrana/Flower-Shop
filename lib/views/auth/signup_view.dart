import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flowershop/provider/auth/auth_notifier.dart';
import 'package:flowershop/repositories/auth_repository.dart';
import 'package:flowershop/services/location_service.dart';
import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/toast.dart';
import 'package:flowershop/views/auth/authentication_view.dart';
import 'package:flowershop/views/widgets/alert_dialogue.dart';
import 'package:flowershop/views/widgets/app_navigator.dart';
import 'package:flowershop/views/widgets/reusable_textfield.dart';
import 'package:flowershop/views/widgets/text_button.dart';
import 'package:location/location.dart';
import 'country_code_field.dart';

class SignUpView extends ConsumerStatefulWidget {
  @override
  ConsumerState createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late FocusNode focusNode;
  bool canResend = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String countryCode = '+964';
  LocationData? userLocationData;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((v) {
      Future.delayed(const Duration(seconds: 3), () {
        showLocationDialog();
      });
    });
    super.initState();
    focusNode = FocusNode();
  }

  showLocationDialog() async {
    await MyDialogue.showLocationPermissionDialog(context, () async {
      Navigator.pop(context);
      userLocationData = await ref.watch(locationProvider).getCurrentLocation();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    focusNode.unfocus();
    super.dispose();
  }

  void _submitForm() async {
    try {
      if (userLocationData?.latitude != null) {
        userLocationData =
            await ref.watch(locationProvider).getCurrentLocation();
      }

      final authStatePro = ref.watch(authStateProvider.notifier);
      final authPro = ref.watch(authRepositoryProvider);

      if (_formKey.currentState!.validate() &&
          _phoneController.text.isNotEmpty) {
        final phoneNum = countryCode + _phoneController.text;
        final phNo = authPro.removeLeadingZero(phoneNum);

        final userInput = {
          "full_name": _nameController.text,
          "phone_no": phNo,
          "latitude": userLocationData?.latitude,
          "longitude": userLocationData?.longitude,
        };
        await authStatePro.createUser(userInput);
      }
    } catch (e) {
      ShowToast.msg('Error: $e');
    }
  }

  void _unfocusFields() {
    focusNode.unfocus(); // Unfocus the text field
    FocusScope.of(context).unfocus(); // Unfocus everything
  }

  @override
  Widget build(BuildContext context) {
    final authPro = ref.watch(authStateProvider);
    return Scaffold(
      backgroundColor: ConstColors.swatch1,
      appBar: AppBar(
        title: Text('signup'.tr()),
      ),
      body: GestureDetector(
        onTap: _unfocusFields,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ReusableTextField(
                    label: 'full_name'.tr(),
                    maxLines: 1,
                    focusNode: focusNode,
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'full_name_validity'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CountryCodeField(
                    label: "phone_number".tr(),
                    controller: _phoneController,
                    onCountryChanged: (country) {
                      countryCode = country.dialCode;
                    },
                  ),
                  const SizedBox(height: 20),
                  authPro.isLoading || ref.watch(locationProvider).isLoading
                      ? ShowToast.loader()
                      : MyTextButton(
                          onPressed: _submitForm,
                          title: 'signup'.tr(),
                        ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      AppNav.push(context, AuthenticationView());
                    },
                    child: Text('user_exists'.tr()),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

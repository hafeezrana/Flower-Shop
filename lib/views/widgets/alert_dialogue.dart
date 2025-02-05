import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flowershop/utils/colors_const.dart';
import 'package:flowershop/utils/get_helper.dart';
import 'package:flowershop/views/widgets/text_button.dart';
import 'package:flowershop/views/widgets/text_styles.dart';

class MyDialogue {
  static showMsg(String msg, {void Function()? onPressed}) {
    return showDialog(
        context: Get.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            elevation: 5,
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(msg,
                      textAlign: TextAlign.center,
                      style:
                          MyTextStyles.largeText.copyWith(color: Colors.black)),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ConstColors.deepBlueColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                          onPressed: onPressed ??
                              () {
                                Navigator.pop(context);
                              },
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                ],
              ),
            ),
          );
        });
  }

  static showLocationPermissionDialog(
      BuildContext context, void Function() onYes) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "يحتاج التطبيق إلى الوصول إلى الموقع الحالي لجهازك لتقديم الخدمة وتقديم العروض والخدمات لمنطقتك.",
            textAlign: TextAlign.right,
            style: TextStyle(
              color: ConstColors.grey,
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('رفض'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MyTextButton(
              onPressed: onYes,
              title: 'موافق',
            ),
          ],
        );
      },
    );
  }

  static showAlertDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_rounded, color: Colors.red, size: 28),
              const SizedBox(width: 8),
              Text(
                'alert_title'.tr(),
                style:
                    MyTextStyles.extraLargeText.copyWith(color: Colors.black),
              ),
            ],
          ),
          content: Text(
            'alert_description'.tr(),
            style: MyTextStyles.mediumText,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm(); // Execute the function when "Yes" is pressed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Yes", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

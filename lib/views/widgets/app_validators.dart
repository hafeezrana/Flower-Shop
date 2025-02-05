class AppValidators {
  static String? emailValidator(String value) {
    if (value.isEmpty) return "Please enter email";
    bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
        .hasMatch(value);
    if (emailValid) {
      return null;
    } else {
      return "Please enter valid email";
    }
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "الرجاء إدخال كلمة المرور";
    }

    bool hasUpperCase = false;
    for (int i = 0; i < value.length; i++) {
      if (value[i].toUpperCase() == value[i]) {
        hasUpperCase = true;
        break;
      }
    }

    bool passwordPattern =
        RegExp(r'^(?=.*[a-z])(?=.*\d).{8,}$').hasMatch(value);

    if (passwordPattern && hasUpperCase) {
      return null; // Valid password
    } else {
      return "الرجاء إدخال كلمة مرور صالحة تحتوي على حرف كبير واحد على الأقل";
    }
  }

  static String? phoneNumValidator(String value) {
    if (value.isEmpty) return "الرجاء إدخال رقم الهاتف";
    RegExp phoneNumberRegExp = RegExp(r'^(\+964)?\d{10,13}$');

    if (phoneNumberRegExp.hasMatch(value)) {
      return null;
    } else {
      return "الرجاء إدخال رقم هاتف صالح";
    }
  }

  static String? intOrdoubleValidator(String? value,
      {bool isRequired = false}) {
    if (value == null || value.isEmpty) {
      if (isRequired) {
        return "من فضلك أدخل رقما";
      } else {
        return null;
      }
    }

    RegExp numberRegExp = RegExp(r'^-?\d+(\.\d+)?$');

    if (numberRegExp.hasMatch(value)) {
      return null; // Valid number
    } else {
      print("رقم غير صالح: $value");
      return "من فضلك أدخل رقما صالحا";
    }
  }

  static String? validateCNIC(String value) {
    RegExp cnicRegex = RegExp(r'^\d{5}-\d{7}-\d$');
    if (!cnicRegex.hasMatch(value)) {
      return 'Invalid CNIC format';
    }
    return null;
  }

  static String? required(String value, {String? message}) {
    if (value.isEmpty) return message ?? "This field is required";
    return null;
  }

  static String? amountValidator(String value, {String? message}) {
    // if (value == null) {
    //   return message ?? "This field is required";
    // }
    print("value: $value");
    if (value.isEmpty) {
      return message ?? "This field is required";
    }

    // Check if the entered value is a valid integer
    try {
      int intValue = int.parse(value);
      if (intValue < 1000) {
        return null; // Valid integer below 1000
      } else {
        return "Please enter a value below 1000";
      }
    } catch (e) {
      return "Please enter a valid amount";
    }
  }

  static String? lengthValidator(String value, {required int length}) {
    // if (value == null) {
    //   return message ?? "This field is required";
    // }
    print("value: $value");
    if (value.isEmpty) {
      return "This field is required";
    }

    if (value.length < length) {
      return "Please enter $length digits";
    } else {
      return null;
    }
  }
}

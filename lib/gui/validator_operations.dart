import 'package:intl/intl.dart';

class ValidatorOperations {
  static String? checkPassword(String? value) {
    if (value!.isEmpty || value.length < 8) {
      return 'Password must be of length 8 or greater.\n';
    }
    return null;
  }

  static String? checkCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your card number.\n';
    }
    String? whiteSpacesRemovedValue = value.replaceAll(RegExp(r' '), "");
    try {
      int.parse(whiteSpacesRemovedValue);
    } catch (error) {
      return 'Please enter numbers only\n';
    }
    return null;
  }

  static String? checkCardExpiry(String? value) {
    if (value != null && value.length != 5) {
      return "Please complete input.\n";
    } else {
      try {
        int.parse(value!.replaceFirst(RegExp(r'/'), ''));
        int month = int.parse(value.substring(0, 2));
        if (month < 1 || month > 12) {
          return "Invalid month.\n";
        }
      } catch (error) {
        return "Invalid Date.\n";
      }

      return null;
    }
  }

  static String? checkCardCvv(String? value) {
    try {
      int.parse(value!);
      if (value.length != 3) {
        return "Please complete Cvv.\n";
      }
    } catch (error) {
      return "Invalid input.\n";
    }
    return null;
  }

  static String? checkPhoneNumber(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a valid phone number.\n';
    }
    value = value.trim();
    if (value.length != 11) {
      return 'Phone number must have a length of 11.\n';
    }
    try {
      int.parse(value);
      return null;
    } catch (err) {
      return 'Please enter a valid phone number.\n';
    }
  }

  static String? checkPhoneNumberType3(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a valid phone number.\n';
    }
    value = value.trim();
    if (value.length != 10) {
      return 'Please enter the last 10 digits.\n';
    }
    try {
      int.parse(value);
      return null;
    } catch (err) {
      return 'Please enter a valid phone number.\n';
    }
  }

  static String? checkPhoneNumberType2(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a valid phone number.\n';
    }
    if (value.substring(0, 4) != "+234") {
      return 'Phone number must begin with +234.\n';
    }
    value = value.trim();
    if (value.length != 14) {
      return 'Phone number must have a length of 13.\n';
    }

    try {
      int.parse(value.substring(1));
      return null;
    } catch (err) {
      return 'Please enter a valid phone number.\n';
    }
  }

  static String? validateEmail(String? value) {
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    if (!regex.hasMatch(value!)) {
      return 'Enter valid email.\n';
    } else {
      return null;
    }
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter valid name.\n';
    } else {
      return null;
    }
  }

  static String? isNotEmpty(String? value) {
    if (value!.isEmpty) {
      return 'Input required. \n';
    }
    return null;
  }

  static String? isDouble(String? value, {bool allowZero = false}) {
    if (value!.isEmpty) {
      return 'Input required. \n';
    } else {
      try {
        double val = double.parse(value);
        if (val > 0) {
          return null;
        } else {
          if (val == 0 && allowZero == true) {
            return null;
          }
          return 'Please value must be greater than 0.\n';
        }
      } catch (err) {
        return 'Please enter a valid number.\n';
      }
    }
  }

  static String? isDoubleLoanAmt(
    String? value,
    double limit,
  ) {
    if (value!.isEmpty) {
      return 'Input required. \n';
    } else {
      try {
        double val = double.parse(value);
        if (val > limit) {
          return null;
        } else {
          return "The amount must be greater than ${NumberFormat.currency(name: "").format(limit)}\n";
        }
      } catch (err) {
        return 'Please enter a valid number.\n';
      }
    }
  }

  static String? isDoubleStaloanAmt(
    String? value,
    double limit,
  ) {
    if (value!.isEmpty) {
      return 'Input required. \n';
    } else {
      try {
        double val = double.parse(value);
        if (val < 1000) {
          return "The amount must be greater than ${NumberFormat.currency(name: "").format(1000)}\n";
        }
        if (val > limit) {
          return "The amount can't be greater than ${NumberFormat.currency(name: "").format(limit)}\n";
        } else {
          return null;
        }
      } catch (err) {
        return 'Please enter a valid number.\n';
      }
    }
  }

  static String? checkBankVerificationNumber(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your bvn.';
    }
    value = value.trim();
    if (value.length != 11) {
      return 'BVN must have a length of 11 characters.';
    }
    try {
      int.parse(value);
      return null;
    } catch (err) {
      return 'Please enter a valid bvn number.';
    }
  }
}

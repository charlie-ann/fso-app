import 'package:flutter/services.dart';

var regex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

const nairaText = '₦';

class Validators {
  static String? validateField(String? value) {
    if (value!.isEmpty) {
      return "Field cannot be empty";
    } else {
      return null;
    }
  }

  static String? validateName(String? value) {
    if (value!.isEmpty) {
      return "Name cannot be empty";
    } else if (value.length < 3) {
      return "Name must be 3 characters or more";
    } else {
      return null;
    }
  }

  static String? validateAmount(String? str) {
    if (str == null || str.isEmpty) {
      return "Amount cannot be empty";
    } else if (num.parse(str.replaceAll(",", "")) < 1) {
      return "Amount must be greater than 0";
    }
    return null;
  }

  static String? validateBvn(String? str) {
    if (str == null || str.isEmpty) {
      return "BVN cannot be empty";
    } else if (str.length != 11) {
      return "BVN must be 11 characters";
    }
    return null;
  }

  static String? validateNin(String? str) {
    if (str == null || str.isEmpty) {
      return null;
    } else if (str.length != 11) {
      return "NIN must be 11 characters";
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (!regex.hasMatch(email!)) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  static String? validateOptionalEmail(String? email) {
    if (email == null || email.isEmpty) {
      return null;
    } else if (!regex.hasMatch(email)) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  static String? validateLoginPassword(String? password) {
    if (password == null || password.isEmpty) {
      return null;
    } else if (password.length < 6) {
      return 'Invalid password';
    } else {
      return null;
    }
  }

  static String? validatePhonenumber(String? str) {
    RegExp regExp = RegExp(
      r"^\d{10,11}$",
    );

    if (!regExp.hasMatch(str!)) {
      return 'Invalid phone number';
    } else {
      return null;
    }
  }

  static String? validateDate2(String? str) {
    final RegExp dateRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
    if (!dateRegex.hasMatch(str!)) {
      return 'Please enter a valid date in format dd-MM-yyyy';
    }
    return null;
  }

  static String? validateFullName(String? fullName) {
    if (fullName != null && fullName.isEmpty) {
      return 'Fullname field cannot be empty';
    }

    if (fullName != null && fullName.split(' ').length < 2) {
      return 'Fullname field should contain first and last name';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return "Password field cannot be empty";
    } else if (value.length < 6) {
      return "Password must be 6 characters or more";
    } else {
      return null;
    }
  }
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    text = text.replaceAll(" ", "");
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if (i < (text.length - 1)) buffer.write(" ");
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}

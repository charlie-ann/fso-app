import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String allFirstToUpper(String input) {
  if (input.isEmpty || input.length < 2) {
    return input;
  } else {
    List<String> splittedTexts = input.split(' ');
    String result = "";

    for (int i = 0; i < splittedTexts.length; i++) {
      String text = splittedTexts[i];
      try {
        result += text[0].toUpperCase() + text.substring(1).toLowerCase();
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }

      if (i < splittedTexts.length - 1) {
        result += " ";
      }
    }
    return result;
  }
}

String formatPhoneNig(String phone, {code = "+234"}) {
  final formattedPhone = phone.startsWith("0")
      ? "$code${phone.substring(1)}"
      : phone.length == 10
          ? "$code$phone"
          : phone;
  return formattedPhone;
}

String formatPhoneNig2(String phone, {code = "0"}) {
  final formattedPhone = phone.startsWith("0")
      ? "$code${phone.substring(1)}"
      : phone.length == 10
          ? "$code$phone"
          : phone;
  return formattedPhone;
}

String formatPhoneNig3(String phoneNumber) {
  // Remove all non-digit characters from the phone number
  String digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

  // Remove the country code if present (e.g., +234 or 234)
  if (digitsOnly.length > 10 && digitsOnly.startsWith('234')) {
    digitsOnly = digitsOnly.substring(3);
  }

  // Remove the leading zero if present
  if (digitsOnly.startsWith('0')) {
    digitsOnly = digitsOnly.substring(1);
  }

  // Return the last 10 digits of the phone number
  return digitsOnly.substring(digitsOnly.length - 10);
}

String formatMoney(
    {required num amount, String? symbol, int? decimalDigits = 0}) {
  final format = NumberFormat.currency(
      locale: "en_US",
      decimalDigits: decimalDigits,
      symbol: symbol == null ? '' : (symbol));
  return format.format(amount);
}

class AmountFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove non-digit characters
    String cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Format the amount by adding commas
    String formattedText = _addCommas(cleanText);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }

  String _addCommas(String text) {
    int length = text.length;
    if (length <= 3) {
      return text;
    }

    int commaCount = (length - 1) ~/ 3;
    List<String> parts = [];

    for (int i = 0; i < commaCount; i++) {
      parts.add(text.substring(length - (i + 1) * 3, length - i * 3));
    }

    parts.add(text.substring(0, length - commaCount * 3));

    return parts.reversed.join(',');
  }
}

extension DummyDetails on String {
  String? get ifDebugging => kDebugMode ? this : null;
}

String maskedText(String text) {
  String maskedText = "";
  maskedText = text.replaceRange(3, text.length - 10,
      List.generate(text.length - 13, (index) => "*").join().toString());
  return maskedText;
}

String formatDateTimeAdv(DateTime dt) {
  final now = DateTime.now();
  var diff = now.difference(dt);

  if (diff.inHours < 1) {
    return timeago.format(dt);
  }

  return DateFormat.yMMMd().add_jm().format(dt);
}

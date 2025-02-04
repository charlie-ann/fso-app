import 'package:flutter/material.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:google_fonts/google_fonts.dart';

class DropDownTheme {
  const DropDownTheme._();

  static DropdownMenuThemeData dropdownMenuThemeData = DropdownMenuThemeData(
    textStyle: GoogleFonts.workSans(
      fontWeight: FontWeight.w400,
      fontSize: 15.text,
      color: AppColors.black,
      height: 1.3,
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: false,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.borderGrey, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.borderGrey, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.borderGrey, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          color: AppColors.borderGrey,
        ),
      ),
      fillColor: Colors.white,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),
    menuStyle: const MenuStyle(),
  );
}

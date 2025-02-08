import 'package:flutter/material.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/config/themes/text_theme.dart';

class FButtonTheme {
  FButtonTheme._();

  static ButtonThemeData lightButtonThemeData = ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    buttonColor: AppColors.primary,
    disabledColor: AppColors.unselectedGrey,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
  );
}

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  static ElevatedButtonThemeData lightElevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      textStyle: FTextTheme.lightTextTheme.labelLarge,
      elevation: 0,
      disabledBackgroundColor: AppColors.unselectedGrey,
      disabledForegroundColor: AppColors.bodyTextGrey,
      enableFeedback: true,
    ),
  );
}

class AppOutlinedButtonTheme {
  AppOutlinedButtonTheme._();

  static OutlinedButtonThemeData lightOutlinedButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: AppColors.white,
      side: const BorderSide(
        color: AppColors.primary,
        width: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      textStyle: FTextTheme.lightTextTheme.labelLarge,
      elevation: 0,
      disabledBackgroundColor: AppColors.unselectedGrey,
      disabledForegroundColor: AppColors.bodyTextGrey,
      enableFeedback: true,
      foregroundColor: AppColors.primary,
    ),
  );
}

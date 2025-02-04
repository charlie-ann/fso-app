import 'package:flutter/material.dart';
import 'package:fso_support/core/config/color/app_colors.dart';

class FAppBarTheme {
  FAppBarTheme._();

  static AppBarTheme lightAppBarTheme = const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: AppColors.white,
  );

  static AppBarTheme darkAppBarTheme = const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: AppColors.darkScaffoldBg,
  );
}

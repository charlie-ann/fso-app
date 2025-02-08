import 'package:flutter/material.dart';
import 'package:fso_support/core/config/color/app_colors.dart';

class CheckBoxTheme {
  const CheckBoxTheme._();

  static CheckboxThemeData lightCheckBoxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    side: const BorderSide(
      color: AppColors.unselectedGrey,
      width: 1,
    ),
    fillColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.successGreen;
        } else if (states.contains(WidgetState.disabled)) {
          return AppColors.dividerGrey;
        } else {
          return AppColors.white;
        }
      },
    ),
    checkColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.white;
        } else if (states.contains(WidgetState.disabled)) {
          return AppColors.unselectedGrey;
        } else {
          return AppColors.white;
        }
      },
    ),
  );
}

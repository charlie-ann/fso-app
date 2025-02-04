import 'package:flutter/material.dart';
import 'package:fso_support/core/config/color/app_colors.dart';

class AppSwitchTheme {
  const AppSwitchTheme._();

  static SwitchThemeData lightToggleButtonTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.dividerGrey;
        } else {
          return AppColors.white;
        }
      },
    ),
    trackColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        } else {
          return AppColors.unselectedGrey;
        }
      },
    ),
    thumbIcon: WidgetStateProperty.resolveWith(
      (states) => const Icon(
        Icons.circle,
        color: Colors.white,
      ),
    ),
    trackOutlineColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        } else {
          return AppColors.unselectedGrey;
        }
      },
    ),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  );
}

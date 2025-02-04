import 'package:flutter/material.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/config/themes/app_bar_theme.dart';
import 'package:fso_support/core/config/themes/button_theme.dart';
import 'package:fso_support/core/config/themes/check_box_theme.dart';
import 'package:fso_support/core/config/themes/dropdown_theme.dart';
import 'package:fso_support/core/config/themes/switch.dart';
import 'package:fso_support/core/config/themes/text_theme.dart';
import 'package:fso_support/core/config/themes/textformfield_theme.dart';

/// Default [ThemeData] for CropXchange
class FAppTheme {
  /// Default constructor for CropXchange [ThemeData]
  FAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    textTheme: FTextTheme.lightTextTheme,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    buttonTheme: FButtonTheme.lightButtonThemeData,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: AppOutlinedButtonTheme.lightOutlinedButtonTheme,
    appBarTheme: FAppBarTheme.lightAppBarTheme,
    checkboxTheme: CheckBoxTheme.lightCheckBoxTheme,
    switchTheme: AppSwitchTheme.lightToggleButtonTheme,
    inputDecorationTheme: TextFormFieldTheme.lightInputDecorationTheme,
    dropdownMenuTheme: DropDownTheme.dropdownMenuThemeData,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    textTheme: FTextTheme.darkTextTheme,
    scaffoldBackgroundColor: AppColors.darkScaffoldBg,
    buttonTheme: FButtonTheme.lightButtonThemeData,
    elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: AppOutlinedButtonTheme.lightOutlinedButtonTheme,
    appBarTheme: FAppBarTheme.darkAppBarTheme,
    checkboxTheme: CheckBoxTheme.lightCheckBoxTheme,
    switchTheme: AppSwitchTheme.lightToggleButtonTheme,
    inputDecorationTheme: TextFormFieldTheme.darkInputDecorationTheme,
    dropdownMenuTheme: DropDownTheme.dropdownMenuThemeData,
  );

  // ColorScheme get _colorScheme => ColorScheme.fromSeed(
  //     seedColor: AppColors.primary,
  //     primary: AppColors.primary,
  //     background: AppColors.white);
}

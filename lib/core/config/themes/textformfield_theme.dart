import 'package:flutter/material.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/config/themes/text_theme.dart';
import 'package:fso_support/core/size_config/extensions.dart';

class TextFormFieldTheme {
  const TextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: AppColors.borderGrey,
        width: .4,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: AppColors.primary.withOpacity(.4),
        width: .4,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: AppColors.borderGrey,
        width: .4,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: AppColors.borderGrey,
        width: .4,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: AppColors.errorRed,
        width: .4,
      ),
    ),
    filled: true,
    fillColor: AppColors.white,
    focusColor: AppColors.borderGrey,
    hintStyle: FTextTheme.lightTextTheme.bodyMedium?.copyWith(
      color: AppColors.black.withOpacity(.3),
      fontSize: 12.text,
    ),
    errorStyle: FTextTheme.lightTextTheme.bodySmall?.copyWith(
      color: AppColors.errorRed,
      fontSize: 12.text,
      height: 1,
    ),
    // isDense: true,
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: AppColors.borderGrey,
        width: .4,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: AppColors.primary,
        width: .4,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: AppColors.borderGrey,
        width: .4,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: AppColors.borderGrey,
        width: .4,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(
        color: AppColors.errorRed,
        width: .4,
      ),
    ),
    filled: true,
    fillColor: AppColors.mainContainerBg,
    focusColor: AppColors.borderGrey,
    hintStyle: FTextTheme.lightTextTheme.bodyMedium?.copyWith(
      color: AppColors.bodyTextGrey,
      fontSize: 14.text,
    ),
    errorStyle: FTextTheme.lightTextTheme.bodySmall?.copyWith(
      color: AppColors.errorRed,
      fontSize: 12.text,
      height: 1,
    ),
    // isDense: true,
  );
}

import 'package:flutter/material.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:google_fonts/google_fonts.dart';

class FTextTheme {
  FTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    titleLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 23.text,
      color: AppColors.black,
      height: 1.2,
    ),
    titleMedium: GoogleFonts.inter(
      fontWeight: FontWeight.w700,
      fontSize: 17.text,
      color: AppColors.black,
      height: 1.3,
    ),
    bodyLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 16.text,
      color: AppColors.black,
      height: 1.3,
    ),
    bodyMedium: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      fontSize: 14.text,
      color: AppColors.black,
      height: 1.3,
    ),
    bodySmall: GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      fontSize: 12.text,
      color: AppColors.black,
      height: 1.3,
    ),
    labelLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 19.text,
      color: AppColors.white,
      height: 1.3,
    ),
    displayLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w800,
      fontSize: 17.text,
      color: AppColors.primary,
      height: 1.3,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    titleLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 23.text,
      color: AppColors.white,
      height: 1.2,
    ),
    titleMedium: GoogleFonts.inter(
      fontWeight: FontWeight.w700,
      fontSize: 17.text,
      color: AppColors.white,
      height: 1.3,
    ),
    bodyLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 16.text,
      color: AppColors.white,
      height: 1.3,
    ),
    bodyMedium: GoogleFonts.inter(
      fontWeight: FontWeight.w500,
      fontSize: 14.text,
      color: AppColors.white,
      height: 1.3,
    ),
    bodySmall: GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      fontSize: 12.text,
      color: AppColors.white,
      height: 1.3,
    ),
    labelLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w600,
      fontSize: 19.text,
      color: AppColors.white,
      height: 1.3,
    ),
    displayLarge: GoogleFonts.inter(
      fontWeight: FontWeight.w800,
      fontSize: 17.text,
      color: AppColors.primary,
      height: 1.3,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AppUtil {
  static showSnackBar(BuildContext context,
      {required String text, bool error = false}) {
    return showTopSnackBar(
      Overlay.of(context),
      Container(
        decoration: BoxDecoration(
            color: error ? const Color(0xffFFE9E7) : const Color(0xffE5FBF3),
            border: Border.all(
              color: error ? AppColors.errorRed : AppColors.successGreen,
            ),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(10),
        child: Material(
          color: error ? const Color(0xffFFE9E7) : const Color(0xffE5FBF3),
          child: Text(
            text,
            style: context.textTheme.bodySmall
                ?.copyWith(fontSize: 12.text, color: AppColors.black),
          ),
        ),
      ),
    );
  }
}

Color checkStatusColor(String status) {
  switch (status) {
    case "Pending":
      return AppColors.pending;
    case "Completed":
      return AppColors.successGreen;
    case "Unresolved":
      return AppColors.errorRed;
    default:
      return AppColors.pending;
  }
}

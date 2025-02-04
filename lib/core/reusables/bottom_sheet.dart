import 'package:flutter/material.dart';
import 'package:fso_support/core/config/color/app_colors.dart';

customBottomSheet({
  required BuildContext context,
  required Widget child,
}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    barrierColor: Colors.black.withOpacity(.25),
    isDismissible: false,
    enableDrag: false,
    context: context,
    useRootNavigator: true,
    builder: (context) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: bottomSheetPadding(context),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: child,
        ),
      );
    },
  );
}

bottomSheetPadding(BuildContext context) {
  return EdgeInsets.only(
    bottom: MediaQuery.of(context).viewInsets.bottom,
    left: 16,
    right: 16,
    top: 10,
  );
}

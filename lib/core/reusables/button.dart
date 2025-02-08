import 'package:flutter/material.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/size_config/extensions.dart';

class AppFilledButton extends StatelessWidget {
  const AppFilledButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.height = 48,
    this.width = double.maxFinite,
    this.icon,
    this.isEnabled = true,
    this.fillColor,
    this.textColor,
    this.isIconPrefix = true,
    this.isLoading = false,
    this.fontSize = 14,
  });
  final void Function()? onPressed;
  final String text;
  final double height;
  final double width;
  final Widget? icon;
  final bool isEnabled;
  final Color? fillColor;
  final Color? textColor;
  final bool isIconPrefix;
  final bool isLoading;
  final int fontSize;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height),
        backgroundColor: fillColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading) ...[
            const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                color: AppColors.white,
              ),
            ),
          ] else ...[
            if (icon != null && isIconPrefix) ...[
              icon!,
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize.text,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (icon != null && !isIconPrefix) ...[
              const SizedBox(width: 10),
              icon!,
            ],
          ],
        ],
      ),
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.height = 48,
    this.width = double.infinity,
    this.icon,
    this.isEnabled = true,
    this.color = AppColors.primary,
    this.isIconPrefix = true,
  });
  final void Function()? onPressed;
  final String text;
  final double height;
  final double width;
  final Widget? icon;
  final bool isEnabled;
  final Color color;
  final bool isIconPrefix;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isEnabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(width, height),
        backgroundColor: isEnabled ? Colors.transparent : AppColors.borderGrey,
        side: BorderSide(
          color: isEnabled ? color : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null && isIconPrefix) ...[
            icon!,
            const SizedBox(width: 10),
          ],
          Text(
            text,
            style: TextStyle(
              color: isEnabled ? color : AppColors.bodyTextGrey,
              fontSize: 16.text,
            ),
          ),
          if (icon != null && !isIconPrefix) ...[
            const SizedBox(width: 10),
            icon!,
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';

class AppInputField extends StatelessWidget {
  const AppInputField({
    super.key,
    this.controller,
    this.initialValue,
    this.obscureText = false,
    this.textStyle,
    this.textInputType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.validator,
    this.hintText = "",
    this.textInputAction = TextInputAction.done,
    this.prefixText,
    this.maxlines = 1,
    this.onChanged,
    this.contentPadding,
    this.inputFormatters,
    this.readOnly = false,
    this.letterSpacing,
    this.enabled = true,
    this.label,
  });
  final TextEditingController? controller;
  final String? initialValue;
  final bool obscureText;
  final TextStyle? textStyle;
  final TextInputType textInputType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final String? hintText;
  final TextInputAction textInputAction;
  final String? prefixText;
  final int maxlines;
  final Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final double? letterSpacing;
  final bool enabled;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 12.text,
              color: AppColors.bodyTextGrey,
            ),
          ),
          const SizedBox(height: 4),
        ],
        TextFormField(
          readOnly: readOnly,
          validator: validator,
          controller: controller,
          initialValue: initialValue,
          focusNode: focusNode,
          keyboardType: textInputType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          maxLines: maxlines,
          textAlignVertical: TextAlignVertical.center,
          onChanged: onChanged,
          enabled: enabled,
          inputFormatters: inputFormatters,
          style: textStyle ?? context.textTheme.bodySmall?.copyWith(),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            contentPadding: contentPadding,
            prefixText: prefixText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintText: hintText,
            enabled: enabled,
          ),
        ),
      ],
    );
  }
}

GestureDetector buildInputIcon(
    {required String icon, void Function()? onTap, Color? iconColor}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          icon,
          height: 24,
          width: 24,
          color: iconColor,
        ),
      ],
    ),
  );
}

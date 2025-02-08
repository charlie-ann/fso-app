// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';

class AppDropDown extends StatelessWidget {
  String? label;
  bool isExpanded;
  List<String?> data;
  String hintText;
  String? selectedValue;
  void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  bool isDisabled;

  AppDropDown({
    Key? key,
    this.label,
    this.isExpanded = true,
    this.data = const [],
    this.hintText = "",
    this.selectedValue,
    this.validator,
    this.onChanged,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(
              label!,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 12.text,
                color: AppColors.bodyTextGrey,
              ),
            ),
          ),
        AbsorbPointer(
          absorbing: isDisabled,
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                  buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown: true,
              )),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  validator: validator,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(1, 12, 12, 12),
                    isDense: true,
                  ),
                  elevation: 1,
                  isExpanded: isExpanded,
                  hint: Text(
                    hintText,
                    style: context.textTheme.bodySmall?.copyWith(),
                    textAlign: TextAlign.left,
                  ),
                  iconEnabledColor: AppColors.bodyTextGrey,
                  iconDisabledColor: AppColors.bodyTextGrey,
                  dropdownColor: Colors.white,
                  icon: const SizedBox(
                    height: 24,
                    width: 24,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 24,
                      color: AppColors.bodyTextGrey,
                    ),
                  ),
                  iconSize: 24,
                  value: selectedValue,
                  onChanged: onChanged,
                  items: data.map((value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value ?? "",
                          style: context.textTheme.bodySmall
                              ?.copyWith(letterSpacing: 0.2, height: 20 / 14),
                          textAlign: TextAlign.left,
                        ));
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

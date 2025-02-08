import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';

class PhoneFieldIcon extends StatelessWidget {
  const PhoneFieldIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, WidgetRef ref, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 12),
            SizedBox(
              height: 20,
              width: 20,
              // child: Image.asset(ImageStrings.nigIcon),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 5.width,
                vertical: 12.height,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                      right: BorderSide(
                    color: AppColors.dividerGrey,
                    width: 1,
                  )),
                ),
                child: Center(
                  child: Text(
                    "+234 ",
                    style: context.textTheme.bodySmall?.copyWith(
                      fontSize: 14.text,
                      height: 1,
                      color: context.isDarkMode(ref)
                          ? Colors.white
                          : AppColors.bodyTextGrey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

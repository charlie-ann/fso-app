import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/constants/image_strings.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:go_router/go_router.dart';

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function? onPressed;

  final Color? backgroundColor;

  final Widget? leading;

  const CAppBar(
      {super.key, this.onPressed, this.backgroundColor, this.leading});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor ?? AppColors.white,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: backgroundColor ?? AppColors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      centerTitle: true,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(),
      ),
      leading: leading ??
          GestureDetector(
            onTap: () {
              if (onPressed != null) {
                onPressed!();
              } else {
                FocusScope.of(context).unfocus();
                Navigator.maybePop(context, true);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.dividerGrey,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.keyboard_backspace_rounded,
                      color: backgroundColor == null
                          ? AppColors.black
                          : AppColors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class AppBackButton extends StatelessWidget {
  final Function()? onTap;
  const AppBackButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => context.pop(),
      child: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              ImageStrings.backIcon,
              height: 14,
            ),
            const SizedBox(width: 7),
            Text(
              "Back",
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontSize: 14.text,
              ),
            )
          ],
        ),
      ),
    );
  }
}

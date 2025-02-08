import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/constants/image_strings.dart';
import 'package:fso_support/core/reusables/progess_indicator.dart';
import 'package:fso_support/core/utils/extensions.dart';

class LoaderView extends StatefulWidget {
  final bool loading;
  final Widget? child;
  final Color? backgroundColor;
  final bool isOverlay;
  const LoaderView({
    super.key,
    required this.loading,
    required this.child,
    this.backgroundColor,
    this.isOverlay = true,
  });

  @override
  State<LoaderView> createState() => _ELoaderViewState();
}

class _ELoaderViewState extends State<LoaderView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.addListener(() => setState(() {}));
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child == null
        ? getLoader()
        : Material(
            // backgroundColor: Colors.transparent,
            color: widget.backgroundColor ??
                Theme.of(context).scaffoldBackgroundColor,
            child: AbsorbPointer(
              absorbing: widget.loading,
              child: getView(context),
            ),
          );
  }

  Widget getView(BuildContext context) {
    return Stack(
      children: [
        widget.child!,
        if (widget.loading)
          Stack(
            children: [
              Consumer(
                builder: (_, WidgetRef ref, __) {
                  return Container(
                    color: widget.isOverlay
                        ? Colors.black.withOpacity(0.75)
                        : context.isDarkMode(ref)
                            ? AppColors.darkScaffoldBg
                            : AppColors.backgroundColor,
                  );
                },
              ),
              Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        height: 100,
                        width: 100,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.cardGrey,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 0,
                        height: 40,
                        width: 100,
                        child: Image.asset(ImageStrings.logo),
                      ),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0)
                              .animate(_animationController),
                          child: const GradientCircularProgressIndicator(
                            radius: 50,
                            gradientColors: [
                              AppColors.primary,
                              AppColors.pink,
                            ],
                            strokeWidth: 6.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }

  getLoader() {
    return SizedBox(
      height: 28,
      width: 28,
      child: RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
        child: const GradientCircularProgressIndicator(
          radius: 14,
          gradientColors: [
            AppColors.primary,
            AppColors.pink,
          ],
          strokeWidth: 6.0,
        ),
      ),
    );
  }
}

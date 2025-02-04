import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/constants/image_strings.dart';
import 'package:fso_support/core/reusables/app_util.dart';
import 'package:fso_support/core/reusables/button.dart';
import 'package:fso_support/core/reusables/loader_view.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:fso_support/features/auth/presentation/change_password.dart';
import 'package:fso_support/features/auth/presentation/login.dart';
import 'package:fso_support/features/auth/providers/auth_providers.dart';
import 'package:fso_support/features/auth/state/auth_state.dart';
import 'package:fso_support/features/log_support/providers/log_support_prov.dart';
import 'package:fso_support/features/log_support/state/log_support_state.dart';
import 'package:fso_support/features/terminals/models/terminal_model.dart';
import 'package:fso_support/features/terminals/presentation/active_terminals.dart';
import 'package:fso_support/features/terminals/presentation/inactive_terminals.dart';
import 'package:fso_support/features/log_support/presentation/log_support.dart';
import 'package:fso_support/features/history/presentation/history_page.dart';
import 'package:fso_support/features/support_request/presentation/support_request_page.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends ConsumerStatefulWidget {
  static const String routeName = 'dashboard-page';
  const DashboardPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  bool isLocation = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(currentUser);
      if (user?.passwordChanged == false) {
        handlePasswordDialog();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderView(
      loading: ref.watch(authLoadingProvider),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 60.relHeight),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Welcome, ${ref.watch(currentUser)?.name}",
                    style: context.textTheme.bodyMedium
                        ?.copyWith(fontSize: 14.text, color: AppColors.black),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      log("message");
                      await getCurrentLocation(ref);
                      final currentLoc = ref.watch(currentLocation);
                      final err = ref.watch(authErrorProvider);
                      if (currentLoc != null) {
                        await clockIn(
                          ref: ref,
                          lat: currentLoc.latitude.toString(),
                          lng: currentLoc.longitude.toString(),
                        );
                        final err = ref.watch(authErrorProvider);
                        if (err == null) {
                          AppUtil.showSnackBar(context,
                              text: "You have clocked in successfully",
                              error: false);
                        }
                      } else if (err != null) {
                        AppUtil.showSnackBar(context, text: err, error: true);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Clock In",
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.text,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  )
                  // AppSwitch(
                  //   enabled: isLocation,
                  //   onChanged: (val) {
                  //     setState(() {
                  //       isLocation = val;
                  //     });
                  //   },
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     fetchInactiveTerminals(ref: ref);
                  //   },
                  //   child: Image.asset(
                  //     ImageStrings.locationIcon,
                  //     height: 15,
                  //   ),
                  // ),
                ],
              ),
              40.vSpacer,
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                mainAxisSpacing: 25,
                crossAxisSpacing: 20,
                children: [
                  buildCard(
                    img: ImageStrings.supportRequest,
                    title: "Support Request",
                    subTitle:
                        "View and manage all incoming\nsupport requests here",
                    onTap: () =>
                        context.pushNamed(SupportRequestPage.routeName),
                  ),
                  // buildCard(
                  //   img: ImageStrings.roadMap,
                  //   title: "Road Map",
                  //   subTitle: "View and manage all assigned\nroad map here",
                  //   onTap: () => context.pushNamed(RoadMapPage.routeName),
                  // ),
                  // buildCard(
                  //   img: ImageStrings.qrcode,
                  //   title: "Log Support with\nQR",
                  //   subTitle: "Scan QR to log support",
                  //   onTap: () => context.pushNamed(ScanQrCodePage.routeName),
                  //   isQr: true,
                  // ),
                  // buildCard(
                  //   img: ImageStrings.logSupport,
                  //   title: "Log Support",
                  //   subTitle: "Log new support",
                  //   onTap: () => context.pushNamed(LogSupportPage.routeName),
                  // ),
                  buildCard(
                    img: ImageStrings.logSupport,
                    title: "Create Task",
                    subTitle: "Create new support task",
                    onTap: () => context.pushNamed(LogSupportPage.routeName,
                        extra: TerminalParams(isCreateTask: true)),
                  ),

                  buildCard(
                    img: ImageStrings.inactiveTerminal,
                    title: "Inactive Terminals",
                    subTitle:
                        "View Terminals that are\ncurrently inactive or offline",
                    onTap: () =>
                        context.pushNamed(InactiveTerminalPage.routeName),
                  ),
                  buildCard(
                    img: ImageStrings.pos,
                    title: "Active Terminals",
                    subTitle: "View Terminals that are\ncurrently active",
                    onTap: () =>
                        context.pushNamed(ActiveTerminalPage.routeName),
                  ),
                  buildCard(
                    img: ImageStrings.supportHistory,
                    title: "Support History",
                    subTitle:
                        "Review the history of all\nlogged support requests",
                    onTap: () =>
                        context.pushNamed(SupportHistoryPage.routeName),
                  ),
                ],
              ),
              60.vSpacer,
              AppFilledButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                      contentPadding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      content: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              10.vSpacer,
                              Text(
                                "Are you sure you want to Logout?",
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontSize: 17.text,
                                  color: AppColors.blackText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              44.vSpacer,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buildButton(
                                    context,
                                    text: "Yes",
                                    color: AppColors.successGreen,
                                    onTap: () async {
                                      await logout(ref: ref);
                                      context.go("/${LoginPage.routeName}");
                                    },
                                  ),
                                  const SizedBox(width: 17),
                                  buildButton(
                                    context,
                                    text: "No",
                                    color: AppColors.errorRed,
                                    onTap: () => context.pop(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                text: "Logout",
                fillColor: AppColors.errorRed2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildCard({
    required String img,
    required String title,
    required String subTitle,
    void Function()? onTap,
    bool isQr = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.white,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 17,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    img,
                    height: 36,
                    color: isQr ? AppColors.black : null,
                  ),
                  10.vSpacer,
                  Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontSize: 13.text,
                      color: AppColors.blackText,
                    ),
                    maxLines: 2,
                  ),
                  10.vSpacer,
                  Text(
                    subTitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      fontSize: 9.text,
                      color: AppColors.black.withOpacity(.6),
                      fontFamily: GoogleFonts.roboto().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  handlePasswordDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        contentPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                10.vSpacer,
                Text(
                  "Change Password",
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 17.text,
                    color: AppColors.blackText,
                  ),
                  textAlign: TextAlign.center,
                ),
                10.vSpacer,
                Text(
                  "Kindly change your default password to a more personalized one that you can remember.",
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.blackText,
                  ),
                ),
                44.vSpacer,
                AppFilledButton(
                  onPressed: () {
                    context.pushNamed(ChangePasswordPage.routeName);
                  },
                  text: "Change Password",
                ),
                10.vSpacer,
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Text(
                    "I will do it later",
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.blackText,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildButton(
    BuildContext context, {
    Function()? onTap,
    required Color color,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: context.textTheme.labelLarge?.copyWith(
              color: AppColors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

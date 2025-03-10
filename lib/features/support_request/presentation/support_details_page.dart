import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/reusables/appbar.dart';
import 'package:fso_support/core/reusables/button.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:fso_support/features/log_support/presentation/log_support.dart';
import 'package:fso_support/features/log_support/presentation/qr_scanner.dart';
import 'package:fso_support/features/support_request/models/support_request.dart';
import 'package:fso_support/features/support_request/presentation/photo_view.dart';
import 'package:fso_support/features/support_request/presentation/widgets/reject_task_sheet.dart';
import 'package:fso_support/features/terminals/models/terminal_model.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportDetailsPage extends StatelessWidget {
  static const String routeName = 'support-details-page';
  const SupportDetailsPage({super.key, required this.supportRequestModel});
  final SupportRequestModel? supportRequestModel;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, WidgetRef ref, __) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            leadingWidth: 100,
            leading: const AppBackButton(),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 36),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.black.withOpacity(.05)),
                  ),
                  child: Column(
                    children: [
                      buildRow(
                        context,
                        title: "Merchant Name",
                        value:
                            supportRequestModel?.terminal?.merchantName ?? "",
                      ),
                      20.vSpacer,
                      buildRow(
                        context,
                        title: "T.I.D",
                        value: supportRequestModel?.terminal?.terminalId ?? "",
                      ),
                      20.vSpacer,
                      buildRow(
                        context,
                        title: "Address",
                        value: supportRequestModel?.terminal?.address ?? "",
                      ),
                      20.vSpacer,
                      if (supportRequestModel?.phoneNumber != null) ...[
                        buildRow(
                          context,
                          title: "Phone Number",
                          value: "",
                          extra: InkWell(
                            onTap: () async {
                              Uri phoneno = Uri.parse(
                                  "tel:${supportRequestModel?.phoneNumber}");
                              if (await launchUrl(phoneno)) {
                                //dialer opened
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  supportRequestModel?.phoneNumber ?? "",
                                  style: context.textTheme.labelLarge?.copyWith(
                                    color: AppColors.blackText,
                                    fontSize: 12.text,
                                  ),
                                ),
                                10.hSpacer,
                                const Icon(
                                  Icons.phone,
                                  color: AppColors.primary,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                        20.vSpacer,
                      ],
                      buildRow(
                        context,
                        title: "Request Type",
                        value: supportRequestModel?.supportType ?? "",
                      ),
                      20.vSpacer,
                      buildRow(
                        context,
                        title: "Request Issue",
                        value: supportRequestModel?.supportIssue ?? "",
                      ),
                      if (supportRequestModel?.attachment != null) ...[
                        20.vSpacer,
                        buildRow(
                          context,
                          title: "Document",
                          value: supportRequestModel?.attachment?.url ?? "",
                          isDocument: true,
                        ),
                      ],
                      20.vSpacer,
                      buildRow(
                        context,
                        title: "Date & Time",
                        value: DateFormat("dd/MM/yyyy, hh.mma")
                            .format(supportRequestModel?.createdAt ??
                                DateTime.now())
                            .toLowerCase(),
                      ),
                    ],
                  ),
                ),
                40.vSpacer,
                Row(
                  children: [
                    Expanded(
                      child: AppFilledButton(
                        onPressed: () {
                          handleDialog(
                            context,
                            isQr: true,
                            tid: supportRequestModel?.terminal?.terminalId,
                            taskId: supportRequestModel?.id,
                            supportReqType: supportRequestModel?.supportType,
                          );
                        },
                        text: "Log with Qr",
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: AppFilledButton(
                        onPressed: () {
                          handleDialog(
                            context,
                            isQr: false,
                            tid: supportRequestModel?.terminal?.terminalId,
                            taskId: supportRequestModel?.id,
                            supportReqType: supportRequestModel?.supportType,
                          );
                        },
                        text: "Log Manually",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      barrierColor: AppColors.black.withOpacity(.5),
                      isDismissible: false,
                      enableDrag: false,
                      context: context,
                      // constraints: BoxConstraints(maxHeight: height),
                      useRootNavigator: true,
                      builder: (context) {
                        return RejectTaskSheet(
                          taskId: supportRequestModel?.id.toString() ?? "",
                        );
                      },
                    );
                  },
                  child: Text(
                    "Reject Task",
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 16.text,
                      color: AppColors.errorRed,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.errorRed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<dynamic> handleDialog(BuildContext context, bool isQr) {
  //   return showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       insetPadding: const EdgeInsets.symmetric(horizontal: 20),
  //       contentPadding: EdgeInsets.zero,
  //       backgroundColor: Colors.transparent,
  //       content: ClipRRect(
  //         borderRadius: BorderRadius.circular(20),
  //         child: Container(
  //           color: Colors.white,
  //           padding: const EdgeInsets.all(24),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               10.vSpacer,
  //               Text(
  //                 "Are you sure you want to Log Support?",
  //                 style: context.textTheme.bodyMedium?.copyWith(
  //                   fontSize: 17.text,
  //                   color: AppColors.blackText,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //               44.vSpacer,
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   buildDialogButton(
  //                     context,
  //                     text: "Yes",
  //                     color: AppColors.successGreen,
  //                     onTap: () {
  //                       context.pop();
  //                       if (isQr) {
  //                         context.pushNamed(ScanQrCodePage.routeName);
  //                       } else {
  //                         context.pushNamed(
  //                           LogSupportPage.routeName,
  //                           extra: TerminalParams(
  //                             terminalModel: null,
  //                             taskId: supportRequestModel?.id,
  //                             tid: supportRequestModel?.terminal?.terminalId,
  //                           ),
  //                         );
  //                       }
  //                     },
  //                   ),
  //                   const SizedBox(width: 17),
  //                   buildDialogButton(
  //                     context,
  //                     text: "No",
  //                     color: AppColors.errorRed,
  //                     onTap: () => context.pop(),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 20),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Row buildRow(
    BuildContext context, {
    required String title,
    required String value,
    bool isDocument = false,
    Widget? extra,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "$title: ",
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.blackText,
              fontSize: 12.text,
            ),
          ),
        ),
        if (extra == null)
          Expanded(
            flex: 3,
            child: isDocument
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => context.pushNamed(PhotoViewPage.routeName,
                          extra: value),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primary.withOpacity(.08),
                        ),
                        child: Text(
                          "Click to view document",
                          style: context.textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  )
                : Text(
                    value,
                    style: context.textTheme.labelLarge?.copyWith(
                      color: AppColors.blackText,
                      fontSize: 12.text,
                    ),
                  ),
          ),
        if (extra != null) Expanded(flex: 3, child: extra),
      ],
    );
  }
}

buildDialogButton(
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

Future<dynamic> handleDialog(
  BuildContext context, {
  required bool isQr,
  required String? tid,
  required int? taskId,
  String? supportReqType,
}) {
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
                "Are you sure you want to Log Support?",
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
                  buildDialogButton(
                    context,
                    text: "Yes",
                    color: AppColors.successGreen,
                    onTap: () {
                      context.pop();
                      if (isQr) {
                        context.pushNamed(ScanQrCodePage.routeName,
                            extra: QrRouteParams(
                              taskId: taskId,
                              supportReqType: supportReqType,
                            ));
                      } else {
                        context.pushNamed(
                          LogSupportPage.routeName,
                          extra: TerminalParams(
                            terminalModel: null,
                            taskId: taskId,
                            tid: tid,
                            supportReqType: supportReqType,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(width: 17),
                  buildDialogButton(
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
}

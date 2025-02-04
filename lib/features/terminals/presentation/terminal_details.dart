import 'package:flutter/material.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/reusables/appbar.dart';
import 'package:fso_support/core/reusables/button.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:fso_support/features/support_request/presentation/support_details_page.dart';
import 'package:fso_support/features/terminals/models/terminal_model.dart';
import 'package:intl/intl.dart';

class TerminalDetailsPage extends StatelessWidget {
  static const String routeName = 'terminal-details-page';
  const TerminalDetailsPage({super.key, required this.terminal});
  final TerminalDetailRoute terminal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leadingWidth: 100,
        leading: const AppBackButton(),
        title: Text(
          "${terminal.status} Terminals",
          style: context.textTheme.titleMedium?.copyWith(fontSize: 16.text),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 36),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.black.withOpacity(.05)),
              ),
              child: Column(
                children: [
                  buildRow(
                    context,
                    title: "Merchant Name",
                    value: terminal.terminalModel?.merchantName ?? "",
                  ),
                  20.vSpacer,
                  buildRow(
                    context,
                    title: "T.I.D",
                    value: terminal.terminalModel?.terminalId ?? "",
                  ),
                  // 20.vSpacer,
                  // buildRow(
                  //   context,
                  //   title: "Phone Number",
                  //   value: terminal.terminalModel.,
                  // ),
                  20.vSpacer,
                  buildRow(
                    context,
                    title: "Serial Number",
                    value: terminal.terminalModel?.serialNumber ?? "",
                  ),
                  20.vSpacer,
                  buildRow(
                    context,
                    title: "Bank Name",
                    value: terminal.terminalModel?.bank ?? "",
                  ),
                  20.vSpacer,
                  InkWell(
                    onTap: () {
                      // launchMapOnAndroid(
                      //   latitude: 9.083333,
                      //   longitude: 7.536111,
                      //   markerName: "Aso Rock",
                      //   context: context,
                      // );
                    },
                    child: buildRow(
                      context,
                      title: "Address",
                      value: terminal.terminalModel?.address ?? "",
                    ),
                  ),
                  20.vSpacer,
                  buildRow(
                    context,
                    title: "Last date of activity",
                    value: DateFormat("dd/MM/yyyy, hh.mma")
                        .format(
                            terminal.terminalModel?.createdAt ?? DateTime.now())
                        .toLowerCase(),
                  ),
                  if (terminal.terminalModel?.chargingStatus != null) ...[
                    20.vSpacer,
                    buildRow(
                      context,
                      title: "Charging Status",
                      value: terminal.terminalModel?.chargingStatus ?? "",
                    ),
                  ],
                  if (terminal.terminalModel?.lastConnection != null) ...[
                    20.vSpacer,
                    buildRow(
                      context,
                      title: "Last Connection",
                      value: DateFormat("dd/MM/yyyy, hh.mma")
                          .format(terminal.terminalModel?.createdAt ??
                              DateTime.now())
                          .toLowerCase(),
                    ),
                  ],
                  if (terminal.terminalModel?.terminalType != null) ...[
                    20.vSpacer,
                    buildRow(
                      context,
                      title: "Terminal Type",
                      value: terminal.terminalModel?.terminalType ?? "",
                    ),
                  ],
                  if (terminal.terminalModel?.batteryLevel != null) ...[
                    20.vSpacer,
                    buildRow(
                      context,
                      title: "Battery Level",
                      value: "${terminal.terminalModel?.batteryLevel}%",
                    ),
                  ],
                  if (terminal.terminalModel?.signalLevel != null) ...[
                    20.vSpacer,
                    buildRow(
                      context,
                      title: "Signal Level",
                      value: "${terminal.terminalModel?.signalLevel}%",
                    ),
                  ],
                  if (terminal.terminalModel?.printerStatus != null) ...[
                    20.vSpacer,
                    buildRow(
                      context,
                      title: "Printer Status",
                      value: terminal.terminalModel?.printerStatus ?? "",
                    ),
                  ],
                ],
              ),
            ),
            40.vSpacer,
            AppFilledButton(
              onPressed: () {
                handleDialog(
                  context,
                  isQr: false,
                  tid: terminal.terminalModel?.terminalId,
                  taskId: terminal.terminalModel?.id,
                );
              },
              text: "Log Support",
            ),
          ],
        ),
      ),
    );
  }

  Row buildRow(
    BuildContext context, {
    required String title,
    required String value,
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
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: context.textTheme.labelLarge?.copyWith(
              color: AppColors.blackText,
              fontSize: 12.text,
            ),
          ),
        ),
      ],
    );
  }
}

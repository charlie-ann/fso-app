import 'package:flutter/material.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/constants/image_strings.dart';
import 'package:fso_support/core/reusables/app_util.dart';
import 'package:fso_support/core/reusables/appbar.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:fso_support/features/history/models/history_model.dart';
import 'package:intl/intl.dart';

class SupportHistoryDetailsPage extends StatefulWidget {
  static const String routeName = 'support-history-details-page';
  const SupportHistoryDetailsPage({super.key, required this.history});
  final HistoryModel history;

  @override
  State<SupportHistoryDetailsPage> createState() =>
      _SupportHistoryDetailsPageState();
}

class _SupportHistoryDetailsPageState extends State<SupportHistoryDetailsPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leadingWidth: 100,
        leading: AppBackButton(
          onTap: index == 1
              ? () => setState(() {
                    index = 0;
                  })
              : null,
        ),
      ),
      body: IndexedStack(
        index: index,
        children: [
          buildPage0(),
          buildPage1(),
        ],
      ),
    );
  }

  buildPage0() {
    return SingleChildScrollView(
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
                  value: widget.history.name ?? "",
                ),
                20.vSpacer,
                buildRow(
                  context,
                  title: "T.I.D",
                  value: widget.history.terminalId ?? "",
                ),
                20.vSpacer,
                buildRow(
                  context,
                  title: "Address",
                  value: widget.history.address ?? "",
                ),
                20.vSpacer,
                buildRow(
                  context,
                  title: "Support Issue",
                  value: widget.history.purpose ?? "",
                  isIssue: true,
                ),
                20.vSpacer,
                buildRow(
                  context,
                  title: "Status",
                  value: widget.history.status ?? "",
                  textColor: checkStatusColor(widget.history.status ?? ""),
                ),
                20.vSpacer,
                buildRow(
                  context,
                  title: "Date & Time",
                  value: DateFormat("dd/MM/yyyy, hh.mma")
                      .format(widget.history.createdAt ?? DateTime.now())
                      .toLowerCase(),
                ),
              ],
            ),
          ),
          40.vSpacer,
        ],
      ),
    );
  }

  buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.black.withOpacity(.05)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: checkStatusColor(widget.history.status ?? "")
                        .withOpacity(.14),
                  ),
                  child: Center(
                    child: Text(
                      widget.history.status ?? "",
                      style: context.textTheme.labelLarge?.copyWith(
                        color: checkStatusColor(widget.history.status ?? ""),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                25.vSpacer,
                Text(
                  "Support Issue",
                  style: context.textTheme.labelLarge?.copyWith(
                    color: AppColors.blackText,
                    fontSize: 12.text,
                  ),
                ),
                19.vSpacer,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    widget.history.purpose ?? "",
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.black,
                      fontSize: 12.text,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                60.vSpacer,
              ],
            ),
          ),
          40.vSpacer,
        ],
      ),
    );
  }

  Row buildRow(
    BuildContext context, {
    required String title,
    required String value,
    bool isIssue = false,
    Color? textColor,
  }) {
    return Row(
      crossAxisAlignment:
          isIssue ? CrossAxisAlignment.center : CrossAxisAlignment.start,
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
          child: isIssue
              ? FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      index = 1;
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primary.withOpacity(.08),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Click to view issue",
                            style: context.textTheme.bodyMedium?.copyWith(
                              fontSize: 10,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Image.asset(
                            ImageStrings.eyeGreen,
                            height: 7,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Text(
                  value,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: textColor ?? AppColors.blackText,
                    fontSize: 12.text,
                  ),
                ),
        ),
      ],
    );
  }
}

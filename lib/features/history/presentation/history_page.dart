import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/reusables/app_util.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:fso_support/features/history/presentation/history_detail.dart';
import 'package:fso_support/features/history/providers/history_prov.dart';
import 'package:fso_support/features/history/state/history_state.dart';
import 'package:go_router/go_router.dart';

class SupportHistoryPage extends ConsumerStatefulWidget {
  static const String routeName = 'support-history-page';
  const SupportHistoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SupportHistoryPageState();
}

class _SupportHistoryPageState extends ConsumerState<SupportHistoryPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHistory(ref: ref);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final historyList = ref.watch(historyListProv);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Support History",
          style: context.textTheme.titleMedium?.copyWith(fontSize: 16.text),
        ),
      ),
      body: historyList.isEmpty
          ? const Center(child: Text("No History"))
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              itemBuilder: (context, index) {
                final history = historyList[index];
                return GestureDetector(
                  onTap: () => context.pushNamed(
                      SupportHistoryDetailsPage.routeName,
                      extra: history),
                  child: Container(
                    height: 90,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(
                          color: AppColors.borderGrey.withOpacity(0.12)),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          left: 10,
                          height: 70,
                          width: MediaQuery.of(context).size.width - 60,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          text: "Merchant: ",
                                          style: context.textTheme.bodySmall
                                              ?.copyWith(
                                            color: AppColors.blackText,
                                            fontSize: 14,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: history.name ?? "",
                                              style: context
                                                  .textTheme.bodyMedium
                                                  ?.copyWith(
                                                color: AppColors.blackText,
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      //  Text(
                                      //   " ${history.name}",
                                      //   style: context.textTheme.bodyMedium
                                      //       ?.copyWith(
                                      //     fontSize: 14,
                                      //     color: AppColors.blackText,
                                      //   ),
                                      // ),
                                    ),
                                    // const Spacer(),
                                    Text.rich(
                                      TextSpan(
                                        text: "TID : ",
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: AppColors.blackText,
                                          fontSize: 14,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: history.terminalId ?? "",
                                            style: context.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: AppColors.bodyTextGrey,
                                              fontSize: 14,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // const Spacer(),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        checkStatusColor(history.status ?? "")
                                            .withOpacity(.14),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    history.status ?? "",
                                    style:
                                        context.textTheme.labelLarge?.copyWith(
                                      color: checkStatusColor(
                                          history.status ?? ""),
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemCount: historyList.length,
            ),
    );
  }
}

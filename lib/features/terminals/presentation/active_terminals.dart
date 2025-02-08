import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/constants/image_strings.dart';
import 'package:fso_support/core/reusables/textfield.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:fso_support/features/terminals/models/terminal_model.dart';
import 'package:fso_support/features/terminals/presentation/inactive_terminals.dart';
import 'package:fso_support/features/terminals/presentation/terminal_details.dart';
import 'package:fso_support/features/terminals/providers/terminal_providers.dart';
import 'package:fso_support/features/terminals/state/terminal_state.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ActiveTerminalPage extends ConsumerStatefulWidget {
  static const String routeName = 'active-terminal-page';
  const ActiveTerminalPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ActiveTerminalPageState();
}

class _ActiveTerminalPageState extends ConsumerState<ActiveTerminalPage> {
  final searchController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchActiveTerminals(ref: ref);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, WidgetRef ref, __) {
        final terminalList = ref.watch(activeTerminalListProv);
        final terminalModel = ref.watch(activeTerminalListModel);
        final terminalCount = terminalModel?.total ?? 0;
        final currentPage = terminalModel?.currentPage ?? 0;
        final lastPage = terminalModel?.lastPage ?? 0;
        final terminalSearchList = ref.watch(activeTerminalSearchProv);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Active Terminals",
              style: context.textTheme.titleMedium?.copyWith(fontSize: 16.text),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Total Active : $terminalCount",
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: AppColors.successGreen),
                  ),
                ),
                const SizedBox(height: 16),
                AppInputField(
                  controller: searchController,
                  hintText: "search with tid or merchant name",
                  prefixIcon: buildInputIcon(icon: ImageStrings.search),
                  textInputAction: TextInputAction.search,
                  onChanged: (p0) {
                    if (p0.isNotEmpty) {
                      fetchActiveTerminals(ref: ref, search: p0);
                      setState(() {});
                    } else {
                      fetchActiveTerminals(ref: ref);
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: NotificationListener(
                    onNotification: (ScrollEndNotification t) {
                      if (t.metrics.pixels != 0 && t.metrics.atEdge) {
                        print("hehehhee");
                        if (currentPage != lastPage) {
                          fetchActiveTerminals(ref: ref, loadMore: true);
                        }
                      }
                      return true;
                    },
                    child: ListView.separated(
                      // shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final terminal = searchController.text.isEmpty
                            ? terminalList[index]
                            : terminalSearchList[index];
                        return GestureDetector(
                          onTap: () =>
                              context.pushNamed(TerminalDetailsPage.routeName,
                                  extra: TerminalDetailRoute(
                                    terminalModel: terminal,
                                    status: "Active",
                                  )),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildColumn(
                                  context,
                                  "Merchant Name",
                                  terminal.merchantName ?? "",
                                ),
                                const SizedBox(width: 10),
                                buildColumn(
                                  context,
                                  "TID",
                                  terminal.terminalId ?? "",
                                ),
                                const SizedBox(width: 10),
                                buildColumn(
                                    context,
                                    "L.D.A",
                                    DateFormat("dd/MM/yyyy").format(
                                        terminal.createdAt ?? DateTime.now())),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: searchController.text.isEmpty
                          ? terminalList.length
                          : terminalSearchList.length,
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
}

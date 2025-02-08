import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/config/color/app_colors.dart';
import 'package:fso_support/core/constants/image_strings.dart';
import 'package:fso_support/core/reusables/textfield.dart';
import 'package:fso_support/core/size_config/extensions.dart';
import 'package:fso_support/core/utils/extensions.dart';
import 'package:fso_support/features/terminals/models/terminal_model.dart';
import 'package:fso_support/features/terminals/presentation/terminal_details.dart';
import 'package:fso_support/features/terminals/providers/terminal_providers.dart';
import 'package:fso_support/features/terminals/state/terminal_state.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class InactiveTerminalPage extends ConsumerStatefulWidget {
  static const String routeName = 'inactive-terminal-page';
  const InactiveTerminalPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InactiveTerminalPageState();
}

class _InactiveTerminalPageState extends ConsumerState<InactiveTerminalPage> {
  final searchController = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchInactiveTerminals(ref: ref);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, WidgetRef ref, __) {
        final terminalList = ref.watch(inactiveTerminalListProv);
        final terminalCount = ref.watch(inactiveTerminalListModel)?.total ?? 0;
        final terminalSearchList = ref.watch(inactiveTerminalSearchProv);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Inactive Terminals",
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
                    "Total Inactive : $terminalCount",
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: AppColors.errorRed2),
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
                      fetchInactiveTerminals(ref: ref, search: p0);
                      setState(() {});
                    } else {
                      fetchInactiveTerminals(ref: ref);
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final terminal = searchController.text.isEmpty
                        ? terminalList[index]
                        : terminalSearchList[index];
                    return GestureDetector(
                      onTap: () =>
                          context.pushNamed(TerminalDetailsPage.routeName,
                              extra: TerminalDetailRoute(
                                terminalModel: terminal,
                                status: "Inactive",
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
              ],
            ),
          ),
        );
      },
    );
  }
}

buildColumn(BuildContext context, String label, String text) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: AppColors.blackText.withOpacity(.6),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          text,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 13,
            color: AppColors.blackText,
          ),
        ),
      ],
    ),
  );
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/features/history/providers/history_prov.dart';
import 'package:fso_support/features/support_request/providers/support_req_prov.dart';

Future<void> fetchHistory({required WidgetRef ref}) async {
  ref.read(supReqLoadingProvider.notifier).state = true;

  Map<String, dynamic> data = {
    "length": 30,
    "interval_type": "custom",
    "start_date": DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day - 30)
        .toIso8601String(),
    "end_date": DateTime.now().toIso8601String(),
  };

  final res =
      await ref.watch(historyRepoProvider).fetchSupportHistory(data: data);

  res.fold((l) {
    ref.read(supReqErrorProvider.notifier).state = l.message;
    ref.read(supReqLoadingProvider.notifier).state = false;
  }, (r) {
    ref.read(historyListProv.notifier).state = r ?? [];
    ref.read(supReqErrorProvider.notifier).state = null;
    ref.read(supReqLoadingProvider.notifier).state = false;
  });
}

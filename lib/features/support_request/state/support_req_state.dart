import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/features/support_request/providers/support_req_prov.dart';

Future<void> fetchSupportRequest({required WidgetRef ref}) async {
  ref.read(supReqLoadingProvider.notifier).state = true;

  final res = await ref.watch(supReqRepoProvider).fetchSupportRequest();

  res.fold((l) {
    ref.read(supReqErrorProvider.notifier).state = l.message;
    ref.read(supReqLoadingProvider.notifier).state = false;
  }, (r) {
    ref.read(requestListProv.notifier).state = r ?? [];
    ref.read(supReqErrorProvider.notifier).state = null;
    ref.read(supReqLoadingProvider.notifier).state = false;
  });
}

Future<void> fetchRoadMap({required WidgetRef ref}) async {
  ref.read(supReqLoadingProvider.notifier).state = true;

  final res = await ref
      .watch(supReqRepoProvider)
      .fetchSupportRequest(data: {"support_type": "Roadmap visitation"});

  res.fold((l) {
    ref.read(supReqErrorProvider.notifier).state = l.message;
    ref.read(supReqLoadingProvider.notifier).state = false;
  }, (r) {
    ref.read(roadMapListProv.notifier).state = r ?? [];
    ref.read(supReqErrorProvider.notifier).state = null;
    ref.read(supReqLoadingProvider.notifier).state = false;
  });
}

Future<void> rejectTask(
    {required WidgetRef ref,
    required String reason,
    required String taskId}) async {
  ref.read(supReqLoadingProvider.notifier).state = true;

  final res = await ref
      .watch(supReqRepoProvider)
      .rejectTask(id: taskId, data: {"rejection_reason": reason});

  res.fold((l) {
    ref.read(supReqErrorProvider.notifier).state = l.message;
    ref.read(supReqLoadingProvider.notifier).state = false;
  }, (r) {
    ref.read(supReqErrorProvider.notifier).state = null;
    ref.read(supReqLoadingProvider.notifier).state = false;
  });
}

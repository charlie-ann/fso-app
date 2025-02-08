import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/features/support_request/datasources/support_req_ds.dart';
import 'package:fso_support/features/support_request/datasources/support_req_ds_impl.dart';
import 'package:fso_support/features/support_request/models/support_request.dart';
import 'package:fso_support/features/support_request/repository/support_req.dart';
import 'package:fso_support/features/support_request/repository/support_req_impl.dart';

final requestListProv = StateProvider<List<SupportRequestModel>>((ref) => []);
final roadMapListProv = StateProvider<List<SupportRequestModel>>((ref) => []);

//loading provider
final supReqLoadingProvider = StateProvider<bool>((ref) => false);

//error provider
final supReqErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

// datasource provider
final supReqDsProvider = Provider<SupportReqDS>((ref) => SupportReqDSImpl());

// repository provider
final supReqRepoProvider = Provider<SupportReqRepo>((ref) {
  final supReqDs = ref.watch(supReqDsProvider);
  return SupportReqRepoImpl(supReqDs);
});

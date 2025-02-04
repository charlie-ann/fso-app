import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/features/log_support/datasources/log_support_ds.dart';
import 'package:fso_support/features/log_support/datasources/log_support_ds_impl.dart';
import 'package:fso_support/features/log_support/model/state_model.dart';
import 'package:fso_support/features/log_support/repository/log_support_repo.dart';
import 'package:fso_support/features/log_support/repository/log_support_repo_impl.dart';
import 'package:location/location.dart';

final currentLocation = StateProvider<LocationData?>((ref) => null);
final scanDateTimeProv = StateProvider<ScanDateTime?>((ref) => null);
final stateListProv = StateProvider<List<String>>((ref) => []);
final bankListProv = StateProvider<List<String>>((ref) => []);
final uniformReportProv = StateProvider<List<String>>((ref) => []);
final stateModelListProv = StateProvider<List<StateModel>>((ref) => []);

//loading provider
final logSupportLoadingProv = StateProvider<bool>((ref) => false);

//error provider
final logSupportErrorProvider =
    StateProvider.autoDispose<String?>((ref) => null);

// datasource provider
final logSupportDsProvider =
    Provider<LogSupportDS>((ref) => LogSupportDSImpl());

// repository provider
final logSupportRepoProvider = Provider<LogSupportRepo>((ref) {
  final logSupportDs = ref.watch(logSupportDsProvider);
  return LogSupportRepoImpl(logSupportDs);
});

class ScanDateTime {
  String? scanDate;
  String? scanTime;

  ScanDateTime({this.scanDate, this.scanTime});
}

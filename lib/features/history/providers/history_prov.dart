import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/features/history/datasources/history_ds.dart';
import 'package:fso_support/features/history/datasources/history_ds_impl.dart';
import 'package:fso_support/features/history/models/history_model.dart';
import 'package:fso_support/features/history/repository/history_repo.dart';
import 'package:fso_support/features/history/repository/history_repo_impl.dart';

final historyListProv = StateProvider<List<HistoryModel>>((ref) => []);

//loading provider
final historyLoadingProvider = StateProvider<bool>((ref) => false);

//error provider
final historyErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

// datasource provider
final historyDsProvider = Provider<HistoryDS>((ref) => HistoryDSImpl());

// repository provider
final historyRepoProvider = Provider<HistoryRepo>((ref) {
  final historyDs = ref.watch(historyDsProvider);
  return HistoryRepoImpl(historyDs);
});

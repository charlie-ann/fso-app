import 'package:fso_support/features/history/models/history_model.dart';

abstract class HistoryDS {
  Future<List<HistoryModel>?> fetchSupportHistory(
      {required Map<String, dynamic> data});
}

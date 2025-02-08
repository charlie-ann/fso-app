import 'package:dartz/dartz.dart';
import 'package:fso_support/core/network/failure.dart';
import 'package:fso_support/features/history/models/history_model.dart';

abstract class HistoryRepo {
  Future<Either<Failure, List<HistoryModel>?>> fetchSupportHistory(
      {required Map<String, dynamic> data});
}

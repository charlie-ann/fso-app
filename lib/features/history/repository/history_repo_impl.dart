import 'package:dartz/dartz.dart';
import 'package:fso_support/core/network/failure.dart';
import 'package:fso_support/features/history/datasources/history_ds.dart';
import 'package:fso_support/features/history/models/history_model.dart';
import 'package:fso_support/features/history/repository/history_repo.dart';

class HistoryRepoImpl implements HistoryRepo {
  final HistoryDS datasource;
  HistoryRepoImpl(this.datasource);

  @override
  Future<Either<Failure, List<HistoryModel>?>> fetchSupportHistory(
      {required Map<String, dynamic> data}) async {
    try {
      final res = await datasource.fetchSupportHistory(data: data);
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

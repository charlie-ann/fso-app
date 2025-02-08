import 'package:dartz/dartz.dart';
import 'package:fso_support/core/network/failure.dart';
import 'package:fso_support/features/log_support/datasources/log_support_ds.dart';
import 'package:fso_support/features/log_support/model/state_model.dart';
import 'package:fso_support/features/log_support/repository/log_support_repo.dart';

class LogSupportRepoImpl implements LogSupportRepo {
  final LogSupportDS datasource;
  LogSupportRepoImpl(this.datasource);

  @override
  Future<Either<Failure, bool?>> logSupport(
      {required Map<String, dynamic> data}) async {
    try {
      final res = await datasource.logSupport(data: data);
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int?>> createTask(
      {required Map<String, dynamic> data}) async {
    try {
      final res = await datasource.createTask(data: data);
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StateModel>?>> fetchStates() async {
    try {
      final res = await datasource.fetchStates();
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>?>> fetchBanks() async {
    try {
      final res = await datasource.fetchBanks();
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>?>> fetchUniformReport() async {
    try {
      final res = await datasource.fetchUniformReport();
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

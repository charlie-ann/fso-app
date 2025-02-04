import 'package:dartz/dartz.dart';
import 'package:fso_support/core/network/failure.dart';
import 'package:fso_support/features/log_support/model/state_model.dart';

abstract class LogSupportRepo {
  Future<Either<Failure, bool?>> logSupport(
      {required Map<String, dynamic> data});
  Future<Either<Failure, bool?>> createTask(
      {required Map<String, dynamic> data});
  Future<Either<Failure, List<StateModel>?>> fetchStates();
  Future<Either<Failure, List<String>?>> fetchBanks();
  Future<Either<Failure, List<String>?>> fetchUniformReport();
}

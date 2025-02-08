import 'package:dartz/dartz.dart';
import 'package:fso_support/core/network/failure.dart';
import 'package:fso_support/features/terminals/datasources/terminals_ds.dart';
import 'package:fso_support/features/terminals/models/terminal_model.dart';
import 'package:fso_support/features/terminals/repository/terminal_repo.dart';

class TerminalRepoImpl implements TerminalRepo {
  final TerminalDS datasource;
  TerminalRepoImpl(this.datasource);

  @override
  Future<Either<Failure, TerminalModel?>> getSingleTerminal(
      {required Map<String, dynamic> data}) async {
    try {
      final res = await datasource.getSingleTerminal(data: data);
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TerminalResponseModel?>> fetchInactiveTerminals(
      {required Map<String, dynamic> data}) async {
    try {
      final res = await datasource.fetchInactiveTerminals(data: data);
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TerminalResponseModel?>> fetchAssignedTerminals(
      {required Map<String, dynamic> data}) async {
    try {
      final res = await datasource.fetchAssignedTerminals(data: data);
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

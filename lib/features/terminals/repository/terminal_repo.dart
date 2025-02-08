import 'package:dartz/dartz.dart';
import 'package:fso_support/core/network/failure.dart';
import 'package:fso_support/features/terminals/models/terminal_model.dart';

abstract class TerminalRepo {
  Future<Either<Failure, TerminalModel?>> getSingleTerminal(
      {required Map<String, dynamic> data});
  Future<Either<Failure, TerminalResponseModel?>> fetchInactiveTerminals(
      {required Map<String, dynamic> data});
  Future<Either<Failure, TerminalResponseModel?>> fetchAssignedTerminals(
      {required Map<String, dynamic> data});
}

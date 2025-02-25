import 'package:dartz/dartz.dart';
import 'package:fso_support/core/network/failure.dart';
import 'package:fso_support/features/auth/models/user_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserModel?>> login(
      {required Map<String, dynamic> data});
  Future<Either<Failure, bool?>> resetPassword(
      {required Map<String, dynamic> data});
  Future<Either<Failure, bool?>> changePassword(
      {required Map<String, dynamic> data});
  Future<Either<Failure, bool?>> forgotPassword(
      {required Map<String, dynamic> data});
  Future<Either<Failure, bool?>> clockIn({required Map<String, dynamic> data});
  Future<Either<Failure, UserModel?>> getUser();
}

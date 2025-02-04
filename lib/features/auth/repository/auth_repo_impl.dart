import 'package:dartz/dartz.dart';
import 'package:fso_support/core/network/failure.dart';
import 'package:fso_support/features/auth/datasources/auth_ds.dart';
import 'package:fso_support/features/auth/models/user_model.dart';
import 'package:fso_support/features/auth/repository/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthDS datasource;
  AuthRepoImpl(this.datasource);

  @override
  Future<Either<Failure, UserModel?>> login(
      {required Map<String, dynamic> data}) async {
    try {
      final res = await datasource.login(data: data);
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool?>> resetPassword(
      {required Map<String, dynamic> data}) async {
    try {
      final res = await datasource.resetPassword(data: data);
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool?>> changePassword(
      {required Map<String, dynamic> data}) async {
    try {
      final res = await datasource.changePassword(data: data);
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getUser() async {
    try {
      final res = await datasource.getUser();
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool?>> clockIn(
      {required Map<String, dynamic> data}) async {
    try {
      final res = await datasource.clockIn(data: data);
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

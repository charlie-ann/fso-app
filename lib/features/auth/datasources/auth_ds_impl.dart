import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fso_support/core/network/api.dart';
import 'package:fso_support/core/network/endpoints.dart';
import 'package:fso_support/core/storage/storage.dart';
import 'package:fso_support/features/auth/datasources/auth_ds.dart';
import 'package:fso_support/features/auth/models/user_model.dart';

class AuthDSImpl implements AuthDS {
  Storage storage = StorageImpl();
  Api api = Api();

  @override
  Future<UserModel?> login({required Map<String, dynamic> data}) async {
    try {
      log(data.toString());
      final res = await api.dio.post(
        AppEndpoints.login,
        data: data,
      );
      log(res.toString(), name: "login");
      if (res.statusCode == 200 || res.statusCode == 201) {
        await storage.saveToken(
            value: res.data["data"]["access_token"] as String);
        return UserModel.fromJson(res.data["data"]);
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "login err");
      rethrow;
    }
  }

  @override
  Future<bool?> resetPassword({required Map<String, dynamic> data}) async {
    try {
      log(data.toString());

      final res = await api.dio.post(
        AppEndpoints.resetPassword,
        data: data,
      );
      log(res.toString(), name: "resetPassword");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "resetPassword err");
      rethrow;
    }
  }

  @override
  Future<bool?> changePassword({required Map<String, dynamic> data}) async {
    try {
      log(data.toString());

      final res = await api.dio.post(
        AppEndpoints.changedPassword,
        data: data,
      );
      log(res.toString(), name: "changePassword");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "changePassword err");
      rethrow;
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final res = await api.dio.get(
        AppEndpoints.getUser,
      );
      log(res.toString(), name: "getUser");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return UserModel.fromJson(res.data["data"]);
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "getUser err");
      rethrow;
    }
  }

  @override
  Future<bool?> clockIn({required Map<String, dynamic> data}) async {
    try {
      log(data.toString());

      final res = await api.dio.post(
        AppEndpoints.clockIn,
        data: data,
      );
      log(res.toString(), name: "clockIn");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "clockIn err");
      rethrow;
    }
  }

  @override
  Future<bool?> forgotPassword({required Map<String, dynamic> data}) async {
    try {
      log(data.toString());

      final res = await api.dio.post(
        AppEndpoints.forgotPassword,
        data: data,
      );
      log(res.toString(), name: "forgotPassword");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "forgotPassword err");
      rethrow;
    }
  }
}

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fso_support/core/network/api.dart';
import 'package:fso_support/core/network/endpoints.dart';
import 'package:fso_support/core/storage/storage.dart';
import 'package:fso_support/core/utils/input_formatters.dart';
import 'package:fso_support/features/log_support/datasources/log_support_ds.dart';
import 'package:fso_support/features/log_support/model/state_model.dart';

class LogSupportDSImpl implements LogSupportDS {
  Storage storage = StorageImpl();
  Api api = Api();

  @override
  Future<bool?> logSupport({required Map<String, dynamic> data}) async {
    try {
      log(data.toString());
      final formData = FormData.fromMap(data);
      final res = await api.dio.post(
        AppEndpoints.logSupport,
        data: formData,
      );
      log(res.toString(), name: "logSupport");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "logSupport err");
      rethrow;
    }
  }

  @override
  Future<int?> createTask({required Map<String, dynamic> data}) async {
    try {
      log(data.toString());
      final formData = FormData.fromMap(data);
      final res = await api.dio.post(
        AppEndpoints.createTask,
        data: formData,
      );
      log(res.toString(), name: "createTask");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return res.data["data"]["id"];
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "createTask err");
      rethrow;
    }
  }

  @override
  Future<List<StateModel>?> fetchStates() async {
    try {
      final res = await api.dio.get(
        AppEndpoints.fetchStates,
      );
      log(res.toString(), name: "fetchStates");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return (res.data["data"] as List)
            .map((e) => StateModel.fromJson(e))
            .toList();
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "fetchStates err");
      rethrow;
    }
  }

  @override
  Future<List<String>?> fetchBanks() async {
    try {
      final res = await api.dio.get(
        AppEndpoints.fetchBanks,
      );
      log(res.toString(), name: "fetchBanks");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return (res.data["data"] as List).map((e) => e.toString()).toList();
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "fetchBanks err");
      rethrow;
    }
  }

  @override
  Future<List<String>?> fetchUniformReport() async {
    try {
      final res = await api.dio.get(
        AppEndpoints.uniformReport,
      );
      log(res.toString(), name: "fetchUniformReport");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return (res.data["data"] as List)
            .map((e) => allFirstToUpper(e.toString()))
            .toList();
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "fetchUniformReport err");
      rethrow;
    }
  }
}

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fso_support/core/network/api.dart';
import 'package:fso_support/core/network/endpoints.dart';
import 'package:fso_support/core/storage/storage.dart';
import 'package:fso_support/features/terminals/datasources/terminals_ds.dart';
import 'package:fso_support/features/terminals/models/terminal_model.dart';

class TerminalDSImpl implements TerminalDS {
  Storage storage = StorageImpl();
  Api api = Api();

  @override
  Future<TerminalModel?> getSingleTerminal(
      {required Map<String, dynamic> data}) async {
    try {
      final res = await api.dio.post(
        AppEndpoints.getSingleTerminal,
        data: data,
      );
      log(res.toString(), name: "getSingleTerminal");
      if ((res.statusCode == 200 || res.statusCode == 201) &&
          res.data["data"] != null) {
        return TerminalModel.fromJson(res.data["data"]);
      } else {
        throw res.data["data"] == null ? "Terminal not found" : Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "getSingleTerminal err");
      rethrow;
    }
  }

  @override
  Future<TerminalResponseModel?> fetchInactiveTerminals(
      {required Map<String, dynamic> data}) async {
    try {
      final res = await api.dio.get(
        AppEndpoints.getInactiveTerminal,
        queryParameters: data,
      );
      log(res.toString(), name: "fetchInactiveTerminal");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return TerminalResponseModel.fromJson(res.data);
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "fetchInactiveTerminal err");
      rethrow;
    }
  }

  @override
  Future<TerminalResponseModel?> fetchAssignedTerminals(
      {required Map<String, dynamic> data}) async {
    try {
      final userId = data["user_id"];
      data.remove("user_id");
      final res = await api.dio.get(
        "${AppEndpoints.getAssignedTerminals}/$userId",
        queryParameters: data,
      );
      log(res.toString(), name: "fetchAssignedTerminals");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return TerminalResponseModel.fromJson(res.data);
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "fetchAssignedTerminals err");
      rethrow;
    }
  }
}

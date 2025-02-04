import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fso_support/core/network/api.dart';
import 'package:fso_support/core/network/endpoints.dart';
import 'package:fso_support/core/storage/storage.dart';
import 'package:fso_support/features/support_request/datasources/support_req_ds.dart';
import 'package:fso_support/features/support_request/models/support_request.dart';

class SupportReqDSImpl implements SupportReqDS {
  Storage storage = StorageImpl();
  Api api = Api();

  @override
  Future<List<SupportRequestModel>?> fetchSupportRequest(
      {Map<String, dynamic>? data}) async {
    try {
      final res = await api.dio.get(
        AppEndpoints.fetchSupportRequest,
        queryParameters: data,
      );
      log(res.toString(),
          name: data == null ? "fetchSupportRequest" : "fetchRoadMap");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return (res.data["data"] as List)
            .map((e) => SupportRequestModel.fromJson(e))
            .toList();
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(),
          name: data == null ? "fetchSupportRequest err" : "fetchRoadMap err");
      rethrow;
    }
  }

  @override
  Future<bool> rejectTask(
      {required Map<String, dynamic> data, required String id}) async {
    try {
      final res = await api.dio.post(
        "${AppEndpoints.createTask}/$id/reject",
        data: data,
      );
      log(res.toString(), name: "rejectTask");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "rejectTask err");
      rethrow;
    }
  }
}

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fso_support/core/network/api.dart';
import 'package:fso_support/core/network/endpoints.dart';
import 'package:fso_support/core/storage/storage.dart';
import 'package:fso_support/features/history/datasources/history_ds.dart';
import 'package:fso_support/features/history/models/history_model.dart';

class HistoryDSImpl implements HistoryDS {
  Storage storage = StorageImpl();
  Api api = Api();

  @override
  Future<List<HistoryModel>?> fetchSupportHistory(
      {required Map<String, dynamic> data}) async {
    try {
      log(data.toString());

      final res = await api.dio.get(
        AppEndpoints.logSupport,
        queryParameters: data,
      );
      log(res.toString(), name: "fetchSupportHistory");
      if (res.statusCode == 200 || res.statusCode == 201) {
        return (res.data["data"] as List)
            .map((e) => HistoryModel.fromJson(e))
            .toList();
      } else {
        throw Exception();
      }
    } on DioException {
      rethrow;
    } catch (e) {
      log(e.toString(), name: "fetchSupportHistory err");
      rethrow;
    }
  }
}

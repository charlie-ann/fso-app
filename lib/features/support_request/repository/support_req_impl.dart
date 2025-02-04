import 'package:dartz/dartz.dart';
import 'package:fso_support/core/network/failure.dart';
import 'package:fso_support/features/support_request/datasources/support_req_ds.dart';
import 'package:fso_support/features/support_request/models/support_request.dart';
import 'package:fso_support/features/support_request/repository/support_req.dart';

class SupportReqRepoImpl implements SupportReqRepo {
  final SupportReqDS datasource;
  SupportReqRepoImpl(this.datasource);

  @override
  Future<Either<Failure, List<SupportRequestModel>?>> fetchSupportRequest(
      {Map<String, dynamic>? data}) async {
    try {
      final res = await datasource.fetchSupportRequest(data: data);
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> rejectTask(
      {required Map<String, dynamic> data, required String id}) async {
    try {
      final res = await datasource.rejectTask(data: data, id: id);
      return right(res);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

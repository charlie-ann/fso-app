import 'package:dartz/dartz.dart';
import 'package:fso_support/core/network/failure.dart';
import 'package:fso_support/features/support_request/models/support_request.dart';

abstract class SupportReqRepo {
  Future<Either<Failure, List<SupportRequestModel>?>> fetchSupportRequest(
      {Map<String, dynamic>? data});
  Future<Either<Failure, bool>> rejectTask(
      {required Map<String, dynamic> data, required String id});
}

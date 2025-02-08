import 'package:fso_support/features/support_request/models/support_request.dart';

abstract class SupportReqDS {
  Future<List<SupportRequestModel>?> fetchSupportRequest(
      {Map<String, dynamic>? data});
  Future<bool> rejectTask(
      {required Map<String, dynamic> data, required String id});
}

import 'package:fso_support/features/log_support/model/state_model.dart';

abstract class LogSupportDS {
  Future<bool?> logSupport({required Map<String, dynamic> data});
  Future<int?> createTask({required Map<String, dynamic> data});
  Future<List<StateModel>?> fetchStates();
  Future<List<String>?> fetchBanks();
  Future<List<String>?> fetchUniformReport();
}

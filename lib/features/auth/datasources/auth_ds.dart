import 'package:fso_support/features/auth/models/user_model.dart';

abstract class AuthDS {
  Future<UserModel?> login({required Map<String, dynamic> data});
  Future<bool?> resetPassword({required Map<String, dynamic> data});
  Future<bool?> changePassword({required Map<String, dynamic> data});
  Future<UserModel?> getUser();
  Future<bool?> clockIn({required Map<String, dynamic> data});
}

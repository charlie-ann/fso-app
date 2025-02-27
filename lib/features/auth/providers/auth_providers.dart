import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/features/auth/datasources/auth_ds.dart';
import 'package:fso_support/features/auth/datasources/auth_ds_impl.dart';
import 'package:fso_support/features/auth/models/user_model.dart';
import 'package:fso_support/features/auth/repository/auth_repo.dart';
import 'package:fso_support/features/auth/repository/auth_repo_impl.dart';

final currentUser = StateProvider<UserModel?>((ref) => null);

final resetPasswordEmail = StateProvider<String?>((ref) => null);

//loading provider
final authLoadingProvider = StateProvider<bool>((ref) => false);

//error provider
final authErrorProvider = StateProvider.autoDispose<String?>((ref) => null);

// datasource provider
final authDsProvider = Provider<AuthDS>((ref) => AuthDSImpl());

// repository provider
final authRepoProvider = Provider<AuthRepo>((ref) {
  final authDs = ref.watch(authDsProvider);
  return AuthRepoImpl(authDs);
});

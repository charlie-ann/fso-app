import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/app_initialization.dart';
import 'package:fso_support/core/storage/storage.dart';
import 'package:fso_support/features/auth/providers/auth_providers.dart';

Future<void> login({
  required WidgetRef ref,
  required String email,
  required String password,
  String? pin,
}) async {
  ref.read(authLoadingProvider.notifier).state = true;

  Map<String, dynamic> data = {
    "email": email,
    "password": password,
    "device_id": AppInitialisation.deviceId,
  };

  final res = await ref.watch(authRepoProvider).login(data: data);

  res.fold((l) {
    ref.read(authErrorProvider.notifier).state = l.message;
    ref.read(authLoadingProvider.notifier).state = false;
  }, (r) {
    ref.read(currentUser.notifier).state = r;
    if (r?.passwordChanged == true) {
      saveDetailsToLocal(ref: ref, email: email, password: password);
    }
    ref.read(authErrorProvider.notifier).state = null;
    ref.read(authLoadingProvider.notifier).state = false;
  });
}

Future<void> saveDetailsToLocal({
  required WidgetRef ref,
  required String email,
  required String password,
  String? pin,
}) async {
  final Storage storage = StorageImpl();
  await storage.saveEmail(value: email);
  await storage.savePassword(value: password);
}

Future<void> getUser({
  required WidgetRef ref,
  String? pin,
}) async {
  ref.read(authLoadingProvider.notifier).state = true;

  final res = await ref.watch(authRepoProvider).getUser();

  res.fold((l) {
    ref.read(authErrorProvider.notifier).state = l.message;
    ref.read(authLoadingProvider.notifier).state = false;
  }, (r) {
    ref.read(currentUser.notifier).state = r;
    ref.read(authErrorProvider.notifier).state = null;
    ref.read(authLoadingProvider.notifier).state = false;
  });
}

Future<void> resetPassword({
  required WidgetRef ref,
  required String code,
  required String password,
}) async {
  ref.read(authLoadingProvider.notifier).state = true;

  final email = ref.read(resetPasswordEmail);

  Map<String, dynamic> data = {
    "otp": code,
    "email": email,
    "password": password,
    "user_type": "user",
  };

  final res = await ref.watch(authRepoProvider).resetPassword(data: data);

  res.fold((l) {
    ref.read(authErrorProvider.notifier).state = l.message;
    ref.read(authLoadingProvider.notifier).state = false;
  }, (r) {
    ref.read(authErrorProvider.notifier).state = null;
    ref.read(authLoadingProvider.notifier).state = false;
  });
}

Future<void> forgotPassword({
  required WidgetRef ref,
  required String email,
}) async {
  ref.read(authLoadingProvider.notifier).state = true;

  Map<String, dynamic> data = {
    "email": email,
    "user_type": "user",
  };

  final res = await ref.watch(authRepoProvider).forgotPassword(data: data);

  res.fold((l) {
    ref.read(authErrorProvider.notifier).state = l.message;
    ref.read(authLoadingProvider.notifier).state = false;
  }, (r) {
    ref.read(resetPasswordEmail.notifier).state = email;
    ref.read(authErrorProvider.notifier).state = null;
    ref.read(authLoadingProvider.notifier).state = false;
  });
}

Future<void> changePassword({
  required WidgetRef ref,
  required String oldPass,
  required String newPass,
}) async {
  ref.read(authLoadingProvider.notifier).state = true;

  Map<String, dynamic> data = {
    "old_password": oldPass,
    "new_password": newPass,
  };

  final res = await ref.watch(authRepoProvider).changePassword(data: data);

  res.fold((l) {
    ref.read(authErrorProvider.notifier).state = l.message;
    ref.read(authLoadingProvider.notifier).state = false;
  }, (r) {
    ref.read(authErrorProvider.notifier).state = null;
    ref.read(authLoadingProvider.notifier).state = false;
  });
}

Future<void> clockIn({
  required WidgetRef ref,
  required String lat,
  required String lng,
}) async {
  ref.read(authLoadingProvider.notifier).state = true;

  Map<String, dynamic> data = {"lat": lat, "lng": lng};

  final res = await ref.watch(authRepoProvider).clockIn(data: data);

  res.fold((l) {
    ref.read(authErrorProvider.notifier).state = l.message;
    ref.read(authLoadingProvider.notifier).state = false;
  }, (r) {
    ref.read(authErrorProvider.notifier).state = null;
    ref.read(authLoadingProvider.notifier).state = false;
  });
}

Future<void> logout({required WidgetRef ref}) async {
  Storage storage = StorageImpl();

  await storage.clearAllStorage();
}

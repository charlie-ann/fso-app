import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/features/log_support/model/log_support.dart';
import 'package:fso_support/features/log_support/providers/log_support_prov.dart';
import 'package:location/location.dart';

Future<void> getCurrentLocation(WidgetRef ref) async {
  try {
    final Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final loc = await location.getLocation();
    ref.read(currentLocation.notifier).state = loc;

    location.onLocationChanged.listen((newLocation) {
      ref.read(currentLocation.notifier).state = newLocation;
    });
  } catch (e, s) {
    log(e.toString(), name: "map wahala");
    log(s.toString(), name: "map wahala");
    ref.read(logSupportErrorProvider.notifier).state = e.toString();
  }
}

Future<void> logSupport(WidgetRef ref, LogSupportParams params) async {
  ref.read(logSupportLoadingProv.notifier).state = true;
  Map<String, dynamic> data = {
    "terminal_id": params.terminalId,
    "support_type": params.supportType,
    "purpose": params.purpose,
    "lat": params.lat,
    "lng": params.lng,
    "merchant_name": params.merchantName,
    "phone_number": params.phoneNumber,
    "state": params.state,
    "business_type": params.businessType,
    "network": params.network,
    "sim_serial": params.simSerial,
    "type": params.type,
    "app_version": params.appVersion,
    "serial_number": params.serialNumber,
    "log_type": params.logType,
    "task_id": params.taskId,
    "bank": params.bankName,
    "uniform_report": params.uniformReport?.toUpperCase(),
    "status": params.supportStatus,
  };

  if (params.logType != "scanned") {
    List<MultipartFile> images = [];
    params.document?.forEach((e) async {
      var img = await MultipartFile.fromFile(e.path);
      images.add(img);
    });
    data.addAll({
      "signature": await MultipartFile.fromFile(params.signature!.path),
      "documents[]": images,
    });
  }

  final scanDateTime = ref.watch(scanDateTimeProv);

  if (scanDateTime?.scanDate != null && params.logType == "scanned") {
    data.addAll({
      "scan_date": scanDateTime?.scanDate,
    });
  }

  if (scanDateTime?.scanTime != null && params.logType == "scanned") {
    data.addAll({
      "scan_time": scanDateTime?.scanTime,
    });
  }

  final res = await ref.watch(logSupportRepoProvider).logSupport(data: data);

  res.fold((l) {
    ref.read(logSupportErrorProvider.notifier).state = l.message;
    ref.read(logSupportLoadingProv.notifier).state = false;
  }, (r) {
    // ref.read(requestListProv.notifier).state = r ?? [];
    ref.read(logSupportErrorProvider.notifier).state = null;
    ref.read(logSupportLoadingProv.notifier).state = false;
  });
}

Future<int?> createTask(WidgetRef ref, LogSupportParams params) async {
  ref.read(logSupportLoadingProv.notifier).state = true;

  final statesModel = ref.watch(stateModelListProv);

  List<MultipartFile> images = [];
  params.document?.forEach((e) async {
    var img = await MultipartFile.fromFile(e.path);
    images.add(img);
  });

  Map<String, dynamic> data = {
    "terminal_id": params.terminalId,
    "merchant_name": params.merchantName,
    "merchant_address": params.address,
    "support_type": params.supportType,
    "support_issue": params.purpose,
    "phone_number": params.phoneNumber,
    "attachment": images,
    "fso_id": params.fsoId,
    "state_id":
        statesModel.firstWhere((element) => element.name == params.state).id,
    "area": params.area,
  };

  final res = await ref.watch(logSupportRepoProvider).createTask(data: data);

  final response = res.fold((l) {
    ref.read(logSupportErrorProvider.notifier).state = l.message;
    ref.read(logSupportLoadingProv.notifier).state = false;
    return null;
  }, (r) {
    ref.read(logSupportErrorProvider.notifier).state = null;
    ref.read(logSupportLoadingProv.notifier).state = false;
    return r;
  });

  return response;
}

Future<void> fetchStates(WidgetRef ref) async {
  final res = await ref.watch(logSupportRepoProvider).fetchStates();

  res.fold((l) {
    ref.read(logSupportErrorProvider.notifier).state = l.message;
  }, (r) {
    ref.read(stateListProv.notifier).state =
        r?.map((e) => e.name ?? "").toList() ?? [];
    ref.read(stateModelListProv.notifier).state = r ?? [];
    ref.read(logSupportErrorProvider.notifier).state = null;
  });
}

Future<List<String>> fetchBanks(WidgetRef ref) async {
  final res = await ref.watch(logSupportRepoProvider).fetchBanks();

  List<String> response = res.fold((l) {
    ref.read(logSupportErrorProvider.notifier).state = l.message;
    return [];
  }, (r) {
    ref.read(bankListProv.notifier).state = r ?? [];
    ref.read(logSupportErrorProvider.notifier).state = null;
    return r ?? [];
  });

  return response;
}

Future<List<String>> fetchUniformReport(WidgetRef ref) async {
  final res = await ref.watch(logSupportRepoProvider).fetchUniformReport();

  List<String> response = res.fold((l) {
    ref.read(logSupportErrorProvider.notifier).state = l.message;
    return [];
  }, (r) {
    ref.read(uniformReportProv.notifier).state = r ?? [];
    ref.read(logSupportErrorProvider.notifier).state = null;
    return r ?? [];
  });

  return response;
}

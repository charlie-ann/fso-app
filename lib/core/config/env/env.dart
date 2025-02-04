import 'package:flutter/foundation.dart';
import 'package:fso_support/core/config/env/build_config.dart';
import 'package:fso_support/core/network/endpoints.dart';

class Environment {
  static final BuildConfig _dev = BuildConfig(
    baseUrl: "${AppEndpoints.baseUrl}api/",
    appName: "FSO Staging",
  );

  static final BuildConfig _prod = BuildConfig(
    baseUrl: "${AppEndpoints.baseUrl}api/",
    appName: "FSO",
  );

  static BuildConfig get getConfig => kReleaseMode ? _prod : _dev;
}

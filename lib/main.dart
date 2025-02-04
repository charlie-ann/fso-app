import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/app.dart';
import 'package:fso_support/app_initialization.dart';

void main() {
  runZonedGuarded(
    () async {
      await AppInitialisation.preRun();
      runApp(
        const ProviderScope(
          child: FsoSupportApp(),
        ),
      );
    },
    (error, stack) {},
  );
}

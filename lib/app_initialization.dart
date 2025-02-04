import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fso_support/core/storage/storage.dart';
import 'package:unique_identifier/unique_identifier.dart';

class AppInitialisation {
  static String? deviceId;

  static Future<void> preRun() async {
    WidgetsFlutterBinding.ensureInitialized();

    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );

    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    await StorageImpl().initStorage();
    String? identifier;
    try {
      identifier = await UniqueIdentifier.serial;
    } on PlatformException {
      identifier = 'Failed to get Unique Identifier';
    }

    deviceId = identifier ?? 'failed';
    log(deviceId.toString(), name: "deviceId");

    // final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  }
}

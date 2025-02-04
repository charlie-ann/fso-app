library storage;

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart' hide Key;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

abstract class Storage {
  Future<void> clearAllStorage();
  Future<bool> containsData({required String key});
  Future<void> delete({required String key});
  Future<dynamic> getData({required String key});
  Future<String?> getToken();
  Future<String?> getEmail();
  Future<dynamic> getUser();
  Future<String?> getUserType();
  Future<String?> getPassword();
  Future<String?> getPin();
  Future<void> initStorage();
  Future<void> saveToken({required String value});
  Future<void> savePassword({required String value});
  Future<void> saveEmail({required String value});
  Future<void> savePin({required String value});
  Future<void> saveUser({dynamic data});
  Future<void> saveUserType({required String data});
  Future<void> storeData({required String key, dynamic value});
  Future<void> saveSignUpState({required bool data});
  Future<bool?> getSignUpState();
}

class StorageImpl implements Storage {
  final secureStorage = const FlutterSecureStorage();

  dynamic encryptionKey;
  dynamic securedKey;

  final String userBox = "userBox";
  final String securedBox = "securedBox";
  final String signUpBox = "signUpBox";
  final String signUpKey = "signUpKey";
  final String tokenKey = "tokenkey";
  final String emailKey = "emailKey";
  final String passwordKey = "passwordKey";
  final String pinKey = "pinKey";
  final String userKey = "userkey";
  final String userTypeKey = "userTypekey";
  final String deviceBox = "device";
  final String tokenExpKey = "tokenExpKey";
  final String printerKey = "printerKey";

  @override
  Future<void> clearAllStorage() async {
    await Hive.deleteBoxFromDisk(deviceBox);
    await Hive.deleteBoxFromDisk(userBox);
    await Hive.deleteBoxFromDisk(signUpBox);
    await Hive.deleteBoxFromDisk(securedBox);
  }

  @override
  Future<bool> containsData({required String key}) async {
    final openBox = await Hive.openBox(deviceBox);
    final contains = openBox.containsKey(key);

    await openBox.close();

    return contains;
  }

  @override
  Future<void> delete({required String key}) async {
    final openBox = await Hive.openBox(deviceBox);
    await openBox.delete(key);
    await openBox.close();
    final openUserBox = await Hive.openBox(userBox);
    await openUserBox.delete(key);
    await openUserBox.close();
  }

  @override
  Future getData({required String key}) async {
    final openBox = await Hive.openBox(deviceBox);
    final value = await openBox.get(key);
    await openBox.close();
    return value;
  }

  @override
  Future<String?> getToken() async {
    final openBox = await Hive.openBox(userBox);
    final value = await openBox.get(tokenKey);
    await openBox.close();
    return value;
  }

  @override
  Future getUser() async {
    final openBox = await Hive.openBox(userBox);
    final value = await openBox.get(userKey);
    await openBox.close();
    return value;
  }

  @override
  Future<String?> getUserType() async {
    final openBox = await Hive.openBox(userBox);
    final value = await openBox.get(userTypeKey);
    await openBox.close();
    return value;
  }

  @override
  Future initStorage() async {
    if (kIsWeb) return;
    final appDocDirectory = await getApplicationDocumentsDirectory();

    Hive.init(appDocDirectory.path);

    var containsEncryptionKey =
        await secureStorage.containsKey(key: passwordKey);
    if (!containsEncryptionKey) {
      securedKey = Hive.generateSecureKey();
      await secureStorage.write(
          key: passwordKey, value: base64UrlEncode(securedKey));
    }
    final String? getSecuredKey = await secureStorage.read(key: passwordKey);

    encryptionKey = base64Url.decode(getSecuredKey!);

    log(encryptionKey.toString(), name: "encryption key");
  }

  @override
  Future<void> saveToken({required String value}) async {
    final openBox = await Hive.openBox(userBox);
    await openBox.put(tokenKey, value);
    // await openBox.close();
  }

  @override
  Future<void> saveUser({data}) async {
    final openBox = await Hive.openBox(userBox);
    await openBox.put(userKey, data);
    await openBox.close();
  }

  @override
  Future<void> saveUserType({required String data}) async {
    final openBox = await Hive.openBox(userBox);
    await openBox.put(userTypeKey, data);
    await openBox.close();
  }

  @override
  Future<void> storeData({required String key, dynamic value}) async {
    final openBox = await Hive.openBox(deviceBox);
    await openBox.put(key, value);
    await openBox.close();
  }

  @override
  Future<String?> getEmail() async {
    final openBox = await Hive.openBox(userBox);
    final value = await openBox.get(emailKey);
    // await openBox.close();
    return value;
  }

  @override
  Future<void> saveEmail({required String value}) async {
    final openBox = await Hive.openBox(userBox);
    await openBox.put(emailKey, value);
    // await openBox.close();
  }

  @override
  Future<void> savePassword({required String value}) async {
    log(encryptionKey.toString(), name: "encryption key");
    var encryptedBox = await Hive.openBox(securedBox,
        encryptionCipher: HiveAesCipher(encryptionKey));
    encryptedBox.put(passwordKey, value);
    // await encryptedBox.close();
  }

  @override
  Future<String?> getPassword() async {
    log(encryptionKey.toString(), name: "encryption key");
    var encryptedBox = await Hive.openBox(securedBox,
        encryptionCipher: HiveAesCipher(encryptionKey));
    final password = encryptedBox.get(passwordKey);
    // await encryptedBox.close();
    return password;
  }

  @override
  Future<bool?> getSignUpState() async {
    final openBox = await Hive.openBox(signUpBox);
    final value = await openBox.get(signUpKey);
    // await openBox.close();
    return value;
  }

  @override
  Future<void> saveSignUpState({required bool data}) async {
    final openBox = await Hive.openBox(signUpBox);
    await openBox.put(signUpKey, data);
    // await openBox.close();
  }

  @override
  Future<String?> getPin() async {
    log(encryptionKey.toString(), name: "encryption key");
    var encryptedBox = await Hive.openBox(securedBox,
        encryptionCipher: HiveAesCipher(encryptionKey));
    final pin = encryptedBox.get(pinKey);
    // await encryptedBox.close();
    return pin;
  }

  @override
  Future<void> savePin({required String value}) async {
    log(encryptionKey.toString(), name: "encryption key");
    var encryptedBox = await Hive.openBox(securedBox,
        encryptionCipher: HiveAesCipher(encryptionKey));
    encryptedBox.put(pinKey, value);
    // await encryptedBox.close();
  }
}

// import 'dart:async';
// import 'dart:developer';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fso_support/core/storage/storage.dart';
// import 'package:go_router/go_router.dart';
// import 'package:local_auth/local_auth.dart';

// class CommonState {
//   final WidgetRef ref;
//   CommonState(this.ref);

//   Storage storage = StorageImpl();
//   final LocalAuthentication auth = LocalAuthentication();

//   Future<void> init() async {
//     loadTheme();
//     getFirstVisitState();
//     getBiometricsState();
//     checkBiometrics();
//     getEmail();

//     final isSupported = ref.read(isBiometricsSupportedProv);
//     if (isSupported) {
//       CommonState(ref).toggleBiometricsState(true);
//       CommonState(ref).toggleTransBiometricsState(true);
//     }
//   }

//   Timer? timer;
//   void startTimer() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       // ref.read(countDownProvider.notifier).state = 59;
//       // int count = ref.read(countDownProvider.notifier).state;
//       int count = 59;
//       const oneSec = Duration(seconds: 1);
//       timer = Timer.periodic(
//         oneSec,
//         (Timer timer) {
//           if (count == 0) {
//             timer.cancel();
//             ref.read(countDownProvider.notifier).state = 0;
//           } else {
//             log(count.toString());
//             count--;
//             ref.read(countDownProvider.notifier).state = count;
//           }
//         },
//       );
//       ref.read(countDownProvider.notifier).state = count;
//     });
//   }

//   Future<void> checkBiometrics() async {
//     try {
//       await auth.canCheckBiometrics;
//       var availableBiometrics = await auth.getAvailableBiometrics();
//       if (availableBiometrics.isNotEmpty) {
//         ref.read(isBiometricsSupportedProv.notifier).state = true;
//         ref.read(selectedBiometricTypeProv.notifier).state =
//             availableBiometrics[0];
//       }
//     } on PlatformException catch (e) {
//       log(e.toString());
//     }
//   }

//   Future<void> getBiometricsState() async {
//     try {
//       final data = await storage.getData(key: "biometricsKey");
//       log(data.toString(), name: "saved biometrics state");
//       if (data == null) {
//         ref.read(isBiometricsEnabledProv.notifier).state = false;
//       } else {
//         ref.read(isBiometricsEnabledProv.notifier).state = data;
//       }
//     } catch (e) {
//       log(e.toString(), name: "get err");
//       rethrow;
//     }
//   }

//   Future<void> toggleBiometricsState(bool currentState) async {
//     try {
//       await storage.storeData(key: "biometricsKey", value: currentState);
//       await getBiometricsState();
//     } catch (e) {
//       log(e.toString(), name: "save biometrics err");
//       rethrow;
//     }
//   }

//   Future<void> getTransBiometricsState() async {
//     try {
//       final data = await storage.getData(key: "transbiometricsKey");
//       log(data.toString(), name: "saved transbiometrics state");
//       if (data == null) {
//         ref.read(isTransBiometricsEnabledProv.notifier).state = false;
//       } else {
//         ref.read(isTransBiometricsEnabledProv.notifier).state = data;
//       }
//     } catch (e) {
//       log(e.toString(), name: "get err");
//       rethrow;
//     }
//   }

//   Future<void> toggleTransBiometricsState(bool currentState) async {
//     try {
//       await storage.storeData(key: "transbiometricsKey", value: currentState);
//       await getTransBiometricsState();
//     } catch (e) {
//       log(e.toString(), name: "save transbiometrics err");
//       rethrow;
//     }
//   }

//   Future<void> saveEmail(String email) async {
//     try {
//       await storage.saveEmail(value: email);
//     } catch (e) {
//       log(e.toString(), name: "save email err");
//       rethrow;
//     }
//   }

//   Future<void> savePassword(String password) async {
//     try {
//       await storage.initStorage();
//       await storage.savePassword(value: password);
//     } catch (e) {
//       log(e.toString(), name: "save pass err");
//       rethrow;
//     }
//   }

//   Future<String?> getEmail() async {
//     try {
//       final email = await storage.getEmail();
//       log(email.toString(), name: "email");
//       ref.read(savedEmail.notifier).state = email;
//       return email;
//     } catch (e) {
//       log(e.toString(), name: "get email err");
//       rethrow;
//     }
//   }

//   Future<void> getPassword() async {
//     try {
//       await storage.initStorage();
//       final password = await storage.getPassword();
//       ref.read(savedPass.notifier).state = password;
//     } catch (e) {
//       log(e.toString(), name: "get pass err");
//       rethrow;
//     }
//   }

//   Future<void> savePin(String pin) async {
//     try {
//       await storage.initStorage();
//       await storage.savePin(value: pin);
//     } catch (e) {
//       log(e.toString(), name: "save pin err");
//       rethrow;
//     }
//   }

//   Future<void> getPin() async {
//     try {
//       await storage.initStorage();
//       final pin = await storage.getPin();
//       log(pin.toString());
//       ref.read(savedPin.notifier).state = pin;
//     } catch (e) {
//       log(e.toString(), name: "get pin err");
//       rethrow;
//     }
//   }

//   Future<void> authenticate(BuildContext context) async {
//     bool authenticated = false;
//     try {
//       final canCheck = await auth.canCheckBiometrics;
//       final isSupported = await auth.isDeviceSupported();
//       if (canCheck && isSupported) {
//         authenticated = await auth.authenticate(
//           localizedReason: "Scan your fingerprint to authenticate",
//           options: const AuthenticationOptions(
//             stickyAuth: true,
//             useErrorDialogs: true,
//           ),
//         );
//         if (authenticated) {
//           await getPassword();
//           await getEmail();
//         }
//       } else {
//         return AppUtil.showSnackBar(context,
//             text: "Device is not supported!", error: true);
//       }
//     } on PlatformException catch (e) {
//       log(e.toString());
//     }
//     if (authenticated) {
//       final email = ref.read(savedEmail);
//       final password = ref.read(savedPass);
//       await login(ref: ref, email: email ?? "", password: password);
//       final err = ref.read(authErrorProvider);
//       if (err != null) {
//         AppUtil.showSnackBar(context, text: err, error: true);
//       } else {
//         final user = await getUser(ref: ref);
//         // AppUtil.showSnackBar(context, text: "Login Successful");
//         if (user?.pin == null) {
//           context.pushNamed(SetLoginPinPage.routeName);
//         } else {
//           context.go("/${HomePage.routeName}");
//         }
//       }
//     }
//   }

//   Future<String?> authenticatePin(BuildContext context) async {
//     bool authenticated = false;
//     String? pin;
//     try {
//       final canCheck = await auth.canCheckBiometrics;
//       final isSupported = await auth.isDeviceSupported();
//       if (canCheck && isSupported) {
//         authenticated = await auth.authenticate(
//           localizedReason: "Scan your fingerprint to authenticate",
//           options: const AuthenticationOptions(
//             stickyAuth: true,
//             useErrorDialogs: true,
//           ),
//         );
//         if (authenticated) {
//           await getPassword();
//         }
//       } else {
//         return AppUtil.showSnackBar(context,
//             text: "Device is not supported!", error: true);
//       }
//     } on PlatformException catch (e) {
//       log(e.toString());
//     }
//     if (authenticated) {
//       pin = ref.read(savedPin);
//       return pin;
//     } else {
//       return null;
//     }
//   }

//   Future<bool?> getFirstVisitState() async {
//     try {
//       final data = await storage.getData(key: "firstVisitKey");
//       log(data.toString(), name: "first visit state");
//       ref.read(isFirstVisit.notifier).state = data;
//       return data;
//     } catch (e) {
//       log(e.toString(), name: "get visit err");
//       rethrow;
//     }
//   }

//   Future<void> saveFirstVisit(bool currentState) async {
//     try {
//       await storage.storeData(key: "firstVisitKey", value: currentState);
//       ref.read(isFirstVisit.notifier).state = currentState;
//     } catch (e) {
//       log(e.toString(), name: "save visit err");
//       rethrow;
//     }
//   }

//   Future<void> clearAllData(BuildContext context) async {
//     ref.read(authLoadingProvider.notifier).state = true;
//     await storage.clearAllStorage();
//     getFirstVisitState();
//     getBiometricsState();
//     getEmail();
//     getPassword();
//     ref.read(authLoadingProvider.notifier).state = false;
//     AppUtil.showSnackBar(context, text: "Logged Out Successfully");
//     context.go("/${IntroPage.routeName}");
//   }

//   Future<void> logout(BuildContext context) async {
//     ref.read(authLoadingProvider.notifier).state = true;
//     await storage.delete(key: "tokenkey");

//     ref.read(authLoadingProvider.notifier).state = false;
//     AppUtil.showSnackBar(context, text: "Logged Out Successfully");
//     context.go("/${SignInPage.routeName}");
//   }

//   void loadTheme() async {
//     String? saved = await storage.getData(key: kThemePreference);
//     final themeMode = ThemeMode.values.firstWhere((e) =>
//         // ignore: deprecated_member_use
//         describeEnum(e) ==
//         (saved ?? ThemeMode.system.toString().split('.')[1]));

//     ref.read(themeModeProvider.notifier).state = themeMode;
//   }

//   setTheme(ThemeMode themeMode) async {
//     await storage.storeData(
//         key: kThemePreference, value: themeMode.toString().split('.')[1]);
//     ref.read(themeModeProvider.notifier).state = themeMode;
//   }

//   turnOffLoading() {
//     ref.watch(billsLoadingProvider.notifier).state = false;
//     ref.watch(authLoadingProvider.notifier).state = false;
//     ref.watch(transferLoadingProvider.notifier).state = false;
//     ref.watch(cardLoadingProvider.notifier).state = false;
//   }

//   void dispose() {
//     timer!.cancel();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

final countDownProvider = StateProvider<int>((ref) => 59);
final isBiometricsSupportedProv = StateProvider<bool>((ref) => false);
final isBiometricsEnabledProv = StateProvider<bool>((ref) => true);
final isTransBiometricsEnabledProv = StateProvider<bool>((ref) => true);
final selectedBiometricTypeProv = StateProvider<BiometricType?>((ref) => null);
final savedEmail = StateProvider<String?>((ref) => null);
final savedPass = StateProvider<String?>((ref) => null);
final savedPin = StateProvider<String?>((ref) => null);
final isFirstVisit = StateProvider<bool>((ref) => true);

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

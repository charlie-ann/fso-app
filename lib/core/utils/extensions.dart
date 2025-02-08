import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fso_support/core/utils/resusable_state/provider.dart';

extension BuildContextX on BuildContext {
  /// Extension for quickly accessing app [ColorScheme]
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Extension for quickly accessing app [TextTheme]
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Extension for quickly accessing app [Theme]
  ThemeData get theme => Theme.of(this);

  /// Extension for quickly accessing screen size
  Size get screenSize => MediaQuery.of(this).size;
}

extension DarkMode on BuildContext {
  bool isDarkMode(WidgetRef ref) {
    ThemeMode? theme = ref.watch(themeModeProvider);
    return (theme == ThemeMode.dark ||
        Theme.of(this).brightness == Brightness.dark);
  }
}

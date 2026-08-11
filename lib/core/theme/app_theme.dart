import 'package:flutter/material.dart';

/// The app's only theme configuration: a Material 3 scheme derived from one
/// seed color. Anything beyond this belongs on a branch, not in `main`.
abstract final class AppTheme {
  static const seedColor = Color(0xFF4C6FFF);

  static ThemeData light() => _from(Brightness.light);

  static ThemeData dark() => _from(Brightness.dark);

  static ThemeData _from(Brightness brightness) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      ),
    );
  }
}

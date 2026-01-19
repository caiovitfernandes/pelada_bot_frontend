import 'package:flutter/material.dart';

class X5Colors {
  static const Color background = Color(0xFF0D0D0D);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color primaryGreen = Color(0xFF00E676);
  static const Color cardBorder = Color(0xFF2C2C2C);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color danger = Color(0xFFFF5252);
}

final x5Theme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: X5Colors.background,
  primaryColor: X5Colors.primaryGreen,
  // CORREÇÃO AQUI: De CardTheme para CardThemeData
  cardTheme: CardThemeData(
    color: X5Colors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: X5Colors.cardBorder),
    ),
  ),
);
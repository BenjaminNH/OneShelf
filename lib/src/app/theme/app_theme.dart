import 'package:flutter/material.dart';

import 'app_palette.dart';

abstract final class AppTheme {
  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppPalette.bg,
      fontFamily: 'Noto Sans SC',
      colorScheme: const ColorScheme.dark(
        surface: AppPalette.surface,
        primary: AppPalette.accent,
        secondary: AppPalette.textSecondary,
        error: AppPalette.danger,
      ),
    );

    return base.copyWith(
      splashFactory: InkSparkle.splashFactory,
      cardColor: AppPalette.surface,
      dividerColor: AppPalette.glassBorder,
      textTheme: base.textTheme.apply(
        bodyColor: AppPalette.textPrimary,
        displayColor: AppPalette.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppPalette.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppPalette.glass,
        hintStyle: base.textTheme.bodyMedium?.copyWith(
          color: AppPalette.textMuted,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppPalette.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppPalette.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppPalette.accent),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: AppPalette.glass,
        side: const BorderSide(color: AppPalette.glassBorder),
        labelStyle: base.textTheme.labelLarge?.copyWith(
          color: AppPalette.textSecondary,
        ),
      ),
    );
  }
}

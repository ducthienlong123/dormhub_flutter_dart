import 'package:flutter/material.dart';

/// Centralized colors and component styling for the DormHub interface.
/// Keeping visual tokens here makes future branding changes predictable.
class AppColors {
  static const navy = Color(0xFF111D3A);
  static const navyLight = Color(0xFF1A3159);
  static const primary = Color(0xFF356AE6);
  static const primaryDark = Color(0xFF2455CB);
  static const primarySoft = Color(0xFFECF2FF);
  static const background = Color(0xFFF5F7FC);
  static const surface = Color(0xFFFFFFFF);
  static const text = Color(0xFF18243B);
  static const muted = Color(0xFF748199);
  static const border = Color(0xFFE4EAF3);
  static const green = Color(0xFF13845B);
  static const greenSoft = Color(0xFFE5F7EF);
  static const orange = Color(0xFFB96A0B);
  static const orangeSoft = Color(0xFFFFF3DE);
  static const red = Color(0xFFBB3E46);
  static const redSoft = Color(0xFFFFEDEF);
  static const purple = Color(0xFF7656D6);
  static const purpleSoft = Color(0xFFF0ECFF);
  static const teal = Color(0xFF0F8790);
  static const tealSoft = Color(0xFFE2F7F7);
}

class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.teal,
      surface: AppColors.surface,
      onSurface: AppColors.text,
      error: AppColors.red,
      outline: AppColors.border,
    );

    final roundedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Roboto',
      visualDensity: VisualDensity.standard,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.w800, letterSpacing: -0.7),
        headlineMedium: TextStyle(color: AppColors.text, fontWeight: FontWeight.w800, letterSpacing: -0.5),
        titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.w800),
        titleMedium: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(color: AppColors.text, fontSize: 14),
        bodyMedium: TextStyle(color: AppColors.text, fontSize: 13),
        bodySmall: TextStyle(color: AppColors.muted, fontSize: 12),
        labelLarge: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        toolbarHeight: 70,
        iconTheme: IconThemeData(color: AppColors.muted),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFBFCFE),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
        labelStyle: const TextStyle(color: AppColors.muted, fontSize: 13),
        prefixIconColor: AppColors.muted,
        suffixIconColor: AppColors.muted,
        border: roundedBorder,
        enabledBorder: roundedBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.red, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFDCE4F4),
          disabledForegroundColor: AppColors.muted,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ).copyWith(
          overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(.10)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        titleTextStyle: const TextStyle(color: AppColors.text, fontSize: 18, fontWeight: FontWeight.w800),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navy,
        contentTextStyle: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),
    );
  }
}

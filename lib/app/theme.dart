import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// SCAM INC. — Visual Design System & Theme Tokens
/// Clean modern corporate satire aesthetic (SaaS dashboard style).
abstract class AppColors {
  // Surface & Neutral Colors
  static const Color background = Color(0xFFF8FAFC); // Slate-50
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceMuted = Color(0xFFF1F5F9); // Slate-100
  static const Color surfaceHover = Color(0xFFE2E8F0); // Slate-200
  static const Color border = Color(0xFFE2E8F0); // Slate-200
  static const Color borderDark = Color(0xFFCBD5E1); // Slate-300

  // Text Hierarchy
  static const Color textPrimary = Color(0xFF0F172A); // Slate-900
  static const Color textSecondary = Color(0xFF475569); // Slate-600
  static const Color textMuted = Color(0xFF94A3B8); // Slate-400

  // Brand / Semantic Resource Colors
  static const Color sCoins = Color(0xFF10B981); // Emerald-500
  static const Color sCoinsDark = Color(0xFF059669); // Emerald-600
  static const Color sCoinsBg = Color(0xFFECFDF5); // Emerald-50

  static const Color trust = Color(0xFF3B82F6); // Blue-500
  static const Color trustDark = Color(0xFF2563EB); // Blue-600
  static const Color trustBg = Color(0xFFEFF6FF); // Blue-50

  static const Color heat = Color(0xFFF97316); // Orange-500
  static const Color heatDanger = Color(0xFFEF4444); // Red-500
  static const Color heatDark = Color(0xFFDC2626); // Red-600
  static const Color heatBg = Color(0xFFFFF7ED); // Orange-50

  static const Color launderedCash = Color(0xFF8B5CF6); // Violet-500
  static const Color launderedCashDark = Color(0xFF7C3AED); // Violet-600
  static const Color launderedCashBg = Color(0xFFF5F3FF); // Violet-50

  static const Color corporateNavy = Color(0xFF1E293B); // Slate-800
  static const Color corporateGold = Color(0xFFF59E0B); // Amber-500
}

abstract class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double pill = 999.0;
}

abstract class AppShadows {
  static List<BoxShadow> get card => [
    const BoxShadow(
      color: Color(0x0A0F172A),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
    const BoxShadow(
      color: Color(0x050F172A),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get elevated => [
    const BoxShadow(
      color: Color(0x140F172A),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];
}

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.corporateNavy,
        secondary: AppColors.sCoins,
        surface: AppColors.surface,
        error: AppColors.heatDanger,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
        labelSmall: baseTextTheme.labelSmall?.copyWith(
          color: AppColors.textMuted,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.border, width: 1.5),
        ),
      ),
    );
  }
}

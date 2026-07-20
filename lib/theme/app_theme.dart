import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../settings/preferences.dart';

class AppTheme {
  static const Color forest = Color(0xFF1F3D2B);
  static const Color moss = Color(0xFF3E6B4F);
  static const Color leather = Color(0xFF8B5E3C);
  static const Color sand = Color(0xFFF3EDE3);
  static const Color ink = Color(0xFF1A1A1A);

  static ThemeData lightFor(AppLanguage language) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: moss,
        primary: forest,
        secondary: leather,
        surface: sand,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F6F8),
    );

    final textTheme = language == AppLanguage.farsi
        ? GoogleFonts.vazirmatnTextTheme(base.textTheme)
        : GoogleFonts.literataTextTheme(base.textTheme);

    TextStyle titleStyle() => language == AppLanguage.farsi
        ? GoogleFonts.vazirmatn(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: forest,
          )
        : GoogleFonts.literata(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: forest,
          );

    TextStyle navStyle() => language == AppLanguage.farsi
        ? GoogleFonts.vazirmatn(fontSize: 12, fontWeight: FontWeight.w600)
        : GoogleFonts.literata(fontSize: 12, fontWeight: FontWeight.w600);

    TextStyle chipStyle() => language == AppLanguage.farsi
        ? GoogleFonts.vazirmatn(color: forest)
        : GoogleFonts.literata(color: forest);

    return base.copyWith(
      textTheme: textTheme.apply(bodyColor: ink, displayColor: forest),
      appBarTheme: AppBarTheme(
        backgroundColor: sand,
        foregroundColor: forest,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: titleStyle(),
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withValues(alpha: 0.92),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: forest.withValues(alpha: 0.08)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: forest.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: forest.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: moss, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: forest,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: forest,
          side: const BorderSide(color: forest),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white,
        selectedColor: moss.withValues(alpha: 0.2),
        labelStyle: chipStyle(),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: moss.withValues(alpha: 0.18),
        labelTextStyle: WidgetStatePropertyAll(navStyle()),
      ),
    );
  }
}

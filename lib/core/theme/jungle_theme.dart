import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JungleColors {
  static const canopy = Color(0xFF0D3B2E);
  static const vine = Color(0xFF1A5F4A);
  static const teal = Color(0xFF2E8B78);
  static const moss = Color(0xFF9FCB76);
  static const amber = Color(0xFFD4A017);
  static const bark = Color(0xFF171915);
  static const night = Color(0xFF07130F);
  static const mist = Color(0xFFE8F3DE);
  static const clay = Color(0xFFB66B45);
}

class JungleTheme {
  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: JungleColors.teal,
      brightness: Brightness.dark,
      primary: JungleColors.moss,
      secondary: JungleColors.amber,
      tertiary: JungleColors.clay,
      surface: JungleColors.bark,
    );

    final textTheme = GoogleFonts.outfitTextTheme(
      base.textTheme,
    ).apply(bodyColor: JungleColors.mist, displayColor: JungleColors.mist);

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: JungleColors.night,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: JungleColors.mist,
      ),
      cardTheme: CardThemeData(
        color: JungleColors.canopy.withValues(alpha: 0.72),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: JungleColors.canopy,
        selectedColor: JungleColors.amber,
        labelStyle: const TextStyle(color: JungleColors.mist),
        secondaryLabelStyle: const TextStyle(color: JungleColors.night),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: JungleColors.bark.withValues(alpha: 0.94),
        indicatorColor: JungleColors.teal.withValues(alpha: 0.34),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? JungleColors.moss
                : JungleColors.mist.withValues(alpha: 0.72),
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: JungleColors.amber,
          foregroundColor: JungleColors.night,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: JungleColors.canopy.withValues(alpha: 0.76),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: JungleColors.mist.withValues(alpha: 0.58)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JungleColors {
  static const ink = Color(0xFF080808);
  static const paper = Color(0xFFF3F0DF);
  static const concrete = Color(0xFFD9D4BF);
  static const acid = Color(0xFFC8FF2E);
  static const volt = Color(0xFF00E5FF);
  static const warning = Color(0xFFFF4D2E);
  static const violet = Color(0xFF8A5CFF);
  static const amber = Color(0xFFFFC400);
  static const steel = Color(0xFF202020);

  static const canopy = ink;
  static const vine = steel;
  static const teal = volt;
  static const moss = acid;
  static const bark = ink;
  static const night = paper;
  static const mist = ink;
  static const clay = warning;
}

class JungleTheme {
  static ThemeData dark() {
    final base = ThemeData.light(useMaterial3: true);
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: JungleColors.ink,
      onPrimary: JungleColors.paper,
      secondary: JungleColors.acid,
      onSecondary: JungleColors.ink,
      tertiary: JungleColors.volt,
      onTertiary: JungleColors.ink,
      error: JungleColors.warning,
      onError: JungleColors.paper,
      surface: JungleColors.paper,
      onSurface: JungleColors.ink,
      surfaceContainerHighest: JungleColors.concrete,
      onSurfaceVariant: JungleColors.ink,
      outline: JungleColors.ink,
    );

    final textTheme = GoogleFonts.outfitTextTheme(
      base.textTheme,
    ).apply(bodyColor: JungleColors.ink, displayColor: JungleColors.ink);

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: JungleColors.paper,
      textTheme: textTheme.copyWith(
        displaySmall: textTheme.displaySmall?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: JungleColors.paper,
        foregroundColor: JungleColors.ink,
        titleTextStyle: TextStyle(
          color: JungleColors.ink,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: JungleColors.paper,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: const BorderSide(color: JungleColors.ink, width: 3),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: JungleColors.paper,
        selectedColor: JungleColors.acid,
        disabledColor: JungleColors.concrete,
        labelStyle: const TextStyle(
          color: JungleColors.ink,
          fontWeight: FontWeight.w900,
        ),
        secondaryLabelStyle: const TextStyle(
          color: JungleColors.ink,
          fontWeight: FontWeight.w900,
        ),
        side: const BorderSide(color: JungleColors.ink, width: 2),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: JungleColors.ink,
        indicatorColor: JungleColors.acid,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? JungleColors.ink
                : JungleColors.paper,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected)
                ? JungleColors.acid
                : JungleColors.paper,
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 0,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: JungleColors.ink,
          foregroundColor: JungleColors.paper,
          minimumSize: const Size(48, 48),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          side: const BorderSide(color: JungleColors.ink, width: 3),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: JungleColors.ink,
          minimumSize: const Size(48, 48),
          side: const BorderSide(color: JungleColors.ink, width: 3),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: JungleColors.paper,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: JungleColors.ink, width: 3),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: JungleColors.ink, width: 3),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: JungleColors.violet, width: 4),
        ),
        hintStyle: const TextStyle(
          color: JungleColors.steel,
          fontWeight: FontWeight.w700,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: JungleColors.ink,
        linearTrackColor: JungleColors.concrete,
      ),
    );
  }
}

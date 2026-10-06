import 'package:flutter/material.dart';

// Tokens de telas/serene_wellness_metabolic_care/DESIGN.md
const _seed = Color(0xFF0F766E);

const _light = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF005C55),
  onPrimary: Colors.white,
  primaryContainer: Color(0xFF0F766E),
  onPrimaryContainer: Color(0xFFA3FAEF),
  primaryFixed: Color(0xFF9CF2E8),
  primaryFixedDim: Color(0xFF80D5CB),
  onPrimaryFixed: Color(0xFF00201D),
  secondary: Color(0xFF006B5F),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFF6DF5E1),
  onSecondaryContainer: Color(0xFF00504A),
  secondaryFixed: Color(0xFF71F8E4),
  onSecondaryFixed: Color(0xFF00201C),
  tertiary: Color(0xFF913200),
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFB94200),
  onTertiaryContainer: Color(0xFFFFE5DC),
  tertiaryFixed: Color(0xFFFFDBCE),
  onTertiaryFixedVariant: Color(0xFF7F2B00),
  error: Color(0xFFBA1A1A),
  onError: Colors.white,
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF93000A),
  surface: Color(0xFFFBF9F6),
  onSurface: Color(0xFF1B1C1A),
  onSurfaceVariant: Color(0xFF3E4947),
  surfaceDim: Color(0xFFDBDAD7),
  surfaceBright: Color(0xFFFBF9F6),
  surfaceContainerLowest: Colors.white,
  surfaceContainerLow: Color(0xFFF5F3F0),
  surfaceContainer: Color(0xFFEFEEEB),
  surfaceContainerHigh: Color(0xFFEAE8E5),
  surfaceContainerHighest: Color(0xFFE4E2DF),
  outline: Color(0xFF6E7977),
  outlineVariant: Color(0xFFBDC9C6),
  inverseSurface: Color(0xFF30312F),
  onInverseSurface: Color(0xFFF2F0ED),
  inversePrimary: Color(0xFF80D5CB),
  surfaceTint: Color(0xFF006A63),
);

final lightTheme = _build(_light);
final darkTheme = _build(ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark));

ThemeData _build(ColorScheme c) {
  const f = 'Manrope';
  final text = TextTheme(
    displayMedium: const TextStyle(fontSize: 38, height: 44 / 38, fontWeight: FontWeight.w700, letterSpacing: -1.1),
    headlineLarge: const TextStyle(fontSize: 26, height: 32 / 26, fontWeight: FontWeight.w600, letterSpacing: -0.4),
    headlineSmall: const TextStyle(fontSize: 20, height: 26 / 20, fontWeight: FontWeight.w600, letterSpacing: -0.2),
    titleMedium: const TextStyle(fontSize: 17, height: 24 / 17, fontWeight: FontWeight.w600),
    bodyLarge: const TextStyle(fontSize: 16, height: 24 / 16),
    bodyMedium: const TextStyle(fontSize: 14, height: 20 / 14),
    labelLarge: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    labelMedium: const TextStyle(fontSize: 13, height: 18 / 13, fontWeight: FontWeight.w500),
    labelSmall: const TextStyle(fontSize: 11, height: 14 / 11, fontWeight: FontWeight.w600, letterSpacing: 0.2),
  ).apply(fontFamily: f, bodyColor: c.onSurface, displayColor: c.onSurface);

  final pill = WidgetStatePropertyAll<OutlinedBorder>(const StadiumBorder());
  const minSize = WidgetStatePropertyAll(Size(48, 52));

  return ThemeData(
    useMaterial3: true,
    colorScheme: c,
    fontFamily: f,
    textTheme: text,
    scaffoldBackgroundColor: c.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: c.surface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: text.titleMedium,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: c.surfaceContainerLowest,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: c.primary.withValues(alpha: 0.08)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(shape: pill, minimumSize: minSize, textStyle: WidgetStatePropertyAll(text.titleMedium)),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(shape: pill, minimumSize: minSize, textStyle: WidgetStatePropertyAll(text.titleMedium)),
    ),
    textButtonTheme: TextButtonThemeData(style: ButtonStyle(minimumSize: const WidgetStatePropertyAll(Size(48, 48)))),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surfaceContainerLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c.primary, width: 1.5),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: StadiumBorder(side: BorderSide(color: c.outline.withValues(alpha: 0.3))),
      selectedColor: c.primary,
      backgroundColor: c.surfaceContainerLowest,
      labelStyle: WidgetStateTextStyle.resolveWith(
        (s) => text.labelMedium!.copyWith(color: s.contains(WidgetState.selected) ? c.onPrimary : c.onSurfaceVariant),
      ),
      showCheckmark: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: c.surface,
      indicatorColor: c.secondaryContainer.withValues(alpha: 0.5),
      labelTextStyle: WidgetStatePropertyAll(text.labelSmall),
    ),
  );
}

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
  onPrimaryFixedVariant: Color(0xFF00504A),
  secondary: Color(0xFF006B5F),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFF6DF5E1),
  onSecondaryContainer: Color(0xFF00504A),
  secondaryFixed: Color(0xFF71F8E4),
  secondaryFixedDim: Color(0xFF4FDBC8),
  onSecondaryFixedVariant: Color(0xFF005048),
  onSecondaryFixed: Color(0xFF00201C),
  tertiary: Color(0xFF913200),
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFB94200),
  onTertiaryContainer: Color(0xFFFFE5DC),
  tertiaryFixed: Color(0xFFFFDBCE),
  tertiaryFixedDim: Color(0xFFFFB599),
  onTertiaryFixed: Color(0xFF370E00),
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

/// Escala tipográfica do DESIGN.md (Tailwind do Stitch). letterSpacing em px = em × fontSize.
///  displaySmall=display-lg · displayMedium=metric-display · headlineLarge=headline-lg · headlineSmall=headline-sm
///  titleMedium=title-md · titleSmall=metric-label · bodyLarge=body-lg · bodyMedium=body-md
///  labelMedium=label-md · labelSmall=label-sm
ThemeData _build(ColorScheme c) {
  const f = 'Manrope';
  final text = const TextTheme(
    displaySmall: TextStyle(fontSize: 34, height: 40 / 34, fontWeight: FontWeight.w700, letterSpacing: -0.68),
    displayMedium: TextStyle(fontSize: 38, height: 44 / 38, fontWeight: FontWeight.w700, letterSpacing: -1.14),
    headlineLarge: TextStyle(fontSize: 26, height: 32 / 26, fontWeight: FontWeight.w600, letterSpacing: -0.39),
    headlineSmall: TextStyle(fontSize: 20, height: 26 / 20, fontWeight: FontWeight.w600, letterSpacing: -0.2),
    titleMedium: TextStyle(fontSize: 17, height: 24 / 17, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontSize: 13, height: 18 / 13, fontWeight: FontWeight.w600, letterSpacing: 0.52),
    bodyLarge: TextStyle(fontSize: 16, height: 24 / 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(fontSize: 17, height: 24 / 17, fontWeight: FontWeight.w600),
    labelMedium: TextStyle(fontSize: 13, height: 18 / 13, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontSize: 11, height: 14 / 11, fontWeight: FontWeight.w600, letterSpacing: 0.22),
  ).apply(fontFamily: f, bodyColor: c.onSurface, displayColor: c.onSurface);

  // Botões: h-[52px], rounded-full, title-md.
  ButtonStyle pill(Color bg, Color fg) => ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.disabled) ? bg.withValues(alpha: 0.4) : bg),
        foregroundColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.disabled) ? fg.withValues(alpha: 0.8) : fg),
        shape: const WidgetStatePropertyAll(StadiumBorder()),
        minimumSize: const WidgetStatePropertyAll(Size(48, 52)),
        elevation: const WidgetStatePropertyAll(0),
        textStyle: WidgetStatePropertyAll(text.titleMedium),
        iconSize: const WidgetStatePropertyAll(20),
      );
  final none = OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none);

  return ThemeData(
    useMaterial3: true,
    colorScheme: c,
    fontFamily: f,
    textTheme: text,
    scaffoldBackgroundColor: c.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: c.surface.withValues(alpha: 0.85),
      surfaceTintColor: Colors.transparent,
      titleTextStyle: text.titleMedium,
      toolbarHeight: 64,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: c.surfaceContainerLowest,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    filledButtonTheme: FilledButtonThemeData(style: pill(c.primary, c.onPrimary)),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: pill(c.surfaceContainer, c.primary).copyWith(side: const WidgetStatePropertyAll(BorderSide.none)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll(Size(48, 48)),
        textStyle: WidgetStatePropertyAll(text.labelMedium!.copyWith(fontWeight: FontWeight.w600)),
      ),
    ),
    // Inputs: h-[52px], rounded-2xl, bg surface-container-low, sem borda; foco = bg surface-container.
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: c.surfaceContainerLow,
      hintStyle: text.bodyLarge!.copyWith(color: c.outline.withValues(alpha: 0.7)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: none,
      enabledBorder: none,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c.primary, width: 1.5),
      ),
    ),
    switchTheme: SwitchThemeData(
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      thumbColor: const WidgetStatePropertyAll(Colors.white),
      trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.primary : c.surfaceContainerHighest),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      side: BorderSide.none,
      fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? c.primaryContainer : c.surfaceContainerHigh),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: c.primaryContainer,
      linearTrackColor: c.surfaceContainer,
      circularTrackColor: c.surfaceContainer,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: c.surfaceContainerLowest,
      dragHandleColor: c.surfaceContainerHighest,
      dragHandleSize: const Size(48, 6),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: c.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}

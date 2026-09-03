// SIMATS ONE – MaterialApp ThemeData
// Translates Stitch design tokens into Flutter Material 3 theme

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'simats_colors.dart';
import 'simats_text_styles.dart';
import 'simats_spacing.dart';

abstract final class SimatsTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme,
    textTheme: _textTheme,
    appBarTheme: _appBarTheme,
    cardTheme: _cardTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
    chipTheme: _chipTheme,
    bottomNavigationBarTheme: _bottomNavTheme,
    navigationBarTheme: _navigationBarTheme,
    dividerTheme: const DividerThemeData(
      color: SimatsColors.outlineVariant,
      thickness: 1,
    ),
    scaffoldBackgroundColor: SimatsColors.surface,
    fontFamily: 'Inter',
  );

  // ── Color Scheme ────────────────────────────────────────────────────────────
  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: SimatsColors.primary,
    onPrimary: SimatsColors.onPrimary,
    primaryContainer: SimatsColors.primaryContainer,
    onPrimaryContainer: SimatsColors.onPrimaryContainer,
    secondary: SimatsColors.secondary,
    onSecondary: SimatsColors.onSecondary,
    secondaryContainer: SimatsColors.secondaryContainer,
    onSecondaryContainer: SimatsColors.onSecondaryContainer,
    tertiary: SimatsColors.tertiary,
    onTertiary: SimatsColors.onTertiary,
    tertiaryContainer: SimatsColors.tertiaryContainer,
    onTertiaryContainer: SimatsColors.onTertiaryContainer,
    error: SimatsColors.error,
    onError: SimatsColors.onError,
    errorContainer: SimatsColors.errorContainer,
    onErrorContainer: SimatsColors.onErrorContainer,
    surface: SimatsColors.surface,
    onSurface: SimatsColors.onSurface,
    surfaceContainerHighest: SimatsColors.surfaceContainerHighest,
    surfaceContainerHigh: SimatsColors.surfaceContainerHigh,
    surfaceContainer: SimatsColors.surfaceContainer,
    surfaceContainerLow: SimatsColors.surfaceContainerLow,
    surfaceContainerLowest: SimatsColors.surfaceContainerLowest,
    onSurfaceVariant: SimatsColors.onSurfaceVariant,
    outline: SimatsColors.outline,
    outlineVariant: SimatsColors.outlineVariant,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: SimatsColors.inverseSurface,
    onInverseSurface: SimatsColors.inverseOnSurface,
    inversePrimary: SimatsColors.inversePrimary,
  );

  // ── Text Theme ───────────────────────────────────────────────────────────────
  static const TextTheme _textTheme = TextTheme(
    displayLarge: SimatsTextStyles.displayLg,
    headlineLarge: SimatsTextStyles.headlineLg,
    headlineMedium: SimatsTextStyles.headlineMd,
    headlineSmall: SimatsTextStyles.headlineSm,
    titleMedium: SimatsTextStyles.titleMd,
    bodyLarge: SimatsTextStyles.bodyLg,
    bodyMedium: SimatsTextStyles.bodyMd,
    bodySmall: SimatsTextStyles.bodySm,
    labelLarge: SimatsTextStyles.labelLg,
    labelMedium: SimatsTextStyles.labelMd,
    labelSmall: SimatsTextStyles.labelSm,
  );

  // ── AppBar ──────────────────────────────────────────────────────────────────
  static const AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: SimatsColors.surface,
    foregroundColor: SimatsColors.onSurface,
    elevation: 0,
    scrolledUnderElevation: 1,
    surfaceTintColor: SimatsColors.surfaceTint,
    titleTextStyle: TextStyle(
      fontFamily: 'Inter',
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: SimatsColors.primary,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // ── Card ────────────────────────────────────────────────────────────────────
  static final CardThemeData _cardTheme = CardThemeData(
    color: SimatsColors.surfaceContainerLowest,
    elevation: SimatsElevation.level1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(SimatsRadius.xl),
      side: const BorderSide(color: SimatsColors.outlineVariant, width: 1),
    ),
    margin: EdgeInsets.zero,
  );

  // ── Buttons ─────────────────────────────────────────────────────────────────
  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SimatsColors.primary,
          foregroundColor: SimatsColors.onPrimary,
          minimumSize: const Size(double.infinity, SimatsSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SimatsRadius.lg),
          ),
          elevation: SimatsElevation.level1,
          textStyle: SimatsTextStyles.labelLg,
        ),
      );

  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SimatsColors.primary,
          minimumSize: const Size(double.infinity, SimatsSpacing.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SimatsRadius.lg),
          ),
          side: const BorderSide(color: SimatsColors.outlineVariant),
          textStyle: SimatsTextStyles.labelLg,
        ),
      );

  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: SimatsColors.secondary,
      textStyle: SimatsTextStyles.labelLg,
      minimumSize: const Size(0, SimatsSpacing.minTouchTarget),
    ),
  );

  // ── Input Decoration ────────────────────────────────────────────────────────
  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
        filled: true,
        fillColor: SimatsColors.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: SimatsSpacing.spaceBase,
          vertical: SimatsSpacing.spaceMd,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SimatsRadius.lg),
          borderSide: const BorderSide(color: SimatsColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SimatsRadius.lg),
          borderSide: const BorderSide(color: SimatsColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SimatsRadius.lg),
          borderSide: const BorderSide(color: SimatsColors.secondary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SimatsRadius.lg),
          borderSide: const BorderSide(color: SimatsColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SimatsRadius.lg),
          borderSide: const BorderSide(color: SimatsColors.error, width: 2),
        ),
        hintStyle: SimatsTextStyles.bodyMd.copyWith(
          color: SimatsColors.outline,
        ),
        labelStyle: SimatsTextStyles.labelLg,
        errorStyle: SimatsTextStyles.bodySm.copyWith(color: SimatsColors.error),
        helperStyle: SimatsTextStyles.bodySm,
        isDense: true,
        constraints: const BoxConstraints(minHeight: SimatsSpacing.inputHeight),
      );

  // ── Chip ─────────────────────────────────────────────────────────────────────
  static final ChipThemeData _chipTheme = ChipThemeData(
    backgroundColor: SimatsColors.surfaceContainer,
    labelStyle: SimatsTextStyles.labelMd,
    padding: const EdgeInsets.symmetric(
      horizontal: SimatsSpacing.spaceSm,
      vertical: SimatsSpacing.spaceXs,
    ),
    shape: const StadiumBorder(),
    side: BorderSide.none,
  );

  // ── Bottom Navigation ────────────────────────────────────────────────────────
  static const BottomNavigationBarThemeData _bottomNavTheme =
      BottomNavigationBarThemeData(
        backgroundColor: SimatsColors.surface,
        selectedItemColor: SimatsColors.onPrimary,
        unselectedItemColor: SimatsColors.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      );

  static final NavigationBarThemeData _navigationBarTheme =
      NavigationBarThemeData(
        backgroundColor: SimatsColors.surface,
        indicatorColor: SimatsColors.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: SimatsColors.onPrimary);
          }
          return const IconThemeData(color: SimatsColors.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return SimatsTextStyles.labelSm.copyWith(
              color: SimatsColors.primary,
              fontWeight: FontWeight.w700,
            );
          }
          return SimatsTextStyles.labelSm;
        }),
        height: SimatsSpacing.bottomNavHeight,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      );
}

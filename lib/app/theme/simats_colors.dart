// SIMATS ONE – Design Token Colors
// Extracted directly from Google Stitch project: "SIMATS ONE Smart Campus Suite"
// Project ID: projects/3267581437947747698
// Color mode: LIGHT | Font: INTER | Corporate Navy palette

import 'package:flutter/material.dart';

abstract final class SimatsColors {
  // ── Primary (Deep Navy) ────────────────────────────────────────────────────
  static const Color primary = Color(0xFF00102D);
  static const Color primaryContainer = Color(0xFF0F254A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF7A8DB8);
  static const Color inversePrimary = Color(0xFFB3C6F4);
  static const Color primaryFixed = Color(0xFFD8E2FF);
  static const Color primaryFixedDim = Color(0xFFB3C6F4);
  static const Color onPrimaryFixed = Color(0xFF021A3F);
  static const Color onPrimaryFixedVariant = Color(0xFF33466D);

  // ── Secondary (Royal Blue) ─────────────────────────────────────────────────
  static const Color secondary = Color(0xFF3755C3);
  static const Color secondaryContainer = Color(0xFF708CFD);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF00217A);
  static const Color secondaryFixed = Color(0xFFDDE1FF);
  static const Color secondaryFixedDim = Color(0xFFB8C4FF);
  static const Color onSecondaryFixed = Color(0xFF001453);
  static const Color onSecondaryFixedVariant = Color(0xFF173BAB);

  // ── Tertiary (Indigo) ──────────────────────────────────────────────────────
  static const Color tertiary = Color(0xFF08004B);
  static const Color tertiaryContainer = Color(0xFF160087);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF817DFF);
  static const Color tertiaryFixed = Color(0xFFE2DFFF);
  static const Color tertiaryFixedDim = Color(0xFFC3C0FF);
  static const Color onTertiaryFixed = Color(0xFF0F0069);
  static const Color onTertiaryFixedVariant = Color(0xFF3323CC);

  // ── Surface ────────────────────────────────────────────────────────────────
  static const Color surface = Color(0xFFF8F9FF);
  static const Color surfaceBright = Color(0xFFF8F9FF);
  static const Color surfaceDim = Color(0xFFCBDBF5);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color surfaceContainer = Color(0xFFE5EEFF);
  static const Color surfaceContainerHigh = Color(0xFFDCE9FF);
  static const Color surfaceContainerHighest = Color(0xFFD3E4FE);
  static const Color surfaceVariant = Color(0xFFD3E4FE);
  static const Color onSurface = Color(0xFF0B1C30);
  static const Color onSurfaceVariant = Color(0xFF44474E);
  static const Color inverseSurface = Color(0xFF213145);
  static const Color inverseOnSurface = Color(0xFFEAF1FF);
  static const Color surfaceTint = Color(0xFF4B5E86);
  static const Color background = Color(0xFFF8F9FF);
  static const Color onBackground = Color(0xFF0B1C30);

  // ── Error ──────────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // ── Outline ────────────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF75777F);
  static const Color outlineVariant = Color(0xFFC5C6CF);

  // ── Status / Semantic (institutional design system) ────────────────────────
  static const Color statusSuccess = Color(0xFF10B981);
  static const Color statusSuccessContainer = Color(0xFFECFDF5);
  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color statusWarningContainer = Color(0xFFFFFBEB);
  static const Color statusDanger = Color(0xFFEF4444);
  static const Color statusDangerContainer = Color(0xFFFEF2F2);
  static const Color statusInfo = Color(0xFF3B82F6);
  static const Color statusInfoContainer = Color(0xFFEFF6FF);
  static const Color statusOffline = Color(0xFF64748B);
  static const Color statusOfflineContainer = Color(0xFFF1F5F9);

  // ── Alert Severity ─────────────────────────────────────────────────────────
  static const Color alertCritical = Color(0xFFBA1A1A);
  static const Color alertCriticalContainer = Color(0xFFFFDAD6);
  static const Color alertHigh = Color(0xFFEF4444);
  static const Color alertHighContainer = Color(0xFFFEF2F2);
  static const Color alertMedium = Color(0xFFF59E0B);
  static const Color alertMediumContainer = Color(0xFFFFFBEB);
  static const Color alertLow = Color(0xFF3B82F6);
  static const Color alertLowContainer = Color(0xFFEFF6FF);

  // ── Timetable Class Type Accents ───────────────────────────────────────────
  static const Color classLecture = Color(0xFF3755C3); // secondary
  static const Color classLab = Color(0xFF08004B); // tertiary
  static const Color classSeminar = Color(0xFF10B981); // success
  static const Color classTutorial = Color(0xFF4B5E86); // surface-tint
}

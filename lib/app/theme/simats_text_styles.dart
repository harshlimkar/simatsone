// SIMATS ONE – Typography System
// Source: Google Stitch "SIMATS ONE Smart Campus Suite"
// Font: Inter (400/600/700) – corporate, high-density legibility
// Tabular figures enabled for all numeric displays

import 'package:flutter/material.dart';
import 'simats_colors.dart';

abstract final class SimatsTextStyles {
  // ── Display ────────────────────────────────────────────────────────────────
  static const TextStyle displayLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: -0.64, // -0.02em
    color: SimatsColors.onSurface,
  );

  // ── Headline ───────────────────────────────────────────────────────────────
  static const TextStyle headlineLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 26,
    fontWeight: FontWeight.w700,
    height: 32 / 26,
    letterSpacing: -0.39, // -0.015em
    color: SimatsColors.primary,
  );

  static const TextStyle headlineMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
    letterSpacing: -0.20, // -0.01em
    color: SimatsColors.onSurface,
  );

  static const TextStyle headlineSm = TextStyle(
    fontFamily: 'Inter',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    letterSpacing: 0,
    color: SimatsColors.primary,
  );

  // ── Title ──────────────────────────────────────────────────────────────────
  static const TextStyle titleMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 22 / 16,
    letterSpacing: 0,
    color: SimatsColors.primary,
  );

  // ── Body ───────────────────────────────────────────────────────────────────
  static const TextStyle bodyLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    letterSpacing: 0,
    color: SimatsColors.onSurface,
  );

  static const TextStyle bodyMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0,
    color: SimatsColors.onSurface,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0.12, // 0.01em
    color: SimatsColors.onSurfaceVariant,
  );

  // ── Label ──────────────────────────────────────────────────────────────────
  static const TextStyle labelLg = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.14, // 0.01em
    color: SimatsColors.onSurface,
  );

  static const TextStyle labelMd = TextStyle(
    fontFamily: 'Inter',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.24, // 0.02em
    color: SimatsColors.onSurface,
  );

  static const TextStyle labelSm = TextStyle(
    fontFamily: 'Inter',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 14 / 11,
    letterSpacing: 0.44, // 0.04em
    color: SimatsColors.onSurfaceVariant,
  );

  // ── Code / Numeric (tabular figures) ──────────────────────────────────────
  /// Use for: attendance %, marks, GPA, register numbers, time schedules
  static const TextStyle codeNum = TextStyle(
    fontFamily: 'Inter',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 18 / 14,
    letterSpacing: 0.28, // 0.02em
    fontFeatures: [FontFeature.tabularFigures()],
    color: SimatsColors.onSurfaceVariant,
  );

  // ── Convenience overrides ─────────────────────────────────────────────────
  static TextStyle headlineLgPrimary = headlineLg.copyWith(
    color: SimatsColors.primary,
  );

  static TextStyle labelSmUppercase = labelSm.copyWith(
    letterSpacing: 0.88, // 0.08em for uppercase labels
  );
}

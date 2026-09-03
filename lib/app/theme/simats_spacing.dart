// SIMATS ONE – Spacing & Shape Tokens
// Source: Google Stitch "SIMATS ONE Smart Campus Suite"
// Grid: 8-point geometric (4px half-steps for micro-components)

abstract final class SimatsSpacing {
  // ── Base Scale ─────────────────────────────────────────────────────────────
  static const double space2xs = 2.0; // 0.125rem
  static const double spaceXs = 4.0; // 0.25rem
  static const double spaceSm = 8.0; // 0.5rem
  static const double spaceMd = 12.0; // 0.75rem
  static const double spaceBase = 16.0; // 1rem – standard card padding
  static const double spaceLg = 20.0; // 1.25rem
  static const double spaceXl = 24.0; // 1.5rem
  static const double space2xl = 32.0; // 2rem
  static const double space3xl = 48.0; // 3rem

  // ── Layout ────────────────────────────────────────────────────────────────
  static const double marginMobile = 16.0; // horizontal screen inset < 600px
  static const double marginTablet = 24.0; // horizontal screen inset 600–1024px
  static const double gutter = 12.0; // vertical component gap

  // ── Touch Targets ─────────────────────────────────────────────────────────
  static const double minTouchTarget = 48.0; // WCAG 2.5.5 – absolute minimum
  static const double inputHeight = 48.0;
  static const double buttonHeight = 48.0;
  static const double appBarHeight = 80.0;
  static const double bottomNavHeight = 64.0;
}

abstract final class SimatsRadius {
  static const double sm = 4.0; // 0.25rem – badges, small chips
  static const double md = 8.0; // 0.5rem  – inputs, buttons
  static const double lg = 12.0; // 0.75rem – form elements
  static const double xl = 16.0; // 1rem    – cards, modals (PRIMARY)
  static const double xxl = 20.0; // 1.25rem – bottom sheets (top only)
  static const double full = 9999.0; // pill shape – chips, badges, pills
}

abstract final class SimatsElevation {
  // Ambient navy-tinted shadows – no heavy drops (institutional aesthetic)
  // Level 0: flat canvas
  // Level 1: cards/containers
  // Level 2: interactive hover cards
  // Level 3: app bar / sticky nav
  // Level 4: bottom sheet / FAB

  static const double level0 = 0;
  static const double level1 = 1;
  static const double level2 = 2;
  static const double level3 = 4;
  static const double level4 = 8;
}

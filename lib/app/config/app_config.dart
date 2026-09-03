// SIMATS ONE – App Configuration & Feature Flags
// Loaded from .env at startup via flutter_dotenv

import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class AppConfig {
  // ── Environment ─────────────────────────────────────────────────────────────
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';

  // ── API ─────────────────────────────────────────────────────────────────────
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.simatsone.edu.in/api/v1';
  static String get wsBaseUrl =>
      dotenv.env['WS_BASE_URL'] ?? 'wss://api.simatsone.edu.in/ws';

  // ── Attendance Thresholds ────────────────────────────────────────────────────
  static double get attendanceWarningThreshold =>
      double.tryParse(dotenv.env['ATTENDANCE_WARNING_THRESHOLD'] ?? '85') ??
      85.0;
  static double get attendanceCriticalThreshold =>
      double.tryParse(dotenv.env['ATTENDANCE_CRITICAL_THRESHOLD'] ?? '75') ??
      75.0;

  // ── Session ──────────────────────────────────────────────────────────────────
  static int get tokenExpiryBufferSeconds =>
      int.tryParse(dotenv.env['TOKEN_EXPIRY_BUFFER_SECONDS'] ?? '60') ?? 60;
  static int get sessionTimeoutMinutes =>
      int.tryParse(dotenv.env['SESSION_TIMEOUT_MINUTES'] ?? '480') ?? 480;

  // ── Feature Flags ────────────────────────────────────────────────────────────
  static bool get enableAnalytics =>
      dotenv.env['ENABLE_ANALYTICS']?.toLowerCase() == 'true';
  static bool get enableRealTimeAlerts =>
      dotenv.env['ENABLE_REAL_TIME_ALERTS']?.toLowerCase() != 'false';
  static bool get enableOfflineSync =>
      dotenv.env['ENABLE_OFFLINE_SYNC']?.toLowerCase() != 'false';
  static bool get enableLibrary =>
      dotenv.env['ENABLE_LIBRARY']?.toLowerCase() != 'false';
  static bool get enableNavigation =>
      dotenv.env['ENABLE_NAVIGATION']?.toLowerCase() != 'false';

  // ── Map Provider ─────────────────────────────────────────────────────────────
  static String get mapProvider =>
      dotenv.env['MAP_PROVIDER'] ?? 'openstreetmap';
}

/// Compile-time feature flags (can override at runtime for gradual rollout)
abstract final class FeatureFlags {
  static const bool attendance = true;
  static const bool securityAlerts = true;
  static const bool library = true;
  static const bool navigation = true;
  static const bool events = true;
  static const bool announcements = true;
  static const bool research = true;
  static const bool centres = true;
  static const bool realTimeAlerts = true;
  static const bool offlineSync = true;
  static const bool facultyPortal = true;
  static const bool securityAdmin = true;
}

/// App-wide constants
abstract final class AppConstants {
  // ── Institutional ────────────────────────────────────────────────────────────
  static const String institutionName = 'SIMATS Engineering';
  static const String institutionFullName =
      'Saveetha Institute of Medical and Technical Sciences';
  static const String institutionAddress =
      'Saveetha Nagar, Thandalam, Chennai – 602105, Tamil Nadu, India';
  static const String institutionPhone = '+91 893 999 4247';
  static const String institutionEmail = 'enggadmission@saveetha.com';
  static const String institutionWebsite = 'https://simatsengineering.com';
  static const String institutionTagline = 'Engineer to Excel';
  static const String institutionAccreditation =
      'AICTE | NAAC A++ | NIRF Rank 46';

  // ── App ───────────────────────────────────────────────────────────────────────
  static const String appName = 'SIMATS ONE';
  static const String appTagline =
      'One Campus. One App. One Connected Experience.';
  static const String appVersion = '1.0.0';

  // ── Library ──────────────────────────────────────────────────────────────────
  static const String libraryName = 'SAIL';
  static const String libraryFullName = 'Saveetha Academic Infotech Library';

  // ── Network ──────────────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
  static const Duration syncInterval = Duration(minutes: 5);
  static const int alertRetentionDays = 30;

  // ── Deep Links ───────────────────────────────────────────────────────────────
  static const String deepLinkScheme = 'simatsone';
  static const String universalLinkHost = 'app.simatsone.edu.in';

  // ── Logging Tags ─────────────────────────────────────────────────────────────
  static const String tagAuth = '[AUTH]';
  static const String tagNetwork = '[NETWORK]';
  static const String tagSync = '[SYNC]';
  static const String tagAttendance = '[ATTENDANCE]';
  static const String tagAlert = '[ALERT]';
  static const String tagLocation = '[LOCATION]';
  static const String tagLibrary = '[LIBRARY]';
  static const String tagDb = '[DB]';
}

// SIMATS ONE – Domain Entities
// Core domain models used across the entire application

// ── Enums ────────────────────────────────────────────────────────────────────

enum UserRole {
  student,
  faculty,
  securityAdmin,
  superAdmin;

  String get displayName => switch (this) {
    UserRole.student => 'Student',
    UserRole.faculty => 'Faculty',
    UserRole.securityAdmin => 'Security Admin',
    UserRole.superAdmin => 'Super Admin',
  };
}

enum AlertSeverity {
  critical,
  high,
  medium,
  low;

  String get displayName => switch (this) {
    AlertSeverity.critical => 'CRITICAL',
    AlertSeverity.high => 'HIGH',
    AlertSeverity.medium => 'MEDIUM',
    AlertSeverity.low => 'LOW',
  };
}

enum AlertCategory {
  emergency,
  security,
  weather,
  academic,
  information;

  String get displayName => switch (this) {
    AlertCategory.emergency => 'Emergency',
    AlertCategory.security => 'Security',
    AlertCategory.weather => 'Weather',
    AlertCategory.academic => 'Academic',
    AlertCategory.information => 'Information',
  };

  String get iconName => switch (this) {
    AlertCategory.emergency => 'emergency_home',
    AlertCategory.security => 'shield',
    AlertCategory.weather => 'thunderstorm',
    AlertCategory.academic => 'school',
    AlertCategory.information => 'info',
  };
}

enum AlertStatus { active, acknowledged, resolved, expired }

enum NetworkStatus {
  connectedWifi,
  connectedMobile,
  connectedEthernet,
  noInternet,
  unknown;

  String get displayLabel => switch (this) {
    NetworkStatus.connectedWifi => 'Wi-Fi',
    NetworkStatus.connectedMobile => '5G/4G',
    NetworkStatus.connectedEthernet => 'Ethernet',
    NetworkStatus.noInternet => 'Offline',
    NetworkStatus.unknown => 'Unknown',
  };

  bool get isConnected =>
      this != NetworkStatus.noInternet && this != NetworkStatus.unknown;
}

enum ClassType {
  lecture,
  lab,
  seminar,
  tutorial;

  String get displayName => switch (this) {
    ClassType.lecture => 'Lecture',
    ClassType.lab => 'Laboratory',
    ClassType.seminar => 'Seminar',
    ClassType.tutorial => 'Tutorial',
  };
}

enum SyncStatus { pending, syncing, synced, failed }

enum EventCategory {
  hackathon,
  workshop,
  conference,
  seminar,
  industry,
  studentActivity,
  research;

  String get displayName => switch (this) {
    EventCategory.hackathon => 'Hackathon',
    EventCategory.workshop => 'Workshop',
    EventCategory.conference => 'Conference',
    EventCategory.seminar => 'Seminar',
    EventCategory.industry => 'Industry',
    EventCategory.studentActivity => 'Student Activity',
    EventCategory.research => 'Research',
  };
}

enum AnnouncementCategory {
  all,
  academic,
  examination,
  department,
  events,
  emergency,
  system;

  String get displayName => switch (this) {
    AnnouncementCategory.all => 'All',
    AnnouncementCategory.academic => 'Academic',
    AnnouncementCategory.examination => 'Examination',
    AnnouncementCategory.department => 'Department',
    AnnouncementCategory.events => 'Events',
    AnnouncementCategory.emergency => 'Emergency',
    AnnouncementCategory.system => 'System',
  };
}

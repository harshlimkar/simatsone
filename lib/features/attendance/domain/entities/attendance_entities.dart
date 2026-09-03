import "../../../../shared/models/enums.dart";

class AttendanceSummary {
  const AttendanceSummary({
    required this.studentId,
    required this.semester,
    required this.courses,
    required this.lastUpdated,
  });
  final String studentId;
  final int semester;
  final List<CourseAttendance> courses;
  final DateTime lastUpdated;
  double get overallPercentage {
    if (courses.isEmpty) return 0;
    final total = courses.fold(0, (s, c) => s + c.totalClasses);
    final present = courses.fold(0, (s, c) => s + c.presentCount);
    return total == 0 ? 0 : (present / total) * 100;
  }

  List<CourseAttendance> get belowWarning =>
      courses.where((c) => c.percentage < 85).toList();
  List<CourseAttendance> get belowCritical =>
      courses.where((c) => c.percentage < 75).toList();
}

class CourseAttendance {
  const CourseAttendance({
    required this.courseId,
    required this.courseName,
    required this.courseCode,
    required this.presentCount,
    required this.absentCount,
    required this.totalClasses,
    required this.lastUpdated,
    this.syncStatus = SyncStatus.synced,
  });
  final String courseId, courseName, courseCode;
  final int presentCount, absentCount, totalClasses;
  final DateTime lastUpdated;
  final SyncStatus syncStatus;
  double get percentage =>
      totalClasses == 0 ? 0 : (presentCount / totalClasses) * 100;
  bool get isBelowWarning => percentage < 85;
  bool get isBelowCritical => percentage < 75;
  String get percentageStr => "${percentage.toStringAsFixed(1)}%";
}

abstract interface class AttendanceRepository {
  Future<AttendanceSummary> getAttendanceSummary(String studentId);
  Future<List<CourseAttendance>> getCourseAttendance(String studentId);
  Future<void> syncAttendance(String studentId);
}

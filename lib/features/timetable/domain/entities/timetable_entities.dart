import '../../../../shared/models/enums.dart';

class TimetableItem {
  const TimetableItem({
    required this.id,
    required this.courseCode,
    required this.courseTitle,
    required this.facultyName,
    required this.roomLocation,
    required this.startTime,
    required this.endTime,
    required this.dayOfWeek,
    this.classType = ClassType.lecture,
    this.isLive = false,
    this.remainingMinutes,
    this.slotBadgeText,
  });

  final String id;
  final String courseCode;
  final String courseTitle;
  final String facultyName;
  final String roomLocation;
  final String startTime;
  final String endTime;
  final int dayOfWeek; // 1 = Mon, 5 = Fri
  final ClassType classType;
  final bool isLive;
  final int? remainingMinutes;
  final String? slotBadgeText;

  String get timeRange => '$startTime - $endTime';
}

abstract interface class TimetableRepository {
  Future<List<TimetableItem>> getTodaySchedule();
  Future<List<TimetableItem>> getWeeklySchedule(int dayOfWeek);
}

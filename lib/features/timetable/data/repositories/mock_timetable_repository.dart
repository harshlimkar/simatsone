import '../../../../shared/models/enums.dart';
import '../../domain/entities/timetable_entities.dart';

class MockTimetableRepository implements TimetableRepository {
  @override
  Future<List<TimetableItem>> getTodaySchedule() async {
    return [
      const TimetableItem(
        id: 'tt_001',
        courseCode: 'CS304',
        courseTitle: 'Mobile Computing & Wireless Comm',
        facultyName: 'Dr. S. K. Narayanan • Senior Professor',
        roomLocation: 'CSE Block • Room 204',
        startTime: '10:00 AM',
        endTime: '11:30 AM',
        dayOfWeek: 5,
        classType: ClassType.lecture,
        isLive: true,
        remainingMinutes: 42,
      ),
      const TimetableItem(
        id: 'tt_002',
        courseCode: 'CS305',
        courseTitle: 'Compiler Design Laboratory',
        facultyName: 'Prof. Meenakshi Sundaram',
        roomLocation:
            'Turing Lab 3 • Ground Floor (Workstation Allocation Confirmed)',
        startTime: '11:45 AM',
        endTime: '01:15 PM',
        dayOfWeek: 5,
        classType: ClassType.lab,
        slotBadgeText: 'Next Up',
      ),
      const TimetableItem(
        id: 'tt_003',
        courseCode: 'CS306',
        courseTitle: 'Machine Learning Applications',
        facultyName: 'Dr. K. Vignesh',
        roomLocation: 'Engineering Auditorium B',
        startTime: '02:00 PM',
        endTime: '03:30 PM',
        dayOfWeek: 5,
        classType: ClassType.lecture,
        slotBadgeText: 'Afternoon Slot',
      ),
    ];
  }

  @override
  Future<List<TimetableItem>> getWeeklySchedule(int dayOfWeek) async {
    return getTodaySchedule();
  }
}

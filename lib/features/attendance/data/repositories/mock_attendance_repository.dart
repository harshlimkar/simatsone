import '../../domain/entities/attendance_entities.dart';

class MockAttendanceRepository implements AttendanceRepository {
  @override
  Future<AttendanceSummary> getAttendanceSummary(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    return AttendanceSummary(
      studentId: studentId,
      semester: 6,
      lastUpdated: now.subtract(const Duration(minutes: 18)),
      courses: [
        CourseAttendance(
          courseId: 'c1',
          courseCode: 'CS304',
          courseName: 'Mobile Computing & Wireless Comm',
          presentCount: 23,
          absentCount: 2,
          totalClasses: 25,
          lastUpdated: now,
        ),
        CourseAttendance(
          courseId: 'c2',
          courseCode: 'CS305',
          courseName: 'Compiler Design Laboratory',
          presentCount: 22,
          absentCount: 3,
          totalClasses: 25,
          lastUpdated: now,
        ),
        CourseAttendance(
          courseId: 'c3',
          courseCode: 'CS306',
          courseName: 'Machine Learning Applications',
          presentCount: 21,
          absentCount: 4,
          totalClasses: 25,
          lastUpdated: now,
        ),
        CourseAttendance(
          courseId: 'c4',
          courseCode: 'CS307',
          courseName: 'Cloud Computing Architectures',
          presentCount: 33,
          absentCount: 7,
          totalClasses: 40,
          lastUpdated: now,
        ),
        CourseAttendance(
          courseId: 'c5',
          courseCode: 'CS308',
          courseName: 'Internet of Things & Embedded Systems',
          presentCount: 22,
          absentCount: 3,
          totalClasses: 25,
          lastUpdated: now,
        ),
        CourseAttendance(
          courseId: 'c6',
          courseCode: 'CS309',
          courseName: 'Full Stack Web Engineering Lab',
          presentCount: 47,
          absentCount: 3,
          totalClasses: 50,
          lastUpdated: now,
        ),
      ],
    );
  }

  @override
  Future<List<CourseAttendance>> getCourseAttendance(String studentId) async {
    final summary = await getAttendanceSummary(studentId);
    return summary.courses;
  }

  @override
  Future<void> syncAttendance(String studentId) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

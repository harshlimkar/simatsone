import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/timetable_entities.dart';
import '../../data/repositories/mock_timetable_repository.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return MockTimetableRepository();
});

final todayScheduleProvider = FutureProvider<List<TimetableItem>>((ref) async {
  final repo = ref.watch(timetableRepositoryProvider);
  return repo.getTodaySchedule();
});

final selectedDayProvider = StateProvider<int>((ref) => 5); // Friday

final weeklyScheduleProvider = FutureProvider.family<List<TimetableItem>, int>((
  ref,
  day,
) async {
  final repo = ref.watch(timetableRepositoryProvider);
  return repo.getWeeklySchedule(day);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/attendance_entities.dart';
import '../../data/repositories/mock_attendance_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return MockAttendanceRepository();
});

final attendanceSummaryProvider = FutureProvider<AttendanceSummary>((
  ref,
) async {
  final repo = ref.watch(attendanceRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  final studentId = user?.id ?? 'stu_001';
  return repo.getAttendanceSummary(studentId);
});

final attendanceSyncNotifierProvider =
    StateNotifierProvider<AttendanceSyncNotifier, AsyncValue<void>>((ref) {
      return AttendanceSyncNotifier(
        ref.watch(attendanceRepositoryProvider),
        ref,
      );
    });

class AttendanceSyncNotifier extends StateNotifier<AsyncValue<void>> {
  AttendanceSyncNotifier(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  final AttendanceRepository _repository;
  final Ref _ref;

  Future<void> sync() async {
    state = const AsyncValue.loading();
    try {
      final user = _ref.read(currentUserProvider);
      final studentId = user?.id ?? 'stu_001';
      await _repository.syncAttendance(studentId);
      _ref.invalidate(attendanceSummaryProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

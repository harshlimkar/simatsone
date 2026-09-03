import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/attendance_provider.dart';

class AttendanceOverviewScreen extends ConsumerWidget {
  const AttendanceOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceAsync = ref.watch(attendanceSummaryProvider);

    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: AppBar(
        title: const Text('Biometric Attendance'),
        backgroundColor: SimatsColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Sync Attendance',
            onPressed: () =>
                ref.read(attendanceSyncNotifierProvider.notifier).sync(),
          ),
        ],
      ),
      body: attendanceAsync.when(
        data: (summary) => SingleChildScrollView(
          padding: const EdgeInsets.all(SimatsSpacing.marginMobile),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero card
              SimatsAttendanceCard(
                percentage: summary.overallPercentage,
                semester: summary.semester,
                totalCourses: summary.courses.length,
                coursesBelowThreshold: summary.belowWarning.length,
              ),
              const SizedBox(height: SimatsSpacing.spaceBase),

              Text(
                'Course Breakdown',
                style: SimatsTextStyles.headlineSm.copyWith(
                  color: SimatsColors.primary,
                ),
              ),
              const SizedBox(height: SimatsSpacing.spaceSm),

              ...summary.courses.map((c) {
                final isLow = c.percentage < 85.0;
                return Container(
                  margin: const EdgeInsets.only(bottom: SimatsSpacing.spaceSm),
                  padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
                  decoration: BoxDecoration(
                    color: SimatsColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(
                      SimatsSpacing.spaceBase,
                    ),
                    border: Border.all(
                      color: isLow
                          ? SimatsColors.errorContainer
                          : SimatsColors.outlineVariant,
                      width: isLow ? 1.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            c.courseCode,
                            style: SimatsTextStyles.labelMd.copyWith(
                              color: SimatsColors.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SimatsSpacing.spaceSm,
                              vertical: SimatsSpacing.space2xs,
                            ),
                            decoration: BoxDecoration(
                              color: isLow
                                  ? SimatsColors.statusWarningContainer
                                  : SimatsColors.statusSuccessContainer,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Text(
                              c.percentageStr,
                              style: SimatsTextStyles.labelMd.copyWith(
                                color: isLow
                                    ? const Color(0xFF92400E)
                                    : const Color(0xFF065F46),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SimatsSpacing.spaceXs),
                      Text(
                        c.courseName,
                        style: SimatsTextStyles.titleMd.copyWith(
                          color: SimatsColors.primary,
                        ),
                      ),
                      const SizedBox(height: SimatsSpacing.spaceSm),
                      LinearProgressIndicator(
                        value: (c.percentage / 100).clamp(0.0, 1.0),
                        backgroundColor: SimatsColors.surfaceContainerHigh,
                        color: isLow
                            ? SimatsColors.statusWarning
                            : SimatsColors.secondary,
                        borderRadius: BorderRadius.circular(4),
                        minHeight: 6,
                      ),
                      const SizedBox(height: SimatsSpacing.spaceSm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${c.presentCount} Present • ${c.absentCount} Absent',
                            style: SimatsTextStyles.bodySm.copyWith(
                              color: SimatsColors.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Total ${c.totalClasses} Sessions',
                            style: SimatsTextStyles.bodySm.copyWith(
                              color: SimatsColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const SimatsErrorState(
          message: 'Could not load attendance details',
        ),
      ),
    );
  }
}

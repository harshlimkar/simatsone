import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/timetable_provider.dart';

class TimetableScreen extends ConsumerWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);
    final scheduleAsync = ref.watch(weeklyScheduleProvider(selectedDay));

    final days = [
      (1, 'Mon'),
      (2, 'Tue'),
      (3, 'Wed'),
      (4, 'Thu'),
      (5, 'Fri'),
      (6, 'Sat'),
    ];

    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: AppBar(
        title: const Text('Academic Timetable'),
        backgroundColor: SimatsColors.surface,
      ),
      body: Column(
        children: [
          // Day selector bar
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SimatsSpacing.marginMobile,
              vertical: SimatsSpacing.spaceSm,
            ),
            color: SimatsColors.surfaceContainerLowest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: days.map((d) {
                final isSelected = selectedDay == d.$1;
                return InkWell(
                  onTap: () =>
                      ref.read(selectedDayProvider.notifier).state = d.$1,
                  borderRadius: BorderRadius.circular(SimatsSpacing.spaceSm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? SimatsColors.primary
                          : SimatsColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(
                        SimatsSpacing.spaceSm,
                      ),
                    ),
                    child: Text(
                      d.$2,
                      style: SimatsTextStyles.labelMd.copyWith(
                        color: isSelected
                            ? SimatsColors.onPrimary
                            : SimatsColors.onSurfaceVariant,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),

          // Schedule list
          Expanded(
            child: scheduleAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const SimatsEmptyState(
                    title: 'No Classes Scheduled',
                    message: 'Enjoy your free study day or laboratory prep.',
                    icon: Icons.event_busy_rounded,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(SimatsSpacing.marginMobile),
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: SimatsSpacing.spaceSm),
                  itemBuilder: (ctx, i) {
                    final item = items[i];
                    return SimatsTimetableCard(
                      timeRange: item.timeRange,
                      courseCode: item.courseCode,
                      courseTitle: item.courseTitle,
                      facultyName: item.facultyName,
                      roomLocation: item.roomLocation,
                      classType: item.classType,
                      isLive: item.isLive,
                      remainingMinutes: item.remainingMinutes,
                      slotBadgeText: item.slotBadgeText,
                      onNavigate: () => context.push('/student/campus'),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const SimatsErrorState(message: 'Could not load timetable'),
            ),
          ),
        ],
      ),
    );
  }
}

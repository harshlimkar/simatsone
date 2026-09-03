import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../alerts/presentation/providers/alerts_provider.dart';
import '../../../attendance/presentation/providers/attendance_provider.dart';
import '../../../timetable/presentation/providers/timetable_provider.dart';

class StudentDashboardScreen extends ConsumerStatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  ConsumerState<StudentDashboardScreen> createState() =>
      _StudentDashboardScreenState();
}

class _StudentDashboardScreenState
    extends ConsumerState<StudentDashboardScreen> {
  bool _dismissedUrgentAlert = false;
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    ref.invalidate(attendanceSummaryProvider);
    ref.invalidate(todayScheduleProvider);
    ref.invalidate(alertsStreamProvider);
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final attendanceAsync = ref.watch(attendanceSummaryProvider);
    final scheduleAsync = ref.watch(todayScheduleProvider);
    final criticalAlert = ref.watch(criticalAlertProvider);

    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: SimatsAppBar(
        subtitle: 'Student Dashboard',
        notificationCount: 2,
        onNotificationsTap: () => context.push('/student/notifications'),
        onProfileTap: () => context.push('/student/profile'),
      ),
      bottomNavigationBar: SimatsBottomNav(
        currentIndex: 0,
        alertBadge: criticalAlert != null,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              context.push('/student/campus');
              break;
            case 2:
              context.push('/alerts');
              break;
            case 3:
              context.push('/student/profile');
              break;
          }
        },
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: SimatsColors.secondary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: SimatsSpacing.marginMobile,
              vertical: SimatsSpacing.spaceBase,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Live Connectivity & Sync Bar
                _buildSyncBar(),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // 2. Student Welcome Banner
                _buildStudentWelcomeBanner(user?.name ?? 'R. Ashwin Kumar'),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // 3. High-Priority Alert Banner (Dismissible)
                if (!_dismissedUrgentAlert && criticalAlert != null)
                  _buildDismissibleAlert(
                    criticalAlert.title,
                    criticalAlert.description,
                  ),
                if (!_dismissedUrgentAlert && criticalAlert != null)
                  const SizedBox(height: SimatsSpacing.spaceBase),

                // 4. Attendance Hero Card
                attendanceAsync.when(
                  data: (summary) => SimatsAttendanceCard(
                    percentage: summary.overallPercentage,
                    semester: summary.semester,
                    totalCourses: summary.courses.length,
                    coursesBelowThreshold: summary.belowWarning.length,
                    onTapBreakdown: () => context.push('/student/attendance'),
                  ),
                  loading: () => const SimatsCardSkeleton(),
                  error: (_, __) => SimatsAttendanceCard(
                    percentage: 86.4,
                    semester: 6,
                    totalCourses: 6,
                    coursesBelowThreshold: 2,
                    onTapBreakdown: () => context.push('/student/attendance'),
                  ),
                ),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // 5. Quick Portals (6-Grid)
                _buildQuickPortals(context),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // 6. Today's Schedule Section
                _buildScheduleSection(scheduleAsync),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // 7. Latest Campus Update Card
                _buildCampusUpdateCard(context),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // 8. Delighter Micro-Feedback Card
                _buildDelighterCard(),
                const SizedBox(height: SimatsSpacing.space3xl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSyncBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SimatsSpacing.spaceSm,
        vertical: SimatsSpacing.spaceXs,
      ),
      decoration: BoxDecoration(
        color: SimatsColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: SimatsColors.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: SimatsColors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'SIMATS-5G',
                    style: SimatsTextStyles.labelSm.copyWith(
                      color: SimatsColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '•',
                  style: SimatsTextStyles.labelSm.copyWith(
                    color: SimatsColors.outline,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Synced 10:42 AM',
                  style: SimatsTextStyles.labelSm.copyWith(
                    color: SimatsColors.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: _handleRefresh,
            borderRadius: BorderRadius.circular(9999),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedRotation(
                    turns: _isRefreshing ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 900),
                    child: const Icon(
                      Icons.sync_rounded,
                      size: 15,
                      color: SimatsColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'Refresh',
                    style: SimatsTextStyles.labelSm.copyWith(
                      color: SimatsColors.secondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentWelcomeBanner(String studentName) {
    return Container(
      padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
      decoration: BoxDecoration(
        color: SimatsColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
        border: Border.all(color: SimatsColors.outlineVariant, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B1C30).withOpacity(0.04),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SimatsSpacing.spaceSm,
                  vertical: SimatsSpacing.space2xs,
                ),
                decoration: BoxDecoration(
                  color: SimatsColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      size: 14,
                      color: SimatsColors.secondary,
                    ),
                    const SizedBox(width: SimatsSpacing.space2xs),
                    Text(
                      'Biometric Verified',
                      style: SimatsTextStyles.labelSm.copyWith(
                        color: SimatsColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Reg: 211001048',
                style: SimatsTextStyles.codeNum.copyWith(
                  color: SimatsColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: SimatsSpacing.spaceSm),
          Text(
            'Welcome Back,',
            style: SimatsTextStyles.labelMd.copyWith(
              color: SimatsColors.onSurfaceVariant,
            ),
          ),
          Text(
            studentName,
            style: SimatsTextStyles.headlineLg.copyWith(
              color: SimatsColors.primary,
            ),
          ),
          const SizedBox(height: SimatsSpacing.spaceSm),
          Wrap(
            spacing: SimatsSpacing.spaceXs,
            runSpacing: SimatsSpacing.spaceXs,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SimatsSpacing.spaceSm,
                  vertical: SimatsSpacing.space2xs,
                ),
                decoration: BoxDecoration(
                  color: SimatsColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(SimatsSpacing.spaceSm),
                ),
                child: Text(
                  'B.Tech Computer Science',
                  style: SimatsTextStyles.labelSm.copyWith(
                    color: SimatsColors.onSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SimatsSpacing.spaceSm,
                  vertical: SimatsSpacing.space2xs,
                ),
                decoration: BoxDecoration(
                  color: SimatsColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(SimatsSpacing.spaceSm),
                ),
                child: Text(
                  'Year 3 • Section A',
                  style: SimatsTextStyles.labelSm.copyWith(
                    color: SimatsColors.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDismissibleAlert(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
      decoration: BoxDecoration(
        color: SimatsColors.errorContainer,
        borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: SimatsColors.error,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              size: 18,
              color: SimatsColors.onError,
            ),
          ),
          const SizedBox(width: SimatsSpacing.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Schedule Revision',
                      style: SimatsTextStyles.labelMd.copyWith(
                        color: SimatsColors.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: SimatsSpacing.spaceXs),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: SimatsColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: SimatsSpacing.spaceXs),
                    Text(
                      'CSE Block',
                      style: SimatsTextStyles.labelSm.copyWith(
                        color: SimatsColors.onErrorContainer.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SimatsSpacing.space2xs),
                Text(
                  'Academic schedule revised for Hall 204. Mobile Computing practical shifted ahead by 15 mins.',
                  style: SimatsTextStyles.bodySm.copyWith(
                    color: SimatsColors.onErrorContainer,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 18),
            color: SimatsColors.onErrorContainer,
            onPressed: () => setState(() => _dismissedUrgentAlert = true),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPortals(BuildContext context) {
    final portals = [
      (
        icon: Icons.pie_chart_rounded,
        label: 'Attendance',
        route: '/student/attendance',
      ),
      (
        icon: Icons.calendar_month_rounded,
        label: 'Timetable',
        route: '/student/timetable',
      ),
      (
        icon: Icons.menu_book_rounded,
        label: 'SAIL Library',
        route: '/student/library',
      ),
      (
        icon: Icons.near_me_rounded,
        label: 'Wayfinding',
        route: '/student/campus',
      ),
      (icon: Icons.shield_rounded, label: 'Security SOS', route: '/alerts'),
      (
        icon: Icons.auto_awesome_rounded,
        label: 'Hackathons',
        route: '/student/events',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quick Portals',
              style: SimatsTextStyles.headlineSm.copyWith(
                color: SimatsColors.primary,
              ),
            ),
            Text(
              '6 Shortcuts',
              style: SimatsTextStyles.labelSm.copyWith(
                color: SimatsColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: SimatsSpacing.spaceSm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: SimatsSpacing.spaceXs,
            crossAxisSpacing: SimatsSpacing.spaceXs,
            childAspectRatio: 1.1,
          ),
          itemCount: portals.length,
          itemBuilder: (ctx, index) {
            final item = portals[index];
            return InkWell(
              onTap: () => context.push(item.route),
              borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
              child: Container(
                decoration: BoxDecoration(
                  color: SimatsColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
                  border: Border.all(
                    color: SimatsColors.outlineVariant,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0B1C30).withOpacity(0.04),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: SimatsColors.surfaceContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        size: 22,
                        color: SimatsColors.secondary,
                      ),
                    ),
                    const SizedBox(height: SimatsSpacing.spaceXs),
                    Text(
                      item.label,
                      style: SimatsTextStyles.labelMd.copyWith(
                        color: SimatsColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildScheduleSection(AsyncValue scheduleAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today's Schedule",
                  style: SimatsTextStyles.headlineSm.copyWith(
                    color: SimatsColors.primary,
                  ),
                ),
                Text(
                  'Friday, Oct 24 • 3 classes remaining',
                  style: SimatsTextStyles.bodySm.copyWith(
                    color: SimatsColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SimatsSpacing.spaceSm,
                vertical: SimatsSpacing.space2xs,
              ),
              decoration: BoxDecoration(
                color: SimatsColors.secondaryFixed,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: SimatsColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: SimatsSpacing.space2xs),
                  Text(
                    'Active Day',
                    style: SimatsTextStyles.labelSm.copyWith(
                      color: SimatsColors.onSecondaryFixed,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: SimatsSpacing.spaceSm),

        // Live Class Card
        SimatsTimetableCard(
          timeRange: '10:00 AM - 11:30 AM',
          courseCode: 'CS304',
          courseTitle: 'Mobile Computing & Wireless Comm',
          facultyName: 'Dr. S. K. Narayanan • Senior Professor',
          roomLocation: 'CSE Block • Room 204',
          isLive: true,
          remainingMinutes: 42,
          onNavigate: () => context.push('/student/campus'),
        ),
        const SizedBox(height: SimatsSpacing.spaceSm),

        // Next Up Class
        SimatsTimetableCard(
          timeRange: '11:45 AM - 01:15 PM',
          courseCode: 'CS305',
          courseTitle: 'Compiler Design Laboratory',
          facultyName: 'Prof. Meenakshi Sundaram',
          roomLocation: 'Turing Lab 3 • Ground Floor (Workstation Confirmed)',
          slotBadgeText: 'Next Up',
        ),
        const SizedBox(height: SimatsSpacing.spaceSm),

        // Afternoon Slot Class
        SimatsTimetableCard(
          timeRange: '02:00 PM - 03:30 PM',
          courseCode: 'CS306',
          courseTitle: 'Machine Learning Applications',
          facultyName: 'Dr. K. Vignesh',
          roomLocation: 'Engineering Auditorium B',
          slotBadgeText: 'Afternoon Slot',
        ),
      ],
    );
  }

  Widget _buildCampusUpdateCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
      decoration: BoxDecoration(
        color: SimatsColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
        border: Border.all(color: SimatsColors.outlineVariant, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B1C30).withOpacity(0.04),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SimatsSpacing.spaceSm,
                  vertical: SimatsSpacing.space2xs,
                ),
                decoration: BoxDecoration(
                  color: SimatsColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(SimatsSpacing.spaceSm),
                ),
                child: Text(
                  'ACADEMIC UPDATE',
                  style: SimatsTextStyles.labelSm.copyWith(
                    color: SimatsColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '45 mins ago',
                style: SimatsTextStyles.labelSm.copyWith(
                  color: SimatsColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: SimatsSpacing.spaceSm),
          Text(
            'End-Semester Theory & Practical Examination Timetable Published',
            style: SimatsTextStyles.titleMd.copyWith(
              color: SimatsColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: SimatsSpacing.spaceXs),
          Text(
            'Controller of Examinations has released the master schedule for Regular and Arrear assessments for B.Tech Autumn 2024.',
            style: SimatsTextStyles.bodySm.copyWith(
              color: SimatsColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SimatsSpacing.spaceSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Official Ref: COE/SIMATS/24/772',
                style: SimatsTextStyles.labelSm.copyWith(
                  color: SimatsColors.onSurfaceVariant,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => context.push('/student/announcements'),
                icon: const Icon(Icons.description_outlined, size: 16),
                label: const Text('View Circular'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SimatsColors.secondary,
                  foregroundColor: SimatsColors.onSecondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  textStyle: SimatsTextStyles.labelMd,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SimatsSpacing.spaceSm),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDelighterCard() {
    return Container(
      padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
      decoration: BoxDecoration(
        color: SimatsColors.surfaceContainerHigh.withOpacity(0.6),
        borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: SimatsColors.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_cafe_rounded,
              color: SimatsColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: SimatsSpacing.spaceSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need a mid-day recharge?',
                  style: SimatsTextStyles.labelMd.copyWith(
                    color: SimatsColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Campus Food Court express counters are open at CSE Quad.',
                  style: SimatsTextStyles.bodySm.copyWith(
                    color: SimatsColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

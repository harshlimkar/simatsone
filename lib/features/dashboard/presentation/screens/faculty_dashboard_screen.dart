import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';
import '../../../../core/services/maps_navigation_service.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class FacultyDashboardScreen extends ConsumerStatefulWidget {
  const FacultyDashboardScreen({super.key});

  @override
  ConsumerState<FacultyDashboardScreen> createState() =>
      _FacultyDashboardScreenState();
}

class _FacultyDashboardScreenState
    extends ConsumerState<FacultyDashboardScreen> {
  final _students = [
    (id: '211001048', name: 'R. Ashwin Kumar', isPresent: true, roll: 'CS-01'),
    (id: '211001049', name: 'B. Deepa Lakshmi', isPresent: true, roll: 'CS-02'),
    (id: '211001050', name: 'M. Harish Shankar', isPresent: false, roll: 'CS-03'),
    (id: '211001051', name: 'K. Sneha Reddy', isPresent: true, roll: 'CS-04'),
    (id: '211001052', name: 'V. Vignesh Waran', isPresent: true, roll: 'CS-05'),
    (id: '211001053', name: 'A. Pooja Dharshini', isPresent: true, roll: 'CS-06'),
    (id: '211001054', name: 'S. Karthik Raja', isPresent: true, roll: 'CS-07'),
    (id: '211001055', name: 'N. Sandhya Devi', isPresent: false, roll: 'CS-08'),
  ];

  late List<bool> _attendanceStatus;
  bool _submitted = false;
  bool _isRefreshing = false;
  String _rosterFilter = '';

  @override
  void initState() {
    super.initState();
    _attendanceStatus = _students.map((s) => s.isPresent).toList();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faculty records & timetable refreshed from SIS Server.'),
          backgroundColor: SimatsColors.primary,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _markAll(bool present) {
    setState(() {
      for (int i = 0; i < _attendanceStatus.length; i++) {
        _attendanceStatus[i] = present;
      }
    });
  }

  void _submitAttendance() {
    setState(() => _submitted = true);
    final presentCount = _attendanceStatus.where((v) => v).length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Attendance submitted for $presentCount/${_students.length} students & synced to SIMATS Cloud.',
        ),
        backgroundColor: SimatsColors.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _openClassroomNavigation() async {
    // Saveetha Engineering College Main Block / CSE Block
    await MapsNavigationService.openGoogleMapsNavigation(
      destinationLat: 13.02685,
      destinationLng: 80.01686,
      query: 'Saveetha Engineering College, Thandalam, Chennai',
      destinationLabel: 'CSE Block Room 204',
    );
  }

  void _openLabNavigation() async {
    // Turing Lab in Library / Academic Complex
    await MapsNavigationService.openGoogleMapsNavigation(
      destinationLat: 13.02720,
      destinationLng: 80.01730,
      query: 'Saveetha Engineering College Central Library, Thandalam',
      destinationLabel: 'Turing Computing Lab',
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final facultyName = user?.name ?? 'Ms. Abisha';

    final presentCount = _attendanceStatus.where((v) => v).length;
    final totalCount = _students.length;
    final pct = (presentCount / totalCount * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: SimatsAppBar(
        subtitle: 'Faculty Portal',
        notificationCount: 3,
        onNotificationsTap: () => context.push('/student/notifications'),
        onProfileTap: () => _showSignOutDialog(),
      ),
      bottomNavigationBar: SimatsBottomNav(
        currentIndex: 0,
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
              _showSignOutDialog();
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

                // 2. Faculty Identity Hero Card
                _buildFacultyHeroCard(facultyName),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // 3. Four Key Stat Metrics (Workload, Students, Reviews, Leaves)
                _buildMetricCards(),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // 4. Live Class in Session with Google Maps Action
                _buildLiveClassCard(presentCount, totalCount, pct),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // 5. Quick Portals (6-Grid Shortcuts)
                _buildQuickPortals(),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // 6. Today's Teaching Schedule
                _buildScheduleSection(),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // 7. Interactive Class Attendance Roster
                _buildAttendanceRosterSection(presentCount, totalCount, pct),
                const SizedBox(height: SimatsSpacing.spaceBase),

                // 8. Research & Academic Activity Card
                _buildResearchCard(),
                const SizedBox(height: SimatsSpacing.space2xl),
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
                    'SIMATS-FACULTY-5G',
                    style: SimatsTextStyles.labelSm.copyWith(
                      color: SimatsColors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Text('•', style: SimatsTextStyles.labelSm.copyWith(color: SimatsColors.outline)),
                const SizedBox(width: 6),
                Text(
                  'Synced Today',
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

  Widget _buildFacultyHeroCard(String facultyName) {
    return Container(
      padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
      decoration: BoxDecoration(
        color: SimatsColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(SimatsRadius.lg),
        border: Border.all(color: SimatsColors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: SimatsColors.primary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                      Icons.verified_user_rounded,
                      size: 14,
                      color: SimatsColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Faculty Biometric Punch Active',
                      style: SimatsTextStyles.labelSm.copyWith(
                        color: SimatsColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'ID: SIMATS-FAC-2041',
                style: SimatsTextStyles.codeNum.copyWith(
                  color: SimatsColors.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: SimatsSpacing.spaceSm),
          Text(
            'Welcome,',
            style: SimatsTextStyles.labelMd.copyWith(
              color: SimatsColors.onSurfaceVariant,
            ),
          ),
          Text(
            facultyName,
            style: SimatsTextStyles.headlineLg.copyWith(
              color: SimatsColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: SimatsSpacing.spaceXs),
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
                  borderRadius: BorderRadius.circular(SimatsRadius.sm),
                ),
                child: Text(
                  'Assistant Professor • Dept of CSE',
                  style: SimatsTextStyles.labelSm.copyWith(
                    color: SimatsColors.onSurface,
                    fontWeight: FontWeight.w600,
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
                  borderRadius: BorderRadius.circular(SimatsRadius.sm),
                ),
                child: Text(
                  'Cabin: Tech Block 312',
                  style: SimatsTextStyles.labelSm.copyWith(
                    color: SimatsColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCards() {
    return Row(
      children: [
        _metricTile(
          icon: Icons.groups_rounded,
          value: '184',
          label: 'Students Taught',
          accent: SimatsColors.primary,
        ),
        const SizedBox(width: SimatsSpacing.spaceXs),
        _metricTile(
          icon: Icons.timer_outlined,
          value: '18h',
          label: 'Weekly Load',
          accent: SimatsColors.secondary,
        ),
        const SizedBox(width: SimatsSpacing.spaceXs),
        _metricTile(
          icon: Icons.assignment_turned_in_outlined,
          value: '14',
          label: 'Pending Reviews',
          accent: const Color(0xFFD97706),
        ),
        const SizedBox(width: SimatsSpacing.spaceXs),
        _metricTile(
          icon: Icons.event_available_rounded,
          value: '12d',
          label: 'Leave Balance',
          accent: const Color(0xFF059669),
        ),
      ],
    );
  }

  Widget _metricTile({
    required IconData icon,
    required String value,
    required String label,
    required Color accent,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        decoration: BoxDecoration(
          color: SimatsColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(SimatsRadius.md),
          border: Border.all(color: SimatsColors.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: SimatsColors.primary.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: accent),
            const SizedBox(height: 4),
            Text(
              value,
              style: SimatsTextStyles.headlineSm.copyWith(
                fontWeight: FontWeight.w800,
                color: SimatsColors.primary,
                fontSize: 16,
              ),
            ),
            Text(
              label,
              style: SimatsTextStyles.labelSm.copyWith(
                color: SimatsColors.onSurfaceVariant,
                fontSize: 9.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveClassCard(int presentCount, int totalCount, String pct) {
    return Container(
      padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
      decoration: BoxDecoration(
        color: SimatsColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(SimatsRadius.lg),
        border: Border.all(color: SimatsColors.secondary, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: SimatsColors.secondary.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                    const SizedBox(width: 4),
                    Text(
                      'Live Teaching Session',
                      style: SimatsTextStyles.labelSm.copyWith(
                        color: SimatsColors.onSecondaryFixed,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '10:00 AM - 11:30 AM',
                style: SimatsTextStyles.codeNum.copyWith(
                  fontWeight: FontWeight.w600,
                  color: SimatsColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: SimatsSpacing.spaceSm),
          Text(
            'CS304 • Mobile Computing & Wireless Comm',
            style: SimatsTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: SimatsColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Saveetha Engineering College • CSE Block Room 204 • Section 3A',
            style: SimatsTextStyles.bodySm.copyWith(
              color: SimatsColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: SimatsSpacing.spaceBase),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance: $presentCount / $totalCount ($pct%)',
                      style: SimatsTextStyles.labelSm.copyWith(
                        fontWeight: FontWeight.w700,
                        color: SimatsColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: presentCount / totalCount,
                        backgroundColor: SimatsColors.surfaceContainerHigh,
                        valueColor: const AlwaysStoppedAnimation(SimatsColors.secondary),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: SimatsSpacing.spaceSm),
              ElevatedButton.icon(
                onPressed: _openClassroomNavigation,
                icon: const Icon(Icons.navigation_rounded, size: 16),
                label: const Text('Navigate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SimatsColors.primary,
                  foregroundColor: SimatsColors.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickPortals() {
    final portals = [
      (
        icon: Icons.checklist_rounded,
        title: 'Mark Roster',
        subtitle: 'Batch Attendance',
      ),
      (
        icon: Icons.calendar_month_rounded,
        title: 'My Timetable',
        subtitle: 'All Weekly Slots',
      ),
      (
        icon: Icons.grading_rounded,
        title: 'Gradebook',
        subtitle: 'Internal Marks',
      ),
      (
        icon: Icons.science_rounded,
        title: 'Turing Lab',
        subtitle: 'Lab Workstations',
      ),
      (
        icon: Icons.article_rounded,
        title: 'Research Hub',
        subtitle: 'Grants & Scopus',
      ),
      (
        icon: Icons.campaign_rounded,
        title: 'Notice Board',
        subtitle: 'Class Broadcast',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Faculty Portals',
              style: SimatsTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: SimatsColors.primary,
              ),
            ),
            Text(
              '6 Workspaces',
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
            childAspectRatio: 1.15,
          ),
          itemCount: portals.length,
          itemBuilder: (ctx, i) {
            final p = portals[i];
            return InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Opening ${p.title}...'),
                    backgroundColor: SimatsColors.primary,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(SimatsRadius.md),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: SimatsColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(SimatsRadius.md),
                  border: Border.all(color: SimatsColors.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: SimatsColors.primary.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: SimatsColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(p.icon, size: 20, color: SimatsColors.secondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p.title,
                      style: SimatsTextStyles.labelSm.copyWith(
                        fontWeight: FontWeight.w700,
                        color: SimatsColors.primary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      p.subtitle,
                      style: SimatsTextStyles.labelSm.copyWith(
                        color: SimatsColors.onSurfaceVariant,
                        fontSize: 9,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Teaching Slots',
              style: SimatsTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: SimatsColors.primary,
              ),
            ),
            Text(
              '2 Slots Remaining',
              style: SimatsTextStyles.labelSm.copyWith(
                color: SimatsColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: SimatsSpacing.spaceSm),
        _scheduleCard(
          time: '11:45 AM - 01:15 PM',
          course: 'CS305 • Compiler Design Laboratory',
          room: 'Turing Lab 3 • Saveetha Academic Library Complex',
          tag: 'Next Up',
          onNav: _openLabNavigation,
        ),
        const SizedBox(height: SimatsSpacing.spaceSm),
        _scheduleCard(
          time: '02:00 PM - 03:30 PM',
          course: 'CS308 • Advanced AI & Neural Networks',
          room: 'Engineering Auditorium B • 120 Students',
          tag: 'Afternoon Slot',
          onNav: _openClassroomNavigation,
        ),
      ],
    );
  }

  Widget _scheduleCard({
    required String time,
    required String course,
    required String room,
    required String tag,
    required VoidCallback onNav,
  }) {
    return Container(
      padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
      decoration: BoxDecoration(
        color: SimatsColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(SimatsRadius.md),
        border: Border.all(color: SimatsColors.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      time,
                      style: SimatsTextStyles.codeNum.copyWith(
                        color: SimatsColors.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: SimatsColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: SimatsTextStyles.labelSm.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: SimatsColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  course,
                  style: SimatsTextStyles.labelMd.copyWith(
                    fontWeight: FontWeight.w700,
                    color: SimatsColors.primary,
                  ),
                ),
                Text(
                  room,
                  style: SimatsTextStyles.bodySm.copyWith(
                    color: SimatsColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onNav,
            icon: const Icon(Icons.navigation_rounded, color: SimatsColors.secondary),
            tooltip: 'Navigate via Google Maps',
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRosterSection(
    int presentCount,
    int totalCount,
    String pct,
  ) {
    final filtered = _students.where((s) {
      if (_rosterFilter.isEmpty) return true;
      final q = _rosterFilter.toLowerCase();
      return s.name.toLowerCase().contains(q) ||
          s.id.toLowerCase().contains(q) ||
          s.roll.toLowerCase().contains(q);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Class Roster & SIS Attendance',
              style: SimatsTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: SimatsColors.primary,
              ),
            ),
            Text(
              _submitted ? 'Status: Submitted' : 'Status: Draft',
              style: SimatsTextStyles.labelSm.copyWith(
                color: _submitted
                    ? const Color(0xFF059669)
                    : SimatsColors.statusWarning,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: SimatsSpacing.spaceXs),
        Row(
          children: [
            Expanded(
              child: SimatsTextField(
                hint: 'Filter student name or roll...',
                prefixIcon: Icons.search_rounded,
                onChanged: (v) => setState(() => _rosterFilter = v.trim()),
              ),
            ),
            const SizedBox(width: SimatsSpacing.spaceSm),
            OutlinedButton(
              onPressed: _submitted ? null : () => _markAll(true),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
              child: const Text('All Present'),
            ),
          ],
        ),
        const SizedBox(height: SimatsSpacing.spaceSm),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          separatorBuilder: (_, __) =>
              const SizedBox(height: SimatsSpacing.spaceXs),
          itemBuilder: (ctx, i) {
            final s = filtered[i];
            final originalIndex = _students.indexWhere((item) => item.id == s.id);
            final isPresent = _attendanceStatus[originalIndex];

            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SimatsSpacing.spaceBase,
                vertical: SimatsSpacing.spaceSm,
              ),
              decoration: BoxDecoration(
                color: SimatsColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(SimatsRadius.md),
                border: Border.all(color: SimatsColors.outlineVariant),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: SimatsColors.surfaceContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        s.roll,
                        style: SimatsTextStyles.labelSm.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          color: SimatsColors.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: SimatsSpacing.spaceSm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.name,
                          style: SimatsTextStyles.labelMd.copyWith(
                            fontWeight: FontWeight.w700,
                            color: SimatsColors.onSurface,
                          ),
                        ),
                        Text(
                          'Reg: ${s.id} • CSE 3A',
                          style: SimatsTextStyles.bodySm.copyWith(
                            color: SimatsColors.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ChoiceChip(
                    label: Text(isPresent ? '✓ Present' : '✕ Absent'),
                    selected: isPresent,
                    selectedColor: SimatsColors.statusSuccessContainer,
                    labelStyle: TextStyle(
                      color: isPresent
                          ? const Color(0xFF065F46)
                          : SimatsColors.error,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                    onSelected: _submitted
                        ? null
                        : (val) {
                            setState(
                              () => _attendanceStatus[originalIndex] = !isPresent,
                            );
                          },
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: SimatsSpacing.spaceBase),
        SizedBox(
          width: double.infinity,
          height: SimatsSpacing.buttonHeight,
          child: ElevatedButton.icon(
            label: Text(
              _submitted
                  ? 'Attendance Locked & Submitted to SIS'
                  : 'Submit Attendance Batch ($presentCount Present)',
            ),
            icon: const Icon(Icons.cloud_upload_rounded, size: 20),
            onPressed: _submitted ? null : _submitAttendance,
            style: ElevatedButton.styleFrom(
              backgroundColor: SimatsColors.primary,
              foregroundColor: SimatsColors.onPrimary,
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResearchCard() {
    return Container(
      padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
      decoration: BoxDecoration(
        color: SimatsColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(SimatsRadius.lg),
        border: Border.all(color: SimatsColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: SimatsColors.secondary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: SimatsColors.secondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: SimatsSpacing.spaceSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Research & Academic Grants',
                      style: SimatsTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: SimatsColors.primary,
                      ),
                    ),
                    Text(
                      'Saveetha School of Engineering R&D Wing',
                      style: SimatsTextStyles.bodySm.copyWith(
                        color: SimatsColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: SimatsSpacing.spaceSm),
          Container(
            padding: const EdgeInsets.all(SimatsSpacing.spaceSm),
            decoration: BoxDecoration(
              color: SimatsColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(SimatsRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _researchPill('₹2.4 Lakh', 'SEC Seed Grant'),
                _researchPill('4 Papers', 'Scopus (2024)'),
                _researchPill('100%', 'NBA/NAAC Ready'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _researchPill(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: SimatsTextStyles.labelMd.copyWith(
            fontWeight: FontWeight.w800,
            color: SimatsColors.primary,
          ),
        ),
        Text(
          label,
          style: SimatsTextStyles.labelSm.copyWith(
            color: SimatsColors.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SimatsColors.surface,
        title: const Text('Faculty Portal Sign Out'),
        content: const Text(
          'Are you sure you want to sign out of the SIMATS ONE Faculty Portal?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref.read(authProvider.notifier).logout();
              if (mounted) context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SimatsColors.error,
              foregroundColor: SimatsColors.onError,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

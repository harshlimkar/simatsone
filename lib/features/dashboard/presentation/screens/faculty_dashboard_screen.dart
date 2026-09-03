import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';
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
    (id: '211001048', name: 'R. Ashwin Kumar', isPresent: true),
    (id: '211001049', name: 'B. Deepa Lakshmi', isPresent: true),
    (id: '211001050', name: 'M. Harish Shankar', isPresent: false),
    (id: '211001051', name: 'K. Sneha Reddy', isPresent: true),
    (id: '211001052', name: 'V. Vignesh Waran', isPresent: true),
  ];

  late List<bool> _attendanceStatus;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _attendanceStatus = _students.map((s) => s.isPresent).toList();
  }

  void _submitAttendance() {
    setState(() => _submitted = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Attendance successfully submitted & synced with SIS server.',
        ),
        backgroundColor: SimatsColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: AppBar(
        title: const Text('Faculty Portal — SIMATS ONE'),
        backgroundColor: SimatsColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SimatsSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Faculty Welcome Card
            Container(
              padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
              decoration: BoxDecoration(
                color: SimatsColors.primaryContainer,
                borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Faculty Control Center',
                    style: SimatsTextStyles.labelMd.copyWith(
                      color: SimatsColors.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: SimatsSpacing.space2xs),
                  Text(
                    user?.name ?? 'Dr. S. K. Narayanan',
                    style: SimatsTextStyles.headlineSm.copyWith(
                      color: SimatsColors.onPrimary,
                    ),
                  ),
                  Text(
                    'Senior Professor • Department of Computer Science & Engineering',
                    style: SimatsTextStyles.bodySm.copyWith(
                      color: SimatsColors.onPrimary.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SimatsSpacing.spaceBase),

            Text('Live Class Session', style: SimatsTextStyles.headlineSm),
            const SizedBox(height: SimatsSpacing.spaceSm),
            Container(
              padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
              decoration: BoxDecoration(
                color: SimatsColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
                border: Border.all(color: SimatsColors.secondary),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CS304 • Mobile Computing & Wireless Comm',
                        style: SimatsTextStyles.titleMd.copyWith(
                          color: SimatsColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: SimatsColors.secondaryFixed,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          'In Progress',
                          style: SimatsTextStyles.labelSm.copyWith(
                            color: SimatsColors.onSecondaryFixed,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SimatsSpacing.spaceXs),
                  Text(
                    'Time: 10:00 AM - 11:30 AM • CSE Block Room 204 • 64 Enrolled',
                    style: SimatsTextStyles.bodySm.copyWith(
                      color: SimatsColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SimatsSpacing.spaceBase),

            // Attendance roster marking
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Class Roster & Attendance',
                  style: SimatsTextStyles.titleMd,
                ),
                Text(
                  _submitted ? 'Status: Submitted' : 'Status: Draft',
                  style: SimatsTextStyles.labelSm.copyWith(
                    color: _submitted
                        ? const Color(0xFF065F46)
                        : SimatsColors.statusWarning,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SimatsSpacing.spaceSm),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _students.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: SimatsSpacing.spaceXs),
              itemBuilder: (ctx, i) {
                final s = _students[i];
                final isPresent = _attendanceStatus[i];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SimatsSpacing.spaceBase,
                    vertical: SimatsSpacing.spaceSm,
                  ),
                  decoration: BoxDecoration(
                    color: SimatsColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(SimatsSpacing.spaceSm),
                    border: Border.all(color: SimatsColors.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      Text(s.id, style: SimatsTextStyles.codeNum),
                      const SizedBox(width: SimatsSpacing.spaceSm),
                      Expanded(
                        child: Text(
                          s.name,
                          style: SimatsTextStyles.bodyMd.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
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
                        ),
                        onSelected: _submitted
                            ? null
                            : (val) {
                                setState(
                                  () => _attendanceStatus[i] = !isPresent,
                                );
                              },
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: SimatsSpacing.spaceBase),

            SimatsButton(
              label: _submitted
                  ? 'Attendance Locked & Submitted'
                  : 'Submit Biometric Attendance Batch',
              icon: Icons.check_circle_rounded,
              onPressed: _submitted ? null : _submitAttendance,
            ),
          ],
        ),
      ),
    );
  }
}

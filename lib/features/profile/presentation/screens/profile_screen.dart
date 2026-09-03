import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: AppBar(
        title: const Text('Institutional Profile'),
        backgroundColor: SimatsColors.surface,
      ),
      bottomNavigationBar: SimatsBottomNav(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/student/dashboard');
              break;
            case 1:
              context.push('/student/campus');
              break;
            case 2:
              context.push('/alerts');
              break;
            case 3:
              break;
          }
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SimatsSpacing.marginMobile),
        child: Column(
          children: [
            // Avatar card
            Container(
              padding: const EdgeInsets.all(SimatsSpacing.spaceXl),
              decoration: BoxDecoration(
                color: SimatsColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
                border: Border.all(color: SimatsColors.outlineVariant),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: SimatsColors.surfaceContainer,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: SimatsColors.secondary,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 36,
                      color: SimatsColors.secondary,
                    ),
                  ),
                  const SizedBox(height: SimatsSpacing.spaceSm),
                  Text(
                    user?.name ?? 'R. Ashwin Kumar',
                    style: SimatsTextStyles.headlineSm.copyWith(
                      color: SimatsColors.primary,
                    ),
                  ),
                  const SizedBox(height: SimatsSpacing.space2xs),
                  Text(
                    user?.email ?? 'ashwin.kumar@simats.edu.in',
                    style: SimatsTextStyles.bodySm.copyWith(
                      color: SimatsColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: SimatsSpacing.spaceSm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: SimatsColors.primaryFixed,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      'Role: ${user?.role.displayName ?? "Student"}',
                      style: SimatsTextStyles.labelSm.copyWith(
                        color: SimatsColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SimatsSpacing.spaceBase),

            // Academic credentials
            Container(
              padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
              decoration: BoxDecoration(
                color: SimatsColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
                border: Border.all(color: SimatsColors.outlineVariant),
              ),
              child: Column(
                children: [
                  _infoRow('Register Number', '211001048'),
                  const Divider(),
                  _infoRow(
                    'Department',
                    user?.department ?? 'Computer Science & Engg',
                  ),
                  const Divider(),
                  _infoRow('Academic Year', 'Year 3 (2022 - 2026)'),
                  const Divider(),
                  _infoRow('Section', 'Section A'),
                  const Divider(),
                  _infoRow(
                    'Campus Access Level',
                    'Tier 1 Student Access (Biometric Enrolled)',
                  ),
                ],
              ),
            ),
            const SizedBox(height: SimatsSpacing.spaceXl),

            SimatsButton(
              label: 'Sign Out of SIMATS ONE',
              variant: SimatsButtonVariant.ghost,
              icon: Icons.logout_rounded,
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SimatsSpacing.spaceXs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: SimatsTextStyles.labelMd.copyWith(
              color: SimatsColors.onSurfaceVariant,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: SimatsTextStyles.bodyMd.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

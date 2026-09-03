import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../alerts/presentation/providers/alerts_provider.dart';
import '../../../../shared/models/enums.dart';

class SecurityDashboardScreen extends ConsumerWidget {
  const SecurityDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final alerts = ref
        .watch(alertsStreamProvider)
        .maybeWhen(data: (a) => a, orElse: () => []);

    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: AppBar(
        title: const Text('Campus Security Command Center'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/security/alerts/create'),
        backgroundColor: SimatsColors.error,
        foregroundColor: SimatsColors.onError,
        icon: const Icon(Icons.add_alert_rounded),
        label: const Text('Broadcast Alert'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SimatsSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Officer Badge Card
            Container(
              padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
              decoration: BoxDecoration(
                color: SimatsColors.primary,
                borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: SimatsColors.onPrimary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: SimatsColors.onPrimary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: SimatsSpacing.spaceSm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Officer V. Rajan',
                          style: SimatsTextStyles.titleMd.copyWith(
                            color: SimatsColors.onPrimary,
                          ),
                        ),
                        Text(
                          'Chief Campus Security Officer • Desk SEC-01',
                          style: SimatsTextStyles.bodySm.copyWith(
                            color: SimatsColors.onPrimary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SimatsSpacing.spaceBase),

            // Metrics grid
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    'Active Advisories',
                    '${alerts.length}',
                    Icons.warning_amber_rounded,
                    SimatsColors.error,
                  ),
                ),
                const SizedBox(width: SimatsSpacing.spaceSm),
                Expanded(
                  child: _statCard(
                    'Incidents Today',
                    '1',
                    Icons.report_problem_outlined,
                    SimatsColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SimatsSpacing.spaceSm),
            Row(
              children: [
                Expanded(
                  child: _statCard(
                    'Resolved Today',
                    '3',
                    Icons.check_circle_outline_rounded,
                    SimatsColors.statusSuccess,
                  ),
                ),
                const SizedBox(width: SimatsSpacing.spaceSm),
                Expanded(
                  child: _statCard(
                    'Monitored Zones',
                    '14',
                    Icons.radar_rounded,
                    SimatsColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SimatsSpacing.spaceBase),

            // Live Alert Management List
            Text(
              'Active Campus Broadcasts',
              style: SimatsTextStyles.headlineSm,
            ),
            const SizedBox(height: SimatsSpacing.spaceSm),

            ...alerts.map((a) {
              return Container(
                margin: const EdgeInsets.only(bottom: SimatsSpacing.spaceSm),
                padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
                decoration: BoxDecoration(
                  color: SimatsColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
                  border: Border.all(color: SimatsColors.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          a.title,
                          style: SimatsTextStyles.titleMd.copyWith(
                            fontWeight: FontWeight.w700,
                            color: SimatsColors.primary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: a.severity == AlertSeverity.critical
                                ? SimatsColors.errorContainer
                                : SimatsColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            a.severity.displayName,
                            style: TextStyle(
                              color: a.severity == AlertSeverity.critical
                                  ? SimatsColors.error
                                  : SimatsColors.onSurface,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SimatsSpacing.spaceXs),
                    Text(a.description, style: SimatsTextStyles.bodySm),
                    const SizedBox(height: SimatsSpacing.spaceSm),
                    Text(
                      'Location: ${a.location}',
                      style: SimatsTextStyles.labelSm,
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: SimatsSpacing.space3xl),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color accent) {
    return Container(
      padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
      decoration: BoxDecoration(
        color: SimatsColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
        border: Border.all(color: SimatsColors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: accent, size: 28),
          const SizedBox(width: SimatsSpacing.spaceSm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: SimatsTextStyles.headlineMd.copyWith(
                  color: SimatsColors.primary,
                ),
              ),
              Text(
                label,
                style: SimatsTextStyles.bodySm.copyWith(
                  color: SimatsColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

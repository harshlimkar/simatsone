import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/alerts_provider.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alerts = ref.watch(filteredAlertsProvider);
    final currentFilter = ref.watch(activeAlertFilterProvider);
    final repo = ref.read(alertRepositoryProvider);

    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: SimatsAppBar(
        subtitle: 'Campus Security Alerts',
        notificationCount: 2,
        onNotificationsTap: () => context.push('/student/notifications'),
        onProfileTap: () => context.push('/student/profile'),
      ),
      bottomNavigationBar: SimatsBottomNav(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/student/dashboard');
              break;
            case 1:
              context.push('/student/campus');
              break;
            case 2:
              break;
            case 3:
              context.push('/student/profile');
              break;
          }
        },
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: SimatsSpacing.marginMobile,
            vertical: SimatsSpacing.spaceBase,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Status & Context Header
              _buildHeader(),
              const SizedBox(height: SimatsSpacing.spaceSm),

              // 2. 24/7 Security Desk Status Pill
              _buildSecurityDeskPill(),
              const SizedBox(height: SimatsSpacing.spaceBase),

              // 3. Filter Chips
              _buildFilterChips(ref, currentFilter),
              const SizedBox(height: SimatsSpacing.spaceBase),

              // 4. Alert Cards List
              if (alerts.isEmpty)
                const SimatsEmptyState(
                  title: 'No Active Alerts',
                  message:
                      'No active safety directives or incident reports in this category.',
                  icon: Icons.shield_outlined,
                )
              else
                ...alerts.map(
                  (alert) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: SimatsSpacing.spaceBase,
                    ),
                    child: SimatsAlertCard(
                      id: alert.id,
                      title: alert.title,
                      description: alert.description,
                      severity: alert.severity,
                      category: alert.category,
                      location: alert.location,
                      issuedBy: alert.issuedBy,
                      timeAgo: '3 mins ago',
                      safeRouteProtocol: alert.safeRouteProtocol,
                      isAcknowledged: alert.isAcknowledged,
                      onAcknowledge: () async {
                        await repo.acknowledgeAlert(alert.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Alert acknowledged.'),
                              backgroundColor: SimatsColors.primary,
                            ),
                          );
                        }
                      },
                      onViewSafeRoute: () => _showSafeRouteModal(context),
                      onTap: () => context.push('/alerts/${alert.id}'),
                    ),
                  ),
                ),

              const SizedBox(height: SimatsSpacing.space3xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Campus Alerts & Safety',
              style: SimatsTextStyles.headlineLg.copyWith(
                color: SimatsColors.primary,
              ),
            ),
            Text(
              'Real-time incident response & facility directives',
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
            color: SimatsColors.surfaceContainerHigh,
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
                'Live Feed',
                style: SimatsTextStyles.labelSm.copyWith(
                  fontWeight: FontWeight.w700,
                  color: SimatsColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityDeskPill() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SimatsSpacing.spaceMd,
        vertical: SimatsSpacing.spaceSm,
      ),
      decoration: BoxDecoration(
        color: SimatsColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(SimatsSpacing.spaceMd),
        border: Border.all(color: SimatsColors.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_user_rounded,
            size: 18,
            color: SimatsColors.secondary,
          ),
          const SizedBox(width: SimatsSpacing.spaceXs),
          Expanded(
            child: Text(
              'All Systems Monitored • 24/7 Security Desk Active',
              style: SimatsTextStyles.labelSm.copyWith(
                color: SimatsColors.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            'SEC-01',
            style: SimatsTextStyles.codeNum.copyWith(
              color: SimatsColors.secondaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(WidgetRef ref, String currentFilter) {
    final filters = [
      ('all', 'All (4)'),
      ('emergency', 'Emergency (1)'),
      ('security', 'Security (1)'),
      ('weather', 'Weather (1)'),
      ('academic', 'Academic Info (1)'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((f) {
          final isSelected = currentFilter == f.$1;
          return Padding(
            padding: const EdgeInsets.only(right: SimatsSpacing.spaceXs),
            child: FilterChip(
              selected: isSelected,
              label: Text(f.$2),
              labelStyle: SimatsTextStyles.labelMd.copyWith(
                color: isSelected
                    ? SimatsColors.onPrimary
                    : SimatsColors.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              backgroundColor: SimatsColors.surfaceContainer,
              selectedColor: SimatsColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
              side: BorderSide.none,
              showCheckmark: false,
              onSelected: (_) {
                ref.read(activeAlertFilterProvider.notifier).state = f.$1;
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showSafeRouteModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: SimatsColors.surfaceContainerLowest,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(SimatsSpacing.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Safe Detour Wayfinding Route',
                  style: SimatsTextStyles.titleMd.copyWith(
                    fontWeight: FontWeight.w700,
                    color: SimatsColors.primary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: SimatsSpacing.spaceSm),
            Container(
              padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
              decoration: BoxDecoration(
                color: SimatsColors.statusSuccessContainer,
                borderRadius: BorderRadius.circular(SimatsSpacing.spaceMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF065F46),
                        size: 18,
                      ),
                      const SizedBox(width: SimatsSpacing.spaceXs),
                      Text(
                        'Recommended Path: North Gate 3 Turnstiles',
                        style: SimatsTextStyles.labelMd.copyWith(
                          color: const Color(0xFF065F46),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SimatsSpacing.spaceXs),
                  Text(
                    'Follow the covered walkway between Engineering Block 2 and the SAIL Library to bypass Gate 1 maintenance.',
                    style: SimatsTextStyles.bodySm.copyWith(
                      color: const Color(0xFF065F46),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SimatsSpacing.spaceBase),
            SizedBox(
              width: double.infinity,
              height: SimatsSpacing.buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  context.push('/student/campus');
                },
                icon: const Icon(Icons.map_rounded),
                label: const Text('Open Campus Wayfinding Map'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SimatsColors.primary,
                  foregroundColor: SimatsColors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SimatsSpacing.spaceSm),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

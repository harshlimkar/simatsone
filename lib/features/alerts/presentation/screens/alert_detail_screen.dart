import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';
import '../../../../shared/widgets/widgets.dart';
import '../providers/alerts_provider.dart';

class AlertDetailScreen extends ConsumerWidget {
  const AlertDetailScreen({super.key, required this.alertId});

  final String alertId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(alertsStreamProvider);

    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: AppBar(
        title: const Text('Alert Incident Report'),
        backgroundColor: SimatsColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: alertsAsync.when(
        data: (alerts) {
          final alert = alerts.firstWhere(
            (a) => a.id == alertId,
            orElse: () => alerts.first,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(SimatsSpacing.marginMobile),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
                  decoration: BoxDecoration(
                    color: SimatsColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(
                      SimatsSpacing.spaceBase,
                    ),
                    border: Border.all(color: SimatsColors.outlineVariant),
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
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Text(
                              '${alert.category.displayName} • ${alert.severity.displayName}',
                              style: SimatsTextStyles.labelSm.copyWith(
                                fontWeight: FontWeight.w700,
                                color: SimatsColors.primary,
                              ),
                            ),
                          ),
                          Text(
                            'Ref #${alert.id}',
                            style: SimatsTextStyles.codeNum,
                          ),
                        ],
                      ),
                      const SizedBox(height: SimatsSpacing.spaceBase),
                      Text(
                        alert.title,
                        style: SimatsTextStyles.headlineSm.copyWith(
                          color: SimatsColors.primary,
                        ),
                      ),
                      const SizedBox(height: SimatsSpacing.spaceSm),
                      Text(alert.description, style: SimatsTextStyles.bodyLg),
                      const SizedBox(height: SimatsSpacing.spaceBase),
                      const Divider(),
                      const SizedBox(height: SimatsSpacing.spaceSm),
                      _detailRow(
                        Icons.location_on_outlined,
                        'Location',
                        alert.location,
                      ),
                      const SizedBox(height: SimatsSpacing.spaceXs),
                      _detailRow(
                        Icons.shield_outlined,
                        'Authorized Authority',
                        alert.issuedBy,
                      ),
                      const SizedBox(height: SimatsSpacing.spaceXs),
                      _detailRow(
                        Icons.schedule_outlined,
                        'Valid Until',
                        '${alert.expiresAt.hour}:${alert.expiresAt.minute.toString().padLeft(2, '0')}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: SimatsSpacing.spaceBase),
                if (alert.safeRouteProtocol != null)
                  Container(
                    padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
                    decoration: BoxDecoration(
                      color: SimatsColors.statusSuccessContainer,
                      borderRadius: BorderRadius.circular(
                        SimatsSpacing.spaceBase,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recommended Safe Detour Protocol',
                          style: SimatsTextStyles.titleMd.copyWith(
                            color: const Color(0xFF065F46),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: SimatsSpacing.spaceXs),
                        Text(
                          alert.safeRouteProtocol!,
                          style: SimatsTextStyles.bodyMd.copyWith(
                            color: const Color(0xFF065F46),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: SimatsSpacing.spaceBase),
                SimatsButton(
                  label: alert.isAcknowledged
                      ? 'Already Acknowledged'
                      : 'Acknowledge Advisory',
                  variant: alert.isAcknowledged
                      ? SimatsButtonVariant.ghost
                      : SimatsButtonVariant.primary,
                  onPressed: alert.isAcknowledged
                      ? null
                      : () async {
                          await ref
                              .read(alertRepositoryProvider)
                              .acknowledgeAlert(alert.id);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) =>
            const SimatsErrorState(message: 'Could not load alert detail'),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: SimatsColors.onSurfaceVariant),
        const SizedBox(width: SimatsSpacing.spaceXs),
        Text(
          '$label: ',
          style: SimatsTextStyles.labelMd.copyWith(
            color: SimatsColors.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: SimatsTextStyles.bodyMd.copyWith(
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

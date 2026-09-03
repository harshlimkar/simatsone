import 'package:flutter/material.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_text_styles.dart';
import '../../app/theme/simats_spacing.dart';
import '../../shared/models/enums.dart';

class SimatsAlertCard extends StatelessWidget {
  const SimatsAlertCard({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.category,
    required this.location,
    required this.issuedBy,
    required this.timeAgo,
    this.safeRouteProtocol,
    this.isAcknowledged = false,
    this.onAcknowledge,
    this.onViewSafeRoute,
    this.onTap,
  });

  final String id;
  final String title;
  final String description;
  final AlertSeverity severity;
  final AlertCategory category;
  final String location;
  final String issuedBy;
  final String timeAgo;
  final String? safeRouteProtocol;
  final bool isAcknowledged;
  final VoidCallback? onAcknowledge;
  final VoidCallback? onViewSafeRoute;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (severity == AlertSeverity.critical) {
      return _CriticalAlertCard(
        title: title,
        description: description,
        location: location,
        issuedBy: issuedBy,
        timeAgo: timeAgo,
        safeRouteProtocol: safeRouteProtocol,
        isAcknowledged: isAcknowledged,
        onAcknowledge: onAcknowledge,
        onViewSafeRoute: onViewSafeRoute,
        onTap: onTap,
      );
    }

    return _StandardAlertCard(
      title: title,
      description: description,
      severity: severity,
      category: category,
      location: location,
      issuedBy: issuedBy,
      timeAgo: timeAgo,
      isAcknowledged: isAcknowledged,
      onTap: onTap,
    );
  }
}

class _CriticalAlertCard extends StatelessWidget {
  const _CriticalAlertCard({
    required this.title,
    required this.description,
    required this.location,
    required this.issuedBy,
    required this.timeAgo,
    this.safeRouteProtocol,
    required this.isAcknowledged,
    this.onAcknowledge,
    this.onViewSafeRoute,
    this.onTap,
  });

  final String title;
  final String description;
  final String location;
  final String issuedBy;
  final String timeAgo;
  final String? safeRouteProtocol;
  final bool isAcknowledged;
  final VoidCallback? onAcknowledge;
  final VoidCallback? onViewSafeRoute;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SimatsColors.errorContainer,
        borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
        boxShadow: [
          BoxShadow(
            color: SimatsColors.error.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Broadcast pill + Critical badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: SimatsColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: SimatsSpacing.spaceXs),
                  Text(
                    'HIGH PRIORITY BROADCAST',
                    style: SimatsTextStyles.headlineSm.copyWith(
                      color: SimatsColors.error,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
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
                  color: SimatsColors.error,
                  borderRadius: BorderRadius.circular(SimatsSpacing.spaceSm),
                ),
                child: Text(
                  'CRITICAL',
                  style: SimatsTextStyles.labelSm.copyWith(
                    color: SimatsColors.onError,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SimatsSpacing.spaceSm),

          // Metadata row
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 14,
                color: SimatsColors.onErrorContainer,
              ),
              const SizedBox(width: SimatsSpacing.space2xs),
              Text(
                timeAgo,
                style: SimatsTextStyles.labelSm.copyWith(
                  color: SimatsColors.onErrorContainer,
                ),
              ),
              const SizedBox(width: SimatsSpacing.spaceXs),
              Text(
                '•',
                style: SimatsTextStyles.labelSm.copyWith(
                  color: SimatsColors.onErrorContainer,
                ),
              ),
              const SizedBox(width: SimatsSpacing.spaceXs),
              const Icon(
                Icons.shield_outlined,
                size: 14,
                color: SimatsColors.onErrorContainer,
              ),
              const SizedBox(width: SimatsSpacing.space2xs),
              Flexible(
                child: Text(
                  issuedBy,
                  style: SimatsTextStyles.labelSm.copyWith(
                    color: SimatsColors.onErrorContainer,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: SimatsSpacing.spaceSm),

          // Incident details box
          Container(
            padding: const EdgeInsets.all(SimatsSpacing.spaceSm),
            decoration: BoxDecoration(
              color: SimatsColors.surfaceContainerLowest.withOpacity(0.85),
              borderRadius: BorderRadius.circular(SimatsSpacing.spaceSm),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.wrong_location_outlined,
                  size: 20,
                  color: SimatsColors.error,
                ),
                const SizedBox(width: SimatsSpacing.spaceXs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zone: $location',
                        style: SimatsTextStyles.labelMd.copyWith(
                          color: SimatsColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: SimatsSpacing.space2xs),
                      Text(
                        description,
                        style: SimatsTextStyles.bodyMd.copyWith(
                          color: SimatsColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SimatsSpacing.spaceSm),

          // Safe detour protocol box
          if (safeRouteProtocol != null)
            Container(
              padding: const EdgeInsets.all(SimatsSpacing.spaceSm),
              decoration: BoxDecoration(
                color: SimatsColors.surfaceContainerLowest.withOpacity(0.9),
                borderRadius: BorderRadius.circular(SimatsSpacing.spaceSm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.alt_route_rounded,
                        size: 18,
                        color: SimatsColors.secondary,
                      ),
                      const SizedBox(width: SimatsSpacing.spaceXs),
                      Text(
                        'Mandatory Safe Detour Protocol',
                        style: SimatsTextStyles.labelMd.copyWith(
                          color: SimatsColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SimatsSpacing.space2xs),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(
                      safeRouteProtocol!,
                      style: SimatsTextStyles.bodySm.copyWith(
                        color: SimatsColors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: SimatsSpacing.spaceMd),

          // Actions Row
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: SimatsSpacing.buttonHeight,
                  child: ElevatedButton.icon(
                    onPressed: onViewSafeRoute,
                    icon: const Icon(Icons.navigation_rounded, size: 18),
                    label: const Text('View Safe Route'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SimatsColors.error,
                      foregroundColor: SimatsColors.onError,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          SimatsSpacing.spaceSm,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: SimatsSpacing.spaceSm),
              SizedBox(
                height: SimatsSpacing.buttonHeight,
                child: OutlinedButton.icon(
                  onPressed: isAcknowledged ? null : onAcknowledge,
                  icon: Icon(
                    isAcknowledged
                        ? Icons.check_circle_rounded
                        : Icons.check_circle_outline_rounded,
                    size: 18,
                    color: isAcknowledged
                        ? SimatsColors.statusSuccess
                        : SimatsColors.error,
                  ),
                  label: Text(
                    isAcknowledged ? 'Acknowledged' : 'Acknowledge',
                    style: TextStyle(
                      color: isAcknowledged
                          ? SimatsColors.statusSuccess
                          : SimatsColors.error,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: SimatsColors.surfaceContainerLowest,
                    side: BorderSide(
                      color: isAcknowledged
                          ? SimatsColors.statusSuccess
                          : SimatsColors.error,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        SimatsSpacing.spaceSm,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StandardAlertCard extends StatelessWidget {
  const _StandardAlertCard({
    required this.title,
    required this.description,
    required this.severity,
    required this.category,
    required this.location,
    required this.issuedBy,
    required this.timeAgo,
    required this.isAcknowledged,
    this.onTap,
  });

  final String title;
  final String description;
  final AlertSeverity severity;
  final AlertCategory category;
  final String location;
  final String issuedBy;
  final String timeAgo;
  final bool isAcknowledged;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final iconData = switch (category) {
      AlertCategory.emergency => Icons.emergency_rounded,
      AlertCategory.security => Icons.shield_rounded,
      AlertCategory.weather => Icons.thunderstorm_rounded,
      AlertCategory.academic => Icons.school_rounded,
      AlertCategory.information => Icons.info_rounded,
    };

    return Container(
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
        child: Padding(
          padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: SimatsColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(
                              SimatsSpacing.spaceSm,
                            ),
                          ),
                          child: Icon(
                            iconData,
                            size: 20,
                            color: SimatsColors.secondary,
                          ),
                        ),
                        const SizedBox(width: SimatsSpacing.spaceSm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: SimatsTextStyles.titleMd.copyWith(
                                  color: SimatsColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                timeAgo,
                                style: SimatsTextStyles.bodySm.copyWith(
                                  color: SimatsColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: SimatsSpacing.spaceSm),
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
                      '${category.displayName} / ${severity.displayName}',
                      style: SimatsTextStyles.labelSm.copyWith(
                        color: SimatsColors.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SimatsSpacing.spaceSm),

              // Description
              Text(
                description,
                style: SimatsTextStyles.bodyMd.copyWith(
                  color: SimatsColors.onSurface,
                ),
              ),
              const SizedBox(height: SimatsSpacing.spaceSm),

              // Location footer
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: SimatsColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: SimatsSpacing.space2xs),
                  Expanded(
                    child: Text(
                      location,
                      style: SimatsTextStyles.labelSm.copyWith(
                        color: SimatsColors.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    'Issued by $issuedBy',
                    style: SimatsTextStyles.labelSm.copyWith(
                      color: SimatsColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

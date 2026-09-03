import 'package:flutter/material.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_text_styles.dart';
import '../../app/theme/simats_spacing.dart';
import '../../shared/models/enums.dart';

class SimatsTimetableCard extends StatelessWidget {
  const SimatsTimetableCard({
    super.key,
    required this.timeRange,
    required this.courseCode,
    required this.courseTitle,
    required this.facultyName,
    required this.roomLocation,
    this.classType = ClassType.lecture,
    this.isLive = false,
    this.remainingMinutes,
    this.slotBadgeText,
    this.onNavigate,
    this.onTap,
  });

  final String timeRange;
  final String courseCode;
  final String courseTitle;
  final String facultyName;
  final String roomLocation;
  final ClassType classType;
  final bool isLive;
  final int? remainingMinutes;
  final String? slotBadgeText;
  final VoidCallback? onNavigate;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = switch (classType) {
      ClassType.lecture => SimatsColors.secondary,
      ClassType.lab => SimatsColors.tertiary,
      ClassType.seminar => SimatsColors.statusSuccess,
      ClassType.tutorial => SimatsColors.surfaceTint,
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
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Left accent bar
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 6,
            child: Container(color: accentColor),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row: Time + Code + Live badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                timeRange,
                                style: SimatsTextStyles.codeNum.copyWith(
                                  color: SimatsColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: SimatsSpacing.spaceXs),
                              Container(
                                width: 4,
                                height: 4,
                                decoration: const BoxDecoration(
                                  color: SimatsColors.outlineVariant,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: SimatsSpacing.spaceXs),
                              Text(
                                courseCode,
                                style: SimatsTextStyles.labelSm.copyWith(
                                  color: SimatsColors.secondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          if (isLive)
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
                                    remainingMinutes != null
                                        ? 'Live (${remainingMinutes}m left)'
                                        : 'Live Now',
                                    style: SimatsTextStyles.labelSm.copyWith(
                                      color: SimatsColors.onSecondaryFixed,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (slotBadgeText != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SimatsSpacing.spaceSm,
                                vertical: SimatsSpacing.space2xs,
                              ),
                              decoration: BoxDecoration(
                                color: SimatsColors.surfaceContainer,
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Text(
                                slotBadgeText!,
                                style: SimatsTextStyles.labelSm.copyWith(
                                  color: SimatsColors.onSurfaceVariant,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: SimatsSpacing.spaceSm),

                      // Title
                      Text(
                        courseTitle,
                        style: SimatsTextStyles.titleMd.copyWith(
                          color: SimatsColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: SimatsSpacing.space2xs),

                      // Faculty
                      Text(
                        facultyName,
                        style: SimatsTextStyles.bodySm.copyWith(
                          color: SimatsColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom location & navigate bar (for live / active classes)
                if (isLive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SimatsSpacing.spaceBase,
                      vertical: SimatsSpacing.spaceSm,
                    ),
                    decoration: BoxDecoration(
                      color: SimatsColors.surfaceContainerLow.withOpacity(0.7),
                      border: const Border(
                        top: BorderSide(
                          color: SimatsColors.outlineVariant,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.apartment_rounded,
                              size: 18,
                              color: SimatsColors.secondary,
                            ),
                            const SizedBox(width: SimatsSpacing.spaceXs),
                            Text(
                              roomLocation,
                              style: SimatsTextStyles.labelMd.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: onNavigate,
                          borderRadius: BorderRadius.circular(
                            SimatsSpacing.spaceSm,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: SimatsSpacing.spaceBase,
                              vertical: SimatsSpacing.spaceXs,
                            ),
                            decoration: BoxDecoration(
                              color: SimatsColors.primary,
                              borderRadius: BorderRadius.circular(
                                SimatsSpacing.spaceSm,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: SimatsColors.primary.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.navigation_rounded,
                                  size: 16,
                                  color: SimatsColors.onPrimary,
                                ),
                                const SizedBox(width: SimatsSpacing.space2xs),
                                Text(
                                  'Navigate',
                                  style: SimatsTextStyles.labelMd.copyWith(
                                    color: SimatsColors.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(
                      left: SimatsSpacing.spaceBase,
                      right: SimatsSpacing.spaceBase,
                      bottom: SimatsSpacing.spaceBase,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.meeting_room_outlined,
                          size: 16,
                          color: SimatsColors.onSurfaceVariant,
                        ),
                        const SizedBox(width: SimatsSpacing.spaceXs),
                        Text(
                          roomLocation,
                          style: SimatsTextStyles.labelSm.copyWith(
                            color: SimatsColors.onSurfaceVariant,
                          ),
                        ),
                      ],
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

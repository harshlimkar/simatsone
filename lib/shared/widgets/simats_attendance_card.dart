import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_text_styles.dart';
import '../../app/theme/simats_spacing.dart';

class SimatsAttendanceCard extends StatelessWidget {
  const SimatsAttendanceCard({
    super.key,
    required this.percentage,
    required this.semester,
    required this.totalCourses,
    required this.coursesBelowThreshold,
    this.onTapBreakdown,
  });

  final double percentage;
  final int semester;
  final int totalCourses;
  final int coursesBelowThreshold;
  final VoidCallback? onTapBreakdown;

  @override
  Widget build(BuildContext context) {
    final isGood = percentage >= 85.0;
    final isWarning = percentage < 85.0 && percentage >= 75.0;

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
      padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.donut_large_rounded,
                    color: SimatsColors.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: SimatsSpacing.spaceXs),
                  Text(
                    'Biometric Attendance',
                    style: SimatsTextStyles.headlineSm.copyWith(
                      color: SimatsColors.primary,
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
                  color: SimatsColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  'Semester $semester',
                  style: SimatsTextStyles.labelSm.copyWith(
                    color: SimatsColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SimatsSpacing.spaceBase),

          // Main Metric Row
          Row(
            children: [
              // Circular Metric
              SizedBox(
                width: 96,
                height: 96,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(96, 96),
                      painter: _CircularProgressPainter(
                        percentage: percentage,
                        progressColor: isGood
                            ? SimatsColors.secondary
                            : isWarning
                            ? SimatsColors.statusWarning
                            : SimatsColors.statusDanger,
                        trackColor: SimatsColors.surfaceContainerHigh,
                        strokeWidth: 9,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: SimatsTextStyles.headlineMd.copyWith(
                            fontWeight: FontWeight.w700,
                            color: SimatsColors.primary,
                          ),
                        ),
                        Text(
                          'AGGREGATED',
                          style: SimatsTextStyles.labelSm.copyWith(
                            fontSize: 9,
                            letterSpacing: 0.5,
                            color: SimatsColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: SimatsSpacing.spaceLg),

              // Breakdown details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: SimatsColors.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: SimatsSpacing.spaceXs),
                        Expanded(
                          child: Text(
                            '$totalCourses Theory & Lab Courses',
                            style: SimatsTextStyles.bodySm.copyWith(
                              color: SimatsColors.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SimatsSpacing.spaceXs),
                    if (coursesBelowThreshold > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SimatsSpacing.spaceSm,
                          vertical: SimatsSpacing.space2xs,
                        ),
                        decoration: BoxDecoration(
                          color: SimatsColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(
                            SimatsSpacing.spaceSm,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.priority_high_rounded,
                              size: 14,
                              color: SimatsColors.error,
                            ),
                            const SizedBox(width: SimatsSpacing.space2xs),
                            Flexible(
                              child: Text(
                                '$coursesBelowThreshold courses below 85% threshold',
                                style: SimatsTextStyles.labelSm.copyWith(
                                  color: SimatsColors.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: SimatsSpacing.spaceXs),
                    Text(
                      isGood
                          ? 'Eligible for End-Sem Exam hall ticket'
                          : 'Attention required to avoid detention risk',
                      style: SimatsTextStyles.labelSm.copyWith(
                        color: isGood
                            ? SimatsColors.onSurfaceVariant
                            : SimatsColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: SimatsSpacing.spaceBase),

          // Action Link
          InkWell(
            onTap: onTapBreakdown,
            borderRadius: BorderRadius.circular(SimatsSpacing.spaceSm),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SimatsSpacing.spaceBase,
                vertical: SimatsSpacing.spaceSm,
              ),
              decoration: BoxDecoration(
                color: SimatsColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(SimatsSpacing.spaceSm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'View Detailed Course Breakdown',
                    style: SimatsTextStyles.labelLg.copyWith(
                      color: SimatsColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: SimatsColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  const _CircularProgressPainter({
    required this.percentage,
    required this.progressColor,
    required this.trackColor,
    required this.strokeWidth,
  });

  final double percentage;
  final Color progressColor;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, trackPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * (percentage.clamp(0.0, 100.0) / 100.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.progressColor != progressColor;
  }
}

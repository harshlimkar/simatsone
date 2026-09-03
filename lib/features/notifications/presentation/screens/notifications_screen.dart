import 'package:flutter/material.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final _notifications = const [
    (
      title: 'Emergency Broadcast: Gate 1 Restricted Access',
      category: 'Security',
      time: '3 mins ago',
      isUnread: true,
      icon: Icons.warning_amber_rounded,
    ),
    (
      title: 'Biometric Attendance Synchronized (86.4%)',
      category: 'Attendance',
      time: '18 mins ago',
      isUnread: true,
      icon: Icons.donut_large_rounded,
    ),
    (
      title: 'COE Examination Timetable Published for Autumn 2024',
      category: 'Academic',
      time: '1 hour ago',
      isUnread: false,
      icon: Icons.school_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: SimatsColors.surface,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(SimatsSpacing.marginMobile),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: SimatsSpacing.spaceSm),
        itemBuilder: (ctx, i) {
          final n = _notifications[i];
          return Container(
            padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
            decoration: BoxDecoration(
              color: n.isUnread
                  ? SimatsColors.surfaceContainerLow
                  : SimatsColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
              border: Border.all(
                color: n.isUnread
                    ? SimatsColors.secondary
                    : SimatsColors.outlineVariant,
                width: n.isUnread ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: SimatsColors.surfaceContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(n.icon, size: 18, color: SimatsColors.secondary),
                ),
                const SizedBox(width: SimatsSpacing.spaceSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            n.category,
                            style: SimatsTextStyles.labelSm.copyWith(
                              color: SimatsColors.secondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(n.time, style: SimatsTextStyles.labelSm),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        n.title,
                        style: SimatsTextStyles.titleMd.copyWith(
                          color: SimatsColors.primary,
                          fontWeight: n.isUnread
                              ? FontWeight.w700
                              : FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

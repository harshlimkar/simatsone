import 'package:flutter/material.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_text_styles.dart';
import '../../app/theme/simats_spacing.dart';
import '../../shared/models/enums.dart';

class SimatsOfflineBanner extends StatelessWidget {
  const SimatsOfflineBanner({
    super.key,
    required this.status,
    this.lastSyncTime,
  });

  final NetworkStatus status;
  final DateTime? lastSyncTime;

  @override
  Widget build(BuildContext context) {
    if (status.isConnected) return const SizedBox.shrink();

    final label = lastSyncTime != null
        ? 'Offline — Last synced at ${_formatTime(lastSyncTime!)}'
        : 'Offline — Viewing local cached records';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: SimatsSpacing.spaceBase,
        vertical: SimatsSpacing.spaceSm,
      ),
      color: SimatsColors.statusOfflineContainer,
      child: Row(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 16,
            color: SimatsColors.statusOffline,
          ),
          const SizedBox(width: SimatsSpacing.spaceXs),
          Expanded(
            child: Text(
              label,
              style: SimatsTextStyles.labelMd.copyWith(
                color: SimatsColors.statusOffline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

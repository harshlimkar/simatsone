import 'package:flutter/material.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_text_styles.dart';
import '../../app/theme/simats_spacing.dart';
import '../../shared/models/enums.dart';

class SimatsSyncIndicator extends StatelessWidget {
  const SimatsSyncIndicator({
    super.key,
    required this.syncStatus,
    this.lastSynced,
  });
  final SyncStatus syncStatus;
  final DateTime? lastSynced;
  @override
  Widget build(BuildContext c) {
    Color dotColor;
    String label;
    switch (syncStatus) {
      case SyncStatus.synced:
        dotColor = SimatsColors.statusSuccess;
        label = 'Synced';
        break;
      case SyncStatus.syncing:
        dotColor = SimatsColors.secondary;
        label = 'Syncing...';
        break;
      case SyncStatus.pending:
        dotColor = SimatsColors.statusWarning;
        label = 'Pending sync';
        break;
      case SyncStatus.failed:
        dotColor = SimatsColors.error;
        label = 'Sync failed';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SimatsSpacing.spaceSm,
        vertical: SimatsSpacing.space2xs,
      ),
      decoration: BoxDecoration(
        color: SimatsColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: SimatsColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: SimatsSpacing.spaceXs),
          Text(
            label,
            style: SimatsTextStyles.labelSm.copyWith(
              color: SimatsColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_text_styles.dart';
import '../../app/theme/simats_spacing.dart';

enum SimatsChipType { success, warning, danger, info, neutral, primary }

class SimatsStatusChip extends StatelessWidget {
  const SimatsStatusChip({
    super.key,
    required this.label,
    this.type = SimatsChipType.neutral,
    this.icon,
  });
  final String label;
  final SimatsChipType type;
  final IconData? icon;
  @override
  Widget build(BuildContext c) {
    Color bg, fg;
    switch (type) {
      case SimatsChipType.success:
        bg = SimatsColors.statusSuccessContainer;
        fg = const Color(0xFF065F46);
        break;
      case SimatsChipType.warning:
        bg = SimatsColors.statusWarningContainer;
        fg = const Color(0xFF92400E);
        break;
      case SimatsChipType.danger:
        bg = SimatsColors.statusDangerContainer;
        fg = SimatsColors.error;
        break;
      case SimatsChipType.info:
        bg = SimatsColors.statusInfoContainer;
        fg = SimatsColors.secondary;
        break;
      case SimatsChipType.neutral:
        bg = SimatsColors.surfaceContainerHigh;
        fg = SimatsColors.onSurfaceVariant;
        break;
      case SimatsChipType.primary:
        bg = SimatsColors.primaryFixed;
        fg = SimatsColors.primary;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SimatsSpacing.spaceSm,
        vertical: SimatsSpacing.space2xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: fg.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: fg),
            const SizedBox(width: SimatsSpacing.space2xs),
          ],
          Text(label, style: SimatsTextStyles.labelMd.copyWith(color: fg)),
        ],
      ),
    );
  }
}

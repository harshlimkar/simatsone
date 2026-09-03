import 'package:flutter/material.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_text_styles.dart';
import '../../app/theme/simats_spacing.dart';
import 'simats_button.dart';

class SimatsEmptyState extends StatelessWidget {
  const SimatsEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });
  final String title, message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext c) => Center(
    child: Padding(
      padding: const EdgeInsets.all(SimatsSpacing.space2xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: SimatsColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36, color: SimatsColors.onSurfaceVariant),
          ),
          const SizedBox(height: SimatsSpacing.spaceBase),
          Text(
            title,
            style: SimatsTextStyles.headlineSm,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: SimatsSpacing.spaceXs),
          Text(
            message,
            style: SimatsTextStyles.bodyMd.copyWith(
              color: SimatsColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: SimatsSpacing.spaceBase),
            SimatsButton(
              label: actionLabel!,
              onPressed: onAction,
              variant: SimatsButtonVariant.secondary,
            ),
          ],
        ],
      ),
    ),
  );
}

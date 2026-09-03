import 'package:flutter/material.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_text_styles.dart';
import '../../app/theme/simats_spacing.dart';
import 'simats_button.dart';

class SimatsErrorState extends StatelessWidget {
  const SimatsErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  });
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  @override
  Widget build(BuildContext c) => Center(
    child: Padding(
      padding: const EdgeInsets.all(SimatsSpacing.space2xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: SimatsColors.errorContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 32, color: SimatsColors.error),
          ),
          const SizedBox(height: SimatsSpacing.spaceBase),
          Text(
            'Something went wrong',
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
          if (onRetry != null) ...[
            const SizedBox(height: SimatsSpacing.spaceBase),
            SimatsButton(
              label: 'Try Again',
              onPressed: onRetry,
              icon: Icons.refresh_rounded,
              variant: SimatsButtonVariant.secondary,
            ),
          ],
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_text_styles.dart';
import '../../app/theme/simats_spacing.dart';

enum SimatsButtonVariant { primary, secondary, ghost, danger }

class SimatsButton extends StatelessWidget {
  const SimatsButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = SimatsButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.width,
  });
  final String label;
  final VoidCallback? onPressed;
  final SimatsButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  @override
  Widget build(BuildContext context) {
    Color bg, fg, border;
    switch (variant) {
      case SimatsButtonVariant.primary:
        bg = SimatsColors.primary;
        fg = SimatsColors.onPrimary;
        border = SimatsColors.primary;
        break;
      case SimatsButtonVariant.secondary:
        bg = SimatsColors.surfaceContainerLow;
        fg = SimatsColors.secondary;
        border = SimatsColors.outlineVariant;
        break;
      case SimatsButtonVariant.ghost:
        bg = Colors.transparent;
        fg = SimatsColors.primary;
        border = SimatsColors.outlineVariant;
        break;
      case SimatsButtonVariant.danger:
        bg = SimatsColors.error;
        fg = SimatsColors.onError;
        border = SimatsColors.error;
        break;
    }
    return SizedBox(
      width: width,
      height: SimatsSpacing.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          side: BorderSide(
            color: border,
            width: variant == SimatsButtonVariant.primary ? 0 : 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SimatsSpacing.spaceMd),
          ),
          elevation: variant == SimatsButtonVariant.primary ? 1 : 0,
          padding: const EdgeInsets.symmetric(
            horizontal: SimatsSpacing.spaceBase,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: fg),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18),
                    const SizedBox(width: SimatsSpacing.spaceXs),
                  ],
                  Text(
                    label,
                    style: SimatsTextStyles.labelLg.copyWith(color: fg),
                  ),
                ],
              ),
      ),
    );
  }
}

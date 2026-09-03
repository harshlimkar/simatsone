import 'package:flutter/material.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_spacing.dart';

class SimatsCard extends StatelessWidget {
  const SimatsCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) => Material(
    color: color ?? SimatsColors.surfaceContainerLowest,
    borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
      child: Container(
        padding: padding ?? const EdgeInsets.all(SimatsSpacing.spaceBase),
        decoration: BoxDecoration(
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
        child: child,
      ),
    ),
  );
}

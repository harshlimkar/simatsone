import 'package:flutter/material.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_spacing.dart';

class SimatsSkeleton extends StatefulWidget {
  const SimatsSkeleton({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final double? borderRadius;

  @override
  State<SimatsSkeleton> createState() => _SimatsSkeletonState();
}

class _SimatsSkeletonState extends State<SimatsSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _anim = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: SimatsColors.surfaceContainerHigh.withValues(
            alpha: _anim.value,
          ),
          borderRadius: BorderRadius.circular(
            widget.borderRadius ?? SimatsSpacing.spaceSm,
          ),
        ),
      ),
    );
  }
}

class SimatsCardSkeleton extends StatelessWidget {
  const SimatsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
      decoration: BoxDecoration(
        color: SimatsColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
        border: Border.all(color: SimatsColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SimatsSkeleton(width: 40, height: 40, borderRadius: 20),
              const SizedBox(width: SimatsSpacing.spaceSm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SimatsSkeleton(width: 120, height: 14),
                  SizedBox(height: SimatsSpacing.spaceXs),
                  SimatsSkeleton(width: 80, height: 11),
                ],
              ),
            ],
          ),
          const SizedBox(height: SimatsSpacing.spaceMd),
          const SimatsSkeleton(width: double.infinity, height: 12),
          const SizedBox(height: SimatsSpacing.spaceXs),
          const SimatsSkeleton(width: 200, height: 12),
        ],
      ),
    );
  }
}

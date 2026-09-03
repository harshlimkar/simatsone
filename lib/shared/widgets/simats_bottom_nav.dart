import 'package:flutter/material.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_text_styles.dart';
import '../../app/theme/simats_spacing.dart';

class SimatsBottomNav extends StatelessWidget {
  const SimatsBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.alertBadge = false,
  });
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool alertBadge;
  @override
  Widget build(BuildContext c) => Container(
    decoration: BoxDecoration(
      color: SimatsColors.surface.withOpacity(0.97),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF000000).withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: SafeArea(
      top: false,
      child: SizedBox(
        height: SimatsSpacing.bottomNavHeight,
        child: Row(
          children: [
            _NavItem(
              icon: Icons.account_balance_rounded,
              label: 'Home',
              isActive: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.explore_rounded,
              label: 'Campus',
              isActive: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavItem(
              icon: Icons.shield_rounded,
              label: 'Alerts',
              isActive: currentIndex == 2,
              onTap: () => onTap(2),
              hasBadge: alertBadge,
            ),
            _NavItem(
              icon: Icons.person_rounded,
              label: 'Profile',
              isActive: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    ),
  );
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.hasBadge = false,
  });
  final IconData icon;
  final String label;
  final bool isActive, hasBadge;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext c) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: SimatsSpacing.spaceSm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: SimatsSpacing.spaceSm,
                    vertical: SimatsSpacing.spaceXs,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? SimatsColors.primaryContainer
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(SimatsSpacing.spaceMd),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isActive
                        ? SimatsColors.onPrimary
                        : SimatsColors.onSurfaceVariant,
                  ),
                ),
                if (hasBadge)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: SimatsColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: SimatsTextStyles.labelSm.copyWith(
                color: isActive
                    ? SimatsColors.primary
                    : SimatsColors.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

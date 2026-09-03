// SIMATS ONE – SimatsAppBar
// Fixed app bar matching Stitch design:
// Logo | App name + network status pill | Actions (notifications + avatar)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_text_styles.dart';
import '../../app/theme/simats_spacing.dart';
import '../../core/connectivity/network_monitor.dart';
import '../../shared/models/enums.dart';
import 'simats_network_badge.dart';

class SimatsAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const SimatsAppBar({
    super.key,
    this.subtitle,
    this.actions,
    this.notificationCount = 0,
    this.onNotificationsTap,
    this.onProfileTap,
    this.profileImageUrl,
    this.showNetworkBadge = true,
  });

  final String? subtitle;
  final List<Widget>? actions;
  final int notificationCount;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onProfileTap;
  final String? profileImageUrl;
  final bool showNetworkBadge;

  @override
  Size get preferredSize => const Size.fromHeight(SimatsSpacing.appBarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkStatus = ref
        .watch(networkStatusProvider)
        .maybeWhen(data: (s) => s, orElse: () => NetworkStatus.unknown);

    return Container(
      decoration: BoxDecoration(
        color: SimatsColors.surface.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0B1C30).withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: SimatsSpacing.appBarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SimatsSpacing.marginMobile,
            ),
            child: Row(
              children: [
                // ── Logo ───────────────────────────────────────────────────
                Image.asset(
                  'assets/branding/simats_logo.png',
                  height: 32,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: SimatsColors.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          color: SimatsColors.onPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: SimatsSpacing.spaceSm),

                // ── Title + Network Badge ──────────────────────────────────
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'SIMATS ONE',
                            style: SimatsTextStyles.headlineSm.copyWith(
                              color: SimatsColors.primary,
                              letterSpacing: -0.2,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(width: SimatsSpacing.spaceXs),
                            Text(
                              '| $subtitle',
                              style: SimatsTextStyles.labelSm,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                      if (showNetworkBadge) ...[
                        const SizedBox(height: SimatsSpacing.space2xs),
                        SimatsNetworkBadge(status: networkStatus),
                      ],
                    ],
                  ),
                ),

                // ── Actions ────────────────────────────────────────────────
                if (actions != null) ...actions!,

                // ── Notification Bell ──────────────────────────────────────
                SizedBox(
                  width: SimatsSpacing.minTouchTarget,
                  height: SimatsSpacing.minTouchTarget,
                  child: Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        color: SimatsColors.onSurface,
                        onPressed: onNotificationsTap,
                        tooltip: 'Notifications',
                      ),
                      if (notificationCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: SimatsColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                notificationCount > 9
                                    ? '9+'
                                    : '$notificationCount',
                                style: SimatsTextStyles.labelSm.copyWith(
                                  color: SimatsColors.onError,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // ── Profile Avatar ─────────────────────────────────────────
                GestureDetector(
                  onTap: onProfileTap,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: SimatsColors.surfaceContainer,
                      border: Border.all(
                        color: SimatsColors.outlineVariant,
                        width: 1.5,
                      ),
                    ),
                    child: profileImageUrl != null
                        ? ClipOval(
                            child: Image.network(
                              profileImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const _DefaultAvatar(),
                            ),
                          )
                        : const _DefaultAvatar(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar();

  @override
  Widget build(BuildContext context) => const Icon(
    Icons.person_rounded,
    size: 20,
    color: SimatsColors.onSurfaceVariant,
  );
}

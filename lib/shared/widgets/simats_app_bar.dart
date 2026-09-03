// SIMATS ONE – SimatsAppBar
// Fixed institutional app bar: Logo | Title + Subtitle | Actions (Notifications + Profile Avatar)
// Built with strict constraints to eliminate RenderFlex overflow on any screen size.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_text_styles.dart';
import '../../app/theme/simats_spacing.dart';
import '../../core/connectivity/network_monitor.dart';
import '../../shared/models/enums.dart';

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
        color: SimatsColors.surface,
        boxShadow: [
          BoxShadow(
            color: SimatsColors.primary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: SimatsSpacing.appBarHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: SimatsSpacing.marginMobile,
          ),
          child: Row(
            children: [
              // ── Brand Logo Icon ──────────────────────────────────────────
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: SimatsColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'S',
                    style: TextStyle(
                      color: SimatsColors.onPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: SimatsSpacing.spaceSm),

              // ── Title + Subtitle (Overflow-Proof Column) ───────────────────
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'SIMATS ONE',
                          style: SimatsTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: SimatsColors.primary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        if (showNetworkBadge) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: networkStatus.isConnected
                                  ? SimatsColors.statusSuccess
                                  : SimatsColors.statusWarning,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 1),
                      Text(
                        subtitle!,
                        style: SimatsTextStyles.labelSm.copyWith(
                          color: SimatsColors.onSurfaceVariant,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // ── Additional Actions ────────────────────────────────────────
              if (actions != null) ...actions!,

              // ── Notification Bell with Badge ──────────────────────────────
              SizedBox(
                width: 40,
                height: 40,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, size: 22),
                      color: SimatsColors.onSurface,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onNotificationsTap,
                      tooltip: 'Notifications',
                    ),
                    if (notificationCount > 0)
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: SimatsColors.error,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            notificationCount > 9 ? '9+' : '$notificationCount',
                            style: const TextStyle(
                              color: SimatsColors.onError,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 6),

              // ── Profile Avatar ────────────────────────────────────────────
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: SimatsColors.surfaceContainerHigh,
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
                            errorBuilder: (_, __, ___) => const _DefaultAvatar(),
                          ),
                        )
                      : const _DefaultAvatar(),
                ),
              ),
            ],
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
        size: 18,
        color: SimatsColors.primary,
      );
}

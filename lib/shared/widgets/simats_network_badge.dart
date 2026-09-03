// SIMATS ONE - SimatsNetworkBadge
import 'package:flutter/material.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_text_styles.dart';
import '../../app/theme/simats_spacing.dart';
import '../../shared/models/enums.dart';

class SimatsNetworkBadge extends StatelessWidget {
  const SimatsNetworkBadge({super.key, required this.status, this.ssid});
  final NetworkStatus status;
  final String? ssid;

  @override
  Widget build(BuildContext context) {
    final cfg = _config(status);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SimatsSpacing.spaceXs,
        vertical: SimatsSpacing.space2xs,
      ),
      decoration: BoxDecoration(
        color: SimatsColors.surfaceContainer,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AnimatedDot(color: cfg.$1, isAnimated: status.isConnected),
          const SizedBox(width: SimatsSpacing.space2xs),
          Text(
            ssid ?? cfg.$2,
            style: SimatsTextStyles.labelSm,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: SimatsSpacing.space2xs),
          Icon(cfg.$3, size: 12, color: SimatsColors.secondary),
        ],
      ),
    );
  }

  (Color, String, IconData) _config(NetworkStatus s) => switch (s) {
    NetworkStatus.connectedWifi => (
      SimatsColors.secondary,
      'Wi-Fi - Campus Secure',
      Icons.sync_rounded,
    ),
    NetworkStatus.connectedMobile => (
      SimatsColors.secondary,
      '5G/4G',
      Icons.signal_cellular_alt_rounded,
    ),
    NetworkStatus.connectedEthernet => (
      SimatsColors.secondary,
      'Ethernet',
      Icons.cable_rounded,
    ),
    NetworkStatus.noInternet => (
      SimatsColors.statusWarning,
      'Offline',
      Icons.cloud_off_rounded,
    ),
    NetworkStatus.unknown => (
      SimatsColors.outline,
      'Checking...',
      Icons.wifi_off_rounded,
    ),
  };
}

class _AnimatedDot extends StatefulWidget {
  const _AnimatedDot({required this.color, required this.isAnimated});
  final Color color;
  final bool isAnimated;
  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _anim = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    if (widget.isAnimated) _ctrl.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_AnimatedDot o) {
    super.didUpdateWidget(o);
    if (widget.isAnimated && !_ctrl.isAnimating) {
      _ctrl.repeat(reverse: true);
    } else if (!widget.isAnimated) {
      _ctrl.stop();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _anim,
    builder: (_, __) => Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: widget.color.withOpacity(_anim.value),
        shape: BoxShape.circle,
      ),
    ),
  );
}

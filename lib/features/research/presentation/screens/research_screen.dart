import 'package:flutter/material.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';

class ResearchScreen extends StatelessWidget {
  const ResearchScreen({super.key});

  final _projects = const [
    (
      title: 'Autonomous Mobile Edge Offloading for Smart Campuses',
      investigators: 'Dr. S. K. Narayanan, Dr. K. Vignesh',
      funding: 'DST-SERB Sponsored Project • ₹48 Lakhs',
      domain: 'Mobile Computing & AI',
      status: 'Active (2023 - 2026)',
    ),
    (
      title: 'Biometric RFID Cryptographic Access Validation over 5G Slices',
      investigators: 'Dr. P. Meenakshi, Officer V. Rajan',
      funding: 'Institutional Innovation Grant • ₹18 Lakhs',
      domain: 'Cybersecurity & 5G',
      status: 'Field Testing Stage',
    ),
    (
      title: 'Real-time Battery Health Prognostics for Campus EV Shuttles',
      investigators: 'Centre for Connected Vehicles & Robotics',
      funding: 'Industry Sponsored (Tata Motors) • ₹32 Lakhs',
      domain: 'Electric Vehicles',
      status: 'Deployment Stage',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: AppBar(
        title: const Text('Research & Innovation'),
        backgroundColor: SimatsColors.surface,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(SimatsSpacing.marginMobile),
        itemCount: _projects.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: SimatsSpacing.spaceSm),
        itemBuilder: (ctx, i) {
          final p = _projects[i];
          return Container(
            padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
            decoration: BoxDecoration(
              color: SimatsColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(SimatsSpacing.spaceBase),
              border: Border.all(color: SimatsColors.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0B1C30).withOpacity(0.04),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: SimatsColors.primaryFixed,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    p.domain,
                    style: SimatsTextStyles.labelSm.copyWith(
                      color: SimatsColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: SimatsSpacing.spaceSm),
                Text(
                  p.title,
                  style: SimatsTextStyles.titleMd.copyWith(
                    fontWeight: FontWeight.w700,
                    color: SimatsColors.primary,
                  ),
                ),
                const SizedBox(height: SimatsSpacing.space2xs),
                Text(
                  p.investigators,
                  style: SimatsTextStyles.bodySm.copyWith(
                    color: SimatsColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: SimatsSpacing.spaceSm),
                Text(
                  p.funding,
                  style: SimatsTextStyles.labelSm.copyWith(
                    color: SimatsColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SimatsSpacing.space2xs),
                Text(
                  'Status: ${p.status}',
                  style: SimatsTextStyles.labelSm.copyWith(
                    color: const Color(0xFF065F46),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

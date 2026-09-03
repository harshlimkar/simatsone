import 'package:flutter/material.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';

class CentresScreen extends StatelessWidget {
  const CentresScreen({super.key});

  final _centres = const [
    (
      name: 'Centre of Excellence in 5G & Wireless NextGen',
      domain: 'Telecommunications & Edge Computing',
      facilities: 'Open RAN Testbed, Vector Signal Analyzers, mmWave Antennas',
      certifications: 'Qualcomm Wireless, IEEE ComSoc',
      icon: Icons.cell_tower_rounded,
    ),
    (
      name: 'Centre of Excellence in Robotics & Automation',
      domain: 'Industrial Robotics & Vision Systems',
      facilities:
          'KUKA 6-Axis Arms, TurtleBot Autonomous Navigation, ROS 2 Rigs',
      certifications: 'FANUC Certified Specialist, RoboMaster Lab',
      icon: Icons.smart_toy_rounded,
    ),
    (
      name: 'Centre of Excellence in Cybersecurity & Forensics',
      domain: 'Network Defense & Cryptography',
      facilities: 'Air-gapped Malware Sandbox, Cyber Range Attack Simulator',
      certifications: 'EC-Council CEH, Cisco CCNA Security',
      icon: Icons.security_rounded,
    ),
    (
      name: 'Centre of Excellence in Connected & Electric Vehicles (CEV)',
      domain: 'E-Mobility & Battery Systems',
      facilities: 'BMS Testing Station, Motor Dynamometer, CAN Bus Analyzers',
      certifications: 'SAE India, Automotive Skills Development',
      icon: Icons.electric_car_rounded,
    ),
    (
      name: 'Centre of Excellence in iOS & Apple Technologies',
      domain: 'Swift, SwiftUI & Mobile Platforms',
      facilities:
          'Mac Studio Workstations, iPad Pro LiDAR Labs, Vision Pro Test Rig',
      certifications: 'Apple Authorized Training Centre',
      icon: Icons.phone_iphone_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: AppBar(
        title: const Text('Centres of Excellence'),
        backgroundColor: SimatsColors.surface,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(SimatsSpacing.marginMobile),
        itemCount: _centres.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: SimatsSpacing.spaceSm),
        itemBuilder: (ctx, i) {
          final c = _centres[i];
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
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: SimatsColors.surfaceContainer,
                        borderRadius: BorderRadius.circular(
                          SimatsSpacing.spaceSm,
                        ),
                      ),
                      child: Icon(
                        c.icon,
                        size: 24,
                        color: SimatsColors.secondary,
                      ),
                    ),
                    const SizedBox(width: SimatsSpacing.spaceSm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name,
                            style: SimatsTextStyles.titleMd.copyWith(
                              fontWeight: FontWeight.w700,
                              color: SimatsColors.primary,
                            ),
                          ),
                          Text(
                            c.domain,
                            style: SimatsTextStyles.bodySm.copyWith(
                              color: SimatsColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SimatsSpacing.spaceSm),
                Text(
                  'Facilities: ${c.facilities}',
                  style: SimatsTextStyles.bodySm.copyWith(
                    color: SimatsColors.onSurface,
                  ),
                ),
                const SizedBox(height: SimatsSpacing.spaceXs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: SimatsColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Certifications: ${c.certifications}',
                    style: SimatsTextStyles.labelSm.copyWith(
                      color: SimatsColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
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

import 'package:flutter/material.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';
import '../../../../shared/widgets/widgets.dart';

class CampusScreen extends StatefulWidget {
  const CampusScreen({super.key});

  @override
  State<CampusScreen> createState() => _CampusScreenState();
}

class _CampusScreenState extends State<CampusScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  final _buildings = [
    (
      name: 'CSE Computing Block',
      category: 'Academic & Laboratories',
      floors: 'G + 4 Floors',
      distance: '120m away',
      eta: '2 min walk',
      icon: Icons.computer_rounded,
      rooms: ['Room 204', 'Turing Lab 1-4', 'AI Research Centre'],
    ),
    (
      name: 'SAIL — Saveetha Academic Infotech Library',
      category: 'Central Library & Digital Hub',
      floors: 'G + 3 Floors',
      distance: '250m away',
      eta: '4 min walk',
      icon: Icons.local_library_rounded,
      rooms: ['Reading Hall A', 'Digital Resource Center', 'Quiet Study Quad'],
    ),
    (
      name: 'Engineering Auditorium B',
      category: 'Seminars & Conferences',
      floors: 'Ground Floor',
      distance: '340m away',
      eta: '5 min walk',
      icon: Icons.theater_comedy_rounded,
      rooms: ['Auditorium Hall', 'Green Room', 'VIP Lounge'],
    ),
    (
      name: 'Robotics & 5G Centre of Excellence',
      category: 'Advanced R&D Innovation',
      floors: 'Level 2, Tech Hub',
      distance: '410m away',
      eta: '6 min walk',
      icon: Icons.smart_toy_rounded,
      rooms: ['Robotics Arena', '5G Core Testing Rig', 'IoT Sensor Bank'],
    ),
    (
      name: 'Administrative Avenue & Gate 1',
      category: 'Campus Entry & Administration',
      floors: 'Ground Complex',
      distance: '500m away',
      eta: '7 min walk',
      icon: Icons.account_balance_rounded,
      rooms: ['Dean Office', 'Admissions Desk', 'Controller of Examinations'],
    ),
    (
      name: 'North Gate 3 Pedestrian Turnstiles',
      category: 'Safe Detour Entry Point',
      floors: 'Perimeter Access',
      distance: '380m away',
      eta: '5 min walk',
      icon: Icons.door_sliding_rounded,
      rooms: ['Security Post 03', 'Automated Biometric Turnstiles'],
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _buildings.where((b) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return b.name.toLowerCase().contains(q) ||
          b.category.toLowerCase().contains(q) ||
          b.rooms.any((r) => r.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: AppBar(
        title: const Text('Campus Wayfinding & Navigation'),
        backgroundColor: SimatsColors.surface,
      ),
      body: Column(
        children: [
          // Search & Filter header
          Padding(
            padding: const EdgeInsets.all(SimatsSpacing.marginMobile),
            child: SimatsTextField(
              controller: _searchCtrl,
              hint: 'Search classroom, lab, auditorium or gate...',
              prefixIcon: Icons.search_rounded,
              onChanged: (val) => setState(() => _query = val.trim()),
            ),
          ),

          // Buildings listing
          Expanded(
            child: filtered.isEmpty
                ? const SimatsEmptyState(
                    title: 'No Destination Found',
                    message:
                        'Check building name or classroom code and search again.',
                    icon: Icons.location_off_rounded,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SimatsSpacing.marginMobile,
                      vertical: SimatsSpacing.spaceXs,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: SimatsSpacing.spaceSm),
                    itemBuilder: (ctx, i) {
                      final item = filtered[i];
                      return Container(
                        padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
                        decoration: BoxDecoration(
                          color: SimatsColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(
                            SimatsSpacing.spaceBase,
                          ),
                          border: Border.all(
                            color: SimatsColors.outlineVariant,
                          ),
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
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: SimatsColors.surfaceContainer,
                                    borderRadius: BorderRadius.circular(
                                      SimatsSpacing.spaceSm,
                                    ),
                                  ),
                                  child: Icon(
                                    item.icon,
                                    size: 22,
                                    color: SimatsColors.secondary,
                                  ),
                                ),
                                const SizedBox(width: SimatsSpacing.spaceSm),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: SimatsTextStyles.titleMd
                                            .copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: SimatsColors.primary,
                                            ),
                                      ),
                                      Text(
                                        item.category,
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
                            Row(
                              children: [
                                const Icon(
                                  Icons.directions_walk_rounded,
                                  size: 16,
                                  color: SimatsColors.secondary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.eta} (${item.distance})',
                                  style: SimatsTextStyles.labelSm.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: SimatsColors.onSurface,
                                  ),
                                ),
                                const SizedBox(width: SimatsSpacing.spaceSm),
                                Text('•', style: SimatsTextStyles.labelSm),
                                const SizedBox(width: SimatsSpacing.spaceSm),
                                const Icon(
                                  Icons.layers_outlined,
                                  size: 16,
                                  color: SimatsColors.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item.floors,
                                  style: SimatsTextStyles.labelSm.copyWith(
                                    color: SimatsColors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: SimatsSpacing.spaceSm),
                            Wrap(
                              spacing: SimatsSpacing.spaceXs,
                              runSpacing: SimatsSpacing.spaceXs,
                              children: item.rooms.map((r) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: SimatsColors.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    r,
                                    style: SimatsTextStyles.labelSm.copyWith(
                                      color: SimatsColors.onSurfaceVariant,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

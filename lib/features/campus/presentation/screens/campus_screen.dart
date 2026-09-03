import 'package:flutter/material.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';
import '../../../../core/services/maps_navigation_service.dart';
import '../../../../shared/widgets/widgets.dart';

class CampusScreen extends StatefulWidget {
  const CampusScreen({super.key});

  @override
  State<CampusScreen> createState() => _CampusScreenState();
}

class _CampusScreenState extends State<CampusScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  final List<CampusLocation> _buildings = MapsNavigationService.locations;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _navigateToLocation(CampusLocation loc) async {
    final launched = await MapsNavigationService.openGoogleMapsNavigation(
      destinationLat: loc.latitude,
      destinationLng: loc.longitude,
      query: loc.query,
      destinationLabel: loc.name,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening walking route to ${loc.name}...'),
          backgroundColor: SimatsColors.primary,
        ),
      );
    }
  }

  void _showLocationDetails(CampusLocation loc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: SimatsColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: SimatsColors.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: SimatsSpacing.spaceBase),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: SimatsColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.map_rounded,
                      color: SimatsColors.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: SimatsSpacing.spaceSm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.name,
                          style: SimatsTextStyles.headlineSm.copyWith(
                            color: SimatsColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          loc.category,
                          style: SimatsTextStyles.bodySm.copyWith(
                            color: SimatsColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SimatsSpacing.spaceBase),
              Container(
                padding: const EdgeInsets.all(SimatsSpacing.spaceSm),
                decoration: BoxDecoration(
                  color: SimatsColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(SimatsRadius.md),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _infoPill(Icons.directions_walk_rounded, loc.distance, 'Distance'),
                    _infoPill(Icons.timer_outlined, loc.eta, 'Est. Time'),
                    _infoPill(Icons.layers_outlined, loc.floors, 'Structure'),
                  ],
                ),
              ),
              const SizedBox(height: SimatsSpacing.spaceBase),
              Text(
                'Key Labs & Facilities Inside',
                style: SimatsTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: SimatsSpacing.spaceXs),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: loc.rooms.map((r) {
                  return Chip(
                    label: Text(r, style: SimatsTextStyles.bodySm),
                    backgroundColor: SimatsColors.surfaceContainerHigh,
                    side: BorderSide.none,
                  );
                }).toList(),
              ),
              const SizedBox(height: SimatsSpacing.spaceXl),
              SizedBox(
                width: double.infinity,
                height: SimatsSpacing.buttonHeight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _navigateToLocation(loc);
                  },
                  icon: const Icon(Icons.navigation_rounded, size: 20),
                  label: const Text('Start Walking Navigation in Google Maps'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SimatsColors.secondary,
                    foregroundColor: SimatsColors.onSecondary,
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(height: SimatsSpacing.spaceSm),
            ],
          ),
        );
      },
    );
  }

  Widget _infoPill(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: SimatsColors.secondary),
        const SizedBox(height: 2),
        Text(
          value,
          style: SimatsTextStyles.labelMd.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          style: SimatsTextStyles.labelSm.copyWith(color: SimatsColors.outline),
        ),
      ],
    );
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
        title: const Text('Campus Wayfinding & Maps'),
        backgroundColor: SimatsColors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── Google Maps Hero Header ─────────────────────────────────────────
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: SimatsSpacing.marginMobile,
              vertical: SimatsSpacing.spaceXs,
            ),
            padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [SimatsColors.primary, Color(0xFF162D50)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(SimatsRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: SimatsColors.primary.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: SimatsColors.onPrimary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.near_me_rounded,
                      color: SimatsColors.onPrimary,
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: SimatsSpacing.spaceSm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Campus Navigation',
                        style: SimatsTextStyles.titleMedium.copyWith(
                          color: SimatsColors.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Turn-by-turn walking routes powered by Google Maps',
                        style: SimatsTextStyles.bodySm.copyWith(
                          color: SimatsColors.onPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Search & Filter bar ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SimatsSpacing.marginMobile,
              vertical: SimatsSpacing.spaceSm,
            ),
            child: SimatsTextField(
              controller: _searchCtrl,
              hint: 'Search classroom, lab, auditorium or gate...',
              prefixIcon: Icons.search_rounded,
              onChanged: (val) => setState(() => _query = val.trim()),
            ),
          ),

          // ── Locations list ────────────────────────────────────────────────
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
                              color: SimatsColors.primary.withValues(alpha: 0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: SimatsColors.surfaceContainer,
                                    borderRadius: BorderRadius.circular(
                                      SimatsSpacing.spaceSm,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.business_rounded,
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
                                        style: SimatsTextStyles.titleMedium
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
                            const SizedBox(height: SimatsSpacing.spaceBase),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () => _showLocationDetails(item),
                                    icon: const Icon(Icons.info_outline_rounded, size: 16),
                                    label: const Text('Details & Rooms'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      side: const BorderSide(color: SimatsColors.outlineVariant),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: SimatsSpacing.spaceSm),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _navigateToLocation(item),
                                    icon: const Icon(Icons.navigation_rounded, size: 16),
                                    label: const Text('Google Maps'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: SimatsColors.secondary,
                                      foregroundColor: SimatsColors.onSecondary,
                                      elevation: 1,
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                    ),
                                  ),
                                ),
                              ],
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

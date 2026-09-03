import 'package:flutter/material.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  final _events = const [
    (
      title: 'SIMATS Hackathon 2024: Smart Campus Innovations',
      category: 'Hackathon',
      date: 'Nov 12 - 14, 2024',
      venue: 'Engineering Auditorium B & Tech Park',
      description:
          '36-hour flagship hackathon solving campus mobility, sustainability, and IoT healthcare challenges.',
      registered: true,
    ),
    (
      title: 'International Conference on 5G & Connected Vehicles',
      category: 'Conference',
      date: 'Dec 05, 2024',
      venue: 'Centres of Excellence Auditorium',
      description:
          'Keynote speakers from IEEE, Qualcomm and leading automotive R&D labs.',
      registered: false,
    ),
    (
      title: 'Hands-on Workshop: Flutter Enterprise Mobile Architecture',
      category: 'Workshop',
      date: 'Nov 20, 2024',
      venue: 'Turing Computer Lab 2',
      description:
          'Deep dive into Riverpod, Drift offline persistence, and Material 3 design systems.',
      registered: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: AppBar(
        title: const Text('Events & Hackathons'),
        backgroundColor: SimatsColors.surface,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(SimatsSpacing.marginMobile),
        itemCount: _events.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: SimatsSpacing.spaceSm),
        itemBuilder: (ctx, i) {
          final e = _events[i];
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: SimatsColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        e.category,
                        style: SimatsTextStyles.labelSm.copyWith(
                          color: SimatsColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (e.registered)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: SimatsColors.statusSuccessContainer,
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          'Registered',
                          style: SimatsTextStyles.labelSm.copyWith(
                            color: const Color(0xFF065F46),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: SimatsSpacing.spaceSm),
                Text(
                  e.title,
                  style: SimatsTextStyles.titleMd.copyWith(
                    fontWeight: FontWeight.w700,
                    color: SimatsColors.primary,
                  ),
                ),
                const SizedBox(height: SimatsSpacing.space2xs),
                Text(
                  e.description,
                  style: SimatsTextStyles.bodySm.copyWith(
                    color: SimatsColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: SimatsSpacing.spaceSm),
                Row(
                  children: [
                    const Icon(
                      Icons.event_outlined,
                      size: 14,
                      color: SimatsColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      e.date,
                      style: SimatsTextStyles.labelSm.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: SimatsSpacing.spaceSm),
                    const Icon(
                      Icons.place_outlined,
                      size: 14,
                      color: SimatsColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        e.venue,
                        style: SimatsTextStyles.labelSm.copyWith(
                          color: SimatsColors.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

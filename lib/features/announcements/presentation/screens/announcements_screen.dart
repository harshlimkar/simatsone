import 'package:flutter/material.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  String _selectedFilter = 'All';

  final _announcements = const [
    (
      title: 'End-Semester Theory & Practical Examination Timetable Published',
      category: 'Examination',
      date: 'Today, 10:00 AM',
      refNo: 'COE/SIMATS/24/772',
      body:
          'Controller of Examinations has released the master schedule for Regular and Arrear assessments for B.Tech Autumn 2024. Students must clear fee dues before downloading hall tickets.',
    ),
    (
      title: 'Study Flex System: Course Registration for Spring 2025',
      category: 'Academic',
      date: 'Yesterday, 04:30 PM',
      refNo: 'ACAD/SIMATS/24/104',
      body:
          'Portal opens Oct 28. Select faculty, slot, and elective modules through the SIMATS ONE student portal.',
    ),
    (
      title: 'Campus Food Court & Cafeteria Express Hours Extended',
      category: 'Department',
      date: 'Oct 22, 2024',
      refNo: 'OPS/SIMATS/24/045',
      body:
          'CSE Quad food counters will operate until 9:00 PM to support evening laboratory students.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Examination', 'Academic', 'Department'];

    final filtered = _announcements.where((a) {
      if (_selectedFilter != 'All' && a.category != _selectedFilter) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: AppBar(
        title: const Text('Official Circulars & Notices'),
        backgroundColor: SimatsColors.surface,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SimatsSpacing.marginMobile,
              vertical: SimatsSpacing.spaceSm,
            ),
            color: SimatsColors.surfaceContainerLowest,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((f) {
                  final isSelected = _selectedFilter == f;
                  return Padding(
                    padding: const EdgeInsets.only(
                      right: SimatsSpacing.spaceXs,
                    ),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: isSelected,
                      selectedColor: SimatsColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? SimatsColors.onPrimary
                            : SimatsColors.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                      onSelected: (_) => setState(() => _selectedFilter = f),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(SimatsSpacing.marginMobile),
              itemCount: filtered.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: SimatsSpacing.spaceSm),
              itemBuilder: (ctx, i) {
                final a = filtered[i];
                return Container(
                  padding: const EdgeInsets.all(SimatsSpacing.spaceBase),
                  decoration: BoxDecoration(
                    color: SimatsColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(
                      SimatsSpacing.spaceBase,
                    ),
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
                              a.category,
                              style: SimatsTextStyles.labelSm.copyWith(
                                color: SimatsColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(a.date, style: SimatsTextStyles.labelSm),
                        ],
                      ),
                      const SizedBox(height: SimatsSpacing.spaceSm),
                      Text(
                        a.title,
                        style: SimatsTextStyles.titleMd.copyWith(
                          fontWeight: FontWeight.w700,
                          color: SimatsColors.primary,
                        ),
                      ),
                      const SizedBox(height: SimatsSpacing.spaceXs),
                      Text(
                        a.body,
                        style: SimatsTextStyles.bodyMd.copyWith(
                          color: SimatsColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: SimatsSpacing.spaceSm),
                      Text(
                        'Ref: ${a.refNo}',
                        style: SimatsTextStyles.codeNum.copyWith(
                          fontSize: 11,
                          color: SimatsColors.onSurfaceVariant,
                        ),
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

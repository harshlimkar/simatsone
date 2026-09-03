import 'package:flutter/material.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';
import '../../../../shared/widgets/widgets.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final _searchCtrl = TextEditingController();
  String _selectedCategory = 'All';

  final _resources = [
    (
      title:
          'Mobile Computing Principles: Designing and Developing Mobile Applications',
      authors: 'Reza B\'Far',
      category: 'Textbook',
      isbn: '978-0521837835',
      location: 'SAIL Stacks • 2nd Floor (Section CS-04)',
      availableCopies: 4,
      totalCopies: 6,
    ),
    (
      title: 'IEEE Transactions on Mobile Computing (Vol. 23, Issue 8)',
      authors: 'IEEE Computer Society',
      category: 'Journals',
      isbn: 'ISSN 1536-1233',
      location: 'Digital Resource Portal • Online Access',
      availableCopies: 99,
      totalCopies: 100,
    ),
    (
      title: 'Compilers: Principles, Techniques, and Tools (Dragon Book)',
      authors: 'Alfred V. Aho, Monica S. Lam, Ravi Sethi, Jeffrey D. Ullman',
      category: 'Textbook',
      isbn: '978-0321486813',
      location: 'SAIL Stacks • 2nd Floor (Section CS-02)',
      availableCopies: 2,
      totalCopies: 5,
    ),
    (
      title: 'Deep Learning with Python (2nd Edition)',
      authors: 'François Chollet',
      category: 'Digital eBook',
      isbn: '978-1617296864',
      location: 'SAIL Cloud E-Library',
      availableCopies: 15,
      totalCopies: 20,
    ),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Textbook', 'Journals', 'Digital eBook'];

    final filtered = _resources.where((r) {
      if (_selectedCategory != 'All' && r.category != _selectedCategory) {
        return false;
      }
      if (_searchCtrl.text.trim().isNotEmpty) {
        final q = _searchCtrl.text.trim().toLowerCase();
        return r.title.toLowerCase().contains(q) ||
            r.authors.toLowerCase().contains(q) ||
            r.isbn.toLowerCase().contains(q);
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: AppBar(
        title: const Text('SAIL Library Catalog'),
        backgroundColor: SimatsColors.surface,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(SimatsSpacing.marginMobile),
            child: Column(
              children: [
                SimatsTextField(
                  controller: _searchCtrl,
                  hint: 'Search titles, authors, or ISBN...',
                  prefixIcon: Icons.search_rounded,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: SimatsSpacing.spaceSm),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Padding(
                        padding: const EdgeInsets.only(
                          right: SimatsSpacing.spaceXs,
                        ),
                        child: ChoiceChip(
                          label: Text(cat),
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
                          onSelected: (_) =>
                              setState(() => _selectedCategory = cat),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: filtered.isEmpty
                ? const SimatsEmptyState(
                    title: 'No Publications Found',
                    message:
                        'Try adjusting your search terms or category filter.',
                    icon: Icons.menu_book_outlined,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SimatsSpacing.marginMobile,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: SimatsSpacing.spaceSm),
                    itemBuilder: (ctx, i) {
                      final r = filtered[i];
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: SimatsSpacing.spaceSm,
                                    vertical: SimatsSpacing.space2xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: SimatsColors.surfaceContainerHigh,
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Text(
                                    r.category,
                                    style: SimatsTextStyles.labelSm.copyWith(
                                      color: SimatsColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: SimatsSpacing.spaceSm,
                                    vertical: SimatsSpacing.space2xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: r.availableCopies > 0
                                        ? SimatsColors.statusSuccessContainer
                                        : SimatsColors.statusDangerContainer,
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Text(
                                    r.availableCopies > 0
                                        ? '${r.availableCopies} Available'
                                        : 'All Borrowed',
                                    style: SimatsTextStyles.labelSm.copyWith(
                                      color: r.availableCopies > 0
                                          ? const Color(0xFF065F46)
                                          : SimatsColors.error,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: SimatsSpacing.spaceSm),
                            Text(
                              r.title,
                              style: SimatsTextStyles.titleMd.copyWith(
                                color: SimatsColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: SimatsSpacing.space2xs),
                            Text(
                              r.authors,
                              style: SimatsTextStyles.bodySm.copyWith(
                                color: SimatsColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: SimatsSpacing.spaceSm),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: SimatsColors.onSurfaceVariant,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    r.location,
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
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/simats_colors.dart';
import '../../../../app/theme/simats_text_styles.dart';
import '../../../../app/theme/simats_spacing.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../shared/models/enums.dart';
import '../providers/alerts_provider.dart';
import '../../domain/entities/alert_entities.dart';

class CreateAlertScreen extends ConsumerStatefulWidget {
  const CreateAlertScreen({super.key});

  @override
  ConsumerState<CreateAlertScreen> createState() => _CreateAlertScreenState();
}

class _CreateAlertScreenState extends ConsumerState<CreateAlertScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locCtrl = TextEditingController();
  final _protocolCtrl = TextEditingController();

  AlertSeverity _severity = AlertSeverity.high;
  AlertCategory _category = AlertCategory.security;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locCtrl.dispose();
    _protocolCtrl.dispose();
    super.dispose();
  }

  Future<void> _broadcast() async {
    if (_titleCtrl.text.isEmpty || _descCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide title and description')),
      );
      return;
    }

    final newAlert = SecurityAlert(
      id: 'alert_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      severity: _severity,
      category: _category,
      location: _locCtrl.text.trim().isEmpty
          ? 'Campus Wide'
          : _locCtrl.text.trim(),
      issuedBy: 'Campus Security Desk',
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 4)),
      safeRouteProtocol: _protocolCtrl.text.trim().isEmpty
          ? null
          : _protocolCtrl.text.trim(),
    );

    await ref.read(alertRepositoryProvider).createAlert(newAlert);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alert broadcasted campus-wide.'),
          backgroundColor: SimatsColors.primary,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SimatsColors.surface,
      appBar: AppBar(
        title: const Text('Broadcast Security Alert'),
        backgroundColor: SimatsColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SimatsSpacing.marginMobile),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Alert Details', style: SimatsTextStyles.headlineSm),
            const SizedBox(height: SimatsSpacing.spaceSm),
            SimatsTextField(
              controller: _titleCtrl,
              label: 'Alert Title',
              hint: 'e.g., Gate 1 Access Restriction',
            ),
            const SizedBox(height: SimatsSpacing.spaceSm),
            SimatsTextField(
              controller: _descCtrl,
              label: 'Incident Description & Directives',
              hint:
                  'Explain what happened and instructions for students & faculty',
            ),
            const SizedBox(height: SimatsSpacing.spaceSm),
            SimatsTextField(
              controller: _locCtrl,
              label: 'Affected Location / Zone',
              hint: 'e.g., Turing Block / Gate 1',
            ),
            const SizedBox(height: SimatsSpacing.spaceSm),
            SimatsTextField(
              controller: _protocolCtrl,
              label: 'Safe Detour Protocol (Optional)',
              hint: 'e.g., Use North Gate 3 turnstiles',
            ),
            const SizedBox(height: SimatsSpacing.spaceBase),

            Text('Severity Level', style: SimatsTextStyles.titleMd),
            const SizedBox(height: SimatsSpacing.spaceXs),
            Wrap(
              spacing: SimatsSpacing.spaceSm,
              children: AlertSeverity.values.map((s) {
                final isSelected = _severity == s;
                return ChoiceChip(
                  label: Text(s.displayName),
                  selected: isSelected,
                  selectedColor: SimatsColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? SimatsColors.onPrimary
                        : SimatsColors.onSurface,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _severity = s);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SimatsSpacing.spaceBase),

            Text('Category', style: SimatsTextStyles.titleMd),
            const SizedBox(height: SimatsSpacing.spaceXs),
            Wrap(
              spacing: SimatsSpacing.spaceSm,
              children: AlertCategory.values.map((c) {
                final isSelected = _category == c;
                return ChoiceChip(
                  label: Text(c.displayName),
                  selected: isSelected,
                  selectedColor: SimatsColors.secondary,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? SimatsColors.onSecondary
                        : SimatsColors.onSurface,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _category = c);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SimatsSpacing.spaceXl),

            SimatsButton(
              label: 'Confirm & Broadcast Campus-Wide',
              icon: Icons.broadcast_on_personal_rounded,
              onPressed: _broadcast,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../app/theme/simats_colors.dart';
import '../../app/theme/simats_text_styles.dart';
import '../../app/theme/simats_spacing.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, this.error});
  final String? error;
  @override
  Widget build(BuildContext c) => Scaffold(
    backgroundColor: SimatsColors.surface,
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(SimatsSpacing.space2xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: SimatsColors.error,
              ),
              const SizedBox(height: SimatsSpacing.spaceBase),
              Text('Page not found', style: SimatsTextStyles.headlineMd),
              const SizedBox(height: SimatsSpacing.spaceXs),
              Text(
                error ?? 'The requested page could not be found.',
                style: SimatsTextStyles.bodyMd.copyWith(
                  color: SimatsColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SimatsSpacing.spaceBase),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(c).popUntil((r) => r.isFirst),
                icon: const Icon(Icons.home_rounded),
                label: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

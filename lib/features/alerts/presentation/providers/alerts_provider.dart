import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/enums.dart';
import '../../domain/entities/alert_entities.dart';
import '../../data/repositories/mock_alert_repository.dart';

final alertRepositoryProvider = Provider<AlertRepository>((ref) {
  return MockAlertRepository();
});

final alertsStreamProvider = StreamProvider<List<SecurityAlert>>((ref) {
  final repo = ref.watch(alertRepositoryProvider);
  return repo.watchAlerts();
});

final activeAlertFilterProvider = StateProvider<String>((ref) => 'all');

final filteredAlertsProvider = Provider<List<SecurityAlert>>((ref) {
  final alertsAsync = ref.watch(alertsStreamProvider);
  final filter = ref.watch(activeAlertFilterProvider);

  return alertsAsync.maybeWhen(
    data: (alerts) {
      if (filter == 'all') return alerts;
      return alerts.where((a) => a.category.name == filter).toList();
    },
    orElse: () => [],
  );
});

final criticalAlertProvider = Provider<SecurityAlert?>((ref) {
  final alertsAsync = ref.watch(alertsStreamProvider);
  return alertsAsync.maybeWhen(
    data: (alerts) {
      try {
        return alerts.firstWhere(
          (a) => a.severity == AlertSeverity.critical && !a.isAcknowledged,
        );
      } catch (_) {
        return null;
      }
    },
    orElse: () => null,
  );
});

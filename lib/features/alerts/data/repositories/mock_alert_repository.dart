import 'dart:async';
import '../../../../shared/models/enums.dart';
import '../../domain/entities/alert_entities.dart';

class MockAlertRepository implements AlertRepository {
  MockAlertRepository() {
    _initAlerts();
  }

  final _alertsController = StreamController<List<SecurityAlert>>.broadcast();
  List<SecurityAlert> _alerts = [];

  void _initAlerts() {
    final now = DateTime.now();
    _alerts = [
      SecurityAlert(
        id: 'alert_001',
        title: 'HIGH PRIORITY BROADCAST',
        description:
            'Temporary vehicle movement restriction and perimeter access protocol due to dignitary campus arrival and automated gate maintenance.',
        severity: AlertSeverity.critical,
        category: AlertCategory.emergency,
        location: 'Main Campus Gate 1 & Administrative Avenue',
        issuedBy: 'Chief Security Officer',
        createdAt: now.subtract(const Duration(minutes: 3)),
        expiresAt: now.add(const Duration(hours: 4)),
        safeRouteProtocol:
            'Use North Gate 3 or CSE Pedestrian Turnstiles. All scheduled academic classes and laboratory sessions continue as normal.',
        affectedZone: 'Zone: Main Campus Gate 1',
      ),
      SecurityAlert(
        id: 'alert_002',
        title: 'Heavy Rain Alert - Chennai IMD Advisory',
        description:
            'Lab sessions will remain indoors. Battery shuttle buses deployed continuously across Engineering blocks 1 to 7 to facilitate sheltered inter-block transit.',
        severity: AlertSeverity.medium,
        category: AlertCategory.weather,
        location: 'All Engineering Blocks (1 to 7)',
        issuedBy: 'Campus Operations',
        createdAt: now.subtract(const Duration(minutes: 45)),
        expiresAt: now.add(const Duration(hours: 6)),
      ),
      SecurityAlert(
        id: 'alert_003',
        title: 'Biometric Turnstile Maintenance',
        description:
            'Scheduled firmware synchronization at Turing Lab corridor. Please use manual RFID verification badge if response takes >3 seconds.',
        severity: AlertSeverity.low,
        category: AlertCategory.security,
        location: 'Turing Computing Block',
        issuedBy: 'Campus Security Desk',
        createdAt: now.subtract(const Duration(hours: 2)),
        expiresAt: now.add(const Duration(hours: 8)),
      ),
      SecurityAlert(
        id: 'alert_004',
        title: 'Schedule Revision for Hall 204',
        description:
            'Academic schedule revised for Hall 204. Mobile Computing practical shifted ahead by 15 mins.',
        severity: AlertSeverity.low,
        category: AlertCategory.academic,
        location: 'CSE Block • Room 204',
        issuedBy: 'Department of CSE',
        createdAt: now.subtract(const Duration(hours: 3)),
        expiresAt: now.add(const Duration(hours: 5)),
      ),
    ];
    _alertsController.add(_alerts);
  }

  @override
  Stream<List<SecurityAlert>> watchAlerts() async* {
    yield _alerts;
    yield* _alertsController.stream;
  }

  @override
  Future<List<SecurityAlert>> getActiveAlerts() async {
    return _alerts.where((a) => a.status == AlertStatus.active).toList();
  }

  @override
  Future<void> acknowledgeAlert(String alertId) async {
    _alerts = _alerts.map((a) {
      if (a.id == alertId) {
        return a.copyWith(isAcknowledged: true);
      }
      return a;
    }).toList();
    _alertsController.add(_alerts);
  }

  @override
  Future<void> createAlert(SecurityAlert alert) async {
    _alerts = [alert, ..._alerts];
    _alertsController.add(_alerts);
  }
}

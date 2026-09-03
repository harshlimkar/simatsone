import '../../../../shared/models/enums.dart';

class SecurityAlert {
  const SecurityAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.category,
    required this.location,
    this.latitude,
    this.longitude,
    required this.issuedBy,
    required this.createdAt,
    required this.expiresAt,
    this.status = AlertStatus.active,
    this.isAcknowledged = false,
    this.safeRouteProtocol,
    this.affectedZone,
  });

  final String id;
  final String title;
  final String description;
  final AlertSeverity severity;
  final AlertCategory category;
  final String location;
  final double? latitude;
  final double? longitude;
  final String issuedBy;
  final DateTime createdAt;
  final DateTime expiresAt;
  final AlertStatus status;
  final bool isAcknowledged;
  final String? safeRouteProtocol;
  final String? affectedZone;

  SecurityAlert copyWith({bool? isAcknowledged, AlertStatus? status}) {
    return SecurityAlert(
      id: id,
      title: title,
      description: description,
      severity: severity,
      category: category,
      location: location,
      latitude: latitude,
      longitude: longitude,
      issuedBy: issuedBy,
      createdAt: createdAt,
      expiresAt: expiresAt,
      status: status ?? this.status,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
      safeRouteProtocol: safeRouteProtocol,
      affectedZone: affectedZone,
    );
  }
}

abstract interface class AlertRepository {
  Stream<List<SecurityAlert>> watchAlerts();
  Future<List<SecurityAlert>> getActiveAlerts();
  Future<void> acknowledgeAlert(String alertId);
  Future<void> createAlert(SecurityAlert alert);
}

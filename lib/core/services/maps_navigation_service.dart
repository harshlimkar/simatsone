// SIMATS ONE – Google Maps Navigation Service
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class CampusLocation {
  const CampusLocation({
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.eta,
    required this.floors,
    required this.rooms,
  });

  final String name;
  final String category;
  final double latitude;
  final double longitude;
  final String distance;
  final String eta;
  final String floors;
  final List<String> rooms;
}

abstract final class MapsNavigationService {
  /// Saveetha Institute of Medical and Technical Sciences (SIMATS), Thandalam
  static const double simatsCenterLat = 13.0298;
  static const double simatsCenterLng = 80.0044;

  static const List<CampusLocation> locations = [
    CampusLocation(
      name: 'CSE Computing Block',
      category: 'Academic & Laboratories',
      latitude: 13.0298,
      longitude: 80.0044,
      distance: '120m away',
      eta: '2 min walk',
      floors: 'G + 4 Floors',
      rooms: ['Room 204', 'Turing Lab 1-4', 'AI Research Centre'],
    ),
    CampusLocation(
      name: 'SAIL — Saveetha Academic Infotech Library',
      category: 'Central Library & Digital Hub',
      latitude: 13.0305,
      longitude: 80.0051,
      distance: '250m away',
      eta: '4 min walk',
      floors: 'G + 3 Floors',
      rooms: ['Reading Hall A', 'Digital Resource Center', 'Quiet Study Quad'],
    ),
    CampusLocation(
      name: 'Engineering Auditorium B',
      category: 'Seminars & Conferences',
      latitude: 13.0292,
      longitude: 80.0038,
      distance: '340m away',
      eta: '5 min walk',
      floors: 'Ground Floor',
      rooms: ['Auditorium Hall', 'Green Room', 'VIP Lounge'],
    ),
    CampusLocation(
      name: 'Robotics & 5G Centre of Excellence',
      category: 'Advanced R&D Innovation',
      latitude: 13.0310,
      longitude: 80.0060,
      distance: '410m away',
      eta: '6 min walk',
      floors: 'Level 2, Tech Hub',
      rooms: ['Robotics Arena', '5G Core Testing Rig', 'IoT Sensor Bank'],
    ),
    CampusLocation(
      name: 'North Gate 3 Turnstiles',
      category: 'Campus Entry & Detour Gate',
      latitude: 13.0320,
      longitude: 80.0035,
      distance: '380m away',
      eta: '5 min walk',
      floors: 'Perimeter Access',
      rooms: ['Security Post 03', 'Automated Biometric Turnstiles'],
    ),
    CampusLocation(
      name: 'Administrative Avenue & Gate 1',
      category: 'Campus Entry & Administration',
      latitude: 13.0280,
      longitude: 80.0030,
      distance: '500m away',
      eta: '7 min walk',
      floors: 'Ground Complex',
      rooms: ['Registrar Office', 'Dean Office', 'Finance Desk'],
    ),
    CampusLocation(
      name: 'Saveetha Food Court & Cafeteria',
      category: 'Dining & Student Amenities',
      latitude: 13.0300,
      longitude: 80.0065,
      distance: '280m away',
      eta: '3 min walk',
      floors: 'Ground & 1st Floor',
      rooms: ['Main Cafeteria', 'Coffee Kiosk', 'Juice Bar'],
    ),
  ];

  /// Launch official Google Maps Navigation with walking directions
  static Future<bool> openGoogleMapsNavigation({
    required double destinationLat,
    required double destinationLng,
    String? destinationLabel,
  }) async {
    // Try geo: intent first on Android for native Google Maps app
    final nativeUri = Uri.parse(
      'google.navigation:q=$destinationLat,$destinationLng&mode=w',
    );

    // Fallback universal Google Maps web/app URL
    final webUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng&travelmode=walking',
    );

    try {
      if (await canLaunchUrl(nativeUri)) {
        return await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(webUri)) {
        return await launchUrl(webUri, mode: LaunchMode.externalApplication);
      } else {
        return await launchUrl(webUri, mode: LaunchMode.inAppBrowserView);
      }
    } catch (e) {
      debugPrint('Error launching Google Maps: $e');
      return false;
    }
  }
}

// SIMATS ONE – Real Saveetha Institute of Medical and Technical Sciences (SIMATS) Campus Navigation Service
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class CampusLocation {
  const CampusLocation({
    required this.name,
    required this.category,
    required this.address,
    required this.query,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.eta,
    required this.floors,
    required this.rooms,
  });

  final String name;
  final String category;
  final String address;
  final String query;
  final double latitude;
  final double longitude;
  final String distance;
  final String eta;
  final String floors;
  final List<String> rooms;
}

abstract final class MapsNavigationService {
  /// Saveetha Engineering College / SIMATS Deemed University Campus, Thandalam, Chennai
  static const double simatsCenterLat = 13.02685;
  static const double simatsCenterLng = 80.01686;
  static const String campusOfficialName =
      'Saveetha Engineering College, SIMATS, Thandalam';

  static const List<CampusLocation> locations = [
    CampusLocation(
      name: 'Saveetha Engineering College (Main Block)',
      category: 'Academic, Laboratories & Departments',
      address: 'Saveetha Nagar, NH48 Chennai-Bengaluru Highway, Thandalam, Chennai - 602105',
      query: 'Saveetha Engineering College, Thandalam, Chennai',
      latitude: 13.02685,
      longitude: 80.01686,
      distance: 'Main Campus',
      eta: '1 min walk',
      floors: 'G + 4 Floors Complex',
      rooms: [
        'Dept of Computer Science & Engineering',
        'AI & Data Science Labs',
        'Turing Computing Hub',
        'IoT & Robotics Arena',
      ],
    ),
    CampusLocation(
      name: 'SAIL — Saveetha Central Library & Digital Hub',
      category: 'Central Digital Library & Research Center',
      address: 'Academic Complex, Saveetha Engineering College, Thandalam',
      query: 'Saveetha Engineering College Central Library, Thandalam',
      latitude: 13.02720,
      longitude: 80.01730,
      distance: '180m away',
      eta: '2 min walk',
      floors: 'G + 3 Floors',
      rooms: [
        'Digital Resource Center',
        'IEEE / ScienceDirect Reading Quad',
        'Reference Section A & B',
        'Scholarly Journal Archive',
      ],
    ),
    CampusLocation(
      name: 'Saveetha Convention Centre & Auditorium',
      category: 'Conferences, Convocations & Cultural Events',
      address: 'Convention Plaza, Saveetha Nagar, Thandalam, Chennai',
      query: 'Saveetha Convention Centre, Thandalam, Chennai',
      latitude: 13.02610,
      longitude: 80.01620,
      distance: '240m away',
      eta: '3 min walk',
      floors: 'Air Conditioned Grand Complex',
      rooms: [
        '3000-Seater Grand Auditorium',
        'Mini Seminar Hall 1 & 2',
        'VIP Green Rooms & Dignitary Lounge',
      ],
    ),
    CampusLocation(
      name: 'Saveetha Medical College & Super Specialty Hospital',
      category: 'Medical Campus & 24/7 Trauma Emergency',
      address: 'Bangalore High Road, Saveetha Nagar, Thandalam, Chennai - 602105',
      query: 'Saveetha Medical College and Hospital, Thandalam, Chennai',
      latitude: 12.99120,
      longitude: 80.05450,
      distance: 'SIMATS Medical Campus',
      eta: '5 min shuttle',
      floors: 'Multi-Block Super Specialty Hospital',
      rooms: [
        '24/7 Emergency & Trauma Care',
        'Outpatient Department (OPD)',
        'Cardiology & Neurology Wings',
        'Medical Intensive Care Unit (ICU)',
      ],
    ),
    CampusLocation(
      name: 'Saveetha Dental College & Hospitals',
      category: 'Dental Sciences, Surgery & Research',
      address: '162, Poonamallee High Road, Velappanchavadi, Chennai - 600077',
      query: 'Saveetha Dental College, Poonamallee High Road, Velappanchavadi, Chennai',
      latitude: 13.04890,
      longitude: 80.14950,
      distance: 'City Campus Hub',
      eta: '18 min drive',
      floors: 'G + 8 Floors Specialized Centre',
      rooms: [
        'Advanced Implantology Wing',
        'Oral & Maxillofacial Surgery Block',
        'Pediatric Dentistry Quad',
        'Dental Stem Cell Bio-Bank',
      ],
    ),
    CampusLocation(
      name: 'Saveetha Campus Gate 1 & Security Checkpost',
      category: 'Campus Entry, Turnstiles & Administration',
      address: 'NH48 Highway Entrance, Saveetha Nagar, Thandalam',
      query: 'Saveetha Engineering College Main Gate, Thandalam, Chennai',
      latitude: 13.02550,
      longitude: 80.01550,
      distance: 'Campus Perimeter',
      eta: '3 min walk',
      floors: 'Ground Access',
      rooms: [
        'Main Security Command Post 01',
        'Automated Biometric Turnstiles',
        'Visitor Vehicle Pass Registration',
      ],
    ),
    CampusLocation(
      name: 'Saveetha Indoor Stadium & Student Activity Centre',
      category: 'Sports, Fitness & Student Cafeteria',
      address: 'Sports Pavilion, Saveetha Nagar, Thandalam',
      query: 'Saveetha Engineering College Sports Complex, Thandalam',
      latitude: 13.02800,
      longitude: 80.01800,
      distance: '320m away',
      eta: '4 min walk',
      floors: 'Sports Complex',
      rooms: [
        'Indoor Badminton & Squash Arena',
        'High-Tech Fitness Gymnasium',
        'Saveetha Central Food Court & Cafeteria',
      ],
    ),
  ];

  /// Launch official Google Maps Navigation to the exact verified place
  static Future<bool> openGoogleMapsNavigation({
    required double destinationLat,
    required double destinationLng,
    required String query,
    String? destinationLabel,
  }) async {
    final encodedQuery = Uri.encodeComponent(query);

    // 1. Android native geo intent with place query & coordinates
    final geoUri = Uri.parse(
      'geo:$destinationLat,$destinationLng?q=$encodedQuery',
    );

    // 2. Google Maps Navigation Intent (turn-by-turn walking)
    final navigationUri = Uri.parse(
      'google.navigation:q=$destinationLat,$destinationLng&mode=w',
    );

    // 3. Universal Google Maps web/app URL with real destination query
    final webDirectionsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$encodedQuery&destination_place_id=&travelmode=walking',
    );

    try {
      if (await canLaunchUrl(geoUri)) {
        return await launchUrl(geoUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(navigationUri)) {
        return await launchUrl(navigationUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(webDirectionsUri)) {
        return await launchUrl(webDirectionsUri, mode: LaunchMode.externalApplication);
      } else {
        return await launchUrl(webDirectionsUri, mode: LaunchMode.inAppBrowserView);
      }
    } catch (e) {
      debugPrint('Error launching Google Maps: $e');
      try {
        return await launchUrl(webDirectionsUri, mode: LaunchMode.externalApplication);
      } catch (_) {
        return false;
      }
    }
  }
}

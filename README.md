# SIMATS ONE — Smart Campus Suite

> **One Campus. One App. One Connected Experience.**

**Institution:** SIMATS Engineering (Saveetha Institute of Medical and Technical Sciences), Saveetha Nagar, Thandalam, Chennai – 602105, Tamil Nadu, India.  
**Accreditation:** AICTE Approved | NAAC A++ Accredited | NIRF Rank 46 (Govt. of India).  
**Visual Source of Truth:** Google Stitch Project *"SIMATS ONE Smart Campus Suite"*.

---

## 📱 Executive Overview

**SIMATS ONE** is an enterprise-grade, offline-first smart campus mobile platform serving engineering students, faculty, and security administration across SIMATS Engineering. It is engineered with Flutter, Dart, Riverpod, GoRouter, and Material 3, translating official institutional workflows into an authoritative, high-density, touch-optimized user experience.

---

## ✨ Features Implemented

### 1. Flagship Student Dashboard (Stitch Screen `b5da04a18375479381c163943a106c56`)
- **Biometric Identity Card**: Live verification status, student register number (`211001048`), academic year, and section.
- **Biometric Attendance Hero**: Interactive circular SVG metric with aggregate percentage (`86.4%`), course breakdown summary, and examination eligibility indicators.
- **6 Quick Portals Grid**: Instant shortcuts to Attendance, Timetable, SAIL Library, Wayfinding, Security SOS, and Hackathons.
- **Dynamic Daily Schedule**: Real-time class status cards with remaining duration badges (`Live (42m left)`) and one-touch indoor navigation.
- **Academic Notices Circular**: Verified Controller of Examinations announcements with official references (`COE/SIMATS/24/772`).

### 2. Campus Security Alerts & Safety (Stitch Screen `77d31287f47e40a09f978834b4fb7c83`)
- **High-Priority Critical Broadcast**: Real-time alerts with pulsing beacons, restricted zone warnings, and safe detour protocol recommendations (North Gate 3 turnstiles).
- **Interactive Multi-Category Filtering**: Instant category chips for Emergency, Security, Weather, and Academic Advisories.
- **Security Officer Command Center**: Administrative dashboard for issuing and broadcasting verified institutional directives campus-wide.

### 3. Academic Attendance Module
- Subject-by-subject percentage calculation (`present / total × 100`) handling zero-class safety.
- Warning threshold notifications for courses dipping below the 85% requirement.
- Interactive Faculty roster for continuous attendance recording and submission.

### 4. Campus Wayfinding & Navigation
- Indoor route calculation and estimated walking times across CSE Block, Turing Block, and Auditorium.
- Accessible alternative routing bypasses during maintenance or restricted zones.

### 5. SAIL — Saveetha Academic Infotech Library
- Searchable catalog for physical engineering textbooks, IEEE journal volumes, and cloud e-books.
- Real-time stack location (Floor, Section) and copy availability indicators.

### 6. Centres of Excellence Discovery
- Institutional discovery portal for SIMATS advanced initiatives: 5G & Wireless NextGen, Robotics & Automation, Cybersecurity & Forensics, Connected & Electric Vehicles (CEV), and iOS Technologies.

---

## 🛠 Technology Stack

- **Framework**: Flutter 3.44.0 (Channel stable)
- **Language**: Dart 3.12.0
- **State Management**: Flutter Riverpod 2.6
- **Navigation & Deep Linking**: GoRouter 14
- **HTTP Client**: Dio 5 with QueuedInterceptors (auto token refresh & secure logging)
- **Local Persistence / Offline Cache**: Drift & SQLite
- **Hardware Security**: `flutter_secure_storage` (backed by Android Keystore AES-256)
- **Design Tokens**: Google Stitch Design System (Inter font, Corporate Navy `#00102D`, Royal Blue `#3755C3`)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK `^3.44.0`
- Dart SDK `^3.12.0`
- Android SDK 34+

### Installation & Run

1. Clone or navigate to the repository:
   ```bash
   cd simatsone
   ```

2. Configure environment:
   ```bash
   cp .env.example .env
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run unit and widget test suite:
   ```bash
   flutter test
   ```

5. Run on an Android device or emulator:
   ```bash
   flutter run
   ```

---

## 🧪 Testing

The repository contains automated unit and widget test suites covering:
- Attendance percentage calculations (zero-safety, 85% warning threshold, 75% critical threshold).
- Network status state-machine and connectivity detection.
- Authentication session persistence and secure token lifecycles.
- Security alert filtering and priority broadcast sorting.

Run all tests:
```bash
flutter test --coverage
```

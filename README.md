# SIMATS ONE — Smart Campus Mobile Suite

[![Flutter](https://img.shields.io/badge/Flutter-3.44.0-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12.0-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/State_Management-Riverpod_2.6-blue)](https://riverpod.dev)
[![GoRouter](https://img.shields.io/badge/Router-GoRouter_14-blueviolet)](https://pub.dev/packages/go_router)
[![Biometrics](https://img.shields.io/badge/Security-Native_Biometrics_&_Fingerprint-success)](https://pub.dev/packages/local_auth)
[![Google Maps](https://img.shields.io/badge/Navigation-Google_Maps_API-brightgreen?logo=googlemaps&logoColor=white)](https://developers.google.com/maps)
[![License](https://img.shields.io/badge/License-Proprietary_SIMATS-red)]()

> **One Campus. One App. One Connected Experience.**  
> Designed & developed for **Saveetha Institute of Medical and Technical Sciences (SIMATS)**, Saveetha Nagar, Thandalam, Chennai – 602105, Tamil Nadu, India.  
> **Accreditation:** AICTE Approved | NAAC A++ Accredited | NIRF Top Ranked Institution.  
> **Design Source of Truth:** Google Stitch *"SIMATS ONE Smart Campus Suite"*.

---

## 🏛️ Executive Summary

**SIMATS ONE** is an enterprise-grade, offline-first smart campus mobile platform serving engineering students, teaching faculty, and campus security command. Built on modern Flutter and clean architecture, SIMATS ONE bridges native device sensors (fingerprint/face biometrics, GPS, and hardware navigation) with high-density academic and security workflows.

---

## 🌟 Key Modules & Role Portals

### 1. 🎓 Student Portal (`Harsh Limkar N` — B.Tech CSE, Year 3)
- **Biometric Verified Identity Card**: Live badge, register number (`211001048`), academic year, and Section A tag.
- **Biometric Attendance Hero**: Interactive circular SVG metric reflecting real-time aggregate percentage (`86.4%`), course breakdown summary, and exam eligibility status.
- **6 Quick Portals Grid**: Shortcuts to Attendance Breakdown, Daily Timetable, SAIL Central Library, Wayfinding, Campus Safety SOS, and Hackathons.
- **Dynamic Daily Schedule**: Real-time classes with remaining countdown badges (`Live (42m left)`) and 1-tap Google Maps classroom navigation.
- **Academic Circulars**: Verified notices issued by the Controller of Examinations with official reference IDs (`COE/SIMATS/24/772`).

---

### 2. 👩‍🏫 Faculty Portal (`Ms. Abisha` — Asst. Professor, Dept. of CSE)
- **Faculty Identity & Cabin Info**: Employee ID `SIMATS-FAC-2041`, Tech Block Cabin 312, and verified biometric check-in status.
- **Key Faculty Metrics**:
  - 👥 **Students Taught**: `184` across Sections CS3A, CS3B, and AI-DS
  - ⏱️ **Weekly Workload**: `18h / 22h` completed (92%)
  - 📋 **Pending Evaluations**: `14` lab records and assignments
  - 🏖️ **Leave Balance**: `12 Days` (Casual, Academic & OD)
- **Live Teaching Session**: Real-time card for `CS304 • Mobile Computing` with live attendance progress (`58/64, 90.6%`) and direct turn-by-turn navigation to Room 204.
- **Interactive Class Attendance Roster**:
  - Live search filter by student name or roll number (`CS-01` to `CS-08`).
  - One-tap **"All Present"** batch action.
  - Interactive Present/Absent toggle chips.
  - Cloud synchronization with Saveetha SIS server.
- **Faculty Portals (6-Grid)**: Mark Attendance, Weekly Timetable, Internal Gradebook, Turing Lab Allocation, Research Grants Hub, and Classroom Notice Broadcast.
- **Research & Grants**: SEC Seed Research Grant (₹2.4 Lakh funded), 4 Scopus papers in 2024, and 100% NBA/NAAC readiness.

---

### 3. 🛡️ Campus Security & Command Center (`Officer V. Rajan`)
- **Emergency Broadcast Center**: Administrative incident console for issuing immediate campus alerts.
- **Detour Routing & Access Management**: Turnstile control and pedestrian rerouting to North Gate 3 during maintenance or security incidents.
- **Priority Categorization**: Emergency (Red), Security (Orange), Weather (Yellow), and Academic Advisories (Blue).

---

## 🔐 Native Device Biometric & Fingerprint Authentication

SIMATS ONE leverages Android's native `BiometricPrompt` framework to provide one-touch biometric authentication across all three portal accounts:

```
                  ┌─────────────────────────────────────┐
                  │          Login Screen UI            │
                  │  [ Student ] [ Faculty ] [ Admin ]  │
                  └──────────────────┬──────────────────┘
                                     │
                                     ▼
                    ┌─────────────────────────────────┐
                    │      BiometricAuthService       │
                    │   (local_auth + dual attempt)   │
                    └────────────────┬────────────────┘
                                     │
                                     ▼
          ┌────────────────────────────────────────────────────────┐
          │               Android Native Biometrics                │
          │  • MainActivity extends FlutterFragmentActivity        │
          │  • Theme.AppCompat.Light.NoActionBar (styles.xml)      │
          │  • Permissions: USE_BIOMETRIC + USE_FINGERPRINT        │
          └──────────────────────────┬─────────────────────────────┘
                                     │
                    ┌────────────────┴────────────────┐
                    │                                 │
           Fingerprint Valid                  Hardware Missing
                    │                                 │
                    ▼                                 ▼
      Direct Dashboard Access              Quick Demo Sign-In Fallback
```

### Technical Platform Setup:
1. **FragmentActivity Architecture**: `MainActivity.kt` inherits from `FlutterFragmentActivity` (required by Android androidx biometric APIs).
2. **AppCompat Theme**: In `android/app/src/main/res/values/styles.xml`, `NormalTheme` inherits from `Theme.AppCompat.Light.NoActionBar`, preventing Android's `IllegalStateException`.
3. **Hardware Permissions**: Configured in `AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.USE_BIOMETRIC"/>
   <uses-permission android:name="android.permission.USE_FINGERPRINT"/>
   ```
4. **Dual-Attempt Fallback**: `BiometricAuthService` attempts standard authentication with device credential fallback, gracefully falling back to hardware-direct mode if credentials are restricted.

---

## 🗺️ Google Maps Walking & Campus Navigation

SIMATS ONE provides deep Google Maps integration with **100% verified, real-world coordinates** for Saveetha Engineering College (SIMATS):

| Campus Landmark | Coordinates | Address & Verified Google Place |
| :--- | :--- | :--- |
| **Saveetha Engineering College (Main Block)** | `13.02685° N, 80.01686° E` | Saveetha Nagar, NH48 Highway, Thandalam, Chennai – 602105 |
| **SAIL Central Library & Digital Hub** | `13.02720° N, 80.01730° E` | Academic Complex, Saveetha Engineering College, Thandalam |
| **Saveetha Convention Centre & Auditorium** | `13.02610° N, 80.01620° E` | Convention Plaza, Saveetha Nagar, Thandalam, Chennai |
| **Saveetha Medical College & Hospital** | `12.99120° N, 80.05450° E` | Bangalore High Road, Saveetha Nagar, Thandalam – 602105 |
| **Saveetha Dental College & Hospitals** | `13.04890° N, 80.14950° E` | 162, Poonamallee High Road, Velappanchavadi, Chennai – 600077 |
| **Main Campus Gate 1 & Checkpost** | `13.02550° N, 80.01550° E` | NH48 Highway Entrance, Saveetha Nagar, Thandalam |
| **Indoor Stadium & Sports Pavilion** | `13.02800° N, 80.01800° E` | Sports Pavilion, Saveetha Nagar, Thandalam |

### Intent & Launch Architecture:
- Android intent query registered in `AndroidManifest.xml`:
  ```xml
  <queries>
      <intent>
          <action android:name="android.intent.action.VIEW"/>
          <data android:scheme="geo"/>
      </intent>
      <package android:name="com.google.android.apps.maps"/>
  </queries>
  ```
- When tapping **"Google Maps"**, the app launches `geo:lat,lng?q=VerifiedPlaceQuery`, opening the verified Google Maps card with real-time walking routes from the user's current GPS position.

---

## 🎨 UI & Design Architecture

- **Visual Framework**: Material 3 customized with the official **Google Stitch** institutional design tokens.
- **Institutional Palette**:
  - Primary Navy: `#00102D`
  - Secondary Gold / Amber: `#D4A017` & `#3755C3`
  - Surface Background: Clean off-white `#F8F9FC`
- **Zero RenderFlex Overflows**: All rows, sync indicators, and status pills are wrapped in `Expanded` and `Flexible` with `TextOverflow.ellipsis`, guaranteed to render without pixel overflow across all device viewports (from 320px to tablet sizes).
- **Clean Display**: Development watermark disabled (`debugShowCheckedModeBanner: false`) for an uncluttered presentation.

---

## 📂 Project Structure

```text
simatsone/
├── android/
│   ├── app/src/main/
│   │   ├── AndroidManifest.xml           # Biometric & Google Maps queries
│   │   ├── kotlin/.../MainActivity.kt    # FlutterFragmentActivity
│   │   └── res/values/styles.xml         # Theme.AppCompat configuration
├── lib/
│   ├── app/
│   │   ├── app.dart                      # Root MaterialApp (debug banner disabled)
│   │   ├── config/app_config.dart        # Environment & institutional config
│   │   ├── router/app_router.dart        # GoRouter navigation & route guards
│   │   └── theme/                        # Colors, typography, spacing & themes
│   ├── core/
│   │   ├── auth/
│   │   │   └── biometric_auth_service.dart # LocalAuth biometric service
│   │   ├── connectivity/                 # Network status monitor
│   │   ├── errors/                       # Failures & exceptions
│   │   ├── network/                      # Dio HTTP client & interceptors
│   │   ├── services/
│   │   │   └── maps_navigation_service.dart # Google Maps navigation service
│   │   ├── storage/                      # Secure storage & SQLite cache
│   │   └── sync/                         # Offline-first sync engine
│   ├── features/
│   │   ├── alerts/                       # Security alerts & broadcast creation
│   │   ├── attendance/                   # Biometric attendance tracking
│   │   ├── auth/                         # Multi-role login & biometric prompt
│   │   ├── campus/                       # Campus wayfinding & Google Maps UI
│   │   ├── dashboard/                    # Student, Faculty & Admin dashboards
│   │   ├── library/                      # SAIL digital library catalog
│   │   ├── notifications/                # Institutional notifications
│   │   ├── profile/                      # User profile & credentials
│   │   └── research/                     # Centres of Excellence discovery
│   └── shared/                           # Reusable Stitch widgets
├── test/
│   └── widget_test.dart                  # Automated unit and widget tests
├── pubspec.yaml                          # Dependencies & asset manifests
└── README.md                             # Project documentation
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `^3.44.0`
- **Dart SDK**: `^3.12.0`
- **Android SDK**: 34+
- **Physical Device or Emulator** with Android 9.0+ (Pie or newer)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/harshlimkar/simatsone.git
   cd simatsone
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify static analysis**:
   ```bash
   flutter analyze
   ```
   *(Expected: `No issues found!`)*

4. **Run automated test suite**:
   ```bash
   flutter test
   ```
   *(Expected: `All tests passed!`)*

5. **Build & Run on Connected Device**:
   ```bash
   flutter run
   ```

---

## 🧪 Testing & Verification

The repository includes comprehensive automated test coverage:
- **Attendance Percentage Engine**: Unit tests validating threshold checks (<85% warning, <75% critical) and zero-division safety.
- **Biometric Authentication Lifecycle**: Mock repository session persistence and token lifecycle tests.
- **Widget Smoke Tests**: Complete application pump and layout verification.

Run all tests with coverage:
```bash
flutter test --coverage
```

Build the release APK:
```bash
flutter build apk --release
```

---

## 👨‍💻 Author & Repository

- **Repository**: [github.com/harshlimkar/simatsone](https://github.com/harshlimkar/simatsone)
- **Developer**: Harsh Limkar (`harsh.limkar@simats.edu.in`)
- **Institution**: Saveetha Institute of Medical and Technical Sciences (SIMATS), Chennai, India.

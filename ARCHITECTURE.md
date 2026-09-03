# SIMATS ONE — Smart Campus Suite
## Architecture & Technical Specification

Institution: **SIMATS Engineering (Saveetha Institute of Medical and Technical Sciences)**  
Tagline: **One Campus. One App. One Connected Experience.**  
Design Foundation: **Google Stitch Project: SIMATS ONE Smart Campus Suite**

---

## 1. Architectural Philosophy

SIMATS ONE is built on **Clean Architecture + Feature-First** separation of concerns:
- **Zero business logic in UI widgets**: All operations flow through Use Cases / Repositories.
- **Offline-First Resilience**: Local Drift/Cache stores authoritative academic & safety state.
- **Predictable State with Riverpod**: Immutable models, `AsyncValue<T>`, reactive streams.
- **Hardware & Network Awareness**: Reactive detection of Wi-Fi ↔ 5G/4G handoffs without forced re-authentication.

```
UI (Widgets / Screens)
       │
       ▼
State Notifiers / Providers (Riverpod)
       │
       ▼
Domain Layer (Use Cases & Entity Contracts)
       │
       ▼
Repositories (Auth, Attendance, Timetable, Alerts, Campus, SAIL Library)
 ┌─────┴─────────────────────────┐
 ▼                               ▼
Remote Data Source (Dio/REST/WS)  Local Database (Drift/SQLite & SecureStorage)
```

---

## 2. Design System & Tokens (Google Stitch)

All UI tokens faithfully translate the Google Stitch design:
- **Primary Color:** `#00102D` (Deep Institutional Navy)
- **Primary Container:** `#0F254A`
- **Secondary:** `#3755C3` (Royal Blue)
- **Background / Surface:** `#F8F9FF`
- **Surface Cards:** `#FFFFFF` with 1px border `#C5C6CF` and ambient elevation
- **Typography:** Inter (400, 600, 700) with tabular numbers for register codes, attendance percentages, and time schedules.
- **Grid:** Strict 8-point geometric scale (16px standard card padding, 48px min touch target).

---

## 3. Core Modules Implemented

1. **Authentication & RBAC**:
   - Roles: `STUDENT`, `FACULTY`, `SECURITY_ADMIN`, `SUPER_ADMIN`
   - Secure token storage using AES-256 Android Keystore (`flutter_secure_storage`).
   - Token refresh interceptor with Dio QueuedInterceptor.
   
2. **Student Dashboard (`b5da04a18375479381c163943a106c56`)**:
   - Biometric verified banner with register number.
   - Attendance Hero with circular SVG progress (86.4% aggregated).
   - 6 Quick Portals grid (Attendance, Timetable, SAIL Library, Wayfinding, Security SOS, Hackathons).
   - Live class schedule with remaining minutes badge and one-tap classroom navigation.
   - Examination announcement circular card with COE reference.

3. **Campus Alerts & Emergency Broadcasts (`77d31287f47e40a09f978834b4fb7c83`)**:
   - Critical Broadcast banner with animated beacon, zone identification, safe detour protocol, and acknowledgement.
   - Filter chips: All, Emergency, Security, Weather, Academic.
   - Security Admin control room to issue and broadcast new advisories campus-wide.

4. **Academic Biometric Attendance**:
   - Overall aggregate calculation: `(present / total) * 100`.
   - Threshold warnings for courses below 85% and critical alerts below 75%.
   - Interactive Faculty attendance roster with duplicate submission prevention.

5. **Campus Wayfinding & Navigation**:
   - Indoor classroom and laboratory finder across CSE Block, Turing Block, and Tech Park.
   - Walking distance and estimated walking time calculations.

6. **SAIL — Saveetha Academic Infotech Library**:
   - Searchable catalog across physical textbooks, IEEE digital transactions, and cloud e-books.
   - Real-time availability tracking by shelf location and floor.

7. **Offline Synchronization Engine**:
   - Mutation queue (`SyncQueue`) with exponential backoff retry.
   - Background re-sync upon network connection restoration.

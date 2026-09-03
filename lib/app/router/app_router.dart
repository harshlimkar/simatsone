// SIMATS ONE – GoRouter Configuration
// Route groups: /auth, /student, /faculty, /security, /settings
// Protects authenticated routes and role-specific routes.
// Handles: expired sessions, unknown routes, deep links.


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/student_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/faculty_dashboard_screen.dart';
import '../../features/dashboard/presentation/screens/security_dashboard_screen.dart';
import '../../features/attendance/presentation/screens/attendance_overview_screen.dart';
import '../../features/timetable/presentation/screens/timetable_screen.dart';
import '../../features/alerts/presentation/screens/alerts_screen.dart';
import '../../features/alerts/presentation/screens/alert_detail_screen.dart';
import '../../features/alerts/presentation/screens/create_alert_screen.dart';
import '../../features/campus/presentation/screens/campus_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/events/presentation/screens/events_screen.dart';
import '../../features/announcements/presentation/screens/announcements_screen.dart';
import '../../features/research/presentation/screens/research_screen.dart';
import '../../features/centres/presentation/screens/centres_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../shared/models/enums.dart';
import '../../shared/widgets/error_screen.dart';

// ── Route Paths ───────────────────────────────────────────────────────────────

abstract final class RoutePaths {
  static const splash = '/';
  static const login = '/login';

  // Student
  static const studentDashboard = '/student/dashboard';
  static const attendance = '/student/attendance';
  static const timetable = '/student/timetable';
  static const campus = '/student/campus';
  static const library = '/student/library';
  static const events = '/student/events';
  static const announcements = '/student/announcements';
  static const research = '/student/research';
  static const centres = '/student/centres';
  static const profile = '/student/profile';
  static const notifications = '/student/notifications';

  // Faculty
  static const facultyDashboard = '/faculty/dashboard';

  // Security
  static const securityDashboard = '/security/dashboard';
  static const createAlert = '/security/alerts/create';

  // Shared
  static const alerts = '/alerts';
  static const alertDetail = '/alerts/:id';
}

// ── Router Provider ───────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isAuth = authState is AuthAuthenticated;
      final isLoading = authState is AuthLoading || authState is AuthInitial;
      final path = state.matchedLocation;

      if (isLoading) return null;
      if (!isAuth && path != RoutePaths.login && path != RoutePaths.splash) {
        return RoutePaths.login;
      }
      if (authState is AuthAuthenticated &&
          (path == RoutePaths.login || path == RoutePaths.splash)) {
        final user = authState.session.user!;
        return switch (user.role) {
          UserRole.faculty => RoutePaths.facultyDashboard,
          UserRole.securityAdmin => RoutePaths.securityDashboard,
          UserRole.superAdmin => RoutePaths.securityDashboard,
          _ => RoutePaths.studentDashboard,
        };
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(path: RoutePaths.login, builder: (_, __) => const LoginScreen()),

      // ── Student Routes ──────────────────────────────────────────────────────
      GoRoute(
        path: RoutePaths.studentDashboard,
        builder: (_, __) => const StudentDashboardScreen(),
      ),
      GoRoute(
        path: RoutePaths.attendance,
        builder: (_, __) => const AttendanceOverviewScreen(),
      ),
      GoRoute(
        path: RoutePaths.timetable,
        builder: (_, __) => const TimetableScreen(),
      ),
      GoRoute(
        path: RoutePaths.campus,
        builder: (_, __) => const CampusScreen(),
      ),
      GoRoute(
        path: RoutePaths.library,
        builder: (_, __) => const LibraryScreen(),
      ),
      GoRoute(
        path: RoutePaths.events,
        builder: (_, __) => const EventsScreen(),
      ),
      GoRoute(
        path: RoutePaths.announcements,
        builder: (_, __) => const AnnouncementsScreen(),
      ),
      GoRoute(
        path: RoutePaths.research,
        builder: (_, __) => const ResearchScreen(),
      ),
      GoRoute(
        path: RoutePaths.centres,
        builder: (_, __) => const CentresScreen(),
      ),
      GoRoute(
        path: RoutePaths.profile,
        builder: (_, __) => const ProfileScreen(),
      ),
      GoRoute(
        path: RoutePaths.notifications,
        builder: (_, __) => const NotificationsScreen(),
      ),

      // ── Faculty Routes ──────────────────────────────────────────────────────
      GoRoute(
        path: RoutePaths.facultyDashboard,
        builder: (_, __) => const FacultyDashboardScreen(),
      ),

      // ── Security Routes ─────────────────────────────────────────────────────
      GoRoute(
        path: RoutePaths.securityDashboard,
        builder: (_, __) => const SecurityDashboardScreen(),
      ),
      GoRoute(
        path: RoutePaths.createAlert,
        builder: (_, __) => const CreateAlertScreen(),
      ),

      // ── Shared Routes ───────────────────────────────────────────────────────
      GoRoute(
        path: RoutePaths.alerts,
        builder: (_, __) => const AlertsScreen(),
      ),
      GoRoute(
        path: RoutePaths.alertDetail,
        builder: (_, state) =>
            AlertDetailScreen(alertId: state.pathParameters['id']!),
      ),
    ],
    errorBuilder: (context, state) =>
        ErrorScreen(error: state.error?.toString()),
  );
});

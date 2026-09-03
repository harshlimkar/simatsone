// SIMATS ONE – Auth Repository Implementation (Mock + Remote)
// MockAuthRepository provides demo data without a live backend.
// RemoteAuthRepository connects to the real API.

import 'package:logger/logger.dart';
import '../../domain/entities/auth_entities.dart';
import '../../../../shared/models/enums.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../app/config/app_config.dart';

// ── Mock Repository (Development / Demo Mode) ─────────────────────────────────

class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._storage);
  final SecureStorageService _storage;
  final _logger = Logger();



  @override
  Future<AuthSession> login({
    required String identifier,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    _logger.d('${AppConstants.tagAuth} [DEMO] Login attempt: $identifier');

    AppUser? user;
    if (identifier.contains('faculty') || identifier.contains('narayanan')) {
      user = _makeUser(UserRole.faculty);
    } else if (identifier.contains('security') ||
        identifier.contains('rajan')) {
      user = _makeUser(UserRole.securityAdmin);
    } else if (identifier.contains('admin')) {
      user = _makeUser(UserRole.superAdmin);
    } else {
      // Default: student login
      user = _makeUser(UserRole.student);
    }

    if (password.isEmpty || password.length < 4) {
      throw const InvalidCredentialsFailure();
    }

    const tokens = AuthTokens(
      accessToken: 'demo_access_token_simats_one',
      refreshToken: 'demo_refresh_token_simats_one',
    );

    await _storage.saveAccessToken(tokens.accessToken);
    await _storage.saveRefreshToken(tokens.refreshToken);
    await _storage.saveUserId(user.id);
    await _storage.saveUserRole(user.role.name);

    return AuthSession(user: user, tokens: tokens, isAuthenticated: true);
  }

  @override
  Future<void> logout() async {
    _logger.d('${AppConstants.tagAuth} Logout');
    await _storage.clearAll();
  }

  @override
  Future<AuthSession> refreshSession() async {
    final userId = await _storage.getUserId();
    final roleStr = await _storage.getUserRole();
    if (userId == null || roleStr == null) {
      return AuthSession.unauthenticated;
    }
    final role = UserRole.values.firstWhere(
      (r) => r.name == roleStr,
      orElse: () => UserRole.student,
    );
    return AuthSession(
      user: _makeUser(role),
      tokens: const AuthTokens(
        accessToken: 'demo_access_token_simats_one',
        refreshToken: 'demo_refresh_token_simats_one',
      ),
      isAuthenticated: true,
    );
  }

  @override
  Future<AuthSession?> getStoredSession() async {
    final hasSession = await _storage.hasValidSession();
    if (!hasSession) return null;
    return refreshSession();
  }

  AppUser _makeUser(UserRole role) {
    final now = DateTime.now();
    return switch (role) {
      UserRole.student => AppUser(
        id: 'stu_001',
        name: 'Harsh limkar N',
        email: 'harsh.limkar@simats.edu.in',
        role: UserRole.student,
        department: 'Computer Science and Engineering',
        profileImageUrl: null,
        createdAt: now,
        updatedAt: now,
      ),
      UserRole.faculty => AppUser(
        id: 'fac_001',
        name: 'Dr. S. K. Narayanan',
        email: 'narayanan@simats.edu.in',
        role: UserRole.faculty,
        department: 'Computer Science and Engineering',
        profileImageUrl: null,
        createdAt: now,
        updatedAt: now,
      ),
      UserRole.securityAdmin => AppUser(
        id: 'sec_001',
        name: 'Officer V. Rajan',
        email: 'rajan.sec@simats.edu.in',
        role: UserRole.securityAdmin,
        department: 'Campus Security',
        profileImageUrl: null,
        createdAt: now,
        updatedAt: now,
      ),
      _ => AppUser(
        id: 'adm_001',
        name: 'Admin User',
        email: 'admin@simats.edu.in',
        role: UserRole.superAdmin,
        department: 'Administration',
        profileImageUrl: null,
        createdAt: now,
        updatedAt: now,
      ),
    };
  }
}

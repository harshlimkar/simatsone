// SIMATS ONE – Auth Domain: Entities + Repository + UseCases

import '../../../../shared/models/enums.dart';

// ── Entities ─────────────────────────────────────────────────────────────────

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.department,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? department;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get firstName => name.split(' ').first;

  AppUser copyWith({
    String? name,
    String? profileImageUrl,
    String? department,
  }) => AppUser(
    id: id,
    name: name ?? this.name,
    email: email,
    role: role,
    department: department ?? this.department,
    profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;
}

class AuthSession {
  const AuthSession({
    required this.user,
    required this.tokens,
    required this.isAuthenticated,
  });

  final AppUser? user;
  final AuthTokens? tokens;
  final bool isAuthenticated;

  static const unauthenticated = AuthSession(
    user: null,
    tokens: null,
    isAuthenticated: false,
  );
}

// ── Repository Interface ──────────────────────────────────────────────────────

abstract interface class AuthRepository {
  Future<AuthSession> login({
    required String identifier,
    required String password,
  });

  Future<void> logout();
  Future<AuthSession> refreshSession();
  Future<AuthSession?> getStoredSession();
  Future<AuthSession> loginWithBiometrics({required UserRole role});
}

// ── Use Cases ─────────────────────────────────────────────────────────────────

class LoginUseCase {
  const LoginUseCase(this._repository);
  final AuthRepository _repository;

  Future<AuthSession> execute({
    required String identifier,
    required String password,
  }) => _repository.login(identifier: identifier, password: password);
}

class LogoutUseCase {
  const LogoutUseCase(this._repository);
  final AuthRepository _repository;

  Future<void> execute() => _repository.logout();
}

class GetStoredSessionUseCase {
  const GetStoredSessionUseCase(this._repository);
  final AuthRepository _repository;

  Future<AuthSession?> execute() => _repository.getStoredSession();
}

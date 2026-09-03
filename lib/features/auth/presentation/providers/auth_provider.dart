// SIMATS ONE – Auth State Provider (Riverpod)

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/auth_entities.dart';
import '../../data/repositories/mock_auth_repository.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/errors/app_failure.dart';

// ── Repository Provider ───────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return MockAuthRepository(storage);
});

// ── Auth State ────────────────────────────────────────────────────────────────

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  AuthAuthenticated(this.session);
  final AuthSession session;
}

final class AuthUnauthenticated extends AuthState {}

final class AuthError extends AuthState {
  AuthError(this.failure);
  final AppFailure failure;
}

// ── Auth Notifier ─────────────────────────────────────────────────────────────

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _checkStoredSession();
    return AuthInitial();
  }

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> _checkStoredSession() async {
    state = AuthLoading();
    try {
      final session = await _repo.getStoredSession();
      if (session != null && session.isAuthenticated) {
        state = AuthAuthenticated(session);
      } else {
        state = AuthUnauthenticated();
      }
    } catch (_) {
      state = AuthUnauthenticated();
    }
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    state = AuthLoading();
    try {
      final session = await _repo.login(
        identifier: identifier,
        password: password,
      );
      state = AuthAuthenticated(session);
    } on AppFailure catch (f) {
      state = AuthError(f);
    } catch (_) {
      state = AuthError(const UnknownFailure());
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    state = AuthUnauthenticated();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

// ── Convenience Providers ──────────────────────────────────────────────────────

final currentUserProvider = Provider<AppUser?>((ref) {
  final authState = ref.watch(authProvider);
  if (authState is AuthAuthenticated) return authState.session.user;
  return null;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is AuthAuthenticated;
});

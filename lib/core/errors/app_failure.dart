// SIMATS ONE – Core Error Hierarchy
// Centralized failure types → human-readable UI messages

sealed class AppFailure {
  const AppFailure({required this.message, this.code});
  final String message;
  final String? code;
}

// ── Network ──────────────────────────────────────────────────────────────────

final class NetworkFailure extends AppFailure {
  const NetworkFailure({
    super.message =
        'Unable to connect. Check your internet connection and try again.',
    super.code,
  });
}

final class TimeoutFailure extends AppFailure {
  const TimeoutFailure({
    super.message = 'Request timed out. Please try again.',
    super.code,
  });
}

// ── Auth ─────────────────────────────────────────────────────────────────────

final class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure({
    super.message = 'Your session has expired. Please log in again.',
    super.code,
  });
}

final class ForbiddenFailure extends AppFailure {
  const ForbiddenFailure({
    super.message = "You don't have permission to access this resource.",
    super.code,
  });
}

final class InvalidCredentialsFailure extends AppFailure {
  const InvalidCredentialsFailure({
    super.message = 'Invalid ID or password. Please try again.',
    super.code,
  });
}

// ── Server ────────────────────────────────────────────────────────────────────

final class ServerFailure extends AppFailure {
  const ServerFailure({
    super.message = 'Something went wrong on our end. Please try again later.',
    super.code,
  });
}

final class ServiceUnavailableFailure extends AppFailure {
  const ServiceUnavailableFailure({
    super.message = 'Service is temporarily unavailable. Showing cached data.',
    super.code,
  });
}

// ── Validation ────────────────────────────────────────────────────────────────

final class ValidationFailure extends AppFailure {
  const ValidationFailure({required super.message, super.code});
}

// ── Storage / Cache ──────────────────────────────────────────────────────────

final class CacheFailure extends AppFailure {
  const CacheFailure({
    super.message =
        'Unable to load cached data. Please refresh when connected.',
    super.code,
  });
}

// ── Sync ─────────────────────────────────────────────────────────────────────

final class SyncFailure extends AppFailure {
  const SyncFailure({
    super.message =
        'Synchronization failed. Changes will be retried automatically.',
    super.code,
  });
}

// ── Location ─────────────────────────────────────────────────────────────────

final class LocationPermissionFailure extends AppFailure {
  const LocationPermissionFailure({
    super.message =
        'Location access is needed for campus navigation. Enable in settings.',
    super.code,
  });
}

// ── Unknown ──────────────────────────────────────────────────────────────────

final class UnknownFailure extends AppFailure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.code,
  });
}

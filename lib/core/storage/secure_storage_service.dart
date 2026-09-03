// SIMATS ONE – Secure Storage Wrapper
// All sensitive data (JWT tokens, session info) goes through this class.
// Storage backend: flutter_secure_storage → Android Keystore (AES-256)
// NEVER store tokens in SharedPreferences or plain storage.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecureStorageService {
  SecureStorageService._();
  static final SecureStorageService _instance = SecureStorageService._();
  factory SecureStorageService() => _instance;

  // Android: AES-256 via Android Keystore
  // iOS: Keychain (excluded from backup by default)
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // ── Keys ─────────────────────────────────────────────────────────────────────
  static const _keyAccessToken = 'simats_access_token';
  static const _keyRefreshToken = 'simats_refresh_token';
  static const _keyUserId = 'simats_user_id';
  static const _keyUserRole = 'simats_user_role';
  static const _keyTokenExpiry = 'simats_token_expiry';

  // ── Access Token ─────────────────────────────────────────────────────────────
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _keyAccessToken, value: token);
  Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);
  Future<void> deleteAccessToken() => _storage.delete(key: _keyAccessToken);

  // ── Refresh Token ─────────────────────────────────────────────────────────────
  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _keyRefreshToken, value: token);
  Future<String?> getRefreshToken() => _storage.read(key: _keyRefreshToken);
  Future<void> deleteRefreshToken() => _storage.delete(key: _keyRefreshToken);

  // ── User Identity ─────────────────────────────────────────────────────────────
  Future<void> saveUserId(String userId) =>
      _storage.write(key: _keyUserId, value: userId);
  Future<String?> getUserId() => _storage.read(key: _keyUserId);

  Future<void> saveUserRole(String role) =>
      _storage.write(key: _keyUserRole, value: role);
  Future<String?> getUserRole() => _storage.read(key: _keyUserRole);

  // ── Token Expiry ──────────────────────────────────────────────────────────────
  Future<void> saveTokenExpiry(DateTime expiry) =>
      _storage.write(key: _keyTokenExpiry, value: expiry.toIso8601String());
  Future<DateTime?> getTokenExpiry() async {
    final v = await _storage.read(key: _keyTokenExpiry);
    if (v == null) return null;
    return DateTime.tryParse(v);
  }

  // ── Session Management ────────────────────────────────────────────────────────
  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    if (token == null) return false;
    final expiry = await getTokenExpiry();
    if (expiry == null) return true; // no expiry stored → assume valid
    return DateTime.now().isBefore(expiry);
  }

  /// Clear all stored credentials on logout or session expiry
  Future<void> clearAll() => _storage.deleteAll();
}

// ── Provider ─────────────────────────────────────────────────────────────────
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

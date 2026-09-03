// SIMATS ONE – Device Biometric & Fingerprint Authentication Service

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

enum BiometricAuthStatus {
  success,
  canceled,
  notEnrolled,
  failed,
}

final biometricServiceProvider = Provider<BiometricAuthService>((ref) {
  return BiometricAuthService();
});

class BiometricAuthService {
  BiometricAuthService({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  /// Check if hardware supports biometric
  Future<bool> isBiometricsAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();
      return canCheck || isSupported;
    } on PlatformException catch (e) {
      debugPrint('Biometrics check error: $e');
      return false;
    }
  }

  /// Get list of available biometric types (fingerprint, face, etc.)
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      debugPrint('getAvailableBiometrics error: $e');
      return [];
    }
  }

  /// Trigger native phone biometrics (Fingerprint / Face ID / Screen Lock)
  Future<BiometricAuthStatus> authenticate({required String roleTitle}) async {
    try {
      final authenticated = await _auth.authenticate(
        localizedReason:
            'Scan fingerprint or verify screen lock to sign in as $roleTitle',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      return authenticated
          ? BiometricAuthStatus.success
          : BiometricAuthStatus.canceled;
    } on PlatformException catch (e) {
      debugPrint('Biometric primary attempt PlatformException: ${e.code} - ${e.message}');
      // Fallback attempt: biometricOnly = true for devices that reject device credentials
      try {
        final retryAuth = await _auth.authenticate(
          localizedReason: 'Scan fingerprint to sign in as $roleTitle',
          biometricOnly: true,
          persistAcrossBackgrounding: true,
        );
        return retryAuth
            ? BiometricAuthStatus.success
            : BiometricAuthStatus.canceled;
      } on PlatformException catch (e2) {
        debugPrint('Biometric retry PlatformException: ${e2.code} - ${e2.message}');
        if (e2.code == 'NotAvailable' ||
            e2.code == 'NotEnrolled' ||
            e2.code == 'PasscodeNotSet') {
          return BiometricAuthStatus.notEnrolled;
        }
        return BiometricAuthStatus.failed;
      }
    } catch (e) {
      debugPrint('Biometric unexpected error: $e');
      return BiometricAuthStatus.failed;
    }
  }
}

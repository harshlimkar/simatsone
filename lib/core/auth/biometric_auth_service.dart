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

  /// Check if hardware supports biometric and has enrolled biometrics
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

  /// Trigger native phone biometrics (Fingerprint / Face ID / Phone Screen Lock)
  Future<BiometricAuthStatus> authenticate({required String roleTitle}) async {
    try {
      final authenticated = await _auth.authenticate(
        localizedReason:
            'Scan your fingerprint or face to sign in as $roleTitle',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      return authenticated
          ? BiometricAuthStatus.success
          : BiometricAuthStatus.canceled;
    } on PlatformException catch (e) {
      debugPrint('Biometric PlatformException: code=${e.code}, msg=${e.message}');
      if (e.code == 'NotAvailable' ||
          e.code == 'NotEnrolled' ||
          e.code == 'PasscodeNotSet') {
        return BiometricAuthStatus.notEnrolled;
      }
      return BiometricAuthStatus.failed;
    } catch (e) {
      debugPrint('Biometric unexpected error: $e');
      return BiometricAuthStatus.failed;
    }
  }
}

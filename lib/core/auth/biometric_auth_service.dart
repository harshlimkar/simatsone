// SIMATS ONE – Device Biometric & Fingerprint Authentication Service

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

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

  /// Trigger native phone biometrics (Fingerprint / Face ID / Phone PIN)
  Future<bool> authenticate({required String roleTitle}) async {
    try {
      final authenticated = await _auth.authenticate(
        localizedReason:
            'Authenticate with your fingerprint or face to sign in as $roleTitle',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
      return authenticated;
    } on PlatformException catch (e) {
      debugPrint('Biometric authentication failed or canceled: $e');
      return false;
    }
  }
}

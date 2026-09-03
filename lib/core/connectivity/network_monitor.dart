// SIMATS ONE – Network Connectivity Monitor
// Wraps connectivity_plus to provide a reactive NetworkStatus stream

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/enums.dart';

class NetworkMonitor {
  NetworkMonitor() {
    _init();
  }

  final _connectivity = Connectivity();
  final _controller = StreamController<NetworkStatus>.broadcast();

  Stream<NetworkStatus> get statusStream => _controller.stream;
  NetworkStatus _currentStatus = NetworkStatus.unknown;
  NetworkStatus get currentStatus => _currentStatus;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  void _init() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final status = _mapResults(results);
      if (status != _currentStatus) {
        _currentStatus = status;
        _controller.add(status);
      }
    });

    // Check immediately on startup
    _connectivity.checkConnectivity().then((results) {
      _currentStatus = _mapResults(results);
      _controller.add(_currentStatus);
    });
  }

  NetworkStatus _mapResults(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) {
      return NetworkStatus.connectedWifi;
    }
    if (results.contains(ConnectivityResult.mobile)) {
      return NetworkStatus.connectedMobile;
    }
    if (results.contains(ConnectivityResult.ethernet)) {
      return NetworkStatus.connectedEthernet;
    }
    if (results.contains(ConnectivityResult.none)) {
      return NetworkStatus.noInternet;
    }
    return NetworkStatus.unknown;
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _controller.close();
  }
}

// ── Riverpod Providers ────────────────────────────────────────────────────────

final networkMonitorProvider = Provider<NetworkMonitor>((ref) {
  final monitor = NetworkMonitor();
  ref.onDispose(monitor.dispose);
  return monitor;
});

final networkStatusProvider = StreamProvider<NetworkStatus>((ref) {
  return ref.watch(networkMonitorProvider).statusStream;
});

final isConnectedProvider = Provider<bool>((ref) {
  return ref
      .watch(networkStatusProvider)
      .maybeWhen(data: (s) => s.isConnected, orElse: () => false);
});

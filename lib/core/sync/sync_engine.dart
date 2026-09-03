import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/enums.dart';
import '../connectivity/network_monitor.dart';

class SyncRecord {
  const SyncRecord({
    required this.id,
    required this.operation,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
    this.status = SyncStatus.pending,
  });

  final String id;
  final String operation;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;
  final SyncStatus status;

  SyncRecord copyWith({int? retryCount, SyncStatus? status}) {
    return SyncRecord(
      id: id,
      operation: operation,
      payload: payload,
      createdAt: createdAt,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
    );
  }
}

class SyncEngine {
  SyncEngine(this._ref) {
    _init();
  }

  final Ref _ref;
  final List<SyncRecord> _queue = [];
  final _syncStreamController = StreamController<List<SyncRecord>>.broadcast();

  Stream<List<SyncRecord>> get queueStream => _syncStreamController.stream;
  List<SyncRecord> get pendingRecords =>
      _queue.where((r) => r.status == SyncStatus.pending).toList();

  void _init() {
    _ref.listen<AsyncValue<NetworkStatus>>(networkStatusProvider, (_, next) {
      next.whenData((status) {
        if (status.isConnected && pendingRecords.isNotEmpty) {
          processQueue();
        }
      });
    });
  }

  void enqueue({
    required String operation,
    required Map<String, dynamic> payload,
  }) {
    final record = SyncRecord(
      id: 'sync_${DateTime.now().millisecondsSinceEpoch}',
      operation: operation,
      payload: payload,
      createdAt: DateTime.now(),
    );
    _queue.add(record);
    _syncStreamController.add(_queue);

    // If online, process immediately
    final isConnected = _ref.read(isConnectedProvider);
    if (isConnected) {
      processQueue();
    }
  }

  Future<void> processQueue() async {
    for (int i = 0; i < _queue.length; i++) {
      final item = _queue[i];
      if (item.status == SyncStatus.pending) {
        _queue[i] = item.copyWith(status: SyncStatus.syncing);
        _syncStreamController.add(_queue);

        try {
          // Simulate network sync request with retry policy
          await Future.delayed(const Duration(milliseconds: 600));
          _queue[i] = item.copyWith(status: SyncStatus.synced);
        } catch (_) {
          _queue[i] = item.copyWith(
            status: SyncStatus.failed,
            retryCount: item.retryCount + 1,
          );
        }
        _syncStreamController.add(_queue);
      }
    }
  }
}

final syncEngineProvider = Provider<SyncEngine>((ref) {
  return SyncEngine(ref);
});

final syncQueueProvider = StreamProvider<List<SyncRecord>>((ref) {
  return ref.watch(syncEngineProvider).queueStream;
});

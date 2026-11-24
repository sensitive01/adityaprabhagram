// lib/services/connectivity_service.dart
//
// Phase 1 — Connectivity Service
//
// PURPOSE:
//   Provides a reusable stream of connectivity changes for use by the future
//   sync engine (Phase 3). In Phase 1 this service is initialized and available
//   but does NOT change any existing survey screen behavior.
//
// IMPORTANT CAVEATS:
//   1. A reported network connection does NOT guarantee that Supabase is
//      reachable. The future sync engine must handle timeouts, failed requests
//      and uncertain write outcomes independently of the connectivity state
//      reported here.
//   2. Network-interface availability (what this service reports) is distinct
//      from actual Supabase reachability. Do not conflate the two.
//   3. If the initial connectivity check fails (e.g. platform error), the
//      service reports ConnectivityState.unknown rather than falsely claiming
//      the device is online.
//
// USAGE (Phase 3 sync engine):
//   ConnectivityService.instance.connectivityStream.listen((state) {
//     if (state == ConnectivityState.online) syncEngine.drainQueue();
//   });

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

/// Three-state connectivity model.
///
/// [unknown] — the initial check has not completed or threw an error.
///             Treat as offline for safety; do not assume connectivity.
/// [online]  — at least one network interface is available.
/// [offline] — no network interface is available.
enum ConnectivityState { unknown, online, offline }

class ConnectivityService {
  ConnectivityService._();
  static final ConnectivityService instance = ConnectivityService._();

  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityState> _controller =
      StreamController<ConnectivityState>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  // Default to unknown — never falsely claim online before the check completes.
  ConnectivityState _state = ConnectivityState.unknown;

  /// Current connectivity state.
  /// [ConnectivityState.unknown] until the initial check succeeds.
  ConnectivityState get state => _state;

  /// Convenience getter — true only when state is confirmed online.
  /// Returns false for both [offline] and [unknown].
  bool get isOnline => _state == ConnectivityState.online;

  /// Broadcast stream that emits the new [ConnectivityState] on every change.
  Stream<ConnectivityState> get connectivityStream => _controller.stream;

  /// Initialize the service and begin listening for connectivity changes.
  /// Safe to call multiple times — subsequent calls are no-ops.
  Future<void> initialize() async {
    if (_subscription != null) return;

    // Perform the initial check. If it throws, leave state as unknown (safe).
    try {
      final results = await _connectivity.checkConnectivity();
      _state = _stateFromResults(results);
      debugPrint('[Connectivity] Initial state: ${_state.name}');
    } catch (e) {
      // Do NOT set _state to online here. Unknown is the safe default.
      debugPrint(
        '[Connectivity] Initial check failed — state remains unknown. Error: $e',
      );
    }

    // Subscribe to future changes.
    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        final newState = _stateFromResults(results);
        if (newState != _state) {
          _state = newState;
          _controller.add(_state);
          debugPrint('[Connectivity] State changed: ${_state.name}');
        }
      },
      onError: (e) {
        debugPrint('[Connectivity] Stream error: $e');
        // Do not change state on stream errors — retain last known state.
      },
    );
  }

  /// Dispose the service. Call when the app is terminating.
  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    await _controller.close();
  }

  ConnectivityState _stateFromResults(List<ConnectivityResult> results) {
    final hasInterface = results.any(
      (r) =>
          r == ConnectivityResult.mobile ||
          r == ConnectivityResult.wifi ||
          r == ConnectivityResult.ethernet ||
          r == ConnectivityResult.vpn,
    );
    return hasInterface ? ConnectivityState.online : ConnectivityState.offline;
  }
}

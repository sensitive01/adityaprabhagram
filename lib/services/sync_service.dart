import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './connectivity_service.dart';
import './local_database_service.dart';
import './supabase_service.dart';

// lib/services/sync_service.dart
//
// Phase 2 — Sync Service
//
// PURPOSE:
//   Drains the local sync_queue when connectivity returns.
//   Each operation is attempted against Supabase; on success it is marked
//   'synced'; on failure it is marked 'failed' with the error message and
//   retry_count incremented.
//
// PARENT-BEFORE-CHILD ORDERING (Fix 6):
//   The drain loop processes 'surveys' table operations before all other
//   (specialized) tables. If a parent survey upload fails, all dependent
//   specialized records for that survey_id are skipped and remain pending/failed
//   for retry. This prevents orphaned specialized records on the server.
//
// IDEMPOTENCY:
//   • surveys: upserted by id (PK) — safe to retry.
//   • household_assets / livestock / cropping_pattern / crops: upserted with
//     onConflict matching the unique constraint — safe to retry.
//   • pests_diseases / employment_seasonality: upserted by id (PK) — safe.
//
// DUPLICATE PREVENTION:
//   enqueueSyncOperation uses ConflictAlgorithm.ignore on operation_id, so
//   re-enqueueing the same operation never creates a duplicate queue row.
//   updatePendingSyncPayload refreshes the payload of a pending operation so
//   repeated saves always upload the latest answers.
//
// USAGE:
//   SyncService.instance.initialize();   // call once from main.dart
//   SyncService.instance.triggerSync();  // call manually if needed

class SyncService {
  SyncService._();
  static final SyncService instance = SyncService._();

  StreamSubscription<ConnectivityState>? _connectivitySub;
  bool _isSyncing = false;

  /// Initialize: listen for connectivity changes and drain on reconnect.

  void initialize() {
    _connectivitySub?.cancel();
    _connectivitySub = ConnectivityService.instance.connectivityStream.listen((
      state,
    ) {
      if (state == ConnectivityState.online) {
        debugPrint('[SyncService] Connectivity restored — draining queue.');
        triggerSync();
      }
    });

    // Also drain the queue when the app starts with connectivity already online.
    if (ConnectivityService.instance.isOnline) {
      debugPrint('[SyncService] Startup online — checking sync queue.');
      triggerSync();
    }
  }

  /// Dispose the service.
  Future<void> dispose() async {
    await _connectivitySub?.cancel();
    _connectivitySub = null;
  }

  /// Trigger a sync drain. Safe to call multiple times — concurrent calls
  /// are no-ops (only one drain runs at a time).
  Future<void> triggerSync() async {
    if (_isSyncing) return;
    if (!LocalDatabaseService.instance.isAvailable) return;
    if (!ConnectivityService.instance.isOnline) return;

    _isSyncing = true;
    try {
      await _drainQueue();
    } catch (e) {
      debugPrint('[SyncService] Drain error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _drainQueue() async {
    final pending = await LocalDatabaseService.instance
        .getPendingSyncOperations();
    if (pending.isEmpty) return;

    debugPrint(
      '[SyncService] Draining ${pending.length} pending operation(s).',
    );

    final client = SupabaseService.instance.client;

    // Fix 6: Enforce parent-before-child ordering.
    // Partition operations: surveys first, then specialized tables.
    // Within each partition, preserve original created_at order.
    final surveyOps = pending
        .where((op) => (op['target_table'] as String) == 'surveys')
        .toList();
    final childOps = pending
        .where((op) => (op['target_table'] as String) != 'surveys')
        .toList();

    // Track which survey_ids were successfully synced in this drain pass.
    final syncedSurveyIds = <String>{};
    // Track which survey_ids failed to sync (children must be skipped).
    final failedSurveyIds = <String>{};

    // ── Phase 1: Upload parent survey rows ───────────────────────────────────
    for (final op in surveyOps) {
      await _processOperation(
        client: client,
        op: op,
        onSuccess: () {
          final surveyId = op['survey_id'] as String?;
          if (surveyId != null) syncedSurveyIds.add(surveyId);
        },
        onFailure: () {
          final surveyId = op['survey_id'] as String?;
          if (surveyId != null) failedSurveyIds.add(surveyId);
        },
      );
    }

    // ── Phase 2: Upload child specialized records ─────────────────────────────
    for (final op in childOps) {
      final surveyId = op['survey_id'] as String?;

      // Skip children whose parent survey failed in this pass.
      // They remain pending/failed for the next retry.
      if (surveyId != null && failedSurveyIds.contains(surveyId)) {
        debugPrint(
          '[SyncService] Skipping child op ${op['operation_id']} — '
          'parent survey $surveyId failed to sync.',
        );
        continue;
      }

      await _processOperation(
        client: client,
        op: op,
        onSuccess: null,
        onFailure: null,
      );
    }
  }

  /// Processes a single sync operation: uploads to Supabase, then marks
  /// complete or failed. Never marks an operation synced if the upload
  /// failed or the operation type is unsupported.
  Future<void> _processOperation({
    required SupabaseClient client,
    required Map<String, dynamic> op,
    void Function()? onSuccess,
    void Function()? onFailure,
  }) async {
    final operationId = op['operation_id'] as String;
    final targetTable = op['target_table'] as String;
    final operationType = op['operation_type'] as String;
    final payloadJson = op['payload_json'] as String;

    try {
      final payload = jsonDecode(payloadJson) as Map<String, dynamic>;

      switch (operationType) {
        case 'upsert':
          await _upsertToSupabase(client, targetTable, payload);
          break;
        case 'delete':
          final id = payload['id'] as String?;
          if (id != null) {
            await client.from(targetTable).delete().eq('id', id);
          }
          break;
        default:
          // Fix 6: Never mark an unsupported operation as synced.
          // Mark it failed so it can be investigated and retried.
          debugPrint(
            '[SyncService] Unknown operation type: $operationType — marking failed.',
          );
          await LocalDatabaseService.instance.markSyncOperationFailed(
            operationId: operationId,
            errorMessage: 'Unsupported operation type: $operationType',
          );
          onFailure?.call();
          return;
      }

      await LocalDatabaseService.instance.markSyncOperationComplete(
        operationId,
      );
      onSuccess?.call();
      debugPrint('[SyncService] ✓ $operationId ($targetTable $operationType)');
    } catch (e) {
      final errMsg = e.toString();
      await LocalDatabaseService.instance.markSyncOperationFailed(
        operationId: operationId,
        errorMessage: errMsg,
      );
      onFailure?.call();
      debugPrint(
        '[SyncService] ✗ $operationId ($targetTable $operationType): $errMsg',
      );
    }
  }

  Future<void> _upsertToSupabase(
    SupabaseClient client,
    String targetTable,
    Map<String, dynamic> payload,
  ) async {
    // Determine the conflict column(s) per table for idempotent upserts.
    switch (targetTable) {
      case 'surveys':
        await client.from('surveys').upsert(payload, onConflict: 'id');
        break;
      case 'household_assets':
        await client
            .from('household_assets')
            .upsert(payload, onConflict: 'survey_id,asset_type');
        break;
      case 'livestock':
        await client
            .from('livestock')
            .upsert(payload, onConflict: 'survey_id,animal_type');
        break;
      case 'cropping_pattern':
        await client
            .from('cropping_pattern')
            .upsert(payload, onConflict: 'survey_id,category');
        break;
      case 'crops':
        await client
            .from('crops')
            .upsert(payload, onConflict: 'survey_id,category,crop_rank');
        break;
      case 'pests_diseases':
        await client.from('pests_diseases').upsert(payload, onConflict: 'id');
        break;
      case 'employment_seasonality':
        await client
            .from('employment_seasonality')
            .upsert(payload, onConflict: 'id');
        break;
      default:
        // Generic upsert by id
        await client.from(targetTable).upsert(payload, onConflict: 'id');
    }
  }
}

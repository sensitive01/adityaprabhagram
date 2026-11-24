import 'package:flutter/foundation.dart';

// lib/services/local_database_service.dart
//
// Phase 1 — Local Storage Foundation
//
// PURPOSE:
//   Provides a versioned SQLite database for offline survey data persistence.
//   This service is ADDITIVE — it does NOT redirect existing Supabase reads/writes.
//   Existing online workflows are completely unchanged in Phase 1.
//
// INITIALIZATION FAILURE DETECTION:
//   initialize() distinguishes three outcomes:
//     • Success  — _initialized = true,  _initializationError = null
//     • Failure  — _initialized = false, _initializationError = <exception>
//     • Web      — _initialized = true,  _initializationError = null (stub path)
//
//   Callers must check isAvailable (not just isInitialized) before performing
//   local writes. isAvailable returns true only when initialization succeeded.
//   Any write attempted when isAvailable is false throws LocalDatabaseUnavailableException
//   so that offline-save operations cannot silently appear successful when local
//   persistence is unavailable.
//
// SCHEMA DESIGN NOTES:
//   • survey_id and household_id are TEXT (UUID strings) matching Supabase PKs.
//   • responses_json stores the full _answers map as a JSON string.
//   • Specialized tables mirror their Supabase counterparts.
//   • questionnaire_cache stores the full question/option configuration as JSON.
//   • sync_queue tracks every pending write operation for the future sync engine.
//
// FUTURE ADMIN QUESTIONS:
//   Answers are keyed by question UUID so new questions added by Admin are
//   automatically supported without any schema change.
//
// WEB PLATFORM:
//   sqflite does not support web. All methods return safe no-op values on web.

import 'local_database_stub.dart'
    if (dart.library.io) 'local_database_impl.dart'
    as db;

/// Thrown when a local-database operation is attempted but the database
/// is unavailable (initialization failed or running on web).
class LocalDatabaseUnavailableException implements Exception {
  final String message;
  const LocalDatabaseUnavailableException(this.message);

  @override
  String toString() => 'LocalDatabaseUnavailableException: $message';
}

/// Singleton service for the local SQLite database.
///
/// Usage:
///   await LocalDatabaseService.instance.initialize();
///   if (!LocalDatabaseService.instance.isAvailable) {
///     // handle unavailability — do not attempt local writes
///   }
class LocalDatabaseService {
  LocalDatabaseService._();
  static final LocalDatabaseService instance = LocalDatabaseService._();

  bool _initialized = false;
  Object? _initializationError;

  /// True only when initialization completed successfully.
  /// On web this is always true (stub path — no-ops).
  bool get isInitialized => _initialized;

  /// The exception thrown during initialization, or null if initialization
  /// succeeded (or has not been attempted yet).
  Object? get initializationError => _initializationError;

  /// True when the database is ready for use.
  /// On web: always false (stub — no local persistence).
  /// On mobile: true only after a successful initialize() call.
  ///
  /// Phase 2 offline-save operations MUST check this before writing.
  /// If false, throw or surface an error rather than silently succeeding.
  bool get isAvailable {
    if (kIsWeb) return false;
    return _initialized && _initializationError == null;
  }

  /// Initialize the local database.
  /// Safe to call multiple times — subsequent calls are no-ops.
  ///
  /// Does NOT throw. Callers should check [isAvailable] and
  /// [initializationError] after calling this method.
  Future<void> initialize() async {
    if (_initialized) return;
    if (kIsWeb) {
      debugPrint(
        '[LocalDB] Web platform detected — SQLite not available. '
        'Existing Supabase-only path remains active.',
      );
      _initialized = true;
      _initializationError = null;
      return;
    }
    try {
      await db.LocalDatabaseImpl.instance.open();
      _initialized = true;
      _initializationError = null;
      debugPrint(
        '[LocalDB] Initialized successfully (v${db.LocalDatabaseImpl.kDbVersion}).',
      );
    } catch (e, st) {
      // Mark as failed — do NOT set _initialized = true.
      _initialized = false;
      _initializationError = e;
      debugPrint('[LocalDB] Initialization FAILED: $e\n$st');
      // Do not rethrow — caller checks isAvailable / initializationError.
    }
  }

  /// Asserts the database is available before any write operation.
  /// Throws [LocalDatabaseUnavailableException] if not available.
  void _assertAvailable(String operation) {
    if (!isAvailable) {
      throw LocalDatabaseUnavailableException(
        'Cannot perform "$operation": local database is unavailable. '
        'initializationError=$_initializationError',
      );
    }
  }

  // ── Survey Records ────────────────────────────────────────────────────────

  Future<void> upsertSurvey({
    required String surveyId,
    required String householdId,
    required String agentId,
    required String status,
    required String responsesJson,
    String? submittedAt,
  }) async {
    if (kIsWeb) return;
    _assertAvailable('upsertSurvey');
    await db.LocalDatabaseImpl.instance.upsertSurvey(
      surveyId: surveyId,
      householdId: householdId,
      agentId: agentId,
      status: status,
      responsesJson: responsesJson,
      submittedAt: submittedAt,
    );
  }

  Future<Map<String, dynamic>?> getSurvey(String surveyId) async {
    if (!isAvailable) return null;
    return db.LocalDatabaseImpl.instance.getSurvey(surveyId);
  }

  Future<List<Map<String, dynamic>>> getSurveysForHousehold(
    String householdId,
  ) async {
    if (!isAvailable) return [];
    return db.LocalDatabaseImpl.instance.getSurveysForHousehold(householdId);
  }
Future<List<Map<String, dynamic>>> getSurveysForAgent(
  String agentId,
) async {
  if (!isAvailable) return [];
  return db.LocalDatabaseImpl.instance.getSurveysForAgent(agentId);
}

  // ── Household Assets ──────────────────────────────────────────────────────

  Future<void> upsertHouseholdAsset(Map<String, dynamic> record) async {
    if (kIsWeb) return;
    _assertAvailable('upsertHouseholdAsset');
    await db.LocalDatabaseImpl.instance.upsertHouseholdAsset(record);
  }

  Future<List<Map<String, dynamic>>> getHouseholdAssets({
    required String surveyId,
    required String householdId,
  }) async {
    if (!isAvailable) return [];
    return db.LocalDatabaseImpl.instance.getHouseholdAssets(
      surveyId: surveyId,
      householdId: householdId,
    );
  }

  // ── Livestock ─────────────────────────────────────────────────────────────

  Future<void> upsertLivestock(Map<String, dynamic> record) async {
    if (kIsWeb) return;
    _assertAvailable('upsertLivestock');
    await db.LocalDatabaseImpl.instance.upsertLivestock(record);
  }

  Future<List<Map<String, dynamic>>> getLivestock({
    required String surveyId,
    required String householdId,
  }) async {
    if (!isAvailable) return [];
    return db.LocalDatabaseImpl.instance.getLivestock(
      surveyId: surveyId,
      householdId: householdId,
    );
  }

  // ── Cropping Pattern ──────────────────────────────────────────────────────

  Future<void> upsertCroppingPattern(Map<String, dynamic> record) async {
    if (kIsWeb) return;
    _assertAvailable('upsertCroppingPattern');
    await db.LocalDatabaseImpl.instance.upsertCroppingPattern(record);
  }

  Future<List<Map<String, dynamic>>> getCroppingPatterns({
    required String surveyId,
    required String householdId,
  }) async {
    if (!isAvailable) return [];
    return db.LocalDatabaseImpl.instance.getCroppingPatterns(
      surveyId: surveyId,
      householdId: householdId,
    );
  }

  // ── Crops (Crop Details) ──────────────────────────────────────────────────

  Future<void> upsertCrop(Map<String, dynamic> record) async {
    if (kIsWeb) return;
    _assertAvailable('upsertCrop');
    await db.LocalDatabaseImpl.instance.upsertCrop(record);
  }

  Future<List<Map<String, dynamic>>> getCrops({
    required String surveyId,
    required String householdId,
  }) async {
    if (!isAvailable) return [];
    return db.LocalDatabaseImpl.instance.getCrops(
      surveyId: surveyId,
      householdId: householdId,
    );
  }

  // ── Pests & Diseases ──────────────────────────────────────────────────────

  Future<void> upsertPestDisease(Map<String, dynamic> record) async {
    if (kIsWeb) return;
    _assertAvailable('upsertPestDisease');
    await db.LocalDatabaseImpl.instance.upsertPestDisease(record);
  }

  Future<List<Map<String, dynamic>>> getPestsDiseases({
    required String surveyId,
    required String householdId,
  }) async {
    if (!isAvailable) return [];
    return db.LocalDatabaseImpl.instance.getPestsDiseases(
      surveyId: surveyId,
      householdId: householdId,
    );
  }

  Future<void> deletePestDisease(String id) async {
    if (kIsWeb) return;
    _assertAvailable('deletePestDisease');
    await db.LocalDatabaseImpl.instance.deletePestDisease(id);
  }

  Future<void> queuePestDiseaseDeletion({
    required String surveyId,
    required String householdId,
    required String recordId,
  }) async {
    if (kIsWeb) return;
    _assertAvailable('queuePestDiseaseDeletion');
    await db.LocalDatabaseImpl.instance.queuePestDiseaseDeletion(
      surveyId: surveyId,
      householdId: householdId,
      recordId: recordId,
    );
  }


  // ── Employment Seasonality ────────────────────────────────────────────────

  Future<void> upsertEmploymentSeasonality(Map<String, dynamic> record) async {
    if (kIsWeb) return;
    _assertAvailable('upsertEmploymentSeasonality');
    await db.LocalDatabaseImpl.instance.upsertEmploymentSeasonality(record);
  }

  Future<List<Map<String, dynamic>>> getEmploymentSeasonality({
    required String surveyId,
    required String householdId,
  }) async {
    if (!isAvailable) return [];
    return db.LocalDatabaseImpl.instance.getEmploymentSeasonality(
      surveyId: surveyId,
      householdId: householdId,
    );
  }

  // ── Questionnaire Cache ───────────────────────────────────────────────────

  Future<void> saveQuestionnaireCache({
    required String cacheKey,
    required String configJson,
  }) async {
    if (kIsWeb) return;
    _assertAvailable('saveQuestionnaireCache');
    await db.LocalDatabaseImpl.instance.saveQuestionnaireCache(
      cacheKey: cacheKey,
      configJson: configJson,
    );
  }

  Future<Map<String, dynamic>?> getQuestionnaireCache(String cacheKey) async {
    if (!isAvailable) return null;
    return db.LocalDatabaseImpl.instance.getQuestionnaireCache(cacheKey);
  }

  // ── Sync Queue ────────────────────────────────────────────────────────────

  Future<int> enqueueSyncOperation({
    required String operationId,
    required String targetTable,
    required String operationType,
    required String surveyId,
    required String householdId,
    String? recordId,
    String? conflictKey,
    required String payloadJson,
  }) async {
    if (kIsWeb) return -1;
    _assertAvailable('enqueueSyncOperation');
    return db.LocalDatabaseImpl.instance.enqueueSyncOperation(
      operationId: operationId,
      targetTable: targetTable,
      operationType: operationType,
      surveyId: surveyId,
      householdId: householdId,
      recordId: recordId,
      conflictKey: conflictKey,
      payloadJson: payloadJson,
    );
  }

  Future<List<Map<String, dynamic>>> getPendingSyncOperations() async {
    if (!isAvailable) return [];
    return db.LocalDatabaseImpl.instance.getPendingSyncOperations();
  }

  Future<void> markSyncOperationComplete(String operationId) async {
    if (!isAvailable) return;
    await db.LocalDatabaseImpl.instance.markSyncOperationComplete(operationId);
  }

  Future<void> markSyncOperationFailed({
    required String operationId,
    required String errorMessage,
  }) async {
    if (!isAvailable) return;
    await db.LocalDatabaseImpl.instance.markSyncOperationFailed(
      operationId: operationId,
      errorMessage: errorMessage,
    );
  }

  
  /// Updates the payload of a pending sync operation.
  ///
  /// Synced and failed operations remain unchanged.
  Future<int> updatePendingSyncPayload({
    required String operationId,
    required String payloadJson,
  }) async {
    if (kIsWeb) return 0;
    if (!isAvailable) return 0;

    return db.LocalDatabaseImpl.instance.updatePendingSyncPayload(
      operationId: operationId,
      payloadJson: payloadJson,
    );
  }
}
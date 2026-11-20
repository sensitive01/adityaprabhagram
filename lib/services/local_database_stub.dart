// lib/services/local_database_stub.dart
//
// Web stub for LocalDatabaseImpl.
// On web, sqflite is not available. This stub satisfies the import so the app
// compiles and runs on web using the existing Supabase-only path.

class LocalDatabaseImpl {
  static final LocalDatabaseImpl instance = LocalDatabaseImpl._();
  LocalDatabaseImpl._();

  static const int kDbVersion = 1;

  Future<void> open() async {}
  Future<void> close() async {}

  Future<void> upsertSurvey({
    required String surveyId,
    required String householdId,
    required String agentId,
    required String status,
    required String responsesJson,
    String? submittedAt,
  }) async {}

  Future<Map<String, dynamic>?> getSurvey(String surveyId) async => null;
  Future<List<Map<String, dynamic>>> getSurveysForHousehold(
    String householdId,
  ) async => [];
Future<List<Map<String, dynamic>>> getSurveysForAgent(
  String agentId,
) async => [];

  Future<void> upsertHouseholdAsset(Map<String, dynamic> record) async {}
  Future<List<Map<String, dynamic>>> getHouseholdAssets({
    required String surveyId,
    required String householdId,
  }) async => [];

  Future<void> upsertLivestock(Map<String, dynamic> record) async {}
  Future<List<Map<String, dynamic>>> getLivestock({
    required String surveyId,
    required String householdId,
  }) async => [];

  Future<void> upsertCroppingPattern(Map<String, dynamic> record) async {}
  Future<List<Map<String, dynamic>>> getCroppingPatterns({
    required String surveyId,
    required String householdId,
  }) async => [];

  Future<void> upsertCrop(Map<String, dynamic> record) async {}
  Future<List<Map<String, dynamic>>> getCrops({
    required String surveyId,
    required String householdId,
  }) async => [];

  Future<void> upsertPestDisease(Map<String, dynamic> record) async {}
  Future<List<Map<String, dynamic>>> getPestsDiseases({
    required String surveyId,
    required String householdId,
  }) async => [];

  Future<void> deletePestDisease(String id) async {}

  Future<void> queuePestDiseaseDeletion({
    required String surveyId,
    required String householdId,
    required String recordId,
  }) async {}

  Future<void> upsertEmploymentSeasonality(Map<String, dynamic> record) async {}
  Future<List<Map<String, dynamic>>> getEmploymentSeasonality({
    required String surveyId,
    required String householdId,
  }) async => [];

  Future<void> saveQuestionnaireCache({
    required String cacheKey,
    required String configJson,
  }) async {}
  Future<Map<String, dynamic>?> getQuestionnaireCache(String cacheKey) async =>
      null;

  Future<int> enqueueSyncOperation({
    required String operationId,
    required String targetTable,
    required String operationType,
    required String surveyId,
    required String householdId,
    String? recordId,
    String? conflictKey,
    required String payloadJson,
  }) async => -1;

  Future<List<Map<String, dynamic>>> getPendingSyncOperations() async => [];
Future<int> updatePendingSyncPayload({
  required String operationId,
  required String payloadJson,
}) async => 0;
  Future<void> markSyncOperationComplete(String operationId) async {}
  Future<void> markSyncOperationFailed({
    required String operationId,
    required String errorMessage,
  }) async {}
}

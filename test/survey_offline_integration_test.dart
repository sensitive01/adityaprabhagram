// test/survey_offline_integration_test.dart
//
// Phase 2 — Offline Integration Tests
//
// Tests cover:
//   1. Questionnaire cache: save and load
//   2. Draft persistence: upsertSurvey and getSurvey
//   3. Specialized sections: dual-write to local tables
//   4. Sync queue: idempotent enqueue, complete, fail
//   5. Duplicate prevention: same operation_id → single row
//   6. Stable Survey Identity (Phase 2 regression)
//   7. Stale Sync Queue Payload (Phase 2 regression)
//   8. Phase 2 targeted fixes (Fixes 1–6)

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:fieldops/services/local_database_impl.dart';

// ── Test helpers ──────────────────────────────────────────────────────────────

/// Opens a fresh in-memory database for each test.
Future<LocalDatabaseImpl> _freshDb() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  final impl = LocalDatabaseImpl.createForTesting();
  await impl.openInMemory();
  return impl;
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  // ── 1. Questionnaire Cache ─────────────────────────────────────────────────
  group('Questionnaire Cache', () {
    test('saves and retrieves a questionnaire cache entry', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      const cacheKey = 'template-uuid-001';
      final payload = jsonEncode({
        'templateId': cacheKey,
        'sections': [
          {'id': 's1', 'title': 'Section A', 'code': 'A', 'displayOrder': 1},
        ],
        'questions': [
          {
            'id': 'q1',
            'sectionId': 's1',
            'sectionTitle': 'Section A',
            'questionText': 'What is your name?',
            'type': 'text',
            'isRequired': false,
          },
        ],
      });

      await db.saveQuestionnaireCache(cacheKey: cacheKey, configJson: payload);

      final row = await db.getQuestionnaireCache(cacheKey);
      expect(row, isNotNull);
      expect(row!['cache_key'], equals(cacheKey));
      expect(row['config_json'], equals(payload));
    });

    test('overwrites existing cache entry (upsert semantics)', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      const cacheKey = 'template-uuid-002';
      await db.saveQuestionnaireCache(
        cacheKey: cacheKey,
        configJson: '{"version": 1}',
      );
      await db.saveQuestionnaireCache(
        cacheKey: cacheKey,
        configJson: '{"version": 2}',
      );

      final row = await db.getQuestionnaireCache(cacheKey);
      expect(row, isNotNull);
      final decoded = jsonDecode(row!['config_json'] as String);
      expect(decoded['version'], equals(2));
    });

    test('returns null for missing cache key', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      final row = await db.getQuestionnaireCache('nonexistent-key');
      expect(row, isNull);
    });

    test('saves under latest key for offline lookup', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      const payload = '{"templateId": "t1", "sections": [], "questions": []}';
      await db.saveQuestionnaireCache(cacheKey: 'latest', configJson: payload);

      final row = await db.getQuestionnaireCache('latest');
      expect(row, isNotNull);
      expect(row!['config_json'], equals(payload));
    });
  });

  // ── 2. Draft Persistence ───────────────────────────────────────────────────
  group('Draft Persistence', () {
    test('upsertSurvey saves and getSurvey retrieves the record', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      const surveyId = 'survey-offline-001';
      const householdId = 'hh-001';
      const agentId = 'agent-001';
      final answers = {'q1': 'answer1', 'q2': 42};
      final responsesJson = jsonEncode(answers);

      await db.upsertSurvey(
        surveyId: surveyId,
        householdId: householdId,
        agentId: agentId,
        status: 'draft',
        responsesJson: responsesJson,
      );

      final row = await db.getSurvey(surveyId);
      expect(row, isNotNull);
      expect(row!['survey_id'], equals(surveyId));
      expect(row['household_id'], equals(householdId));
      expect(row['status'], equals('draft'));

      final decoded = jsonDecode(row['responses_json'] as String);
      expect(decoded['q1'], equals('answer1'));
      expect(decoded['q2'], equals(42));
    });

    test('upsertSurvey updates existing record (replace semantics)', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      const surveyId = 'survey-offline-002';
      await db.upsertSurvey(
        surveyId: surveyId,
        householdId: 'hh-002',
        agentId: 'agent-001',
        status: 'draft',
        responsesJson: '{"q1": "v1"}',
      );
      await db.upsertSurvey(
        surveyId: surveyId,
        householdId: 'hh-002',
        agentId: 'agent-001',
        status: 'draft',
        responsesJson: '{"q1": "v2", "q2": "new"}',
      );

      final rows = await db.getSurveysForHousehold('hh-002');
      expect(
        rows.length,
        equals(1),
        reason: 'Upsert must not create duplicates',
      );
      final decoded = jsonDecode(rows.first['responses_json'] as String);
      expect(decoded['q1'], equals('v2'));
      expect(decoded['q2'], equals('new'));
    });

    test(
      'getSurveysForHousehold returns only surveys for the given household',
      () async {
        final db = await _freshDb();
        addTearDown(db.close);

        await db.upsertSurvey(
          surveyId: 'sv-hh-a-1',
          householdId: 'hh-a',
          agentId: 'agent-001',
          status: 'draft',
          responsesJson: '{}',
        );
        await db.upsertSurvey(
          surveyId: 'sv-hh-a-2',
          householdId: 'hh-a',
          agentId: 'agent-001',
          status: 'submitted',
          responsesJson: '{}',
        );
        await db.upsertSurvey(
          surveyId: 'sv-hh-b-1',
          householdId: 'hh-b',
          agentId: 'agent-001',
          status: 'draft',
          responsesJson: '{}',
        );

        final hhA = await db.getSurveysForHousehold('hh-a');
        expect(hhA.length, equals(2));
        expect(hhA.every((r) => r['household_id'] == 'hh-a'), isTrue);

        final hhB = await db.getSurveysForHousehold('hh-b');
        expect(hhB.length, equals(1));
      },
    );

    test('draft answers survive close and reopen (persistence)', () async {
      // This test uses a named temp file to verify on-disk persistence.
      // It does NOT use openInMemory — it uses openNamed with a temp path.
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      final dbPath = await databaseFactoryFfi.getDatabasesPath();
      final tempPath =
          '$dbPath/apg_test_offline_${DateTime.now().microsecondsSinceEpoch}.db';

      final db1 = LocalDatabaseImpl.createForTesting();
      await db1.openNamed(tempPath);

      const surveyId = 'sv-persist-001';
      await db1.upsertSurvey(
        surveyId: surveyId,
        householdId: 'hh-persist',
        agentId: 'agent-001',
        status: 'draft',
        responsesJson: '{"q1": "persisted_value"}',
      );
      await db1.close();

      // Reopen the same file with a fresh instance
      final db2 = LocalDatabaseImpl.createForTesting();
      await db2.openNamed(tempPath);

      addTearDown(() async {
        await db2.close();
        try {
          await databaseFactoryFfi.deleteDatabase(tempPath);
        } catch (_) {}
      });

      final row = await db2.getSurvey(surveyId);
      expect(row, isNotNull);
      final decoded = jsonDecode(row!['responses_json'] as String);
      expect(decoded['q1'], equals('persisted_value'));
    });
  });

  // ── 3. Specialized Sections ────────────────────────────────────────────────
  group('Specialized Sections — local dual-write', () {
    test('upsertHouseholdAsset saves and retrieves asset record', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      const surveyId = 'sv-asset-001';
      // Must insert local_surveys row first (FK constraint)
      await db.upsertSurvey(
        surveyId: surveyId,
        householdId: 'hh-asset',
        agentId: 'agent-001',
        status: 'draft',
        responsesJson: '{}',
      );

      await db.upsertHouseholdAsset({
        'id': 'asset-row-001',
        'survey_id': surveyId,
        'household_id': 'hh-asset',
        'asset_type': 'Tractor',
        'asset_data_json': jsonEncode({
          'ownership_status': 'Yes',
          'quantity': 1,
        }),
        'created_at': DateTime.now().toIso8601String(),
      });

      final rows = await db.getHouseholdAssets(
        surveyId: surveyId,
        householdId: 'hh-asset',
      );
      expect(rows.length, equals(1));
      expect(rows.first['asset_type'], equals('Tractor'));
    });

    test('upsertLivestock saves and retrieves livestock record', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      const surveyId = 'sv-livestock-001';
      await db.upsertSurvey(
        surveyId: surveyId,
        householdId: 'hh-livestock',
        agentId: 'agent-001',
        status: 'draft',
        responsesJson: '{}',
      );

      await db.upsertLivestock({
        'id': 'livestock-row-001',
        'survey_id': surveyId,
        'household_id': 'hh-livestock',
        'animal_type': 'Yak',
        'livestock_data_json': jsonEncode({'count': 3}),
        'created_at': DateTime.now().toIso8601String(),
      });

      final rows = await db.getLivestock(
        surveyId: surveyId,
        householdId: 'hh-livestock',
      );
      expect(rows.length, equals(1));
      expect(rows.first['animal_type'], equals('Yak'));
    });

    test('upsertCroppingPattern saves and retrieves pattern record', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      const surveyId = 'sv-crop-001';
      await db.upsertSurvey(
        surveyId: surveyId,
        householdId: 'hh-crop',
        agentId: 'agent-001',
        status: 'draft',
        responsesJson: '{}',
      );

      await db.upsertCroppingPattern({
        'id': 'cp-row-001',
        'survey_id': surveyId,
        'household_id': 'hh-crop',
        'category': 'Agriculture',
        'pattern_data_json': jsonEncode({'kharif': 'Rice', 'rabi': 'Wheat'}),
        'created_at': DateTime.now().toIso8601String(),
      });

      final rows = await db.getCroppingPatterns(
        surveyId: surveyId,
        householdId: 'hh-crop',
      );
      expect(rows.length, equals(1));
      expect(rows.first['category'], equals('Agriculture'));
    });

    test('upsertCrop saves and retrieves crop detail record', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      const surveyId = 'sv-cropdet-001';
      await db.upsertSurvey(
        surveyId: surveyId,
        householdId: 'hh-cropdet',
        agentId: 'agent-001',
        status: 'draft',
        responsesJson: '{}',
      );

      await db.upsertCrop({
        'id': 'crop-row-001',
        'survey_id': surveyId,
        'household_id': 'hh-cropdet',
        'category': 'Vegetable',
        'crop_rank': 1,
        'crop_data_json': jsonEncode({
          'crop_name': 'Tomato',
          'area_acres': '2.5',
        }),
        'created_at': DateTime.now().toIso8601String(),
      });

      final rows = await db.getCrops(
        surveyId: surveyId,
        householdId: 'hh-cropdet',
      );
      expect(rows.length, equals(1));
      expect(rows.first['category'], equals('Vegetable'));
      expect(rows.first['crop_rank'], equals(1));
    });

    test('upsertPestDisease saves and retrieves pest record', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      const surveyId = 'sv-pest-001';
      await db.upsertSurvey(
        surveyId: surveyId,
        householdId: 'hh-pest',
        agentId: 'agent-001',
        status: 'draft',
        responsesJson: '{}',
      );

      await db.upsertPestDisease({
        'id': 'pest-row-001',
        'survey_id': surveyId,
        'household_id': 'hh-pest',
        'incident_type': 'pest',
        'pest_data_json': jsonEncode({
          'crop_name': 'Rice',
          'pest_name': 'Aphid',
        }),
        'created_at': DateTime.now().toIso8601String(),
      });

      final rows = await db.getPestsDiseases(
        surveyId: surveyId,
        householdId: 'hh-pest',
      );
      expect(rows.length, equals(1));
      expect(rows.first['incident_type'], equals('pest'));
    });

    test(
      'upsertEmploymentSeasonality saves and retrieves seasonality record',
      () async {
        final db = await _freshDb();
        addTearDown(db.close);

        const surveyId = 'sv-season-001';
        await db.upsertSurvey(
          surveyId: surveyId,
          householdId: 'hh-season',
          agentId: 'agent-001',
          status: 'draft',
          responsesJson: '{}',
        );

        await db.upsertEmploymentSeasonality({
          'id': 'season-row-001',
          'survey_id': surveyId,
          'household_id': 'hh-season',
          'activity': 'Agriculture',
          'seasonality_data_json': jsonEncode({'jan_available': true}),
          'created_at': DateTime.now().toIso8601String(),
        });

        final rows = await db.getEmploymentSeasonality(
          surveyId: surveyId,
          householdId: 'hh-season',
        );
        expect(rows.length, equals(1));
        expect(rows.first['activity'], equals('Agriculture'));
      },
    );
  });

  // ── 4. Sync Queue ──────────────────────────────────────────────────────────
  group('Sync Queue', () {
    test('enqueueSyncOperation adds a pending operation', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      await db.enqueueSyncOperation(
        operationId: 'op-001',
        targetTable: 'surveys',
        operationType: 'upsert',
        surveyId: 'sv-001',
        householdId: 'hh-001',
        payloadJson: '{"id": "sv-001"}',
      );

      final pending = await db.getPendingSyncOperations();
      expect(pending.length, equals(1));
      expect(pending.first['operation_id'], equals('op-001'));
      expect(pending.first['sync_state'], equals('pending'));
    });

    test(
      'enqueue is idempotent — same operation_id produces single row',
      () async {
        final db = await _freshDb();
        addTearDown(db.close);

        await db.enqueueSyncOperation(
          operationId: 'op-idem-001',
          targetTable: 'surveys',
          operationType: 'upsert',
          surveyId: 'sv-001',
          householdId: 'hh-001',
          payloadJson: '{"id": "sv-001"}',
        );
        // Re-enqueue same operation_id — must be ignored
        await db.enqueueSyncOperation(
          operationId: 'op-idem-001',
          targetTable: 'surveys',
          operationType: 'upsert',
          surveyId: 'sv-001',
          householdId: 'hh-001',
          payloadJson: '{"id": "sv-001", "updated": true}',
        );

        final pending = await db.getPendingSyncOperations();
        expect(
          pending.where((r) => r['operation_id'] == 'op-idem-001').length,
          equals(1),
          reason: 'Duplicate operation_id must be ignored',
        );
      },
    );

    test('markSyncOperationComplete removes from pending list', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      await db.enqueueSyncOperation(
        operationId: 'op-complete-001',
        targetTable: 'surveys',
        operationType: 'upsert',
        surveyId: 'sv-001',
        householdId: 'hh-001',
        payloadJson: '{}',
      );

      await db.markSyncOperationComplete('op-complete-001');

      final pending = await db.getPendingSyncOperations();
      expect(
        pending.any((r) => r['operation_id'] == 'op-complete-001'),
        isFalse,
        reason: 'Completed operations must not appear in pending list',
      );
    });

    test(
      'markSyncOperationFailed increments retry_count and keeps in pending',
      () async {
        final db = await _freshDb();
        addTearDown(db.close);

        await db.enqueueSyncOperation(
          operationId: 'op-fail-001',
          targetTable: 'surveys',
          operationType: 'upsert',
          surveyId: 'sv-001',
          householdId: 'hh-001',
          payloadJson: '{}',
        );

        await db.markSyncOperationFailed(
          operationId: 'op-fail-001',
          errorMessage: 'Network timeout',
        );

        final pending = await db.getPendingSyncOperations();
        final op = pending.firstWhere(
          (r) => r['operation_id'] == 'op-fail-001',
        );
        expect(op['sync_state'], equals('failed'));
        expect(op['retry_count'], equals(1));
        expect(op['last_error'], equals('Network timeout'));

        // Second failure increments again
        await db.markSyncOperationFailed(
          operationId: 'op-fail-001',
          errorMessage: 'Still failing',
        );
        final pending2 = await db.getPendingSyncOperations();
        final op2 = pending2.firstWhere(
          (r) => r['operation_id'] == 'op-fail-001',
        );
        expect(op2['retry_count'], equals(2));
      },
    );

    test(
      'multiple operations for different surveys are all returned',
      () async {
        final db = await _freshDb();
        addTearDown(db.close);

        for (int i = 1; i <= 5; i++) {
          await db.enqueueSyncOperation(
            operationId: 'op-multi-$i',
            targetTable: 'surveys',
            operationType: 'upsert',
            surveyId: 'sv-$i',
            householdId: 'hh-$i',
            payloadJson: '{"id": "sv-$i"}',
          );
        }

        final pending = await db.getPendingSyncOperations();
        expect(pending.length, equals(5));
      },
    );
  });

  // ── 5. FK Constraint — specialized records require local_surveys row ───────
  group('FK Constraint', () {
    test(
      'inserting asset without local_surveys row throws FK violation',
      () async {
        final db = await _freshDb();
        addTearDown(db.close);

        // Do NOT insert a local_surveys row first
        expect(
          () => db.upsertHouseholdAsset({
            'id': 'asset-fk-001',
            'survey_id': 'nonexistent-survey',
            'household_id': 'hh-fk',
            'asset_type': 'Tractor',
            'asset_data_json': '{}',
            'created_at': DateTime.now().toIso8601String(),
          }),
          throwsA(anything),
          reason: 'FK constraint must prevent orphaned asset records',
        );
      },
    );
  });

  // ── 6. Stable Survey Identity (Phase 2 regression) ────────────────────────
  group('Stable Survey Identity', () {
    test(
      'survey_id is preserved across repeated offline saves (no new row)',
      () async {
        final db = await _freshDb();
        addTearDown(db.close);

        // Simulate a UUID v4 offline survey ID (no offline_ prefix)
        const surveyId = '550e8400-e29b-41d4-a716-446655440000';
        const householdId = 'hh-stable-001';

        // First save
        await db.upsertSurvey(
          surveyId: surveyId,
          householdId: householdId,
          agentId: 'agent-001',
          status: 'draft',
          responsesJson: '{"q1": "first"}',
        );

        // Second save — same surveyId, updated answers
        await db.upsertSurvey(
          surveyId: surveyId,
          householdId: householdId,
          agentId: 'agent-001',
          status: 'draft',
          responsesJson: '{"q1": "second", "q2": "new"}',
        );

        // Third save
        await db.upsertSurvey(
          surveyId: surveyId,
          householdId: householdId,
          agentId: 'agent-001',
          status: 'draft',
          responsesJson: '{"q1": "third", "q2": "new", "q3": "added"}',
        );

        final rows = await db.getSurveysForHousehold(householdId);
        expect(
          rows.length,
          equals(1),
          reason: 'Repeated saves must not create duplicate survey rows',
        );
        expect(rows.first['survey_id'], equals(surveyId));
        final decoded = jsonDecode(rows.first['responses_json'] as String);
        expect(decoded['q1'], equals('third'));
        expect(decoded['q3'], equals('added'));
      },
    );

    test(
      'specialized records reference the correct survey_id after repeated saves',
      () async {
        final db = await _freshDb();
        addTearDown(db.close);

        const surveyId = '550e8400-e29b-41d4-a716-446655440001';
        const householdId = 'hh-stable-002';

        // Insert survey row first (FK requirement)
        await db.upsertSurvey(
          surveyId: surveyId,
          householdId: householdId,
          agentId: 'agent-001',
          status: 'draft',
          responsesJson: '{}',
        );

        // Insert specialized records referencing the same surveyId
        await db.upsertHouseholdAsset({
          'id': 'asset-stable-001',
          'survey_id': surveyId,
          'household_id': householdId,
          'asset_type': 'Tractor',
          'asset_data_json': '{"quantity": 1}',
          'created_at': DateTime.now().toIso8601String(),
        });
        await db.upsertLivestock({
          'id': 'livestock-stable-001',
          'survey_id': surveyId,
          'household_id': householdId,
          'animal_type': 'Cow',
          'livestock_data_json': '{"count": 2}',
          'created_at': DateTime.now().toIso8601String(),
        });

        // Repeated survey save must not break FK references
        await db.upsertSurvey(
          surveyId: surveyId,
          householdId: householdId,
          agentId: 'agent-001',
          status: 'draft',
          responsesJson: '{"q1": "updated"}',
        );

        final assets = await db.getHouseholdAssets(
          surveyId: surveyId,
          householdId: householdId,
        );
        expect(assets.length, equals(1));
        expect(assets.first['survey_id'], equals(surveyId));

        final livestock = await db.getLivestock(
          surveyId: surveyId,
          householdId: householdId,
        );
        expect(livestock.length, equals(1));
        expect(livestock.first['survey_id'], equals(surveyId));
      },
    );

    test(
      'offline survey ID is a valid UUID format (no offline_ prefix)',
      () async {
        // Verify that the UUID v4 format used by the fixed code is accepted
        // as a valid TEXT primary key and does not violate any schema constraint.
        final db = await _freshDb();
        addTearDown(db.close);

        // UUID v4 format (what const Uuid().v4() produces)
        const uuidV4 = 'f47ac10b-58cc-4372-a567-0e02b2c3d479';

        await db.upsertSurvey(
          surveyId: uuidV4,
          householdId: 'hh-uuid-test',
          agentId: 'agent-001',
          status: 'draft',
          responsesJson: '{}',
        );

        final row = await db.getSurvey(uuidV4);
        expect(row, isNotNull);
        expect(row!['survey_id'], equals(uuidV4));
      },
    );
  });

  // ── 7. Stale Sync Queue Payload (Phase 2 regression) ──────────────────────
  group('Stale Sync Queue Payload', () {
    test(
      'updatePendingSyncPayload refreshes payload of a pending operation',
      () async {
        final db = await _freshDb();
        addTearDown(db.close);

        const operationId = 'survey_sv-stale-001_draft';

        // Initial enqueue
        await db.enqueueSyncOperation(
          operationId: operationId,
          targetTable: 'surveys',
          operationType: 'upsert',
          surveyId: 'sv-stale-001',
          householdId: 'hh-stale',
          payloadJson: '{"responses": {"q1": "first"}}',
        );

        // Simulate repeated save: enqueue is ignored (ConflictAlgorithm.ignore),
        // then updatePendingSyncPayload refreshes the payload.
        await db.enqueueSyncOperation(
          operationId: operationId,
          targetTable: 'surveys',
          operationType: 'upsert',
          surveyId: 'sv-stale-001',
          householdId: 'hh-stale',
          payloadJson: '{"responses": {"q1": "second"}}',
        );
        await db.updatePendingSyncPayload(
          operationId: operationId,
          payloadJson: '{"responses": {"q1": "second"}}',
        );

        final pending = await db.getPendingSyncOperations();
        final op = pending.firstWhere((r) => r['operation_id'] == operationId);
        final decoded = jsonDecode(op['payload_json'] as String);
        expect(
          decoded['responses']['q1'],
          equals('second'),
          reason: 'Payload must reflect the latest save, not the first one',
        );
      },
    );

    test(
      'repeated saves produce exactly one queue entry with latest payload',
      () async {
        final db = await _freshDb();
        addTearDown(db.close);

        const operationId = 'survey_sv-repeat-001_draft';

        // Simulate 5 repeated saves
        for (int i = 1; i <= 5; i++) {
          final payload = jsonEncode({
            'responses': {'q1': 'save_$i'},
          });
          await db.enqueueSyncOperation(
            operationId: operationId,
            targetTable: 'surveys',
            operationType: 'upsert',
            surveyId: 'sv-repeat-001',
            householdId: 'hh-repeat',
            payloadJson: payload,
          );
          await db.updatePendingSyncPayload(
            operationId: operationId,
            payloadJson: payload,
          );
        }

        final pending = await db.getPendingSyncOperations();
        final matching = pending
            .where((r) => r['operation_id'] == operationId)
            .toList();

        expect(
          matching.length,
          equals(1),
          reason: 'Repeated saves must not create duplicate queue entries',
        );

        final decoded = jsonDecode(matching.first['payload_json'] as String);
        expect(
          decoded['responses']['q1'],
          equals('save_5'),
          reason: 'Queue must hold the payload from the last save',
        );
      },
    );

    test(
      'updatePendingSyncPayload does not touch a completed operation',
      () async {
        final db = await _freshDb();
        addTearDown(db.close);

        const operationId = 'survey_sv-done-001_draft';

        await db.enqueueSyncOperation(
          operationId: operationId,
          targetTable: 'surveys',
          operationType: 'upsert',
          surveyId: 'sv-done-001',
          householdId: 'hh-done',
          payloadJson: '{"responses": {"q1": "original"}}',
        );

        // Mark as synced
        await db.markSyncOperationComplete(operationId);

        // Attempt to update payload — must be a no-op
        final updated = await db.updatePendingSyncPayload(
          operationId: operationId,
          payloadJson: '{"responses": {"q1": "should_not_update"}}',
        );

        expect(
          updated,
          equals(0),
          reason: 'Completed operations must not have their payload changed',
        );

        // Verify the synced operation is not in the pending list
        final pending = await db.getPendingSyncOperations();
        expect(pending.any((r) => r['operation_id'] == operationId), isFalse);
      },
    );

    test(
      'updatePendingSyncPayload does not touch a failed operation',
      () async {
        final db = await _freshDb();
        addTearDown(db.close);

        const operationId = 'survey_sv-fail-001_draft';

        await db.enqueueSyncOperation(
          operationId: operationId,
          targetTable: 'surveys',
          operationType: 'upsert',
          surveyId: 'sv-fail-001',
          householdId: 'hh-fail',
          payloadJson: '{"responses": {"q1": "original"}}',
        );

        // Mark as failed
        await db.markSyncOperationFailed(
          operationId: operationId,
          errorMessage: 'Network error',
        );

        // Attempt to update payload — must be a no-op (failed ops retain
        // their payload for retry)
        final updated = await db.updatePendingSyncPayload(
          operationId: operationId,
          payloadJson: '{"responses": {"q1": "should_not_update"}}',
        );

        expect(
          updated,
          equals(0),
          reason:
              'Failed operations must retain their original payload for retry',
        );

        // Verify retry_count is preserved
        final pending = await db.getPendingSyncOperations();
        final op = pending.firstWhere((r) => r['operation_id'] == operationId);
        expect(op['retry_count'], equals(1));
        final decoded = jsonDecode(op['payload_json'] as String);
        expect(decoded['responses']['q1'], equals('original'));
      },
    );
  });

  // ── 8. Phase 2 Targeted Fixes Regression Tests ────────────────────────────
  group('Phase 2 Targeted Fixes', () {
    // Fix 1: Valid, stable UUID across repeated offline saves and reopen
    test(
      'Fix 1: UUID v4 offline survey ID is stable across repeated saves',
      () async {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
        final dbPath = await databaseFactoryFfi.getDatabasesPath();
        final tempPath =
            '$dbPath/apg_fix1_${DateTime.now().microsecondsSinceEpoch}.db';

        final db1 = LocalDatabaseImpl.createForTesting();
        await db1.openNamed(tempPath);

        // Simulate what _performLocalDraftSave does: generate UUID once, reuse
        const stableUuid = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';
        for (int i = 1; i <= 3; i++) {
          await db1.upsertSurvey(
            surveyId: stableUuid,
            householdId: 'hh-fix1',
            agentId: 'agent-001',
            status: 'draft',
            responsesJson: jsonEncode({'q1': 'save_$i'}),
          );
        }
        await db1.close();

        // Reopen — same UUID must be found
        final db2 = LocalDatabaseImpl.createForTesting();
        await db2.openNamed(tempPath);
        addTearDown(() async {
          await db2.close();
          try {
            await databaseFactoryFfi.deleteDatabase(tempPath);
          } catch (_) {}
        });

        final rows = await db2.getSurveysForHousehold('hh-fix1');
        expect(
          rows.length,
          equals(1),
          reason: 'Only one row for the stable UUID',
        );
        expect(rows.first['survey_id'], equals(stableUuid));
        final decoded = jsonDecode(rows.first['responses_json'] as String);
        expect(decoded['q1'], equals('save_3'), reason: 'Latest save wins');
      },
    );

    // Fix 2: Latest payload wins for repeated draft and specialized-record edits
    test('Fix 2: latest payload wins for repeated draft edits', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      const opId = 'survey_fix2-sv_draft';

      for (int i = 1; i <= 4; i++) {
        final payload = jsonEncode({
          'responses': {'q1': 'edit_$i'},
        });
        await db.enqueueSyncOperation(
          operationId: opId,
          targetTable: 'surveys',
          operationType: 'upsert',
          surveyId: 'fix2-sv',
          householdId: 'hh-fix2',
          payloadJson: payload,
        );
        await db.updatePendingSyncPayload(
          operationId: opId,
          payloadJson: payload,
        );
      }

      final pending = await db.getPendingSyncOperations();
      final ops = pending.where((r) => r['operation_id'] == opId).toList();
      expect(ops.length, equals(1), reason: 'No duplicate queue entries');
      final decoded = jsonDecode(ops.first['payload_json'] as String);
      expect(decoded['responses']['q1'], equals('edit_4'));
    });

    // Fix 2: An edit after a successful sync is queued again
    test(
      'Fix 2: edit after successful sync creates a new pending operation',
      () async {
        final db = await _freshDb();
        addTearDown(db.close);

        const opId = 'survey_fix2b-sv_draft';

        // First save + sync
        await db.enqueueSyncOperation(
          operationId: opId,
          targetTable: 'surveys',
          operationType: 'upsert',
          surveyId: 'fix2b-sv',
          householdId: 'hh-fix2b',
          payloadJson: '{"responses": {"q1": "v1"}}',
        );
        await db.markSyncOperationComplete(opId);

        // After sync, the operation is 'synced' — updatePendingSyncPayload is a no-op
        final updated = await db.updatePendingSyncPayload(
          operationId: opId,
          payloadJson: '{"responses": {"q1": "v2"}}',
        );
        expect(updated, equals(0), reason: 'Synced op payload must not change');

        // A new edit must use a new operation ID (different from the synced one)
        const newOpId = 'survey_fix2b-sv_draft_2';
        await db.enqueueSyncOperation(
          operationId: newOpId,
          targetTable: 'surveys',
          operationType: 'upsert',
          surveyId: 'fix2b-sv',
          householdId: 'hh-fix2b',
          payloadJson: '{"responses": {"q1": "v2"}}',
        );

        final pending = await db.getPendingSyncOperations();
        expect(
          pending.any((r) => r['operation_id'] == newOpId),
          isTrue,
          reason: 'New edit after sync must be queued as a new operation',
        );
      },
    );

    // Fix 3: Specialized data can be loaded from local storage without Supabase
    test('Fix 3: specialized data loaded from local storage', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      const surveyId = 'fix3-sv-001';
      await db.upsertSurvey(
        surveyId: surveyId,
        householdId: 'hh-fix3',
        agentId: 'agent-001',
        status: 'draft',
        responsesJson: '{}',
      );

      // Write all 6 specialized tables
      await db.upsertHouseholdAsset({
        'id': 'fix3-asset-001',
        'survey_id': surveyId,
        'household_id': 'hh-fix3',
        'asset_type': 'Tractor',
        'asset_data_json': '{"ownership_status": "Yes"}',
        'created_at': DateTime.now().toIso8601String(),
      });
      await db.upsertLivestock({
        'id': 'fix3-ls-001',
        'survey_id': surveyId,
        'household_id': 'hh-fix3',
        'animal_type': 'Cow',
        'livestock_data_json': '{"count": 5}',
        'created_at': DateTime.now().toIso8601String(),
      });
      await db.upsertCroppingPattern({
        'id': 'fix3-cp-001',
        'survey_id': surveyId,
        'household_id': 'hh-fix3',
        'category': 'Agriculture',
        'pattern_data_json': '{"kharif": "Rice"}',
        'created_at': DateTime.now().toIso8601String(),
      });
      await db.upsertCrop({
        'id': 'fix3-crop-001',
        'survey_id': surveyId,
        'household_id': 'hh-fix3',
        'category': 'Vegetable',
        'crop_rank': 1,
        'crop_data_json': '{"crop_name": "Tomato"}',
        'created_at': DateTime.now().toIso8601String(),
      });
      await db.upsertPestDisease({
        'id': 'fix3-pest-001',
        'survey_id': surveyId,
        'household_id': 'hh-fix3',
        'incident_type': 'pest',
        'pest_data_json': '{"crop_name": "Rice"}',
        'created_at': DateTime.now().toIso8601String(),
      });
      await db.upsertEmploymentSeasonality({
        'id': 'fix3-season-001',
        'survey_id': surveyId,
        'household_id': 'hh-fix3',
        'activity': 'Agriculture',
        'seasonality_data_json': '{"jan_available": true}',
        'created_at': DateTime.now().toIso8601String(),
      });

      // Verify all 6 tables can be read back (simulating offline load)
      final assets = await db.getHouseholdAssets(
        surveyId: surveyId,
        householdId: 'hh-fix3',
      );
      expect(assets.length, equals(1));

      final livestock = await db.getLivestock(
        surveyId: surveyId,
        householdId: 'hh-fix3',
      );
      expect(livestock.length, equals(1));

      final patterns = await db.getCroppingPatterns(
        surveyId: surveyId,
        householdId: 'hh-fix3',
      );
      expect(patterns.length, equals(1));

      final crops = await db.getCrops(
        surveyId: surveyId,
        householdId: 'hh-fix3',
      );
      expect(crops.length, equals(1));

      final pests = await db.getPestsDiseases(
        surveyId: surveyId,
        householdId: 'hh-fix3',
      );
      expect(pests.length, equals(1));

      final seasonality = await db.getEmploymentSeasonality(
        surveyId: surveyId,
        householdId: 'hh-fix3',
      );
      expect(seasonality.length, equals(1));
    });

    // Fix 4: A local draft can be discovered and resumed after restart
    test(
      'Fix 4: local draft is discoverable by household_id after restart',
      () async {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
        final dbPath = await databaseFactoryFfi.getDatabasesPath();
        final tempPath =
            '$dbPath/apg_fix4_${DateTime.now().microsecondsSinceEpoch}.db';

        final db1 = LocalDatabaseImpl.createForTesting();
        await db1.openNamed(tempPath);

        const surveyId = 'fix4-sv-001';
        const householdId = 'hh-fix4';
        await db1.upsertSurvey(
          surveyId: surveyId,
          householdId: householdId,
          agentId: 'agent-001',
          status: 'draft',
          responsesJson: '{"q1": "draft_answer"}',
        );
        await db1.close();

        // Simulate app restart: reopen and query by household_id
        final db2 = LocalDatabaseImpl.createForTesting();
        await db2.openNamed(tempPath);
        addTearDown(() async {
          await db2.close();
          try {
            await databaseFactoryFfi.deleteDatabase(tempPath);
          } catch (_) {}
        });

        final drafts = await db2.getSurveysForHousehold(householdId);
        expect(
          drafts.isNotEmpty,
          isTrue,
          reason: 'Draft must be discoverable after restart',
        );
        expect(drafts.first['survey_id'], equals(surveyId));
        final decoded = jsonDecode(drafts.first['responses_json'] as String);
        expect(decoded['q1'], equals('draft_answer'));
      },
    );

    // Fix 5: A remote save failure preserves the draft locally
    test('Fix 5: local draft is preserved when remote save fails', () async {
      final db = await _freshDb();
      addTearDown(db.close);

      // Simulate what the fallback path does: write to local DB and enqueue
      const surveyId = 'fix5-sv-001';
      await db.upsertSurvey(
        surveyId: surveyId,
        householdId: 'hh-fix5',
        agentId: 'agent-001',
        status: 'draft',
        responsesJson: '{"q1": "saved_locally"}',
      );
      await db.enqueueSyncOperation(
        operationId: 'survey_${surveyId}_draft',
        targetTable: 'surveys',
        operationType: 'upsert',
        surveyId: surveyId,
        householdId: 'hh-fix5',
        payloadJson: jsonEncode({
          'id': surveyId,
          'household_id': 'hh-fix5',
          'agent_id': 'agent-001',
          'status': 'draft',
          'responses': {'q1': 'saved_locally'},
        }),
      );

      // Verify local draft exists
      final row = await db.getSurvey(surveyId);
      expect(
        row,
        isNotNull,
        reason: 'Draft must be saved locally after remote failure',
      );
      final decoded = jsonDecode(row!['responses_json'] as String);
      expect(decoded['q1'], equals('saved_locally'));

      // Verify sync operation is queued
      final pending = await db.getPendingSyncOperations();
      expect(
        pending.any((r) => r['survey_id'] == surveyId),
        isTrue,
        reason: 'Sync operation must be queued for later upload',
      );
    });

    // Fix 6: Parent survey failure prevents dependent records from being marked synced
    test(
      'Fix 6: child operations remain pending when parent survey fails',
      () async {
        final db = await _freshDb();
        addTearDown(db.close);

        const surveyId = 'fix6-sv-001';

        // Enqueue parent survey op
        await db.enqueueSyncOperation(
          operationId: 'survey_${surveyId}_draft',
          targetTable: 'surveys',
          operationType: 'upsert',
          surveyId: surveyId,
          householdId: 'hh-fix6',
          payloadJson: jsonEncode({'id': surveyId}),
        );

        // Enqueue child specialized ops
        await db.enqueueSyncOperation(
          operationId: 'asset_${surveyId}_Tractor',
          targetTable: 'household_assets',
          operationType: 'upsert',
          surveyId: surveyId,
          householdId: 'hh-fix6',
          payloadJson: jsonEncode({'id': 'asset-001', 'survey_id': surveyId}),
        );
        await db.enqueueSyncOperation(
          operationId: 'livestock_${surveyId}_Cow',
          targetTable: 'livestock',
          operationType: 'upsert',
          surveyId: surveyId,
          householdId: 'hh-fix6',
          payloadJson: jsonEncode({'id': 'ls-001', 'survey_id': surveyId}),
        );

        // Simulate: parent survey upload fails
        await db.markSyncOperationFailed(
          operationId: 'survey_${surveyId}_draft',
          errorMessage: 'Network error',
        );

        // Children must still be pending (not synced)
        final pending = await db.getPendingSyncOperations();
        final childOps = pending
            .where(
              (r) =>
                  r['survey_id'] == surveyId && r['target_table'] != 'surveys',
            )
            .toList();
        expect(
          childOps.length,
          equals(2),
          reason: 'Child ops must remain pending when parent fails',
        );
        for (final op in childOps) {
          expect(
            op['sync_state'],
            isNot(equals('synced')),
            reason: 'Children must not be marked synced if parent failed',
          );
        }
      },
    );

    // Fix 6: Retrying synchronization does not create duplicate server records
    test(
      'Fix 6: retrying sync does not create duplicate queue entries',
      () async {
        final db = await _freshDb();
        addTearDown(db.close);

        const opId = 'survey_fix6b-sv_draft';

        // Enqueue once
        await db.enqueueSyncOperation(
          operationId: opId,
          targetTable: 'surveys',
          operationType: 'upsert',
          surveyId: 'fix6b-sv',
          householdId: 'hh-fix6b',
          payloadJson: '{"id": "fix6b-sv"}',
        );

        // Fail it (simulating a network error)
        await db.markSyncOperationFailed(
          operationId: opId,
          errorMessage: 'Timeout',
        );

        // Re-enqueue (retry) — must not create a duplicate
        await db.enqueueSyncOperation(
          operationId: opId,
          targetTable: 'surveys',
          operationType: 'upsert',
          surveyId: 'fix6b-sv',
          householdId: 'hh-fix6b',
          payloadJson: '{"id": "fix6b-sv"}',
        );

        final pending = await db.getPendingSyncOperations();
        final matching = pending
            .where((r) => r['operation_id'] == opId)
            .toList();
        expect(
          matching.length,
          equals(1),
          reason: 'Retry must not create a duplicate queue entry',
        );
        // retry_count must be preserved from the failed state
        expect(matching.first['retry_count'], equals(1));
      },
    );
  });
}

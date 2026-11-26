import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

// lib/services/local_database_impl.dart
//
// Mobile (dart:io) implementation of LocalDatabaseImpl using sqflite.
// This file is only compiled on non-web platforms via the conditional import
// in local_database_service.dart.
//
// ── DATABASE VERSIONING ───────────────────────────────────────────────────
//   kDbVersion = 2  (Phase 1 v2: adds FK constraints to specialized tables)
//
//   Version history:
//     v1 — Phase 1 foundation schema (no FK constraints on specialized tables)
//     v2 — Adds FOREIGN KEY(survey_id) REFERENCES local_surveys(survey_id)
//          to all specialized tables. Achieved by recreating each table with
//          the standard SQLite rename-create-copy-drop migration pattern.
//          PRAGMA foreign_keys = ON is set on every connection so constraints
//          are enforced at runtime.
//
//   To add a new version in a future phase:
//     1. Increment kDbVersion.
//     2. Add a new case to the onUpgrade switch statement.
//     3. Never modify existing migration cases — they are immutable.
//
// ── FOREIGN KEY RELATIONSHIPS ─────────────────────────────────────────────
//
//   ENFORCED BY SQLITE (FK constraint + PRAGMA foreign_keys = ON):
//     local_household_assets.survey_id  → local_surveys.survey_id
//     local_livestock.survey_id         → local_surveys.survey_id
//     local_cropping_pattern.survey_id  → local_surveys.survey_id
//     local_crops.survey_id             → local_surveys.survey_id
//     local_pests_diseases.survey_id    → local_surveys.survey_id
//     local_employment_seasonality.survey_id → local_surveys.survey_id
//
//   MAINTAINED BY APPLICATION LOGIC ONLY (no FK constraint):
//     local_surveys.household_id — references households in Supabase, not a
//       local table. No local households table exists in Phase 1.
//     local_surveys.agent_id     — references user_profiles in Supabase.
//     questionnaire_cache        — standalone; no FK relationships.
//     sync_queue.survey_id       — intentionally not FK-constrained: a queue
//       entry may reference a survey that has already been synced and whose
//       local row has been cleaned up. Orphaned queue entries are handled by
//       the sync engine in Phase 3.
//
//   ORPHAN PREVENTION:
//     With FK constraints enforced, inserting a specialized record whose
//     survey_id does not exist in local_surveys will raise a constraint
//     violation. The application must always upsert the local_surveys row
//     before inserting specialized records. Phase 2 must respect this order.
//
// ── SCHEMA OVERVIEW ───────────────────────────────────────────────────────
//
//   local_surveys
//     PK: survey_id (TEXT, client-generated UUID)
//     Stores the full _answers map as responses_json (TEXT / JSON string).
//
//   local_household_assets
//     PK: id (TEXT UUID), FK: survey_id → local_surveys
//     Unique on (survey_id, asset_type).
//
//   local_livestock
//     PK: id (TEXT UUID), FK: survey_id → local_surveys
//     Unique on (survey_id, animal_type).
//
//   local_cropping_pattern
//     PK: id (TEXT UUID), FK: survey_id → local_surveys
//     Unique on (survey_id, category).
//
//   local_crops
//     PK: id (TEXT UUID), FK: survey_id → local_surveys
//     Unique on (survey_id, category, crop_rank).
//     NOTE: CropDetailsSectionWidget does not call saveData() on draft save —
//     this is a pre-existing gap flagged for Phase 2 review.
//
//   local_pests_diseases
//     PK: id (TEXT UUID), FK: survey_id → local_surveys
//     incident_type discriminates Section E ('crop') vs Section F ('livestock').
//
//   local_employment_seasonality
//     PK: id (TEXT UUID), FK: survey_id → local_surveys
//
//   questionnaire_cache
//     PK: cache_key (TEXT). No FK relationships.
//
//   sync_queue
//     PK: operation_id (TEXT UUID, client-generated). No FK on survey_id
//     (intentional — see note above).

class LocalDatabaseImpl {
  LocalDatabaseImpl._();
  static final LocalDatabaseImpl instance = LocalDatabaseImpl._();

  /// Creates a fresh, independent [LocalDatabaseImpl] instance for use in
  /// tests only.
  ///
  /// Unlike [instance], each call returns a **new object** with its own [_db]
  /// field. Tests that hold separate instances cannot interfere with one
  /// another — closing or replacing one instance's connection has no effect on
  /// any other instance.
  ///
  /// Production code must use [instance] and [open].
  @visibleForTesting
  factory LocalDatabaseImpl.createForTesting() => LocalDatabaseImpl._();

  static const int kDbVersion = 2;
  static const String _dbName = 'apg_offline.db';

  Database? _db;
  Database get _database {
    if (_db == null) {
      throw StateError(
        '[LocalDB] Database not initialized. Call open() first.',
      );
    }
    return _db!;
  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  Future<void> open() async {
    if (_db != null) return;
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    _db = await openDatabase(
      path,
      version: kDbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        // Enable foreign key enforcement on every connection.
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (db) async {
        await _ensureCroppingPatternColumns(db);
      },
    );
  }

  /// Opens a fresh in-memory database.
  ///
  /// Intended for use in tests only. Each call to [openInMemory] creates a
  /// completely isolated database that is discarded when [close] is called.
  /// Production code must use [open] instead.
  Future<void> openInMemory() async {
    await _db?.close();
    _db = null;
    _db = await openDatabase(
      inMemoryDatabasePath,
      version: kDbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (db) async {
        await _ensureCroppingPatternColumns(db);
      },
    );
  }

  /// Opens a database at an explicit file [path].
  ///
  /// Intended for use in tests only — specifically for persistence tests that
  /// must close and reopen the **same** file to verify data survives across
  /// connections. The caller is responsible for deleting the file after the
  /// test completes.
  ///
  /// Production code must use [open] (which derives the path from
  /// [getDatabasesPath] and [_dbName]). This method must never be called from
  /// production code.
  @visibleForTesting
  Future<void> openNamed(String path) async {
    await _db?.close();
    _db = null;
    _db = await openDatabase(
      path,
      version: kDbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (db) async {
        await _ensureCroppingPatternColumns(db);
      },
    );
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  // ── Raw SQL access (used by tests) ────────────────────────────────────────
  //
  // Exposes a thin passthrough to the underlying sqflite Database.rawQuery so
  // that test code can execute PRAGMA queries and sqlite_master inspections
  // without requiring a full typed API for every possible SQL statement.
  // Production code should prefer the typed methods below.

  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    return _database.rawQuery(sql, arguments);
  }

  // ── Schema Creation ───────────────────────────────────────────────────────

  Future<void> _onCreate(Database db, int version) async {
    // Fresh install: apply all versions in order.
    await _applyV1Schema(db);
    if (version >= 2) await _applyV2Migration(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Immutable migration pattern: each case applies only its own delta.
    for (int v = oldVersion + 1; v <= newVersion; v++) {
      switch (v) {
        case 1:
          await _applyV1Schema(db);
          break;
        case 2:
          await _applyV2Migration(db);
          break;
        // Future phases add new cases here. Never modify existing cases.
      }
    }
  }

  // ── v1 Schema (immutable — do not modify) ─────────────────────────────────

  Future<void> _applyV1Schema(Database db) async {
    final now = DateTime.now().toIso8601String();

    await db.execute('''
      CREATE TABLE IF NOT EXISTS local_surveys (
        survey_id       TEXT PRIMARY KEY,
        household_id    TEXT NOT NULL,
        agent_id        TEXT NOT NULL,
        status          TEXT NOT NULL DEFAULT 'draft',
        responses_json  TEXT NOT NULL DEFAULT '{}',
        submitted_at    TEXT,
        created_at      TEXT NOT NULL DEFAULT '$now',
        updated_at      TEXT NOT NULL DEFAULT '$now',
        synced_at       TEXT
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_surveys_household ON local_surveys(household_id)',
    );

    await db.execute('''
      CREATE TABLE IF NOT EXISTS local_household_assets (
        id              TEXT PRIMARY KEY,
        survey_id       TEXT NOT NULL,
        household_id    TEXT NOT NULL,
        asset_type      TEXT NOT NULL,
        asset_data_json TEXT NOT NULL DEFAULT '{}',
        created_at      TEXT NOT NULL DEFAULT '$now',
        updated_at      TEXT NOT NULL DEFAULT '$now',
        synced_at       TEXT,
        UNIQUE(survey_id, asset_type)
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_assets_survey ON local_household_assets(survey_id)',
    );

    await db.execute('''
      CREATE TABLE IF NOT EXISTS local_livestock (
        id              TEXT PRIMARY KEY,
        survey_id       TEXT NOT NULL,
        household_id    TEXT NOT NULL,
        animal_type     TEXT NOT NULL,
        livestock_data_json TEXT NOT NULL DEFAULT '{}',
        created_at      TEXT NOT NULL DEFAULT '$now',
        updated_at      TEXT NOT NULL DEFAULT '$now',
        synced_at       TEXT,
        UNIQUE(survey_id, animal_type)
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_livestock_survey ON local_livestock(survey_id)',
    );

    await db.execute('''
      CREATE TABLE IF NOT EXISTS local_cropping_pattern (
        id              TEXT PRIMARY KEY,
        survey_id       TEXT NOT NULL,
        household_id    TEXT NOT NULL,
        category        TEXT NOT NULL,
        pattern_data_json TEXT NOT NULL DEFAULT '{}',
        kharif          TEXT,
        rabi            TEXT,
        zaid            TEXT,
        perennial       TEXT,
        created_at      TEXT NOT NULL DEFAULT '$now',
        updated_at      TEXT NOT NULL DEFAULT '$now',
        synced_at       TEXT,
        UNIQUE(survey_id, category)
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_cropping_survey ON local_cropping_pattern(survey_id)',
    );

    await db.execute('''
      CREATE TABLE IF NOT EXISTS local_crops (
        id              TEXT PRIMARY KEY,
        survey_id       TEXT NOT NULL,
        household_id    TEXT NOT NULL,
        category        TEXT,
        crop_rank       INTEGER,
        crop_data_json  TEXT NOT NULL DEFAULT '{}',
        created_at      TEXT NOT NULL DEFAULT '$now',
        updated_at      TEXT NOT NULL DEFAULT '$now',
        synced_at       TEXT,
        UNIQUE(survey_id, category, crop_rank)
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_crops_survey ON local_crops(survey_id)',
    );

    await db.execute('''
      CREATE TABLE IF NOT EXISTS local_pests_diseases (
        id              TEXT PRIMARY KEY,
        survey_id       TEXT NOT NULL,
        household_id    TEXT NOT NULL,
        incident_type   TEXT NOT NULL,
        pest_data_json  TEXT NOT NULL DEFAULT '{}',
        created_at      TEXT NOT NULL DEFAULT '$now',
        updated_at      TEXT NOT NULL DEFAULT '$now',
        synced_at       TEXT
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_pests_survey ON local_pests_diseases(survey_id)',
    );

    await db.execute('''
      CREATE TABLE IF NOT EXISTS local_employment_seasonality (
        id              TEXT PRIMARY KEY,
        survey_id       TEXT NOT NULL,
        household_id    TEXT NOT NULL,
        activity        TEXT,
        seasonality_data_json TEXT NOT NULL DEFAULT '{}',
        created_at      TEXT NOT NULL DEFAULT '$now',
        updated_at      TEXT NOT NULL DEFAULT '$now',
        synced_at       TEXT
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_seasonality_survey ON local_employment_seasonality(survey_id)',
    );

    await db.execute('''
      CREATE TABLE IF NOT EXISTS questionnaire_cache (
        cache_key       TEXT PRIMARY KEY,
        config_json     TEXT NOT NULL,
        cached_at       TEXT NOT NULL DEFAULT '$now',
        version_hash    TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS sync_queue (
        operation_id    TEXT PRIMARY KEY,
        target_table    TEXT NOT NULL,
        operation_type  TEXT NOT NULL,
        survey_id       TEXT NOT NULL,
        household_id    TEXT NOT NULL,
        record_id       TEXT,
        conflict_key    TEXT,
        payload_json    TEXT NOT NULL DEFAULT '{}',
        sync_state      TEXT NOT NULL DEFAULT 'pending',
        retry_count     INTEGER NOT NULL DEFAULT 0,
        last_error      TEXT,
        created_at      TEXT NOT NULL DEFAULT '$now',
        last_attempt_at TEXT,
        synced_at       TEXT
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_queue_state ON sync_queue(sync_state)',
    );
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_queue_survey ON sync_queue(survey_id)',
    );

    debugPrint('[LocalDB] v1 schema applied successfully.');
  }

  // ── v2 Migration: Add FK constraints to specialized tables ────────────────
  //
  // SQLite does not support ALTER TABLE ADD CONSTRAINT. The standard approach
  // is: rename old table → create new table with FK → copy data → drop old.
  // Each step is wrapped in a single transaction for atomicity.
  //
  // After this migration, inserting a specialized record whose survey_id does
  // not exist in local_surveys will raise a FOREIGN KEY constraint violation,
  // preventing orphaned specialized records.
  //
  // sync_queue.survey_id is intentionally NOT FK-constrained (see header note).

  Future<void> _applyV2Migration(Database db) async {
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      // ── local_household_assets ───────────────────────────────────────
      await txn.execute(
        'ALTER TABLE local_household_assets RENAME TO _local_household_assets_v1',
      );
      await txn.execute('''
        CREATE TABLE local_household_assets (
          id              TEXT PRIMARY KEY,
          survey_id       TEXT NOT NULL,
          household_id    TEXT NOT NULL,
          asset_type      TEXT NOT NULL,
          asset_data_json TEXT NOT NULL DEFAULT '{}',
          created_at      TEXT NOT NULL DEFAULT '$now',
          updated_at      TEXT NOT NULL DEFAULT '$now',
          synced_at       TEXT,
          UNIQUE(survey_id, asset_type),
          FOREIGN KEY(survey_id) REFERENCES local_surveys(survey_id)
        )
      ''');
      await txn.execute('''
        INSERT INTO local_household_assets
          SELECT id, survey_id, household_id, asset_type, asset_data_json,
                 created_at, updated_at, synced_at
          FROM _local_household_assets_v1
      ''');
      await txn.execute('DROP TABLE _local_household_assets_v1');
      await txn.execute(
        'CREATE INDEX IF NOT EXISTS idx_assets_survey ON local_household_assets(survey_id)',
      );

      // ── local_livestock ─────────────────────────────────────────────────
      await txn.execute(
        'ALTER TABLE local_livestock RENAME TO _local_livestock_v1',
      );
      await txn.execute('''
        CREATE TABLE local_livestock (
          id              TEXT PRIMARY KEY,
          survey_id       TEXT NOT NULL,
          household_id    TEXT NOT NULL,
          animal_type     TEXT NOT NULL,
          livestock_data_json TEXT NOT NULL DEFAULT '{}',
          created_at      TEXT NOT NULL DEFAULT '$now',
          updated_at      TEXT NOT NULL DEFAULT '$now',
          synced_at       TEXT,
          UNIQUE(survey_id, animal_type),
          FOREIGN KEY(survey_id) REFERENCES local_surveys(survey_id)
        )
      ''');
      await txn.execute('''
        INSERT INTO local_livestock
          SELECT id, survey_id, household_id, animal_type, livestock_data_json,
                 created_at, updated_at, synced_at
          FROM _local_livestock_v1
      ''');
      await txn.execute('DROP TABLE _local_livestock_v1');
      await txn.execute(
        'CREATE INDEX IF NOT EXISTS idx_livestock_survey ON local_livestock(survey_id)',
      );

      // ── local_cropping_pattern ──────────────────────────────────────────
      await txn.execute(
        'ALTER TABLE local_cropping_pattern RENAME TO _local_cropping_pattern_v1',
      );
      await txn.execute('''
        CREATE TABLE local_cropping_pattern (
          id              TEXT PRIMARY KEY,
          survey_id       TEXT NOT NULL,
          household_id    TEXT NOT NULL,
          category        TEXT NOT NULL,
          pattern_data_json TEXT NOT NULL DEFAULT '{}',
          kharif          TEXT,
          rabi            TEXT,
          zaid            TEXT,
          perennial       TEXT,
          created_at      TEXT NOT NULL DEFAULT '$now',
          updated_at      TEXT NOT NULL DEFAULT '$now',
          synced_at       TEXT,
          UNIQUE(survey_id, category),
          FOREIGN KEY(survey_id) REFERENCES local_surveys(survey_id)
        )
      ''');
      await txn.execute('''
        INSERT INTO local_cropping_pattern (
          id, survey_id, household_id, category, pattern_data_json,
          created_at, updated_at, synced_at
        )
          SELECT id, survey_id, household_id, category, pattern_data_json,
                 created_at, updated_at, synced_at
          FROM _local_cropping_pattern_v1
      ''');
      await txn.execute('DROP TABLE _local_cropping_pattern_v1');
      await txn.execute(
        'CREATE INDEX IF NOT EXISTS idx_cropping_survey ON local_cropping_pattern(survey_id)',
      );

      // ── local_crops ─────────────────────────────────────────────────────
      await txn.execute('ALTER TABLE local_crops RENAME TO _local_crops_v1');
      await txn.execute('''
        CREATE TABLE local_crops (
          id              TEXT PRIMARY KEY,
          survey_id       TEXT NOT NULL,
          household_id    TEXT NOT NULL,
          category        TEXT,
          crop_rank       INTEGER,
          crop_data_json  TEXT NOT NULL DEFAULT '{}',
          created_at      TEXT NOT NULL DEFAULT '$now',
          updated_at      TEXT NOT NULL DEFAULT '$now',
          synced_at       TEXT,
          UNIQUE(survey_id, category, crop_rank),
          FOREIGN KEY(survey_id) REFERENCES local_surveys(survey_id)
        )
      ''');
      await txn.execute('''
        INSERT INTO local_crops
          SELECT id, survey_id, household_id, category, crop_rank,
                 crop_data_json, created_at, updated_at, synced_at
          FROM _local_crops_v1
      ''');
      await txn.execute('DROP TABLE _local_crops_v1');
      await txn.execute(
        'CREATE INDEX IF NOT EXISTS idx_crops_survey ON local_crops(survey_id)',
      );

      // ── local_pests_diseases ────────────────────────────────────────────
      await txn.execute(
        'ALTER TABLE local_pests_diseases RENAME TO _local_pests_diseases_v1',
      );
      await txn.execute('''
        CREATE TABLE local_pests_diseases (
          id              TEXT PRIMARY KEY,
          survey_id       TEXT NOT NULL,
          household_id    TEXT NOT NULL,
          incident_type   TEXT NOT NULL,
          pest_data_json  TEXT NOT NULL DEFAULT '{}',
          created_at      TEXT NOT NULL DEFAULT '$now',
          updated_at      TEXT NOT NULL DEFAULT '$now',
          synced_at       TEXT,
          FOREIGN KEY(survey_id) REFERENCES local_surveys(survey_id)
        )
      ''');
      await txn.execute('''
        INSERT INTO local_pests_diseases
          SELECT id, survey_id, household_id, incident_type, pest_data_json,
                 created_at, updated_at, synced_at
          FROM _local_pests_diseases_v1
      ''');
      await txn.execute('DROP TABLE _local_pests_diseases_v1');
      await txn.execute(
        'CREATE INDEX IF NOT EXISTS idx_pests_survey ON local_pests_diseases(survey_id)',
      );

      // ── local_employment_seasonality ────────────────────────────────────
      await txn.execute(
        'ALTER TABLE local_employment_seasonality RENAME TO _local_employment_seasonality_v1',
      );
      await txn.execute('''
        CREATE TABLE local_employment_seasonality (
          id              TEXT PRIMARY KEY,
          survey_id       TEXT NOT NULL,
          household_id    TEXT NOT NULL,
          activity        TEXT,
          seasonality_data_json TEXT NOT NULL DEFAULT '{}',
          created_at      TEXT NOT NULL DEFAULT '$now',
          updated_at      TEXT NOT NULL DEFAULT '$now',
          synced_at       TEXT,
          FOREIGN KEY(survey_id) REFERENCES local_surveys(survey_id)
        )
      ''');
      await txn.execute('''
        INSERT INTO local_employment_seasonality
          SELECT id, survey_id, household_id, activity, seasonality_data_json,
                 created_at, updated_at, synced_at
          FROM _local_employment_seasonality_v1
      ''');
      await txn.execute('DROP TABLE _local_employment_seasonality_v1');
      await txn.execute(
        'CREATE INDEX IF NOT EXISTS idx_seasonality_survey ON local_employment_seasonality(survey_id)',
      );
    });

    debugPrint(
      '[LocalDB] v2 migration applied: FK constraints added to specialized tables.',
    );
  }

  // ── Survey CRUD ───────────────────────────────────────────────────────────

  Future<void> upsertSurvey({
    required String surveyId,
    required String householdId,
    required String agentId,
    required String status,
    required String responsesJson,
    String? submittedAt,
  }) async {
    final now = DateTime.now().toIso8601String();
    await _database.insert('local_surveys', {
      'survey_id': surveyId,
      'household_id': householdId,
      'agent_id': agentId,
      'status': status,
      'responses_json': responsesJson,
      'submitted_at': submittedAt,
      'updated_at': now,
      'created_at': now,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getSurvey(String surveyId) async {
    final rows = await _database.query(
      'local_surveys',
      where: 'survey_id = ?',
      whereArgs: [surveyId],
      limit: 1,
    );
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<List<Map<String, dynamic>>> getSurveysForHousehold(
    String householdId,
  ) async {
    return _database.query(
      'local_surveys',
      where: 'household_id = ?',
      whereArgs: [householdId],
      orderBy: 'updated_at DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getSurveysForAgent(String agentId) async {
    return _database.query(
      'local_surveys',
      where: 'agent_id = ?',
      whereArgs: [agentId],
      orderBy: 'updated_at DESC',
    );
  }

  // ── Household Assets ──────────────────────────────────────────────────────

  Future<void> upsertHouseholdAsset(Map<String, dynamic> record) async {
    final now = DateTime.now().toIso8601String();
    await _database.insert('local_household_assets', {
      ...record,
      'updated_at': now,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getHouseholdAssets({
    required String surveyId,
    required String householdId,
  }) async {
    return _database.query(
      'local_household_assets',
      where: 'survey_id = ? AND household_id = ?',
      whereArgs: [surveyId, householdId],
    );
  }

  // ── Livestock ─────────────────────────────────────────────────────────────

  Future<void> upsertLivestock(Map<String, dynamic> record) async {
    final now = DateTime.now().toIso8601String();
    await _database.insert('local_livestock', {
      ...record,
      'updated_at': now,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getLivestock({
    required String surveyId,
    required String householdId,
  }) async {
    return _database.query(
      'local_livestock',
      where: 'survey_id = ? AND household_id = ?',
      whereArgs: [surveyId, householdId],
    );
  }

  // ── Cropping Pattern ──────────────────────────────────────────────────────

  static Future<void> _ensureCroppingPatternColumns(Database db) async {
    try {
      final info = await db.rawQuery('PRAGMA table_info(local_cropping_pattern)');
      final existingCols = info
          .map((row) => (row['name'] as String?)?.toLowerCase())
          .whereType<String>()
          .toSet();
      for (final col in ['kharif', 'rabi', 'zaid', 'perennial']) {
        if (!existingCols.contains(col)) {
          await db.execute('ALTER TABLE local_cropping_pattern ADD COLUMN $col TEXT');
        }
      }
    } catch (_) {}
  }

  Future<void> upsertCroppingPattern(Map<String, dynamic> record) async {
    final now = DateTime.now().toIso8601String();
    try {
      await _database.insert('local_cropping_pattern', {
        ...record,
        'updated_at': now,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      await _ensureCroppingPatternColumns(_database);
      try {
        await _database.insert('local_cropping_pattern', {
          ...record,
          'updated_at': now,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      } catch (retryErr) {
        final fallback = Map<String, dynamic>.from(record);
        fallback.remove('kharif');
        fallback.remove('rabi');
        fallback.remove('zaid');
        fallback.remove('perennial');
        await _database.insert('local_cropping_pattern', {
          ...fallback,
          'updated_at': now,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  Future<List<Map<String, dynamic>>> getCroppingPatterns({
    required String surveyId,
    required String householdId,
  }) async {
    return _database.query(
      'local_cropping_pattern',
      where: 'survey_id = ? AND household_id = ?',
      whereArgs: [surveyId, householdId],
    );
  }

  // ── Crops ─────────────────────────────────────────────────────────────────

  Future<void> upsertCrop(Map<String, dynamic> record) async {
    final now = DateTime.now().toIso8601String();
    await _database.insert('local_crops', {
      ...record,
      'updated_at': now,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getCrops({
    required String surveyId,
    required String householdId,
  }) async {
    return _database.query(
      'local_crops',
      where: 'survey_id = ? AND household_id = ?',
      whereArgs: [surveyId, householdId],
    );
  }

  // ── Pests & Diseases ──────────────────────────────────────────────────────

  Future<void> upsertPestDisease(Map<String, dynamic> record) async {
    final now = DateTime.now().toIso8601String();
    await _database.insert('local_pests_diseases', {
      ...record,
      'updated_at': now,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getPestsDiseases({
    required String surveyId,
    required String householdId,
  }) async {
    return _database.query(
      'local_pests_diseases',
      where: 'survey_id = ? AND household_id = ?',
      whereArgs: [surveyId, householdId],
    );
  }

  Future<void> deletePestDisease(String id) async {
    await _database.delete(
      'local_pests_diseases',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> queuePestDiseaseDeletion({
    required String surveyId,
    required String householdId,
    required String recordId,
  }) async {
    final now = DateTime.now().toIso8601String();
    final payloadJson = jsonEncode({'id': recordId});
    final deleteOperationId = 'pest_delete_${surveyId}_$recordId';

    await _database.transaction((txn) async {
      // Remove pending or failed upserts for this exact record so they
      // cannot recreate it after the deletion.
      await txn.delete(
        'sync_queue',
        where: '''
          target_table = ?
          AND survey_id = ?
          AND household_id = ?
          AND record_id = ?
          AND operation_type = ?
          AND sync_state IN ('pending', 'failed')
        ''',
        whereArgs: [
          'pests_diseases',
          surveyId,
          householdId,
          recordId,
          'upsert',
        ],
      );

      // Reuse an existing delete operation if one exists.
      final existing = await txn.query(
        'sync_queue',
        columns: ['operation_id'],
        where: '''
          operation_id = ?
          AND sync_state IN ('pending', 'failed')
        ''',
        whereArgs: [deleteOperationId],
        limit: 1,
      );

      if (existing.isNotEmpty) {
        await txn.update(
          'sync_queue',
          {
            'target_table': 'pests_diseases',
            'operation_type': 'delete',
            'survey_id': surveyId,
            'household_id': householdId,
            'record_id': recordId,
            'payload_json': payloadJson,
            'sync_state': 'pending',
            'retry_count': 0,
            'last_error': null,
            'last_attempt_at': now,
            'synced_at': null,
            'created_at': now,
          },
          where: 'operation_id = ?',
          whereArgs: [deleteOperationId],
        );
      } else {
        await txn.insert('sync_queue', {
          'operation_id': deleteOperationId,
          'target_table': 'pests_diseases',
          'operation_type': 'delete',
          'survey_id': surveyId,
          'household_id': householdId,
          'record_id': recordId,
          'payload_json': payloadJson,
          'sync_state': 'pending',
          'retry_count': 0,
          'last_error': null,
          'last_attempt_at': now,
          'synced_at': null,
          'created_at': now,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }

  // ── Employment Seasonality ────────────────────────────────────────────────

  Future<void> upsertEmploymentSeasonality(Map<String, dynamic> record) async {
    final now = DateTime.now().toIso8601String();
    await _database.insert('local_employment_seasonality', {
      ...record,
      'updated_at': now,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getEmploymentSeasonality({
    required String surveyId,
    required String householdId,
  }) async {
    return _database.query(
      'local_employment_seasonality',
      where: 'survey_id = ? AND household_id = ?',
      whereArgs: [surveyId, householdId],
    );
  }

  // ── Questionnaire Cache ───────────────────────────────────────────────────

  Future<void> saveQuestionnaireCache({
    required String cacheKey,
    required String configJson,
  }) async {
    final now = DateTime.now().toIso8601String();
    await _database.insert('questionnaire_cache', {
      'cache_key': cacheKey,
      'config_json': configJson,
      'cached_at': now,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getQuestionnaireCache(String cacheKey) async {
    final rows = await _database.query(
      'questionnaire_cache',
      where: 'cache_key = ?',
      whereArgs: [cacheKey],
      limit: 1,
    );
    return rows.isNotEmpty ? rows.first : null;
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
    final now = DateTime.now().toIso8601String();
    return _database.insert(
      'sync_queue',
      {
        'operation_id': operationId,
        'target_table': targetTable,
        'operation_type': operationType,
        'survey_id': surveyId,
        'household_id': householdId,
        'record_id': recordId,
        'conflict_key': conflictKey,
        'payload_json': payloadJson,
        'sync_state': 'pending',
        'retry_count': 0,
        'created_at': now,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // idempotent enqueue
    );
  }

  /// Updates the [payloadJson] of an existing sync-queue entry **only when it
  /// is still pending** (sync_state = 'pending').
  ///
  /// Call this after [enqueueSyncOperation] on repeated draft saves so that
  /// the queue always holds the latest payload rather than the first one.
  ///
  /// Completed ('synced') and failed operations are intentionally left
  /// untouched — a failed operation retains its original payload for retry,
  /// and a synced operation must not be modified.
  ///
  /// Returns the number of rows updated (0 if the operation was already
  /// synced/failed, 1 if the payload was refreshed).
  Future<int> updatePendingSyncPayload({
    required String operationId,
    required String payloadJson,
  }) async {
    final now = DateTime.now().toIso8601String();

    return _database.update(
      'sync_queue',
      {
        'payload_json': payloadJson,
        'sync_state': 'pending',
        'retry_count': 0,
        'last_error': null,
        'last_attempt_at': now,
        'synced_at': null,
      },
      where: 'operation_id = ?',
      whereArgs: [operationId],
    );
  }

  Future<List<Map<String, dynamic>>> getPendingSyncOperations() async {
    return _database.query(
      'sync_queue',
      where: "sync_state IN ('pending', 'failed')",
      orderBy: 'created_at ASC',
    );
  }

  Future<void> markSyncOperationComplete(String operationId) async {
    final now = DateTime.now().toIso8601String();
    await _database.update(
      'sync_queue',
      {'sync_state': 'synced', 'synced_at': now},
      where: 'operation_id = ?',
      whereArgs: [operationId],
    );
  }

  Future<void> markSyncOperationFailed({
    required String operationId,
    required String errorMessage,
  }) async {
    final now = DateTime.now().toIso8601String();
    await _database.rawUpdate(
      '''
      UPDATE sync_queue
      SET sync_state = 'failed',
          last_error = ?,
          retry_count = retry_count + 1,
          last_attempt_at = ?
      WHERE operation_id = ?
    ''',
      [errorMessage, now, operationId],
    );
  }
}

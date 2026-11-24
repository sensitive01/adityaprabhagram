import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../services/supabase_service.dart';
import '../../../services/local_database_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model for a single livestock row
// ─────────────────────────────────────────────────────────────────────────────
class _LivestockRow {
  /// DB row id — null means not yet saved
  String? dbId;

  /// Fixed animal type key (e.g. "Yak"). For "Other" row this is always "Other".
  final String animalType;

  /// Display label shown in the UI.
  final String animalLabel;

  /// True only for the "Other if any" row — enables the custom name text field.
  final bool isOther;

  /// True for Fishery row — shows species sub-selection.
  final bool isFishery;

  /// True for Bee keeping row — count label changes to "Nos. of Box".
  final bool isBeeKeeping;

  // ── User-entered values ──────────────────────────────────────────────────

  /// For "Other if any": the user-entered animal/enterprise name.
  String otherAnimalName;

  /// For Fishery: selected species (Trout / Carp / Tilapia / Other species).
  String? fisherySpecies;

  /// For Fishery "Other species": free text.
  String fisheryOtherSpecies;

  /// Stored in livestock.breed
  String breed;

  /// Stored in livestock.count
  int? count;

  /// Stored in livestock.purpose — comma-separated list of selected purposes.
  List<String> selectedPurposes;

  /// Stored in livestock.market_value — JSON-like string of sub-field values.
  /// We store as a pipe-separated "key=value|key=value" string for simplicity.
  Map<String, String> marketValues;

  /// Stored in livestock.feed_source — comma-separated list of selected sources.
  List<String> selectedFeedSources;

  /// "Other" feed source free text (appended to feed_source).
  String otherFeedSource;

  /// Stored in livestock.remarks
  String remarks;

  _LivestockRow({
    this.dbId,
    required this.animalType,
    required this.animalLabel,
    this.isOther = false,
    this.isFishery = false,
    this.isBeeKeeping = false,
    this.otherAnimalName = '',
    this.fisherySpecies,
    this.fisheryOtherSpecies = '',
    this.breed = '',
    this.count,
    List<String>? selectedPurposes,
    Map<String, String>? marketValues,
    List<String>? selectedFeedSources,
    this.otherFeedSource = '',
    this.remarks = '',
  }) : selectedPurposes = selectedPurposes ?? [],
       marketValues = marketValues ?? {},
       selectedFeedSources = selectedFeedSources ?? [];

  /// Encode marketValues map to a storable string: "Adult=1000|Calf=500"
  static String _encodeMarketValues(Map<String, String> mv) {
    if (mv.isEmpty) return '';
    return mv.entries
        .where((e) => e.value.trim().isNotEmpty)
        .map((e) => '${e.key}=${e.value.trim()}')
        .join('|');
  }

  /// Decode storable string back to map.
  static Map<String, String> _decodeMarketValues(String? raw) {
    if (raw == null || raw.trim().isEmpty) return {};
    final result = <String, String>{};
    for (final part in raw.split('|')) {
      final idx = part.indexOf('=');
      if (idx > 0) {
        result[part.substring(0, idx)] = part.substring(idx + 1);
      }
    }
    return result;
  }

  /// Encode feed sources list + other text to storable string.
  static String _encodeFeedSources(List<String> sources, String otherText) {
    final list = List<String>.from(sources);
    if (list.contains('Other') && otherText.trim().isNotEmpty) {
      // Replace "Other" with "Other:<text>"
      list.remove('Other');
      list.add('Other:${otherText.trim()}');
    }
    return list.join(',');
  }

  /// Decode feed sources string back to list + other text.
  static ({List<String> sources, String otherText}) _decodeFeedSources(
    String? raw,
  ) {
    if (raw == null || raw.trim().isEmpty) {
      return (sources: [], otherText: '');
    }
    final parts = raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final sources = <String>[];
    String otherText = '';
    for (final p in parts) {
      if (p.startsWith('Other:')) {
        sources.add('Other');
        otherText = p.substring(6);
      } else {
        sources.add(p);
      }
    }
    return (sources: sources, otherText: otherText);
  }

  /// Encode purposes list to storable string.
  static String _encodePurposes(List<String> purposes) => purposes.join(',');

  /// Decode purposes string to list.
  static List<String> _decodePurposes(String? raw) {
    if (raw == null || raw.trim().isEmpty) return [];
    return raw
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  factory _LivestockRow.fromDbRow(
    Map<String, dynamic> row,
    String animalLabel,
    bool isOther,
    bool isFishery,
    bool isBeeKeeping,
  ) {
    final feedDecoded = _decodeFeedSources(row['feed_source'] as String?);
    final purposeList = _decodePurposes(row['purpose'] as String?);
    final mvMap = _decodeMarketValues(row['market_value'] as String?);

    // For Fishery: breed stores species; remarks stores other species text
    String? fisherySpecies;
    String fisheryOtherSpecies = '';
    String breed = (row['breed'] as String?) ?? '';
    String remarks = (row['remarks'] as String?) ?? '';

    if (isFishery) {
      fisherySpecies = breed.isNotEmpty ? breed : null;
      if (fisherySpecies == 'Other species') {
        fisheryOtherSpecies = remarks;
        remarks = '';
      }
    }

    return _LivestockRow(
      dbId: row['id'] as String?,
      animalType: (row['animal_type'] as String?) ?? '',
      animalLabel: animalLabel,
      isOther: isOther,
      isFishery: isFishery,
      isBeeKeeping: isBeeKeeping,
      otherAnimalName: isOther ? ((row['breed'] as String?) ?? '') : '',
      fisherySpecies: fisherySpecies,
      fisheryOtherSpecies: fisheryOtherSpecies,
      breed: isFishery || isOther ? '' : breed,
      count: row['count'] as int?,
      selectedPurposes: purposeList,
      marketValues: mvMap,
      selectedFeedSources: feedDecoded.sources,
      otherFeedSource: feedDecoded.otherText,
      remarks: isFishery && fisherySpecies == 'Other species' ? '' : remarks,
    );
  }

  Map<String, dynamic> toDbMap(
    String householdId,
    String surveyId,
    String? createdBy,
  ) {
    // For Fishery: store species in breed; other species text in remarks
    String dbBreed = breed;
    String dbRemarks = remarks;
    if (isFishery) {
      dbBreed = fisherySpecies ?? '';
      if (fisherySpecies == 'Other species') {
        dbRemarks = fisheryOtherSpecies.trim();
      }
    }
    // For Other: store user-entered name in breed
    if (isOther) {
      dbBreed = otherAnimalName.trim();
    }

    final dbPurpose = selectedPurposes.isEmpty
        ? null
        : _encodePurposes(selectedPurposes);
    final dbMarketValue = marketValues.isEmpty
        ? null
        : _encodeMarketValues(marketValues);
    final dbFeedSource = selectedFeedSources.isEmpty
        ? null
        : _encodeFeedSources(selectedFeedSources, otherFeedSource);

    return {
      'household_id': householdId,
      'survey_id': surveyId,
      'animal_type': animalType,
      'breed': dbBreed.isEmpty ? null : dbBreed,
      'count': count,
      'purpose': dbPurpose,
      'market_value': dbMarketValue,
      'feed_source': dbFeedSource,
      'remarks': dbRemarks.trim().isEmpty ? null : dbRemarks.trim(),
      if (createdBy != null) 'created_by': createdBy,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Livestock definitions
// ─────────────────────────────────────────────────────────────────────────────
class _LivestockDef {
  final String type;
  final String label;
  final bool isOther;
  final bool isFishery;
  final bool isBeeKeeping;
  final List<String> purposes;
  final List<String> marketValueKeys; // sub-field labels for market value
  final List<String> feedSources;

  const _LivestockDef({
    required this.type,
    required this.label,
    this.isOther = false,
    this.isFishery = false,
    this.isBeeKeeping = false,
    required this.purposes,
    required this.marketValueKeys,
    required this.feedSources,
  });
}

const List<String> _kStandardFeed = [
  'Farm-produced',
  'Purchased',
  'Community grazing land',
  'Other',
];
const List<String> _kFisheryFeed = ['Farm-produced', 'Purchased'];

const List<_LivestockDef> _kLivestockDefs = [
  _LivestockDef(
    type: 'Yak',
    label: 'Yak',
    purposes: ['Milk', 'Draught', 'Meat'],
    marketValueKeys: ['Adult', 'Calf'],
    feedSources: _kStandardFeed,
  ),
  _LivestockDef(
    type: 'Mithun',
    label: 'Mithun',
    purposes: ['Milk', 'Draught', 'Meat'],
    marketValueKeys: ['Adult', 'Calf'],
    feedSources: _kStandardFeed,
  ),
  _LivestockDef(
    type: 'Cow',
    label: 'Cow',
    purposes: ['Milk', 'Draught', 'Meat'],
    marketValueKeys: ['Adult', 'Calf'],
    feedSources: _kStandardFeed,
  ),
  _LivestockDef(
    type: 'Buffalo',
    label: 'Buffalo',
    purposes: ['Milk', 'Draught', 'Meat'],
    marketValueKeys: ['Adult', 'Calf'],
    feedSources: _kStandardFeed,
  ),
  _LivestockDef(
    type: 'Goat',
    label: 'Goat',
    purposes: ['Milk', 'Meat'],
    marketValueKeys: ['Adult', 'Lamb'],
    feedSources: _kStandardFeed,
  ),
  _LivestockDef(
    type: 'Sheep',
    label: 'Sheep',
    purposes: ['Milk', 'Meat'],
    marketValueKeys: ['Adult', 'Kid'],
    feedSources: _kStandardFeed,
  ),
  _LivestockDef(
    type: 'Pig',
    label: 'Pig',
    purposes: ['Meat', 'Others'],
    marketValueKeys: ['Adult', 'Piglet'],
    feedSources: _kStandardFeed,
  ),
  _LivestockDef(
    type: 'Poultry',
    label: 'Poultry',
    purposes: ['Meat', 'Egg', 'Chicks'],
    marketValueKeys: ['Adult', 'Chick'],
    feedSources: _kStandardFeed,
  ),
  _LivestockDef(
    type: 'Duck',
    label: 'Duck',
    purposes: ['Meat', 'Egg', 'Ducklings'],
    marketValueKeys: ['Adult', 'Duckling'],
    feedSources: _kStandardFeed,
  ),
  _LivestockDef(
    type: 'Fishery',
    label: 'Fishery',
    isFishery: true,
    purposes: ['Meat', 'Fingerlings'],
    marketValueKeys: ['Meat (Rs/kg)', 'Fingerlings (Rs/kg)'],
    feedSources: _kFisheryFeed,
  ),
  _LivestockDef(
    type: 'Bee keeping',
    label: 'Bee keeping',
    isBeeKeeping: true,
    purposes: ['Honey', 'Pollination', 'Others'],
    marketValueKeys: ['Honey (Rs/kg)', 'Others (Rs/kg)'],
    feedSources: [],
  ),
  _LivestockDef(
    type: 'Other',
    label: 'Other if any',
    isOther: true,
    purposes: [],
    marketValueKeys: [],
    feedSources: _kStandardFeed,
  ),
];

const List<String> _kFisherySpecies = [
  'Trout',
  'Carp',
  'Tilapia',
  'Other species',
];

// ─────────────────────────────────────────────────────────────────────────────
// Livestock Section Widget (C-10)
// ─────────────────────────────────────────────────────────────────────────────
class LivestockSectionWidget extends StatefulWidget {
  final String householdId;
  final String surveyId;
  final bool isReadOnly;

  const LivestockSectionWidget({
    super.key,
    required this.householdId,
    required this.surveyId,
    this.isReadOnly = false,
  });

  @override
  State<LivestockSectionWidget> createState() => LivestockSectionWidgetState();
}

class LivestockSectionWidgetState extends State<LivestockSectionWidget> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _loadError;

  late List<_LivestockRow> _rows;

  @override
  void initState() {
    super.initState();
    _initRows();
    _loadFromDb();
  }

  void _initRows() {
    _rows = _kLivestockDefs
        .map(
          (def) => _LivestockRow(
            animalType: def.type,
            animalLabel: def.label,
            isOther: def.isOther,
            isFishery: def.isFishery,
            isBeeKeeping: def.isBeeKeeping,
          ),
        )
        .toList();
  }

  Future<void> _loadFromDb() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      final isOnline = ConnectivityService.instance.isOnline;
      List<dynamic> data = [];

      if (isOnline) {
        final client = SupabaseService.instance.client;
        data = await client
            .from('livestock')
            .select()
            .eq('household_id', widget.householdId)
            .eq('survey_id', widget.surveyId);
      } else {
        // Offline: load from local DB
        final localRows = await LocalDatabaseService.instance.getLivestock(
          surveyId: widget.surveyId,
          householdId: widget.householdId,
        );
        data = localRows.map((r) {
          final decoded = <String, dynamic>{};
          try {
            final json = r['livestock_data_json'] as String? ?? '{}';
            decoded.addAll(
              Map<String, dynamic>.from((jsonDecode(json) as Map? ?? {})),
            );
          } catch (_) {}
          decoded['id'] = r['id'];
          decoded['animal_type'] = r['animal_type'];
          decoded['survey_id'] = r['survey_id'];
          decoded['household_id'] = r['household_id'];
          return decoded;
        }).toList();
      }

      if (!mounted) return;

      // Map DB rows by animal_type for quick lookup.
      final dbByType = <String, Map<String, dynamic>>{};
      for (final row in data) {
        final type = (row['animal_type'] as String?) ?? '';
        if (type.isNotEmpty) dbByType[type] = Map<String, dynamic>.from(row);
      }

      // Merge DB data into predefined rows
      for (int i = 0; i < _rows.length; i++) {
        final def = _kLivestockDefs[i];
        final dbRow = dbByType[_rows[i].animalType];
        if (dbRow != null) {
          _rows[i] = _LivestockRow.fromDbRow(
            dbRow,
            def.label,
            def.isOther,
            def.isFishery,
            def.isBeeKeeping,
          );
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint(
        'LivestockSection load error (Supabase): $e — trying local DB',
      );
      // Supabase failed: fall back to local DB
      try {
        final localRows = await LocalDatabaseService.instance.getLivestock(
          surveyId: widget.surveyId,
          householdId: widget.householdId,
        );
        if (localRows.isNotEmpty) {
          final dbByType = <String, Map<String, dynamic>>{};
          for (final r in localRows) {
            final decoded = <String, dynamic>{};
            try {
              final json = r['livestock_data_json'] as String? ?? '{}';
              decoded.addAll(
                Map<String, dynamic>.from((jsonDecode(json) as Map? ?? {})),
              );
            } catch (_) {}
            decoded['id'] = r['id'];
            decoded['animal_type'] = r['animal_type'];
            final type = r['animal_type'] as String? ?? '';
            if (type.isNotEmpty) dbByType[type] = decoded;
          }
          for (int i = 0; i < _rows.length; i++) {
            final def = _kLivestockDefs[i];
            final dbRow = dbByType[_rows[i].animalType];
            if (dbRow != null) {
              _rows[i] = _LivestockRow.fromDbRow(
                dbRow,
                def.label,
                def.isOther,
                def.isFishery,
                def.isBeeKeeping,
              );
            }
          }
          if (mounted) setState(() => _isLoading = false);
          return;
        }
      } catch (localErr) {
        debugPrint('LivestockSection local fallback error: $localErr');
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadError = 'Failed to load livestock data. Tap retry to try again.';
        });
      }
    }
  }

  /// Save all rows to DB: INSERT if no dbId, UPDATE if dbId exists.
  /// Only saves rows that have at least one field filled in.
  Future<void> saveData() async {
    if (_isSaving) return;
    if (!mounted) return;
    setState(() => _isSaving = true);

    try {
      final client = SupabaseService.instance.client;
      final uid = SupabaseService.instance.currentUser?.id;
      final isOnline = ConnectivityService.instance.isOnline;

      for (final row in _rows) {
        final hasData =
            row.count != null ||
            row.selectedPurposes.isNotEmpty ||
            row.marketValues.isNotEmpty ||
            row.selectedFeedSources.isNotEmpty ||
            row.breed.trim().isNotEmpty ||
            row.remarks.trim().isNotEmpty ||
            (row.isOther && row.otherAnimalName.trim().isNotEmpty) ||
            (row.isFishery && row.fisherySpecies != null) ||
            (row.isBeeKeeping && row.remarks.trim().isNotEmpty);

        if (!hasData && row.dbId == null) continue;

        final payload = row.toDbMap(widget.householdId, widget.surveyId, uid);

        // ── Local DB dual-write ─────────────────────────────────────────────
        if (LocalDatabaseService.instance.isAvailable) {
          try {
            final localId = row.dbId ?? const Uuid().v4();
            await LocalDatabaseService.instance.upsertLivestock({
              'id': localId,
              'survey_id': widget.surveyId,
              'household_id': widget.householdId,
              'animal_type': row.animalType,
              'livestock_data_json': jsonEncode(payload),
              'created_at': DateTime.now().toIso8601String(),
            });
            final opId = 'livestock_${widget.surveyId}_${row.animalType}';
            final opPayload = jsonEncode({...payload, 'id': localId});
            await LocalDatabaseService.instance.enqueueSyncOperation(
              operationId: opId,
              targetTable: 'livestock',
              operationType: 'upsert',
              surveyId: widget.surveyId,
              householdId: widget.householdId,
              recordId: localId,
              conflictKey: '${widget.surveyId}|${row.animalType}',
              payloadJson: opPayload,
            );
            // Fix 2: refresh payload on repeated saves
            await LocalDatabaseService.instance.updatePendingSyncPayload(
              operationId: opId,
              payloadJson: opPayload,
            );
          } catch (localErr) {
            debugPrint(
              '[LocalDB] Livestock dual-write error (non-fatal): $localErr',
            );
          }
        }

        // ── Supabase write (online only) ────────────────────────────────────
        if (isOnline) {
          if (row.dbId != null) {
            await client
                .from('livestock')
                .update({
                  ...payload,
                  'updated_at': DateTime.now().toIso8601String(),
                })
                .eq('id', row.dbId!);
          } else {
            final inserted = await client
                .from('livestock')
                .insert(payload)
                .select('id')
                .single();
            final newId = inserted['id'] as String?;
            if (newId != null) row.dbId = newId;
          }
        }
      }

      if (mounted) setState(() => _isSaving = false);
      Fluttertoast.showToast(
        msg: isOnline ? 'Livestock data saved' : 'Livestock data saved locally',
        backgroundColor: AppTheme.success,
        textColor: Colors.white,
      );
    } catch (e) {
      debugPrint('LivestockSection save error: $e');
      if (mounted) setState(() => _isSaving = false);
      Fluttertoast.showToast(
        msg: 'Failed to save livestock data. Please try again.',
        backgroundColor: AppTheme.error,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: AppTheme.error,
              ),
              const SizedBox(height: 12),
              Text(
                _loadError!,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadFromDb,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: Text(
                  'Retry',
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ──────────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'C-10. Livestock / Enterprises Owned',
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  if (_isSaving)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  if (!widget.isReadOnly && !_isSaving)
                    TextButton.icon(
                      onPressed: saveData,
                      icon: const Icon(Icons.save_outlined, size: 15),
                      label: Text(
                        'Save',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Record livestock and enterprises: breed, count, purpose, market value and feed source.',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: AppTheme.primary.withAlpha(179),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Livestock rows ──────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline.withAlpha(51)),
          ),
          child: Column(
            children: [
              for (int i = 0; i < _rows.length; i++) ...[
                _buildLivestockRow(theme, i),
                if (i < _rows.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: theme.colorScheme.outline.withAlpha(26),
                    indent: 12,
                    endIndent: 12,
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildLivestockRow(ThemeData theme, int rowIndex) {
    final row = _rows[rowIndex];
    final def = _kLivestockDefs[rowIndex];
    final isReadOnly = widget.isReadOnly;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Animal label ─────────────────────────────────────────────────
          Text(
            def.label,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),

          // ── "Other if any" — animal/enterprise name text field ───────────
          if (row.isOther) ...[
            const SizedBox(height: 8),
            _buildTextField(
              theme: theme,
              label: 'Livestock / Enterprise Name',
              value: row.otherAnimalName,
              isReadOnly: isReadOnly,
              hint: 'Enter name',
              onChanged: (v) =>
                  setState(() => _rows[rowIndex].otherAnimalName = v),
            ),
          ],

          // ── Fishery: species selection ───────────────────────────────────
          if (row.isFishery) ...[
            const SizedBox(height: 10),
            Text(
              'Species',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withAlpha(179),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _kFisherySpecies.map((species) {
                final selected = row.fisherySpecies == species;
                return _buildChoiceChip(
                  theme: theme,
                  label: species,
                  selected: selected,
                  isReadOnly: isReadOnly,
                  onTap: () => setState(() {
                    _rows[rowIndex].fisherySpecies = selected ? null : species;
                    if (species != 'Other species') {
                      _rows[rowIndex].fisheryOtherSpecies = '';
                    }
                  }),
                );
              }).toList(),
            ),
            if (row.fisherySpecies == 'Other species') ...[
              const SizedBox(height: 8),
              _buildTextField(
                theme: theme,
                label: 'Specify other species',
                value: row.fisheryOtherSpecies,
                isReadOnly: isReadOnly,
                hint: 'Enter species name',
                onChanged: (v) =>
                    setState(() => _rows[rowIndex].fisheryOtherSpecies = v),
              ),
            ],
          ],

          // ── Specify breed (not for Fishery, Bee keeping, Other) ──────────
          if (!row.isFishery && !row.isBeeKeeping && !row.isOther) ...[
            const SizedBox(height: 10),
            _buildTextField(
              theme: theme,
              label: 'Specify breed',
              value: row.breed,
              isReadOnly: isReadOnly,
              hint: 'Enter breed',
              onChanged: (v) => setState(() => _rows[rowIndex].breed = v),
            ),
          ],

          // ── No. / Count ──────────────────────────────────────────────────
          const SizedBox(height: 10),
          _buildNumberField(
            theme: theme,
            label: row.isBeeKeeping ? 'Nos. of Box' : 'No.',
            value: row.count,
            isReadOnly: isReadOnly,
            onChanged: (v) => setState(() => _rows[rowIndex].count = v),
          ),

          // ── Purpose ──────────────────────────────────────────────────────
          if (def.purposes.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              'Purpose',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withAlpha(179),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: def.purposes.map((purpose) {
                final selected = row.selectedPurposes.contains(purpose);
                return _buildChoiceChip(
                  theme: theme,
                  label: purpose,
                  selected: selected,
                  isReadOnly: isReadOnly,
                  onTap: () => setState(() {
                    if (selected) {
                      _rows[rowIndex].selectedPurposes.remove(purpose);
                    } else {
                      _rows[rowIndex].selectedPurposes.add(purpose);
                    }
                  }),
                );
              }).toList(),
            ),
          ],

          // ── Present Market Value ─────────────────────────────────────────
          if (def.marketValueKeys.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              'Present Market Value (Rs)',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withAlpha(179),
              ),
            ),
            const SizedBox(height: 6),
            ...def.marketValueKeys.map((key) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: Text(
                        key,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withAlpha(153),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _buildInlineNumberTextField(
                        theme: theme,
                        value: row.marketValues[key] ?? '',
                        isReadOnly: isReadOnly,
                        hint: 'Rs',
                        onChanged: (v) => setState(() {
                          _rows[rowIndex].marketValues[key] = v;
                        }),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],

          // ── Source of feed/fodder ────────────────────────────────────────
          if (def.feedSources.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              'Source of feed/fodder',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withAlpha(179),
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: def.feedSources.map((source) {
                final selected = row.selectedFeedSources.contains(source);
                return _buildChoiceChip(
                  theme: theme,
                  label: source,
                  selected: selected,
                  isReadOnly: isReadOnly,
                  onTap: () => setState(() {
                    if (selected) {
                      _rows[rowIndex].selectedFeedSources.remove(source);
                      if (source == 'Other') {
                        _rows[rowIndex].otherFeedSource = '';
                      }
                    } else {
                      _rows[rowIndex].selectedFeedSources.add(source);
                    }
                  }),
                );
              }).toList(),
            ),
            if (row.selectedFeedSources.contains('Other')) ...[
              const SizedBox(height: 8),
              _buildTextField(
                theme: theme,
                label: 'Specify other feed source',
                value: row.otherFeedSource,
                isReadOnly: isReadOnly,
                hint: 'Enter other feed source',
                onChanged: (v) =>
                    setState(() => _rows[rowIndex].otherFeedSource = v),
              ),
            ],
          ],

          // ── Remarks ──────────────────────────────────────────────────────
          if (row.isBeeKeeping || row.isOther) ...[
            const SizedBox(height: 10),
            _buildTextField(
              theme: theme,
              label: 'Remarks if any',
              value: row.remarks,
              isReadOnly: isReadOnly,
              hint: 'Enter remarks',
              onChanged: (v) => setState(() => _rows[rowIndex].remarks = v),
            ),
          ],
        ],
      ),
    );
  }

  // ── Helper widgets ─────────────────────────────────────────────────────────

  Widget _buildChoiceChip({
    required ThemeData theme,
    required String label,
    required bool selected,
    required bool isReadOnly,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isReadOnly ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primary.withAlpha(26)
              : theme.colorScheme.surface,
          border: Border.all(
            color: selected
                ? AppTheme.primary
                : theme.colorScheme.outline.withAlpha(102),
            width: selected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected
                ? AppTheme.primary
                : theme.colorScheme.onSurface.withAlpha(179),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required ThemeData theme,
    required String label,
    required String value,
    required bool isReadOnly,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withAlpha(153),
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          readOnly: isReadOnly,
          onChanged: onChanged,
          style: GoogleFonts.manrope(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.manrope(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withAlpha(102),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withAlpha(102),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withAlpha(102),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primary),
            ),
            filled: true,
            fillColor: isReadOnly
                ? theme.colorScheme.surfaceContainerHighest.withAlpha(77)
                : theme.colorScheme.surface,
          ),
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required ThemeData theme,
    required String label,
    required int? value,
    required bool isReadOnly,
    required ValueChanged<int?> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withAlpha(179),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          child: TextFormField(
            initialValue: value?.toString() ?? '',
            readOnly: isReadOnly,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) => onChanged(int.tryParse(v)),
            style: GoogleFonts.manrope(fontSize: 13),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: GoogleFonts.manrope(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withAlpha(102),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withAlpha(102),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: theme.colorScheme.outline.withAlpha(102),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppTheme.primary),
              ),
              filled: true,
              fillColor: isReadOnly
                  ? theme.colorScheme.surfaceContainerHighest.withAlpha(77)
                  : theme.colorScheme.surface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInlineNumberTextField({
    required ThemeData theme,
    required String value,
    required bool isReadOnly,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return TextFormField(
      initialValue: value,
      readOnly: isReadOnly,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      onChanged: onChanged,
      style: GoogleFonts.manrope(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.manrope(
          fontSize: 12,
          color: theme.colorScheme.onSurface.withAlpha(102),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withAlpha(102),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withAlpha(102),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.primary),
        ),
        filled: true,
        fillColor: isReadOnly
            ? theme.colorScheme.surfaceContainerHighest.withAlpha(77)
            : theme.colorScheme.surface,
      ),
    );
  }
}

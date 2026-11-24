import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../services/supabase_service.dart';
import '../../../services/local_database_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model for a single asset row in the matrix
// ─────────────────────────────────────────────────────────────────────────────
class _AssetRow {
  /// DB row id — null means not yet saved
  /// Local SQLite row ID.
  String? dbId;

  /// Supabase row ID. Only use this ID for Supabase updates.
  String? supabaseId;

  /// Fixed asset type key (e.g. "Tractor"). For "Other" row this is always "Other".
  final String assetType;

  /// Display label shown in the UI (same as assetType for fixed rows).
  final String assetLabel;

  /// True only for the "Other if any" row — enables the custom name text field.
  final bool isOther;

  /// User-entered name for the "Other" row; stored in asset_name column.
  String otherAssetName;

  /// Owned Yes / No
  String? ownershipStatus; // 'Yes' | 'No' | null

  int? quantity;

  /// Rent/Hired Yes / No
  bool? isHired; // true=Yes, false=No, null=not answered

  double? hireCost;
  String hireCostUnit; // 'Per Hour' | 'Per Day'
  String hiringSource; // 'Private' | 'Government' | 'Custom hiring center'

  // Preserved but not shown in UI (kept for DB round-trip)
  String assetCondition;
  int? yearAcquired;
  double? estimatedValue;
  String remarks;

  _AssetRow({
    this.dbId,
    this.supabaseId,
    required this.assetType,
    required this.assetLabel,
    this.isOther = false,
    this.otherAssetName = '',
    this.ownershipStatus,
    this.quantity,
    this.isHired,
    this.hireCost,
    this.hireCostUnit = '',
    this.hiringSource = '',
    this.assetCondition = '',
    this.yearAcquired,
    this.estimatedValue,
    this.remarks = '',
  });

  factory _AssetRow.fromDbRow(
    Map<String, dynamic> row,
    String assetLabel,
    bool isOther, {
    bool isSupabaseRow = true,
  }) {
    final isHiredRaw = row['is_hired'];
    bool? isHiredParsed;
    if (isHiredRaw is bool) {
      isHiredParsed = isHiredRaw;
    } else if (isHiredRaw != null) {
      isHiredParsed = isHiredRaw.toString().toLowerCase() == 'true';
    }

    final ownershipRaw = (row['ownership_status'] as String?) ?? '';
    String? ownershipParsed;
    if (ownershipRaw == 'Yes' || ownershipRaw == 'No') {
      ownershipParsed = ownershipRaw;
    } else if (ownershipRaw.isNotEmpty) {
      // Legacy values: treat non-empty as 'Yes'
      ownershipParsed = 'Yes';
    }

    return _AssetRow(
      dbId: row['id'] as String?,
      supabaseId: isSupabaseRow ? row['id'] as String? : null,
      assetType: (row['asset_type'] as String?) ?? '',
      assetLabel: assetLabel,
      isOther: isOther,
      otherAssetName: isOther ? ((row['asset_name'] as String?) ?? '') : '',
      ownershipStatus: ownershipParsed,
      quantity: row['quantity'] as int?,
      isHired: isHiredParsed,
      hireCost: row['hire_cost'] != null
          ? double.tryParse(row['hire_cost'].toString())
          : null,
      hireCostUnit: (row['hire_cost_unit'] as String?) ?? '',
      hiringSource: (row['hiring_source'] as String?) ?? '',
      assetCondition: (row['asset_condition'] as String?) ?? '',
      yearAcquired: row['year_acquired'] as int?,
      estimatedValue: row['estimated_value'] != null
          ? double.tryParse(row['estimated_value'].toString())
          : null,
      remarks: (row['remarks'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toDbMap(
    String householdId,
    String surveyId,
    String? createdBy,
  ) {
    final String dbAssetName = isOther ? otherAssetName.trim() : assetLabel;
    return {
      'household_id': householdId,
      'survey_id': surveyId,
      'asset_type': assetType,
      'asset_name': dbAssetName.isEmpty ? assetType : dbAssetName,
      'ownership_status': ownershipStatus,
      'quantity': quantity,
      'is_hired': isHired,
      'hire_cost': hireCost,
      'hire_cost_unit': hireCostUnit.isEmpty ? null : hireCostUnit,
      'hiring_source': hiringSource.isEmpty ? null : hiringSource,
      'asset_condition': assetCondition.isEmpty ? null : assetCondition,
      'year_acquired': yearAcquired,
      'estimated_value': estimatedValue,
      'remarks': remarks.trim().isEmpty ? null : remarks.trim(),
      if (createdBy != null) 'created_by': createdBy,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Predefined APG asset list — exactly 10 rows per the questionnaire
// ─────────────────────────────────────────────────────────────────────────────
const List<Map<String, dynamic>> _kAssetDefinitions = [
  {'type': 'Tractor', 'label': 'Tractor', 'isOther': false},
  {'type': 'Pump set', 'label': 'Pump set', 'isOther': false},
  {'type': 'Farm tools', 'label': 'Farm tools', 'isOther': false},
  {'type': 'Power tiller', 'label': 'Power tiller', 'isOther': false},
  {'type': 'Diesel generator', 'label': 'Diesel generator', 'isOther': false},
  {'type': 'Car', 'label': 'Car', 'isOther': false},
  {'type': 'Bike', 'label': 'Bike', 'isOther': false},
  {'type': 'Smartphone', 'label': 'Smartphone', 'isOther': false},
  {'type': 'Pickup truck', 'label': 'Pickup truck', 'isOther': false},
  {'type': 'Other', 'label': 'Other if any', 'isOther': true},
];

const List<String> _kHireCostUnitOptions = ['Per Hour', 'Per Day'];
const List<String> _kHiringSourceOptions = [
  'Private',
  'Government',
  'Custom hiring center',
];

// ─────────────────────────────────────────────────────────────────────────────
// Asset Matrix Section Widget
// ─────────────────────────────────────────────────────────────────────────────
class AssetMatrixSectionWidget extends StatefulWidget {
  final String householdId;
  final String surveyId;
  final bool isReadOnly;

  const AssetMatrixSectionWidget({
    super.key,
    required this.householdId,
    required this.surveyId,
    this.isReadOnly = false,
  });

  @override
  State<AssetMatrixSectionWidget> createState() =>
      AssetMatrixSectionWidgetState();
}

class AssetMatrixSectionWidgetState extends State<AssetMatrixSectionWidget> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _loadError;

  /// One row per predefined asset definition.
  late List<_AssetRow> _rows;

  @override
  void initState() {
    super.initState();
    _initRows();
    _loadFromDb();
  }

  /// Initialise rows from the predefined asset list (all blank).
  void _initRows() {
    _rows = _kAssetDefinitions
        .map(
          (def) => _AssetRow(
            assetType: def['type'] as String,
            assetLabel: def['label'] as String,
            isOther: def['isOther'] as bool,
          ),
        )
        .toList();
  }

  /// Load existing asset rows from DB for this household + survey.
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
            .from('household_assets')
            .select()
            .eq('household_id', widget.householdId)
            .eq('survey_id', widget.surveyId);
      } else {
        // Offline: load from local DB
        final localRows = await LocalDatabaseService.instance
            .getHouseholdAssets(
              surveyId: widget.surveyId,
              householdId: widget.householdId,
            );
        // Decode asset_data_json back to flat map for each row
        data = localRows.map((r) {
          final decoded = <String, dynamic>{};
          try {
            final json = r['asset_data_json'] as String? ?? '{}';
            decoded.addAll(
              Map<String, dynamic>.from((jsonDecode(json) as Map? ?? {})),
            );
          } catch (_) {}
          decoded['id'] = r['id'];
          decoded['asset_type'] = r['asset_type'];
          decoded['survey_id'] = r['survey_id'];
          decoded['household_id'] = r['household_id'];
          return decoded;
        }).toList();
      }

      if (!mounted) return;

      // Map DB rows by asset_type for quick lookup.
      // For "Other" rows, key by asset_type = "Other".
      final dbByType = <String, Map<String, dynamic>>{};
      for (final row in data) {
        final type = (row['asset_type'] as String?) ?? '';
        if (type.isNotEmpty) dbByType[type] = Map<String, dynamic>.from(row);
      }

      // Merge DB data into predefined rows
      for (int i = 0; i < _rows.length; i++) {
        final dbRow = dbByType[_rows[i].assetType];
        if (dbRow != null) {
          _rows[i] = _AssetRow.fromDbRow(
            dbRow,
            _rows[i].assetLabel,
            _rows[i].isOther,
            isSupabaseRow: isOnline,
          );
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('AssetMatrix load error (Supabase): $e — trying local DB');
      // Supabase failed: fall back to local DB without replacing populated data
      try {
        final localRows = await LocalDatabaseService.instance
            .getHouseholdAssets(
              surveyId: widget.surveyId,
              householdId: widget.householdId,
            );
        if (localRows.isNotEmpty) {
          final dbByType = <String, Map<String, dynamic>>{};
          for (final r in localRows) {
            final decoded = <String, dynamic>{};
            try {
              final json = r['asset_data_json'] as String? ?? '{}';
              decoded.addAll(
                Map<String, dynamic>.from((jsonDecode(json) as Map? ?? {})),
              );
            } catch (_) {}
            decoded['id'] = r['id'];
            decoded['asset_type'] = r['asset_type'];
            final type = r['asset_type'] as String? ?? '';
            if (type.isNotEmpty) dbByType[type] = decoded;
          }
          for (int i = 0; i < _rows.length; i++) {
            final dbRow = dbByType[_rows[i].assetType];
            if (dbRow != null) {
              _rows[i] = _AssetRow.fromDbRow(
                dbRow,
                _rows[i].assetLabel,
                _rows[i].isOther,
                isSupabaseRow: false,
              );
            }
          }
          if (mounted) setState(() => _isLoading = false);
          return;
        }
      } catch (localErr) {
        debugPrint('AssetMatrix local fallback error: $localErr');
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadError = 'Failed to load asset data. Tap retry to try again.';
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
        // Skip completely empty rows
        final isEmpty =
            row.ownershipStatus == null &&
            row.quantity == null &&
            row.isHired == null &&
            (!row.isOther || row.otherAssetName.trim().isEmpty);
        if (isEmpty && row.dbId == null) continue;

        final payload = row.toDbMap(widget.householdId, widget.surveyId, uid);

        // ── Local DB dual-write ─────────────────────────────────────────────
        if (LocalDatabaseService.instance.isAvailable) {
          try {
            // Ensure local_surveys row exists first (FK constraint)
            final localId = row.dbId ?? const Uuid().v4();
            row.dbId = localId;

            await LocalDatabaseService.instance.upsertHouseholdAsset({
              'id': localId,
              'survey_id': widget.surveyId,
              'household_id': widget.householdId,
              'asset_type': row.assetType,
              'asset_data_json': jsonEncode(payload),
              'created_at': DateTime.now().toIso8601String(),
            });
            // Enqueue sync operation then refresh payload (Fix 2)
            final opId = 'asset_${widget.surveyId}_${row.assetType}';
            final opPayload = jsonEncode({...payload, 'id': localId});
            await LocalDatabaseService.instance.enqueueSyncOperation(
              operationId: opId,
              targetTable: 'household_assets',
              operationType: 'upsert',
              surveyId: widget.surveyId,
              householdId: widget.householdId,
              recordId: localId,
              conflictKey: '${widget.surveyId}|${row.assetType}',
              payloadJson: opPayload,
            );
            await LocalDatabaseService.instance.updatePendingSyncPayload(
              operationId: opId,
              payloadJson: opPayload,
            );
          } catch (localErr) {
            debugPrint(
              '[LocalDB] Asset dual-write error (non-fatal): $localErr',
            );
          }
        }

        // ── Supabase write (online only) ────────────────────────────────────
        if (isOnline) {
          if (row.supabaseId != null) {
            await client
                .from('household_assets')
                .update({
                  ...payload,
                  'updated_at': DateTime.now().toIso8601String(),
                })
                .eq('id', row.supabaseId!);
          } else {
            final inserted = await client
                .from('household_assets')
                .insert(payload)
                .select('id')
                .single();
            final newId = inserted['id'] as String?;
            if (newId != null) row.supabaseId = newId;
          }
        }
      }

      if (mounted) setState(() => _isSaving = false);
      Fluttertoast.showToast(
        msg: isOnline ? 'Asset data saved' : 'Asset data saved locally',
        backgroundColor: AppTheme.success,
        textColor: Colors.white,
      );
    } catch (e) {
      debugPrint('AssetMatrix save error: $e');
      if (mounted) setState(() => _isSaving = false);
      Fluttertoast.showToast(
        msg: 'Failed to save asset data. Please try again.',
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
                      'Asset Matrix',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
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
                'Record household assets: ownership, quantity and hiring details.',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: AppTheme.primary.withAlpha(179),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Asset rows ──────────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline.withAlpha(51)),
          ),
          child: Column(
            children: [
              for (int i = 0; i < _rows.length; i++) ...[
                _buildAssetRow(theme, i),
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

  Widget _buildAssetRow(ThemeData theme, int rowIndex) {
    final row = _rows[rowIndex];
    final isReadOnly = widget.isReadOnly;
    final showHiringFields = row.isHired == true;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Asset label ──────────────────────────────────────────────────
          Text(
            row.assetLabel,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),

          // ── "Other if any" — asset name text field ───────────────────────
          if (row.isOther) ...[
            const SizedBox(height: 8),
            _buildLabeledTextField(
              theme: theme,
              label: 'Asset Name',
              value: row.otherAssetName,
              isReadOnly: isReadOnly,
              hint: 'Enter asset name',
              onChanged: (v) => setState(() {
                _rows[rowIndex].otherAssetName = v;
              }),
            ),
          ],

          const SizedBox(height: 10),

          // ── Row 1: Ownership Yes/No + Quantity ───────────────────────────
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildYesNoField(
                  theme: theme,
                  label: 'Owned (Yes/No)',
                  value: row.ownershipStatus,
                  isReadOnly: isReadOnly,
                  onChanged: (v) => setState(() {
                    _rows[rowIndex].ownershipStatus = v;
                  }),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: _buildNumberField(
                  theme: theme,
                  label: 'Quantity',
                  value: row.quantity?.toString() ?? '',
                  isReadOnly: isReadOnly,
                  isDecimal: false,
                  onChanged: (v) => setState(() {
                    _rows[rowIndex].quantity = int.tryParse(v);
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // ── Row 2: Rent/Hired Yes/No ─────────────────────────────────────
          _buildYesNoField(
            theme: theme,
            label: 'Rent/Hired (Yes/No)',
            value: row.isHired == null ? null : (row.isHired! ? 'Yes' : 'No'),
            isReadOnly: isReadOnly,
            onChanged: (v) => setState(() {
              if (v == null) {
                _rows[rowIndex].isHired = null;
              } else {
                _rows[rowIndex].isHired = v == 'Yes';
              }
              // Clear hiring fields when switching to No
              if (_rows[rowIndex].isHired != true) {
                _rows[rowIndex].hireCost = null;
                _rows[rowIndex].hireCostUnit = '';
                _rows[rowIndex].hiringSource = '';
              }
            }),
          ),

          // ── Conditional hiring fields (only when Rent/Hired = Yes) ───────
          if (showHiringFields) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildNumberField(
                    theme: theme,
                    label: 'Charges if Hired',
                    value: row.hireCost?.toString() ?? '',
                    isReadOnly: isReadOnly,
                    isDecimal: true,
                    onChanged: (v) => setState(() {
                      _rows[rowIndex].hireCost = double.tryParse(v);
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdownField(
                    theme: theme,
                    label: 'Hire Cost Unit',
                    value: row.hireCostUnit.isEmpty ? null : row.hireCostUnit,
                    options: _kHireCostUnitOptions,
                    isReadOnly: isReadOnly,
                    onChanged: (v) => setState(() {
                      _rows[rowIndex].hireCostUnit = v ?? '';
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildDropdownField(
              theme: theme,
              label: 'Source of Hiring',
              value: row.hiringSource.isEmpty ? null : row.hiringSource,
              options: _kHiringSourceOptions,
              isReadOnly: isReadOnly,
              onChanged: (v) => setState(() {
                _rows[rowIndex].hiringSource = v ?? '';
              }),
            ),
          ],
        ],
      ),
    );
  }

  // ── Field builders ──────────────────────────────────────────────────────────

  /// Yes / No segmented selector
  Widget _buildYesNoField({
    required ThemeData theme,
    required String label,
    required String? value,
    required bool isReadOnly,
    required ValueChanged<String?> onChanged,
  }) {
    if (isReadOnly) {
      return _buildReadOnlyField(theme, label, value ?? '—');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          children: ['Yes', 'No'].map((option) {
            final isSelected = value == option;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onChanged(isSelected ? null : option),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primary
                        : theme.colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primary
                          : theme.colorScheme.outline.withAlpha(77),
                    ),
                  ),
                  child: Text(
                    option,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required ThemeData theme,
    required String label,
    required String? value,
    required List<String> options,
    required bool isReadOnly,
    required ValueChanged<String?> onChanged,
  }) {
    if (isReadOnly) {
      return _buildReadOnlyField(theme, label, value ?? '—');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 3),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
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
                color: theme.colorScheme.outline.withAlpha(77),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
            ),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerLowest,
          ),
          style: GoogleFonts.manrope(
            fontSize: 12,
            color: theme.colorScheme.onSurface,
          ),
          hint: Text(
            'Select',
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          items: options
              .map(
                (o) => DropdownMenuItem(
                  value: o,
                  child: Text(
                    o,
                    style: GoogleFonts.manrope(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required ThemeData theme,
    required String label,
    required String value,
    required bool isReadOnly,
    required bool isDecimal,
    required ValueChanged<String> onChanged,
  }) {
    if (isReadOnly) {
      return _buildReadOnlyField(theme, label, value.isEmpty ? '—' : value);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 3),
        _AssetNumberField(
          initialValue: value,
          isDecimal: isDecimal,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildLabeledTextField({
    required ThemeData theme,
    required String label,
    required String value,
    required bool isReadOnly,
    required ValueChanged<String> onChanged,
    String hint = '',
  }) {
    if (isReadOnly) {
      return _buildReadOnlyField(theme, label, value.isEmpty ? '—' : value);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 3),
        _AssetTextField(initialValue: value, hint: hint, onChanged: onChanged),
      ],
    );
  }

  Widget _buildReadOnlyField(ThemeData theme, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 3),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.outline.withAlpha(51)),
          ),
          child: Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: value == '—'
                  ? theme.colorScheme.onSurfaceVariant
                  : theme.colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stateful number input field (avoids controller rebuild issues)
// ─────────────────────────────────────────────────────────────────────────────
class _AssetNumberField extends StatefulWidget {
  final String initialValue;
  final bool isDecimal;
  final ValueChanged<String> onChanged;

  const _AssetNumberField({
    required this.initialValue,
    required this.isDecimal,
    required this.onChanged,
  });

  @override
  State<_AssetNumberField> createState() => _AssetNumberFieldState();
}

class _AssetNumberFieldState extends State<_AssetNumberField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_AssetNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.numberWithOptions(decimal: widget.isDecimal),
      style: GoogleFonts.manrope(
        fontSize: 12,
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withAlpha(102),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withAlpha(77),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLowest,
      ),
      onChanged: widget.onChanged,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stateful text input field
// ─────────────────────────────────────────────────────────────────────────────
class _AssetTextField extends StatefulWidget {
  final String initialValue;
  final String hint;
  final ValueChanged<String> onChanged;

  const _AssetTextField({
    required this.initialValue,
    required this.onChanged,
    this.hint = '',
  });

  @override
  State<_AssetTextField> createState() => _AssetTextFieldState();
}

class _AssetTextFieldState extends State<_AssetTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_AssetTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: _controller,
      style: GoogleFonts.manrope(
        fontSize: 12,
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: widget.hint.isEmpty ? null : widget.hint,
        hintStyle: GoogleFonts.manrope(
          fontSize: 12,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withAlpha(102),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withAlpha(77),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLowest,
      ),
      onChanged: widget.onChanged,
    );
  }
}

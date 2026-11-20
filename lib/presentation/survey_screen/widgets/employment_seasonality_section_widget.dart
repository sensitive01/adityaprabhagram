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
// Data model for a single employment_seasonality row
// ─────────────────────────────────────────────────────────────────────────────
class _SeasonalityRow {
  final String activity;
  final List<bool> months; // index 0=Jan … 11=Dec
  String remarks;

  /// The DB UUID for this row, null if not yet persisted.
  String? persistedId;

  _SeasonalityRow({
    required this.activity,
    required this.months,
    this.remarks = '',
    this.persistedId,
  });

  factory _SeasonalityRow.empty(String activity) =>
      _SeasonalityRow(activity: activity, months: List.filled(12, false));

  factory _SeasonalityRow.fromDbRow(Map<String, dynamic> row) {
    bool b(String col) {
      final v = row[col];
      if (v == null) return false;
      if (v is bool) return v;
      final d = double.tryParse(v.toString()) ?? 0;
      return d >= 1.0;
    }

    return _SeasonalityRow(
      activity: (row['activity'] as String?) ?? '',
      months: [
        b('jan_available'),
        b('feb_available'),
        b('mar_available'),
        b('apr_available'),
        b('may_available'),
        b('jun_available'),
        b('jul_available'),
        b('aug_available'),
        b('sep_available'),
        b('oct_available'),
        b('nov_available'),
        b('dec_available'),
      ],
      remarks: (row['remarks'] as String?) ?? '',
      persistedId: row['id'] as String?,
    );
  }

  bool get hasAnyMonthSelected => months.any((m) => m);

  Map<String, dynamic> toDbMap(
    String householdId,
    String surveyId,
    String? createdBy,
    String id,
  ) {
    bool v(int i) => months[i];
    return {
      'id': id,
      'household_id': householdId,
      'survey_id': surveyId,
      'activity': activity,
      'jan_available': v(0),
      'feb_available': v(1),
      'mar_available': v(2),
      'apr_available': v(3),
      'may_available': v(4),
      'jun_available': v(5),
      'jul_available': v(6),
      'aug_available': v(7),
      'sep_available': v(8),
      'oct_available': v(9),
      'nov_available': v(10),
      'dec_available': v(11),
      'remarks': remarks.trim().isEmpty ? null : remarks.trim(),
      if (createdBy != null) 'created_by': createdBy,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section L Widget
// ─────────────────────────────────────────────────────────────────────────────
class EmploymentSeasonalitySectionWidget extends StatefulWidget {
  final String householdId;
  final String surveyId;
  final bool isReadOnly;

  const EmploymentSeasonalitySectionWidget({
    super.key,
    required this.householdId,
    required this.surveyId,
    this.isReadOnly = false,
  });

  @override
  State<EmploymentSeasonalitySectionWidget> createState() =>
      EmploymentSeasonalitySectionWidgetState();
}

class EmploymentSeasonalitySectionWidgetState
    extends State<EmploymentSeasonalitySectionWidget> {
  static const List<String> _activities = [
    'Agriculture',
    'Horticulture',
    'Livestock',
    'Wage labour',
    'Migration',
    'No work',
    'Others (if any)',
  ];

  static const List<String> _monthLabels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  late List<_SeasonalityRow> _rows;
  final Map<String, TextEditingController> _remarkControllers = {};
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _rows = _activities.map((a) => _SeasonalityRow.empty(a)).toList();
    for (final a in _activities) {
      _remarkControllers[a] = TextEditingController();
    }
    _loadData();
  }

  @override
  void dispose() {
    for (final c in _remarkControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadData() async {
    if (widget.surveyId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    try {
      final isOnline = ConnectivityService.instance.isOnline;

      if (isOnline) {
        final client = SupabaseService.instance.client;
        final rows = await client
            .from('employment_seasonality')
            .select()
            .eq('household_id', widget.householdId)
            .eq('survey_id', widget.surveyId)
            .order('created_at', ascending: true);

        if (!mounted) return;

        // Build a map of activity -> persisted DB row (only rows that exist in DB)
        final loaded = <String, _SeasonalityRow>{};
        for (final r in (rows as List)) {
          final row = _SeasonalityRow.fromDbRow(Map<String, dynamic>.from(r));
          loaded[row.activity] = row;
        }

        // Fixed activities always shown; merge with DB data if a row exists.
        final merged = _activities.map((a) {
          return loaded[a] ?? _SeasonalityRow.empty(a);
        }).toList();

        // Sync remark controllers
        for (int i = 0; i < _activities.length; i++) {
          _remarkControllers[_activities[i]]?.text = merged[i].remarks;
        }

        setState(() {
          _rows = merged;
          _isLoading = false;
        });
      } else {
        // Offline: load from local DB
        await _loadDataFromLocal();
      }
    } catch (e) {
      debugPrint(
        'EmploymentSeasonality load error (Supabase): $e — trying local DB',
      );
      if (mounted) {
        await _loadDataFromLocal();
      }
    }
  }

  /// Loads employment seasonality records from local SQLite (offline fallback).
  Future<void> _loadDataFromLocal() async {
    try {
      final localRows = await LocalDatabaseService.instance
          .getEmploymentSeasonality(
            surveyId: widget.surveyId,
            householdId: widget.householdId,
          );

      final loaded = <String, _SeasonalityRow>{};
      for (final r in localRows) {
        final decoded = <String, dynamic>{};
        try {
          final json = r['seasonality_data_json'] as String? ?? '{}';
          decoded.addAll(
            Map<String, dynamic>.from((jsonDecode(json) as Map? ?? {})),
          );
        } catch (_) {}
        decoded['id'] = r['id'];
        decoded['activity'] = r['activity'];
        decoded['survey_id'] = r['survey_id'];
        decoded['household_id'] = r['household_id'];
        final row = _SeasonalityRow.fromDbRow(decoded);
        loaded[row.activity] = row;
      }

      final merged = _activities.map((a) {
        return loaded[a] ?? _SeasonalityRow.empty(a);
      }).toList();

      for (int i = 0; i < _activities.length; i++) {
        _remarkControllers[_activities[i]]?.text = merged[i].remarks;
      }

      if (mounted) {
        setState(() {
          _rows = merged;
          _isLoading = false;
        });
      }
    } catch (localErr) {
      debugPrint('EmploymentSeasonality local fallback error: $localErr');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> saveData() async {
    if (_isSaving || widget.surveyId.isEmpty) return;
    setState(() => _isSaving = true);
    try {
      final client = SupabaseService.instance.client;
      final uid = SupabaseService.instance.currentUser?.id;
      const uuidGen = Uuid();
      final isOnline = ConnectivityService.instance.isOnline;

      // Sync remarks from controllers into rows
      for (int i = 0; i < _activities.length; i++) {
        _rows[i].remarks = _remarkControllers[_activities[i]]?.text ?? '';
      }

      for (final row in _rows) {
        if (row.hasAnyMonthSelected) {
          final id = row.persistedId ?? uuidGen.v4();
          final dbMap = row.toDbMap(
            widget.householdId,
            widget.surveyId,
            uid,
            id,
          );

          // ── Local DB dual-write ───────────────────────────────────────────
          if (LocalDatabaseService.instance.isAvailable) {
            try {
              await LocalDatabaseService.instance.upsertEmploymentSeasonality({
                'id': id,
                'survey_id': widget.surveyId,
                'household_id': widget.householdId,
                'activity': row.activity,
                'seasonality_data_json': jsonEncode(dbMap),
                'created_at': DateTime.now().toIso8601String(),
              });
              final opId = 'seasonality_${widget.surveyId}_${row.activity}';
              final opPayload = jsonEncode(dbMap);
              await LocalDatabaseService.instance.enqueueSyncOperation(
                operationId: opId,
                targetTable: 'employment_seasonality',
                operationType: 'upsert',
                surveyId: widget.surveyId,
                householdId: widget.householdId,
                recordId: id,
                payloadJson: opPayload,
              );
              // Fix 2: refresh payload on repeated saves
              await LocalDatabaseService.instance.updatePendingSyncPayload(
                operationId: opId,
                payloadJson: opPayload,
              );
            } catch (localErr) {
              debugPrint(
                '[LocalDB] Seasonality dual-write error (non-fatal): $localErr',
              );
            }
          }

          // ── Supabase write (online only) ──────────────────────────────────
          if (isOnline) {
            await client
                .from('employment_seasonality')
                .upsert(dbMap, onConflict: 'id')
                .select();
          }

          row.persistedId = id;
        } else {
          // No months selected: delete if exists
          if (row.persistedId != null) {
            if (isOnline) {
              await client
                  .from('employment_seasonality')
                  .delete()
                  .eq('id', row.persistedId!);
            }
            // Also remove from local DB
            if (LocalDatabaseService.instance.isAvailable) {
              try {
                await LocalDatabaseService.instance.enqueueSyncOperation(
                  operationId:
                      'seasonality_del_${widget.surveyId}_${row.activity}',
                  targetTable: 'employment_seasonality',
                  operationType: 'delete',
                  surveyId: widget.surveyId,
                  householdId: widget.householdId,
                  recordId: row.persistedId,
                  payloadJson: jsonEncode({'id': row.persistedId}),
                );
              } catch (localErr) {
                debugPrint(
                  '[LocalDB] Seasonality delete enqueue error (non-fatal): $localErr',
                );
              }
            }
            row.persistedId = null;
          }
        }
      }

      if (mounted) setState(() => _isSaving = false);
      Fluttertoast.showToast(
        msg: isOnline ? 'Section L saved' : 'Section L saved locally',
        backgroundColor: AppTheme.success,
        textColor: Colors.white,
      );
    } catch (e) {
      debugPrint('EmploymentSeasonality save error: $e');
      if (mounted) setState(() => _isSaving = false);
      Fluttertoast.showToast(
        msg: 'Failed to save Section L data',
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
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
              Text(
                'L: Seasonality — Employment Calendar',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tick the months when each activity is available. Add remarks if needed.',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: AppTheme.primary.withAlpha(179),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Matrix table
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline.withAlpha(51)),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 600),
              child: Column(
                children: [
                  // Header row
                  _buildHeaderRow(theme),
                  const Divider(height: 1, thickness: 1),
                  // Activity rows
                  for (int i = 0; i < _rows.length; i++) ...[
                    _buildActivityRow(theme, i),
                    if (i < _rows.length - 1)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: theme.colorScheme.outline.withAlpha(26),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),

        if (!widget.isReadOnly) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : saveData,
              icon: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_outlined, size: 18),
              label: Text(
                _isSaving ? 'Saving…' : 'Save Section L',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildHeaderRow(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Activity label column
          SizedBox(
            width: 120,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Activity',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          // Month columns
          for (final m in _monthLabels)
            SizedBox(
              width: 38,
              child: Center(
                child: Text(
                  m,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          // Remarks column
          const SizedBox(
            width: 140,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Remarks',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(ThemeData theme, int rowIndex) {
    final row = _rows[rowIndex];
    final isAlt = rowIndex % 2 == 1;

    return Container(
      color: isAlt
          ? theme.colorScheme.surfaceContainerLowest
          : theme.colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Activity name
          SizedBox(
            width: 120,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                row.activity,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          // Month checkboxes
          for (int m = 0; m < 12; m++)
            SizedBox(
              width: 38,
              child: Center(
                child: widget.isReadOnly
                    ? Icon(
                        row.months[m]
                            ? Icons.check_box_rounded
                            : Icons.check_box_outline_blank_rounded,
                        size: 20,
                        color: row.months[m]
                            ? AppTheme.primary
                            : theme.colorScheme.outline.withAlpha(128),
                      )
                    : Checkbox(
                        value: row.months[m],
                        onChanged: (val) {
                          setState(() {
                            row.months[m] = val ?? false;
                          });
                        },
                        activeColor: AppTheme.primary,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
              ),
            ),
          // Remarks field
          SizedBox(
            width: 140,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: widget.isReadOnly
                  ? Text(
                      row.remarks.isEmpty ? '—' : row.remarks,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: row.remarks.isEmpty
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  : TextField(
                      controller: _remarkControllers[row.activity],
                      style: GoogleFonts.manrope(fontSize: 11),
                      decoration: InputDecoration(
                        hintText: 'Remarks',
                        hintStyle: GoogleFonts.manrope(
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline.withAlpha(77),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline.withAlpha(51),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(
                            color: AppTheme.primary,
                            width: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerLowest,
                        isDense: true,
                      ),
                      maxLines: 1,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

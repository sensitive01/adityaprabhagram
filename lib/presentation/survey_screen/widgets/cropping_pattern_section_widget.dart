import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../services/supabase_service.dart';
import '../../../services/local_database_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../theme/app_theme.dart';
import './crop_details_section_widget.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model for a single cropping pattern category row
// ─────────────────────────────────────────────────────────────────────────────
class _CroppingRow {
  /// DB row id — null means not yet saved
  String? dbId;

  /// Fixed category name (matches DB category column exactly)
  final String category;

  /// Season values
  String kharif;
  String rabi;
  String zaid;

  _CroppingRow({
    this.dbId,
    required this.category,
    this.kharif = '',
    this.rabi = '',
    this.zaid = '',
  });

  /// True when all three season fields are blank
  bool get isBlank =>
      kharif.trim().isEmpty && rabi.trim().isEmpty && zaid.trim().isEmpty;

  factory _CroppingRow.fromDbRow(Map<String, dynamic> row, String category) {
    return _CroppingRow(
      dbId: row['id'] as String?,
      category: category,
      kharif: (row['kharif'] as String?) ?? '',
      rabi: (row['rabi'] as String?) ?? '',
      zaid: (row['zaid'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toDbMap(
    String householdId,
    String surveyId,
    String? createdBy,
  ) {
    return {
      'household_id': householdId,
      'survey_id': surveyId,
      'category': category,
      'kharif': kharif.trim().isEmpty ? null : kharif.trim(),
      'rabi': rabi.trim().isEmpty ? null : rabi.trim(),
      'zaid': zaid.trim().isEmpty ? null : zaid.trim(),
      if (createdBy != null) 'created_by': createdBy,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fixed category definitions — order matches the questionnaire
// ─────────────────────────────────────────────────────────────────────────────
const List<String> _kCategories = [
  'Agriculture crops',
  'Fruits & vegetable',
  'Medicinal & aromatic',
  'NTFP (Non-Timber Forest Products)',
  'Others (Spices/ flowers/ etc.)',
];

// ─────────────────────────────────────────────────────────────────────────────
// Cropping Pattern Section Widget
// ─────────────────────────────────────────────────────────────────────────────
class CroppingPatternSectionWidget extends StatefulWidget {
  final String householdId;
  final String surveyId;
  final bool isReadOnly;

  const CroppingPatternSectionWidget({
    super.key,
    required this.householdId,
    required this.surveyId,
    this.isReadOnly = false,
  });

  @override
  State<CroppingPatternSectionWidget> createState() =>
      CroppingPatternSectionWidgetState();
}

class CroppingPatternSectionWidgetState
    extends State<CroppingPatternSectionWidget> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _loadError;

  /// One row per fixed category
  late List<_CroppingRow> _rows;

  /// Text controllers keyed by "category|season"
  final Map<String, TextEditingController> _controllers = {};

  /// GlobalKey for the Q10 Crop Details widget so we can call saveData()
  final GlobalKey<CropDetailsSectionWidgetState> _cropDetailsKey =
      GlobalKey<CropDetailsSectionWidgetState>();

  @override
  void initState() {
    super.initState();
    _initRows();
    _loadFromDb();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _initRows() {
    _rows = _kCategories.map((cat) => _CroppingRow(category: cat)).toList();
    _buildControllers();
  }

  void _buildControllers() {
    // Dispose existing controllers
    for (final c in _controllers.values) {
      c.dispose();
    }
    _controllers.clear();
    for (final row in _rows) {
      _controllers['${row.category}|kharif'] = TextEditingController(
        text: row.kharif,
      );
      _controllers['${row.category}|rabi'] = TextEditingController(
        text: row.rabi,
      );
      _controllers['${row.category}|zaid'] = TextEditingController(
        text: row.zaid,
      );
    }
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
            .from('cropping_pattern')
            .select()
            .eq('household_id', widget.householdId)
            .eq('survey_id', widget.surveyId);
      } else {
        // Offline: load from local DB
        final localRows = await LocalDatabaseService.instance
            .getCroppingPatterns(
              surveyId: widget.surveyId,
              householdId: widget.householdId,
            );
        data = localRows.map((r) {
          final decoded = <String, dynamic>{};
          try {
            final json = r['pattern_data_json'] as String? ?? '{}';
            decoded.addAll(
              Map<String, dynamic>.from((jsonDecode(json) as Map? ?? {})),
            );
          } catch (_) {}
          decoded['id'] = r['id'];
          decoded['category'] = r['category'];
          decoded['survey_id'] = r['survey_id'];
          decoded['household_id'] = r['household_id'];
          return decoded;
        }).toList();
      }

      if (!mounted) return;

      // Map DB rows by category for quick lookup
      final dbByCategory = <String, Map<String, dynamic>>{};
      for (final row in data) {
        final cat = (row['category'] as String?) ?? '';
        if (cat.isNotEmpty) {
          dbByCategory[cat] = Map<String, dynamic>.from(row);
        }
      }

      // Merge DB data into predefined rows
      for (int i = 0; i < _rows.length; i++) {
        final dbRow = dbByCategory[_rows[i].category];
        if (dbRow != null) {
          _rows[i] = _CroppingRow.fromDbRow(dbRow, _rows[i].category);
        }
      }

      // Rebuild controllers with loaded values
      _buildControllers();

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('CroppingPattern load error (Supabase): $e — trying local DB');
      // Supabase failed: fall back to local DB
      try {
        final localRows = await LocalDatabaseService.instance
            .getCroppingPatterns(
              surveyId: widget.surveyId,
              householdId: widget.householdId,
            );
        if (localRows.isNotEmpty) {
          final dbByCategory = <String, Map<String, dynamic>>{};
          for (final r in localRows) {
            final decoded = <String, dynamic>{};
            try {
              final json = r['pattern_data_json'] as String? ?? '{}';
              decoded.addAll(
                Map<String, dynamic>.from((jsonDecode(json) as Map? ?? {})),
              );
            } catch (_) {}
            decoded['id'] = r['id'];
            decoded['category'] = r['category'];
            final cat = r['category'] as String? ?? '';
            if (cat.isNotEmpty) dbByCategory[cat] = decoded;
          }
          for (int i = 0; i < _rows.length; i++) {
            final dbRow = dbByCategory[_rows[i].category];
            if (dbRow != null) {
              _rows[i] = _CroppingRow.fromDbRow(dbRow, _rows[i].category);
            }
          }
          _buildControllers();
          if (mounted) setState(() => _isLoading = false);
          return;
        }
      } catch (localErr) {
        debugPrint('CroppingPattern local fallback error: $localErr');
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadError = 'Failed to load cropping pattern data. Tap retry.';
        });
      }
    }
  }

  /// Sync text controller values back into the row models
  void _syncControllersToRows() {
    for (final row in _rows) {
      row.kharif = _controllers['${row.category}|kharif']?.text ?? '';
      row.rabi = _controllers['${row.category}|rabi']?.text ?? '';
      row.zaid = _controllers['${row.category}|zaid']?.text ?? '';
    }
  }

  /// Public method called by survey_screen.dart on Next / Save Draft
  Future<void> saveData() async {
    if (widget.isReadOnly) return;
    _syncControllersToRows();
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      final client = SupabaseService.instance.client;
      final authUser = SupabaseService.instance.client.auth.currentUser;
      final createdBy = authUser?.id;
      final isOnline = ConnectivityService.instance.isOnline;

      for (final row in _rows) {
        // ── Local DB dual-write ─────────────────────────────────────────────
        if (LocalDatabaseService.instance.isAvailable && !row.isBlank) {
          try {
            final localId = row.dbId ?? const Uuid().v4();
            final opPayload = jsonEncode({
              'id': localId,
              'household_id': widget.householdId,
              'survey_id': widget.surveyId,
              'category': row.category,
              'kharif': row.kharif.trim().isEmpty ? null : row.kharif.trim(),
              'rabi': row.rabi.trim().isEmpty ? null : row.rabi.trim(),
              'zaid': row.zaid.trim().isEmpty ? null : row.zaid.trim(),
              if (createdBy != null) 'created_by': createdBy,
            });
            await LocalDatabaseService.instance.upsertCroppingPattern({
              'id': localId,
              'survey_id': widget.surveyId,
              'household_id': widget.householdId,
              'category': row.category,
              'pattern_data_json': jsonEncode({
                'category': row.category,
                'kharif': row.kharif,
                'rabi': row.rabi,
                'zaid': row.zaid,
              }),
              'created_at': DateTime.now().toIso8601String(),
            });
            final opId = 'cropping_${widget.surveyId}_${row.category}';
            await LocalDatabaseService.instance.enqueueSyncOperation(
              operationId: opId,
              targetTable: 'cropping_pattern',
              operationType: 'upsert',
              surveyId: widget.surveyId,
              householdId: widget.householdId,
              recordId: localId,
              conflictKey: '${widget.surveyId}|${row.category}',
              payloadJson: opPayload,
            );
            // Fix 2: refresh payload on repeated saves
            await LocalDatabaseService.instance.updatePendingSyncPayload(
              operationId: opId,
              payloadJson: opPayload,
            );
          } catch (localErr) {
            debugPrint(
              '[LocalDB] CroppingPattern dual-write error (non-fatal): $localErr',
            );
          }
        }

        // ── Supabase write (online only) ────────────────────────────────────
        if (isOnline) {
          if (row.dbId != null) {
            if (row.isBlank) {
              await client
                  .from('cropping_pattern')
                  .delete()
                  .eq('id', row.dbId!);
              row.dbId = null;
            } else {
              await client
                  .from('cropping_pattern')
                  .update({
                    'kharif': row.kharif.trim().isEmpty
                        ? null
                        : row.kharif.trim(),
                    'rabi': row.rabi.trim().isEmpty ? null : row.rabi.trim(),
                    'zaid': row.zaid.trim().isEmpty ? null : row.zaid.trim(),
                    'updated_at': DateTime.now().toIso8601String(),
                  })
                  .eq('id', row.dbId!);
            }
          } else if (!row.isBlank) {
            final inserted = await client
                .from('cropping_pattern')
                .insert(
                  row.toDbMap(widget.householdId, widget.surveyId, createdBy),
                )
                .select('id')
                .single();
            row.dbId = inserted['id'] as String?;
          }
        }
      }

      if (mounted) setState(() => _isSaving = false);
      Fluttertoast.showToast(
        msg: isOnline
            ? 'Cropping pattern saved'
            : 'Cropping pattern saved locally',
        backgroundColor: AppTheme.success,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    } catch (e) {
      debugPrint('CroppingPattern save error: $e');
      if (mounted) setState(() => _isSaving = false);
      Fluttertoast.showToast(
        msg: 'Failed to save cropping pattern. Please try again.',
        backgroundColor: AppTheme.error,
        textColor: Colors.white,
      );
    }

    // Also save Q10 Crop Details
    await _cropDetailsKey.currentState?.saveData();
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
              Icon(Icons.error_outline, color: AppTheme.error, size: 40),
              const SizedBox(height: 12),
              Text(
                _loadError!,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(color: AppTheme.error),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadFromDb,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header card ──────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primary.withAlpha(51)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Q9',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Cropping Pattern',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Name of the crops grown by you in different Seasons.',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withAlpha(204),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.warning.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.warning.withAlpha(77)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 14,
                      color: AppTheme.warning,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'If there are more than one crop in a particular season and particular category, enter crop names separated by "+".',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: AppTheme.warning.withAlpha(230),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Season header row ────────────────────────────────────────────
        _buildSeasonHeader(theme),
        const SizedBox(height: 8),

        // ── Category rows ────────────────────────────────────────────────
        ...List.generate(_rows.length, (i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildCategoryCard(_rows[i], theme),
          );
        }),

        if (_isSaving)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(child: CircularProgressIndicator()),
          ),

        const SizedBox(height: 8),

        // ── Q10 Crop Details ─────────────────────────────────────────────
        const SizedBox(height: 16),
        CropDetailsSectionWidget(
          key: _cropDetailsKey,
          householdId: widget.householdId,
          surveyId: widget.surveyId,
          isReadOnly: widget.isReadOnly,
        ),
      ],
    );
  }

  Widget _buildSeasonHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(31),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Category',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
          Expanded(flex: 2, child: _headerLabel('Kharif', 'Jun–Oct')),
          const SizedBox(width: 6),
          Expanded(flex: 2, child: _headerLabel('Rabi', 'Oct–Apr')),
          const SizedBox(width: 6),
          Expanded(flex: 2, child: _headerLabel('Zaid', 'Mar–Jun')),
        ],
      ),
    );
  }

  Widget _headerLabel(String season, String months) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          season,
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.primary,
          ),
        ),
        Text(
          months,
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: 9,
            color: AppTheme.primary.withAlpha(179),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(_CroppingRow row, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(51)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category label
            Text(
              row.category,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            // Three season inputs in a row
            Row(
              children: [
                Expanded(
                  child: _seasonField(
                    controller: _controllers['${row.category}|kharif']!,
                    label: 'Kharif',
                    readOnly: widget.isReadOnly,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _seasonField(
                    controller: _controllers['${row.category}|rabi']!,
                    label: 'Rabi',
                    readOnly: widget.isReadOnly,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _seasonField(
                    controller: _controllers['${row.category}|zaid']!,
                    label: 'Zaid',
                    readOnly: widget.isReadOnly,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _seasonField({
    required TextEditingController controller,
    required String label,
    required bool readOnly,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      textCapitalization: TextCapitalization.sentences,
      style: GoogleFonts.manrope(fontSize: 12),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.manrope(
          fontSize: 11,
          color: AppTheme.primary.withAlpha(179),
        ),
        hintText: 'Crop name(s)',
        hintStyle: GoogleFonts.manrope(
          fontSize: 10,
          color: Colors.grey.withAlpha(128),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.primary.withAlpha(77)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.primary.withAlpha(51)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
        ),
        filled: true,
        fillColor: readOnly
            ? Colors.grey.withAlpha(13)
            : AppTheme.primary.withAlpha(8),
      ),
      maxLines: 2,
      minLines: 1,
    );
  }
}

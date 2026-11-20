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
// Data model for a single crop entry (Crop 1 or Crop 2 within a category)
// ─────────────────────────────────────────────────────────────────────────────
class _CropEntry {
  /// DB row id — null means not yet saved
  String? dbId;

  final String category;
  final int cropRank; // 1 or 2

  String cropName;
  String areaAcres;
  String yieldKg;
  String variety; // 'Local' | 'Hybrid' | ''

  _CropEntry({
    this.dbId,
    required this.category,
    required this.cropRank,
    this.cropName = '',
    this.areaAcres = '',
    this.yieldKg = '',
    this.variety = '',
  });

  bool get isEmpty =>
      cropName.trim().isEmpty &&
      areaAcres.trim().isEmpty &&
      yieldKg.trim().isEmpty &&
      variety.trim().isEmpty;

  factory _CropEntry.fromDbRow(
    Map<String, dynamic> row,
    String category,
    int rank,
  ) {
    return _CropEntry(
      dbId: row['id'] as String?,
      category: category,
      cropRank: rank,
      cropName: (row['crop_name'] as String?) ?? '',
      areaAcres: row['area_acres'] != null ? row['area_acres'].toString() : '',
      yieldKg: row['yield_kg'] != null ? row['yield_kg'].toString() : '',
      variety: (row['variety'] as String?) ?? '',
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fixed D-10 categories
// ─────────────────────────────────────────────────────────────────────────────
const List<String> _kD10Categories = [
  'Agriculture',
  'Vegetable',
  'Fruits',
  'Medicinal & aromatic',
  'Spices',
  'Flower',
  'NTFP (Forest Products)',
  'Roots & tubers',
];

// ─────────────────────────────────────────────────────────────────────────────
// Crop Details Section Widget (Q10)
// ─────────────────────────────────────────────────────────────────────────────
class CropDetailsSectionWidget extends StatefulWidget {
  final String householdId;
  final String surveyId;
  final bool isReadOnly;

  const CropDetailsSectionWidget({
    super.key,
    required this.householdId,
    required this.surveyId,
    this.isReadOnly = false,
  });

  @override
  State<CropDetailsSectionWidget> createState() =>
      CropDetailsSectionWidgetState();
}

class CropDetailsSectionWidgetState extends State<CropDetailsSectionWidget> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _loadError;

  /// Map: category → [Crop1, Crop2]
  late Map<String, List<_CropEntry>> _entries;

  /// Which categories are expanded
  final Set<String> _expandedCategories = {};

  /// Text controllers keyed by "category|rank|field"
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initEntries();
    _loadFromDb();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _initEntries() {
    _entries = {};
    for (final cat in _kD10Categories) {
      _entries[cat] = [
        _CropEntry(category: cat, cropRank: 1),
        _CropEntry(category: cat, cropRank: 2),
      ];
    }
    _buildControllers();
  }

  void _buildControllers() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _controllers.clear();
    for (final cat in _kD10Categories) {
      for (int rank = 1; rank <= 2; rank++) {
        final entry = _entries[cat]![rank - 1];
        _controllers['$cat|$rank|name'] = TextEditingController(
          text: entry.cropName,
        );
        _controllers['$cat|$rank|area'] = TextEditingController(
          text: entry.areaAcres,
        );
        _controllers['$cat|$rank|yield'] = TextEditingController(
          text: entry.yieldKg,
        );
      }
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
            .from('crops')
            .select(
              'id, category, crop_rank, crop_name, area_acres, yield_kg, variety',
            )
            .eq('household_id', widget.householdId)
            .eq('survey_id', widget.surveyId)
            .not('category', 'is', null)
            .not('crop_rank', 'is', null);
      } else {
        // Offline: load from local DB
        final localRows = await LocalDatabaseService.instance.getCrops(
          surveyId: widget.surveyId,
          householdId: widget.householdId,
        );
        data = localRows.map((r) {
          final decoded = <String, dynamic>{};
          try {
            final json = r['crop_data_json'] as String? ?? '{}';
            decoded.addAll(
              Map<String, dynamic>.from((jsonDecode(json) as Map? ?? {})),
            );
          } catch (_) {}
          decoded['id'] = r['id'];
          decoded['category'] = r['category'];
          decoded['crop_rank'] = r['crop_rank'];
          decoded['survey_id'] = r['survey_id'];
          decoded['household_id'] = r['household_id'];
          return decoded;
        }).toList();
      }

      if (!mounted) return;

      // Populate entries from DB
      for (final row in data) {
        final cat = (row['category'] as String?) ?? '';
        final rank = (row['crop_rank'] as int?) ?? 0;
        if (!_kD10Categories.contains(cat)) continue;
        if (rank < 1 || rank > 2) continue;
        _entries[cat]![rank - 1] = _CropEntry.fromDbRow(row, cat, rank);
      }

      _buildControllers();

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('CropDetails load error (Supabase): $e — trying local DB');
      // Supabase failed: fall back to local DB
      try {
        final localRows = await LocalDatabaseService.instance.getCrops(
          surveyId: widget.surveyId,
          householdId: widget.householdId,
        );
        if (localRows.isNotEmpty) {
          for (final r in localRows) {
            final decoded = <String, dynamic>{};
            try {
              final json = r['crop_data_json'] as String? ?? '{}';
              decoded.addAll(
                Map<String, dynamic>.from((jsonDecode(json) as Map? ?? {})),
              );
            } catch (_) {}
            decoded['id'] = r['id'];
            decoded['category'] = r['category'];
            decoded['crop_rank'] = r['crop_rank'];
            final cat = (decoded['category'] as String?) ?? '';
            final rank = (decoded['crop_rank'] as int?) ?? 0;
            if (!_kD10Categories.contains(cat)) continue;
            if (rank < 1 || rank > 2) continue;
            _entries[cat]![rank - 1] = _CropEntry.fromDbRow(decoded, cat, rank);
          }
          _buildControllers();
          if (mounted) setState(() => _isLoading = false);
          return;
        }
      } catch (localErr) {
        debugPrint('CropDetails local fallback error: $localErr');
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
          _loadError = 'Failed to load crop details. Tap retry.';
        });
      }
    }
  }

  void _syncControllersToEntries() {
    for (final cat in _kD10Categories) {
      for (int rank = 1; rank <= 2; rank++) {
        final entry = _entries[cat]![rank - 1];
        entry.cropName = _controllers['$cat|$rank|name']?.text ?? '';
        entry.areaAcres = _controllers['$cat|$rank|area']?.text ?? '';
        entry.yieldKg = _controllers['$cat|$rank|yield']?.text ?? '';
        // variety is managed via setState directly on the entry
      }
    }
  }

  /// Public method called by parent on Next / Save Draft
  Future<void> saveData() async {
    if (widget.isReadOnly) return;
    _syncControllersToEntries();
    if (_isSaving) return;
    if (mounted) setState(() => _isSaving = true);
    try {
      final client = SupabaseService.instance.client;
      final authUser = client.auth.currentUser;
      final createdBy = authUser?.id;
      final isOnline = ConnectivityService.instance.isOnline;

      for (final cat in _kD10Categories) {
        for (int rank = 1; rank <= 2; rank++) {
          final entry = _entries[cat]![rank - 1];

          // ── Local DB dual-write ───────────────────────────────────────────
          if (LocalDatabaseService.instance.isAvailable && !entry.isEmpty) {
            try {
              final localId = entry.dbId ?? const Uuid().v4();
              await LocalDatabaseService.instance.upsertCrop({
                'id': localId,
                'survey_id': widget.surveyId,
                'household_id': widget.householdId,
                'category': cat,
                'crop_rank': rank,
                'crop_data_json': jsonEncode({
                  'crop_name': entry.cropName,
                  'area_acres': entry.areaAcres,
                  'yield_kg': entry.yieldKg,
                  'variety': entry.variety,
                }),
                'created_at': DateTime.now().toIso8601String(),
              });
              final opId = 'crop_${widget.surveyId}_${cat}_$rank';
              final opPayload = jsonEncode({
                'id': localId,
                'household_id': widget.householdId,
                'survey_id': widget.surveyId,
                'category': cat,
                'crop_rank': rank,
                'crop_name': entry.cropName.trim().isEmpty
                    ? null
                    : entry.cropName.trim(),
                'area_acres': entry.areaAcres.trim().isEmpty
                    ? null
                    : double.tryParse(entry.areaAcres.trim()),
                'yield_kg': entry.yieldKg.trim().isEmpty
                    ? null
                    : double.tryParse(entry.yieldKg.trim()),
                'variety': entry.variety.trim().isEmpty
                    ? null
                    : entry.variety.trim(),
                if (createdBy != null) 'created_by': createdBy,
              });
              await LocalDatabaseService.instance.enqueueSyncOperation(
                operationId: opId,
                targetTable: 'crops',
                operationType: 'upsert',
                surveyId: widget.surveyId,
                householdId: widget.householdId,
                recordId: localId,
                conflictKey: '${widget.surveyId}|$cat|$rank',
                payloadJson: opPayload,
              );
              // Fix 2: refresh payload on repeated saves
              await LocalDatabaseService.instance.updatePendingSyncPayload(
                operationId: opId,
                payloadJson: opPayload,
              );
            } catch (localErr) {
              debugPrint(
                '[LocalDB] CropDetails dual-write error (non-fatal): $localErr',
              );
            }
          }

          // ── Supabase write (online only) ──────────────────────────────────
          if (isOnline) {
            if (entry.dbId != null) {
              if (entry.isEmpty) {
                await client.from('crops').delete().eq('id', entry.dbId!);
                entry.dbId = null;
              } else {
                await client
                    .from('crops')
                    .update({
                      'crop_name': entry.cropName.trim().isEmpty
                          ? null
                          : entry.cropName.trim(),
                      'area_acres': entry.areaAcres.trim().isEmpty
                          ? null
                          : double.tryParse(entry.areaAcres.trim()),
                      'yield_kg': entry.yieldKg.trim().isEmpty
                          ? null
                          : double.tryParse(entry.yieldKg.trim()),
                      'variety': entry.variety.trim().isEmpty
                          ? null
                          : entry.variety.trim(),
                      'updated_at': DateTime.now().toIso8601String(),
                    })
                    .eq('id', entry.dbId!);
              }
            } else if (!entry.isEmpty) {
              final inserted = await client
                  .from('crops')
                  .insert({
                    'household_id': widget.householdId,
                    'survey_id': widget.surveyId,
                    'category': cat,
                    'crop_rank': rank,
                    'crop_name': entry.cropName.trim().isEmpty
                        ? null
                        : entry.cropName.trim(),
                    'area_acres': entry.areaAcres.trim().isEmpty
                        ? null
                        : double.tryParse(entry.areaAcres.trim()),
                    'yield_kg': entry.yieldKg.trim().isEmpty
                        ? null
                        : double.tryParse(entry.yieldKg.trim()),
                    'variety': entry.variety.trim().isEmpty
                        ? null
                        : entry.variety.trim(),
                    if (createdBy != null) 'created_by': createdBy,
                  })
                  .select('id')
                  .single();
              entry.dbId = inserted['id'] as String?;
            }
          }
        }
      }

      if (mounted) setState(() => _isSaving = false);
      Fluttertoast.showToast(
        msg: isOnline ? 'Crop details saved' : 'Crop details saved locally',
        backgroundColor: AppTheme.success,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );
    } catch (e) {
      debugPrint('CropDetails save error: $e');
      if (mounted) setState(() => _isSaving = false);
      Fluttertoast.showToast(
        msg: 'Failed to save crop details. Please try again.',
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
                      'Q10',
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
                      'Crop Details',
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
                'Provide details of major 2 crops grown in each category.',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withAlpha(204),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── Category cards ───────────────────────────────────────────────
        ...List.generate(_kD10Categories.length, (i) {
          final cat = _kD10Categories[i];
          final isExpanded = _expandedCategories.contains(cat);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildCategoryCard(cat, isExpanded, theme),
          );
        }),

        if (_isSaving)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(child: CircularProgressIndicator()),
          ),

        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildCategoryCard(String cat, bool isExpanded, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isExpanded
              ? AppTheme.primary.withAlpha(102)
              : theme.colorScheme.outline.withAlpha(51),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header / toggle row
          InkWell(
            onTap: widget.isReadOnly
                ? null
                : () {
                    setState(() {
                      if (isExpanded) {
                        _expandedCategories.remove(cat);
                      } else {
                        _expandedCategories.add(cat);
                      }
                    });
                  },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      cat,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isExpanded
                            ? AppTheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    color: isExpanded
                        ? AppTheme.primary
                        : theme.colorScheme.onSurface.withAlpha(128),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (isExpanded) ...[
            Divider(height: 1, color: AppTheme.primary.withAlpha(51)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: _buildCropPair(cat, theme),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCropPair(String cat, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildCropColumn(cat, 1, theme)),
        const SizedBox(width: 12),
        Expanded(child: _buildCropColumn(cat, 2, theme)),
      ],
    );
  }

  Widget _buildCropColumn(String cat, int rank, ThemeData theme) {
    final entry = _entries[cat]![rank - 1];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Crop label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'Crop $rank',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Name
        _fieldLabel('Name', theme),
        const SizedBox(height: 4),
        _textField(
          controller: _controllers['$cat|$rank|name']!,
          hint: 'Crop name',
          readOnly: widget.isReadOnly,
        ),
        const SizedBox(height: 10),

        // Area (acres)
        _fieldLabel('Area (acres)', theme),
        const SizedBox(height: 4),
        _numericField(
          controller: _controllers['$cat|$rank|area']!,
          hint: '0.0',
          readOnly: widget.isReadOnly,
        ),
        const SizedBox(height: 10),

        // Yield (kg)
        _fieldLabel('Yield (kg)', theme),
        const SizedBox(height: 4),
        _numericField(
          controller: _controllers['$cat|$rank|yield']!,
          hint: '0',
          readOnly: widget.isReadOnly,
        ),
        const SizedBox(height: 10),

        // Variety
        _fieldLabel('Variety', theme),
        const SizedBox(height: 4),
        _buildVarietyRadio(entry, theme),
      ],
    );
  }

  Widget _fieldLabel(String label, ThemeData theme) {
    return Text(
      label,
      style: GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface.withAlpha(153),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required bool readOnly,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      textCapitalization: TextCapitalization.sentences,
      style: GoogleFonts.manrope(fontSize: 12),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.manrope(
          fontSize: 11,
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
    );
  }

  Widget _numericField({
    required TextEditingController controller,
    required String hint,
    required bool readOnly,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      style: GoogleFonts.manrope(fontSize: 12),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.manrope(
          fontSize: 11,
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
    );
  }

  Widget _buildVarietyRadio(_CropEntry entry, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _varietyOption(entry, 'Local', theme),
        const SizedBox(height: 4),
        _varietyOption(entry, 'Hybrid', theme),
      ],
    );
  }

  Widget _varietyOption(_CropEntry entry, String value, ThemeData theme) {
    final isSelected = entry.variety == value;
    return GestureDetector(
      onTap: widget.isReadOnly
          ? null
          : () {
              setState(() {
                entry.variety = isSelected ? '' : value;
              });
            },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppTheme.primary
                    : theme.colorScheme.outline.withAlpha(128),
                width: 1.5,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primary,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: isSelected
                  ? AppTheme.primary
                  : theme.colorScheme.onSurface.withAlpha(179),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

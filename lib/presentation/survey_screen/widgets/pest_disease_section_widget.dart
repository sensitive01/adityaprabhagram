import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../services/supabase_service.dart';
import '../../../services/local_database_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data model for a single pests_diseases record (Section E)
// ─────────────────────────────────────────────────────────────────────────────
class PestDiseaseRecord {
  final String? id; // null = not yet saved to DB
  final String incidentType; // 'pest' | 'disease'
  final String cropName;
  final String pestDiseaseName;
  final String? cropStage;
  final String? infestationLevel; // pest only
  final String? attackFrequency; // pest only
  final String? symptoms;
  final String? severity; // disease only
  final String? diseaseType; // disease only
  final String? controlMethod; // disease only

  const PestDiseaseRecord({
    this.id,
    required this.incidentType,
    required this.cropName,
    required this.pestDiseaseName,
    this.cropStage,
    this.infestationLevel,
    this.attackFrequency,
    this.symptoms,
    this.severity,
    this.diseaseType,
    this.controlMethod,
  });

  PestDiseaseRecord copyWith({
    String? id,
    String? incidentType,
    String? cropName,
    String? pestDiseaseName,
    String? cropStage,
    String? infestationLevel,
    String? attackFrequency,
    String? symptoms,
    String? severity,
    String? diseaseType,
    String? controlMethod,
  }) {
    return PestDiseaseRecord(
      id: id ?? this.id,
      incidentType: incidentType ?? this.incidentType,
      cropName: cropName ?? this.cropName,
      pestDiseaseName: pestDiseaseName ?? this.pestDiseaseName,
      cropStage: cropStage ?? this.cropStage,
      infestationLevel: infestationLevel ?? this.infestationLevel,
      attackFrequency: attackFrequency ?? this.attackFrequency,
      symptoms: symptoms ?? this.symptoms,
      severity: severity ?? this.severity,
      diseaseType: diseaseType ?? this.diseaseType,
      controlMethod: controlMethod ?? this.controlMethod,
    );
  }

  Map<String, dynamic> toDbMap(String householdId, String surveyId) => {
    'household_id': householdId,
    'survey_id': surveyId,
    'incident_type': incidentType,
    'crop_name': cropName,
    'pest_disease_name': pestDiseaseName,
    'crop_stage': cropStage,
    'infestation_level': infestationLevel,
    'attack_frequency': attackFrequency,
    'symptoms': symptoms,
    'severity': severity,
    'disease_type': diseaseType,
    'control_method': controlMethod,
  };

  factory PestDiseaseRecord.fromDbRow(Map<String, dynamic> row) {
    return PestDiseaseRecord(
      id: row['id'] as String?,
      incidentType: (row['incident_type'] as String?) ?? 'pest',
      cropName: (row['crop_name'] as String?) ?? '',
      pestDiseaseName: (row['pest_disease_name'] as String?) ?? '',
      cropStage: row['crop_stage'] as String?,
      infestationLevel: row['infestation_level'] as String?,
      attackFrequency: row['attack_frequency'] as String?,
      symptoms: row['symptoms'] as String?,
      severity: row['severity'] as String?,
      diseaseType: row['disease_type'] as String?,
      controlMethod: row['control_method'] as String?,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section E Widget
// ─────────────────────────────────────────────────────────────────────────────
class PestDiseaseSectionWidget extends StatefulWidget {
  final String householdId;
  final String surveyId;
  final bool isReadOnly;

  const PestDiseaseSectionWidget({
    super.key,
    required this.householdId,
    required this.surveyId,
    this.isReadOnly = false,
  });

  @override
  State<PestDiseaseSectionWidget> createState() =>
      _PestDiseaseSectionWidgetState();
}

class _PestDiseaseSectionWidgetState extends State<PestDiseaseSectionWidget> {
  List<PestDiseaseRecord> _records = [];
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    if (widget.surveyId.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }
    try {
      final isOnline = ConnectivityService.instance.isOnline;
      final pendingOperations = await LocalDatabaseService.instance
          .getPendingSyncOperations();

      final pendingDeletionIds = pendingOperations
          .where(
            (op) =>
                op['target_table'] == 'pests_diseases' &&
                op['operation_type'] == 'delete' &&
                op['survey_id']?.toString() == widget.surveyId &&
                op['household_id']?.toString() == widget.householdId,
          )
          .map((op) => op['record_id']?.toString())
          .whereType<String>()
          .toSet();
      if (isOnline) {
        final client = SupabaseService.instance.client;
        final rows = await client
            .from('pests_diseases')
            .select()
            .eq('household_id', widget.householdId)
            .eq('survey_id', widget.surveyId)
            .order('created_at', ascending: true);
        if (mounted) {
          setState(() {
            _records = (rows as List)
                .map(
                  (r) =>
                      PestDiseaseRecord.fromDbRow(Map<String, dynamic>.from(r)),
                )
                .where((record) => !pendingDeletionIds.contains(record.id))
                .toList();
            _isLoading = false;
          });
        }
      } else {
        // Offline: load from local DB
        await _loadRecordsFromLocal();
      }
    } catch (e) {
      debugPrint(
        'PestDiseaseSectionWidget load error (Supabase): $e — trying local DB',
      );
      if (mounted) {
        await _loadRecordsFromLocal();
      }
    }
  }

  /// Loads pest/disease records from local SQLite (offline fallback).
  Future<void> _loadRecordsFromLocal() async {
    try {
      final localRows = await LocalDatabaseService.instance.getPestsDiseases(
        surveyId: widget.surveyId,
        householdId: widget.householdId,
      );
      if (mounted) {
        setState(() {
          _records = localRows.map((r) {
            final decoded = <String, dynamic>{};
            try {
              final json = r['pest_data_json'] as String? ?? '{}';
              decoded.addAll(
                Map<String, dynamic>.from((jsonDecode(json) as Map? ?? {})),
              );
            } catch (_) {}
            decoded['id'] = r['id'];
            decoded['incident_type'] = r['incident_type'];
            return PestDiseaseRecord.fromDbRow(decoded);
          }).toList();
          _isLoading = false;
        });
      }
    } catch (localErr) {
      debugPrint('PestDiseaseSectionWidget local fallback error: $localErr');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveRecord(PestDiseaseRecord record) async {
    setState(() => _isSaving = true);
    final payload = record.toDbMap(widget.householdId, widget.surveyId);
    final isOnline = ConnectivityService.instance.isOnline;
    try {
      // ── Local DB dual-write (always) ──────────────────────────────────────
      if (LocalDatabaseService.instance.isAvailable) {
        try {
          final localId = record.id ?? const Uuid().v4();
          await LocalDatabaseService.instance.upsertPestDisease({
            'id': localId,
            'survey_id': widget.surveyId,
            'household_id': widget.householdId,
            'incident_type': record.incidentType,
            'pest_data_json': jsonEncode(payload),
            'created_at': DateTime.now().toIso8601String(),
          });
          final opId = 'pest_${widget.surveyId}_$localId';
          final opPayload = jsonEncode({...payload, 'id': localId});
          await LocalDatabaseService.instance.enqueueSyncOperation(
            operationId: opId,
            targetTable: 'pests_diseases',
            operationType: 'upsert',
            surveyId: widget.surveyId,
            householdId: widget.householdId,
            recordId: localId,
            payloadJson: opPayload,
          );
          // Fix 2: refresh payload on repeated saves
          await LocalDatabaseService.instance.updatePendingSyncPayload(
            operationId: opId,
            payloadJson: opPayload,
          );
        } catch (localErr) {
          debugPrint(
            '[LocalDB] PestDisease dual-write error (non-fatal): $localErr',
          );
        }
      }

      // ── Supabase write (online only) ──────────────────────────────────────
      if (isOnline) {
        final client = SupabaseService.instance.client;
        if (record.id != null) {
          await client
              .from('pests_diseases')
              .update(payload)
              .eq('id', record.id!);
          if (mounted) {
            setState(() {
              final idx = _records.indexWhere((r) => r.id == record.id);
              if (idx >= 0) _records[idx] = record;
            });
          }
        } else {
          final inserted = await client
              .from('pests_diseases')
              .insert(payload)
              .select()
              .single();
          final saved = PestDiseaseRecord.fromDbRow(
            Map<String, dynamic>.from(inserted),
          );
          if (mounted) {
            setState(() => _records.add(saved));
          }
        }
      } else {
        // Offline: add to in-memory list with a temporary ID
        if (record.id == null) {
          final tempRecord = record.copyWith(id: const Uuid().v4());
          if (mounted) setState(() => _records.add(tempRecord));
        } else {
          if (mounted) {
            setState(() {
              final idx = _records.indexWhere((r) => r.id == record.id);
              if (idx >= 0) _records[idx] = record;
            });
          }
        }
      }

      Fluttertoast.showToast(
        msg: isOnline
            ? (record.id != null ? 'Record updated' : 'Record saved')
            : 'Record saved locally',
        backgroundColor: AppTheme.success,
        textColor: Colors.white,
      );
    } catch (e) {
      if (e is PostgrestException) {
        debugPrint(
          'PestDiseaseSectionWidget INSERT failed (PostgrestException):',
        );
        debugPrint('  code:    ${(e).code}');
        debugPrint('  message: ${(e).message}');
        debugPrint('  details: ${(e).details}');
        debugPrint('  hint:    ${(e).hint}');
        debugPrint('  payload: $payload');
      } else {
        debugPrint('PestDiseaseSectionWidget save error (non-Postgrest): $e');
      }
      Fluttertoast.showToast(
        msg: 'Failed to save record. Please try again.',
        backgroundColor: AppTheme.error,
        textColor: Colors.white,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteRecord(PestDiseaseRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Delete Record',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Delete "${record.pestDiseaseName}" (${record.cropName})?',
          style: GoogleFonts.manrope(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: GoogleFonts.manrope()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            child: Text(
              'Delete',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final recordId = record.id;
    if (recordId == null || recordId.isEmpty) {
      if (mounted) {
        setState(() {
          _records.removeWhere((r) => identical(r, record));
        });
      }
      return;
    }

    try {
      final db = LocalDatabaseService.instance;

      if (!db.isAvailable) {
        throw StateError('Local database is unavailable');
      }

      await db.queuePestDiseaseDeletion(
        surveyId: widget.surveyId,
        householdId: widget.householdId,
        recordId: recordId,
      );

      await db.deletePestDisease(recordId);

      if (mounted) {
        setState(() {
          _records.removeWhere((r) => r.id == recordId);
        });
      }

      Fluttertoast.showToast(
        msg: ConnectivityService.instance.isOnline
            ? 'Record deleted locally; server deletion queued'
            : 'Record deleted locally; will sync when online',
        backgroundColor: AppTheme.warning,
        textColor: Colors.white,
      );
    } catch (e) {
      debugPrint('Crop pest/disease delete error: $e');

      Fluttertoast.showToast(
        msg: 'Failed to delete record. Please try again.',
        backgroundColor: AppTheme.error,
        textColor: Colors.white,
      );
    }
  }

  void _openAddEditDialog({PestDiseaseRecord? existing, required String type}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _PestDiseaseFormDialog(
        incidentType: type,
        existing: existing,
        onSave: (record) {
          Navigator.pop(ctx);
          _saveRecord(record);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pestRecords = _records
        .where((r) => r.incidentType == 'pest')
        .toList();
    final diseaseRecords = _records
        .where((r) => r.incidentType == 'disease')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.primary.withAlpha(60)),
          ),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'E: Crop Pest & Disease Management',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          // ── E.1 Pest Incidence ──────────────────────────────────
          _buildSubsectionHeader(
            context,
            'E.1 Pest Incidence',
            Icons.bug_report_outlined,
            Colors.orange,
          ),
          if (pestRecords.isEmpty)
            _buildEmptyState('No pest records added yet.')
          else
            ...pestRecords.map(
              (r) => _buildRecordCard(context, record: r, theme: theme),
            ),
          if (!widget.isReadOnly)
            _buildAddButton(
              label: 'Add Pest Record',
              color: Colors.orange,
              onTap: () => _openAddEditDialog(type: 'pest'),
            ),

          const SizedBox(height: 8),

          // ── E.2 Disease Incidence ───────────────────────────────
          _buildSubsectionHeader(
            context,
            'E.2 Disease Incidence',
            Icons.coronavirus_outlined,
            Colors.red,
          ),
          if (diseaseRecords.isEmpty)
            _buildEmptyState('No disease records added yet.')
          else
            ...diseaseRecords.map(
              (r) => _buildRecordCard(context, record: r, theme: theme),
            ),
          if (!widget.isReadOnly)
            _buildAddButton(
              label: 'Add Disease Record',
              color: Colors.red,
              onTap: () => _openAddEditDialog(type: 'disease'),
            ),

          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildSubsectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Text(
        message,
        style: GoogleFonts.manrope(
          fontSize: 12,
          color: Colors.grey.shade500,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildAddButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: OutlinedButton.icon(
        onPressed: _isSaving ? null : onTap,
        icon: Icon(Icons.add_circle_outline, size: 16, color: color),
        label: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withAlpha(150)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildRecordCard(
    BuildContext context, {
    required PestDiseaseRecord record,
    required ThemeData theme,
  }) {
    final isPest = record.incidentType == 'pest';
    final accentColor = isPest ? Colors.orange : Colors.red;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accentColor.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.pestDiseaseName.isNotEmpty
                          ? record.pestDiseaseName
                          : '(unnamed)',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Crop: ${record.cropName.isNotEmpty ? record.cropName : "—"}',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!widget.isReadOnly) ...[
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                  onPressed: () => _openAddEditDialog(
                    existing: record,
                    type: record.incidentType,
                  ),
                  tooltip: 'Edit',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: AppTheme.error,
                  ),
                  onPressed: () => _deleteRecord(record),
                  tooltip: 'Delete',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              if (record.cropStage != null && record.cropStage!.isNotEmpty)
                _chip('Stage: ${record.cropStage!}', accentColor),
              if (isPest) ...[
                if (record.infestationLevel != null &&
                    record.infestationLevel!.isNotEmpty)
                  _chip(
                    'Infestation: ${record.infestationLevel!}',
                    accentColor,
                  ),
                if (record.attackFrequency != null &&
                    record.attackFrequency!.isNotEmpty)
                  _chip('Frequency: ${record.attackFrequency!}', accentColor),
              ] else ...[
                if (record.diseaseType != null &&
                    record.diseaseType!.isNotEmpty)
                  _chip('Type: ${record.diseaseType!}', accentColor),
                if (record.severity != null && record.severity!.isNotEmpty)
                  _chip('Severity: ${record.severity!}', accentColor),
              ],
            ],
          ),
          if (record.symptoms != null && record.symptoms!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Symptoms: ${record.symptoms!}',
              style: GoogleFonts.manrope(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (!isPest &&
              record.controlMethod != null &&
              record.controlMethod!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Control: ${record.controlMethod!}',
              style: GoogleFonts.manrope(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add / Edit Form Dialog
// ─────────────────────────────────────────────────────────────────────────────
class _PestDiseaseFormDialog extends StatefulWidget {
  final String incidentType;
  final PestDiseaseRecord? existing;
  final ValueChanged<PestDiseaseRecord> onSave;

  const _PestDiseaseFormDialog({
    required this.incidentType,
    this.existing,
    required this.onSave,
  });

  @override
  State<_PestDiseaseFormDialog> createState() => _PestDiseaseFormDialogState();
}

class _PestDiseaseFormDialogState extends State<_PestDiseaseFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cropNameCtrl;
  late final TextEditingController _pestDiseaseNameCtrl;
  late final TextEditingController _symptomsCtrl;
  late final TextEditingController _controlMethodCtrl;

  String? _cropStage;
  String? _infestationLevel;
  String? _attackFrequency;
  String? _severity;
  String? _diseaseType;

  static const _cropStages = [
    'Seedling',
    'Vegetative',
    'Flowering',
    'Fruiting',
  ];
  static const _infestationLevels = ['Low', 'Medium', 'High'];
  static const _attackFrequencies = ['Rare', 'Seasonal', 'Frequent'];
  static const _severities = ['Mild', 'Moderate', 'Severe'];
  static const _diseaseTypes = ['Fungal', 'Bacterial', 'Viral'];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _cropNameCtrl = TextEditingController(text: e?.cropName ?? '');
    _pestDiseaseNameCtrl = TextEditingController(
      text: e?.pestDiseaseName ?? '',
    );
    _symptomsCtrl = TextEditingController(text: e?.symptoms ?? '');
    _controlMethodCtrl = TextEditingController(text: e?.controlMethod ?? '');
    _cropStage = e?.cropStage;
    _infestationLevel = e?.infestationLevel;
    _attackFrequency = e?.attackFrequency;
    _severity = e?.severity;
    _diseaseType = e?.diseaseType;
  }

  @override
  void dispose() {
    _cropNameCtrl.dispose();
    _pestDiseaseNameCtrl.dispose();
    _symptomsCtrl.dispose();
    _controlMethodCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final isPest = widget.incidentType == 'pest';
    final record = PestDiseaseRecord(
      id: widget.existing?.id,
      incidentType: widget.incidentType,
      cropName: _cropNameCtrl.text.trim(),
      pestDiseaseName: _pestDiseaseNameCtrl.text.trim(),
      cropStage: _cropStage,
      infestationLevel: isPest ? _infestationLevel : null,
      attackFrequency: isPest ? _attackFrequency : null,
      symptoms: _symptomsCtrl.text.trim().isEmpty
          ? null
          : _symptomsCtrl.text.trim(),
      severity: isPest ? null : _severity,
      diseaseType: isPest ? null : _diseaseType,
      controlMethod: isPest
          ? null
          : (_controlMethodCtrl.text.trim().isEmpty
                ? null
                : _controlMethodCtrl.text.trim()),
    );
    widget.onSave(record);
  }

  @override
  Widget build(BuildContext context) {
    final isPest = widget.incidentType == 'pest';
    final title = isPest ? 'E.1 — Add Pest Record' : 'E.2 — Add Disease Record';
    final editTitle = isPest
        ? 'E.1 — Edit Pest Record'
        : 'E.2 — Edit Disease Record';
    final accentColor = isPest ? Colors.orange : Colors.red;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
              decoration: BoxDecoration(
                color: accentColor.withAlpha(25),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isPest
                        ? Icons.bug_report_outlined
                        : Icons.coronavirus_outlined,
                    color: accentColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.existing != null ? editTitle : title,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ),

            // Form body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Crop name
                      _buildTextField(
                        controller: _cropNameCtrl,
                        label: 'Name of Crop *',
                        hint: 'e.g. Rice, Maize, Tomato',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Crop name is required'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // Pest / Disease name
                      _buildTextField(
                        controller: _pestDiseaseNameCtrl,
                        label: isPest
                            ? 'Major Insect Pest Observed *'
                            : 'Major Disease Observed *',
                        hint: isPest
                            ? 'e.g. Stem borer, Aphids'
                            : 'e.g. Blast, Blight',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'This field is required'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // Disease type (disease only)
                      if (!isPest) ...[
                        _buildDropdown(
                          label: 'Type of Disease',
                          value: _diseaseType,
                          items: _diseaseTypes,
                          onChanged: (v) => setState(() => _diseaseType = v),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Crop stage
                      _buildDropdown(
                        label: 'Stage of Crop Affected',
                        value: _cropStage,
                        items: _cropStages,
                        onChanged: (v) => setState(() => _cropStage = v),
                      ),
                      const SizedBox(height: 12),

                      // Pest-specific fields
                      if (isPest) ...[
                        _buildDropdown(
                          label: 'Level of Pest Infestation',
                          value: _infestationLevel,
                          items: _infestationLevels,
                          onChanged: (v) =>
                              setState(() => _infestationLevel = v),
                        ),
                        const SizedBox(height: 12),
                        _buildDropdown(
                          label: 'Frequency of Pest Attack',
                          value: _attackFrequency,
                          items: _attackFrequencies,
                          onChanged: (v) =>
                              setState(() => _attackFrequency = v),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Disease severity (disease only)
                      if (!isPest) ...[
                        _buildDropdown(
                          label: 'Severity',
                          value: _severity,
                          items: _severities,
                          onChanged: (v) => setState(() => _severity = v),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Symptoms
                      _buildTextField(
                        controller: _symptomsCtrl,
                        label: 'Symptoms Observed',
                        hint: 'Describe visible symptoms',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),

                      // Control method (disease only — text field per spec)
                      if (!isPest) ...[
                        _buildTextField(
                          controller: _controlMethodCtrl,
                          label: 'Methods Used to Control',
                          hint: 'e.g. Bio-pesticides, Cultural practices',
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        widget.existing != null ? 'Update' : 'Save',
                        style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.manrope(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
            ),
            isDense: true,
          ),
          style: GoogleFonts.manrope(fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: GoogleFonts.manrope(fontSize: 13)),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
            ),
            isDense: true,
          ),
          hint: Text(
            'Select...',
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
          ),
          isExpanded: true,
          style: GoogleFonts.manrope(fontSize: 13, color: Colors.grey.shade800),
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data model for a single pests_diseases record (Section F — Livestock)
// Uses the same pests_diseases table but with incident_type = 'livestock_pest'
// or 'livestock_disease'. crop_name stores the livestock name.
// Section E records (incident_type = 'pest' | 'disease') are never touched.
//
// OFFLINE-SYNC CONTRACT (F.1 / F.2):
//   • Every record carries a stable client-generated UUID in [id].
//   • The UUID is assigned before the record is first persisted and never
//     changes through UI state, local persistence, or Supabase sync.
//   • [toDbMap] always includes the id so that upsert is idempotent.
//   • Retrying the same save will update the same DB row (no duplicates).
//   • Editing preserves the UUID via [copyWith].
//   • Deletion uses the same UUID to target the exact DB row.
// ─────────────────────────────────────────────────────────────────────────────
class LivestockPestDiseaseRecord {
  /// Stable client-generated UUID. Never null — assigned before first save.
  final String id;
  final String incidentType; // 'livestock_pest' | 'livestock_disease'
  final String livestockName; // stored in crop_name column
  final String pestDiseaseName;
  final String? animalStage; // Young / Adult / Pregnancy / Old / All time
  final String? infestationLevel; // livestock_pest only: Low / Medium / High
  final String?
  attackFrequency; // livestock_pest only: Rare / Seasonal / Frequent
  final String? symptoms;
  final String?
  diseaseType; // livestock_disease only: Fungal / Bacterial / Viral
  final String? severity; // livestock_disease only: Mild / Moderate / Severe
  final String? controlMethod; // livestock_disease only

  const LivestockPestDiseaseRecord({
    required this.id,
    required this.incidentType,
    required this.livestockName,
    required this.pestDiseaseName,
    this.animalStage,
    this.infestationLevel,
    this.attackFrequency,
    this.symptoms,
    this.diseaseType,
    this.severity,
    this.controlMethod,
  });

  LivestockPestDiseaseRecord copyWith({
    String? id,
    String? incidentType,
    String? livestockName,
    String? pestDiseaseName,
    String? animalStage,
    String? infestationLevel,
    String? attackFrequency,
    String? symptoms,
    String? diseaseType,
    String? severity,
    String? controlMethod,
  }) {
    return LivestockPestDiseaseRecord(
      id: id ?? this.id,
      incidentType: incidentType ?? this.incidentType,
      livestockName: livestockName ?? this.livestockName,
      pestDiseaseName: pestDiseaseName ?? this.pestDiseaseName,
      animalStage: animalStage ?? this.animalStage,
      infestationLevel: infestationLevel ?? this.infestationLevel,
      attackFrequency: attackFrequency ?? this.attackFrequency,
      symptoms: symptoms ?? this.symptoms,
      diseaseType: diseaseType ?? this.diseaseType,
      severity: severity ?? this.severity,
      controlMethod: controlMethod ?? this.controlMethod,
    );
  }

  /// Produces the DB payload including the stable [id].
  /// Always used for upsert so the same UUID targets the same row.
  Map<String, dynamic> toDbMap(String householdId, String surveyId) => {
    'id': id,
    'household_id': householdId,
    'survey_id': surveyId,
    'incident_type': incidentType,
    'crop_name': livestockName, // repurposed column
    'pest_disease_name': pestDiseaseName,
    'animal_stage': animalStage,
    'infestation_level': infestationLevel,
    'attack_frequency': attackFrequency,
    'symptoms': symptoms,
    'disease_type': diseaseType,
    'severity': severity,
    'control_method': controlMethod,
  };

  factory LivestockPestDiseaseRecord.fromDbRow(Map<String, dynamic> row) {
    return LivestockPestDiseaseRecord(
      id: row['id'] as String,
      incidentType: (row['incident_type'] as String?) ?? 'livestock_pest',
      livestockName: (row['crop_name'] as String?) ?? '',
      pestDiseaseName: (row['pest_disease_name'] as String?) ?? '',
      animalStage: row['animal_stage'] as String?,
      infestationLevel: row['infestation_level'] as String?,
      attackFrequency: row['attack_frequency'] as String?,
      symptoms: row['symptoms'] as String?,
      diseaseType: row['disease_type'] as String?,
      severity: row['severity'] as String?,
      controlMethod: row['control_method'] as String?,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section F Widget — Livestock Pest & Disease Management
// Completely separate from PestDiseaseSectionWidget (Section E).
// Only loads/saves records with incident_type IN ('livestock_pest','livestock_disease').
// ─────────────────────────────────────────────────────────────────────────────
class LivestockPestDiseaseSectionWidget extends StatefulWidget {
  final String householdId;
  final String surveyId;
  final bool isReadOnly;

  const LivestockPestDiseaseSectionWidget({
    super.key,
    required this.householdId,
    required this.surveyId,
    this.isReadOnly = false,
  });

  @override
  State<LivestockPestDiseaseSectionWidget> createState() =>
      _LivestockPestDiseaseSectionWidgetState();
}

class _LivestockPestDiseaseSectionWidgetState
    extends State<LivestockPestDiseaseSectionWidget> {
  List<LivestockPestDiseaseRecord> _records = [];
  bool _isLoading = true;
  bool _isSaving = false;

  static const _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    if (widget.surveyId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final db = LocalDatabaseService.instance;
    final recordsById = <String, LivestockPestDiseaseRecord>{};
    final pendingOperations = await db.getPendingSyncOperations();

    final pendingDeletionIds = pendingOperations
        .where(
          (op) =>
              op['target_table'] == 'pests_diseases' &&
              op['operation_type'] == 'delete' &&
              op['survey_id']?.toString() == widget.surveyId &&
              op['household_id']?.toString() == widget.householdId,
        )
        .map((op) => op['record_id']?.toString())
        .whereType<String>()
        .toSet();
    try {
      // Load locally saved records first, including offline saves.
      if (db.isAvailable) {
        final localRows = await db.getPestsDiseases(
          surveyId: widget.surveyId,
          householdId: widget.householdId,
        );

        for (final row in localRows) {
          final incidentType = row['incident_type']?.toString() ?? '';
          if (incidentType != 'livestock_pest' &&
              incidentType != 'livestock_disease') {
            continue;
          }

          try {
            final rawJson = row['pest_data_json']?.toString();
            if (rawJson == null || rawJson.isEmpty) continue;

            final decoded = jsonDecode(rawJson);
            if (decoded is! Map) continue;

            final payload = Map<String, dynamic>.from(decoded);
            payload['id'] ??= row['id'];
            payload['household_id'] ??= widget.householdId;
            payload['survey_id'] ??= widget.surveyId;
            payload['incident_type'] ??= incidentType;

            final record = LivestockPestDiseaseRecord.fromDbRow(payload);
            recordsById[record.id] = record;
          } catch (e) {
            debugPrint('Could not parse local livestock record: $e');
          }
        }
      }

      // Merge server records when online. Local values take precedence.
      if (ConnectivityService.instance.isOnline) {
        try {
          final rows = await SupabaseService.instance.client
              .from('pests_diseases')
              .select()
              .eq('household_id', widget.householdId)
              .eq('survey_id', widget.surveyId)
              .inFilter('incident_type', [
                'livestock_pest',
                'livestock_disease',
              ])
              .order('created_at', ascending: true);

          for (final row in rows as List) {
            final record = LivestockPestDiseaseRecord.fromDbRow(
              Map<String, dynamic>.from(row),
            );

            if (pendingDeletionIds.contains(record.id)) {
              continue;
            }

            recordsById.putIfAbsent(record.id, () => record);
          }
        } catch (e) {
          debugPrint('Livestock server load failed; using local data: $e');
        }
      }

      if (mounted) {
        setState(() {
          _records = recordsById.values.toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Livestock local load error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Persists a record using idempotent upsert keyed on the record's stable UUID.
  /// Retrying the same record updates the same DB row and never creates a duplicate.
  Future<void> _saveRecord(LivestockPestDiseaseRecord record) async {
    if (!mounted) return;

    setState(() => _isSaving = true);

    final payload = record.toDbMap(widget.householdId, widget.surveyId);
    final db = LocalDatabaseService.instance;
    final isOnline = ConnectivityService.instance.isOnline;

    try {
      // 1. Save locally first. Keep the record's stable UUID.
      if (!db.isAvailable) {
        throw StateError('Local database is unavailable.');
      }

      await db.upsertPestDisease({
        'id': record.id,
        'survey_id': widget.surveyId,
        'household_id': widget.householdId,
        'incident_type': record.incidentType,
        'pest_data_json': jsonEncode(payload),
        'created_at': DateTime.now().toIso8601String(),
      });

      // 2. Queue an idempotent upsert for synchronization.
      final operationId = 'pest_${widget.surveyId}_${record.id}';
      final payloadJson = jsonEncode(payload);

      await db.enqueueSyncOperation(
        operationId: operationId,
        targetTable: 'pests_diseases',
        operationType: 'upsert',
        surveyId: widget.surveyId,
        householdId: widget.householdId,
        recordId: record.id,
        payloadJson: payloadJson,
      );

      await db.updatePendingSyncPayload(
        operationId: operationId,
        payloadJson: payloadJson,
      );

      // 3. Update the screen immediately after the local save.
      if (mounted) {
        setState(() {
          final index = _records.indexWhere((r) => r.id == record.id);
          if (index >= 0) {
            _records[index] = record;
          } else {
            _records.add(record);
          }
        });
      }

      // 4. Online sync is best-effort; local data remains saved on failure.
      if (isOnline) {
        try {
          await SupabaseService.instance.client
              .from('pests_diseases')
              .upsert(payload, onConflict: 'id');

          await db.markSyncOperationComplete(operationId);
        } catch (syncError) {
          debugPrint(
            'Livestock record saved locally; sync pending: $syncError',
          );
        }
      }

      Fluttertoast.showToast(
        msg: isOnline
            ? 'Record saved locally; sync queued if needed'
            : 'Record saved locally',
        backgroundColor: AppTheme.success,
        textColor: Colors.white,
      );
    } catch (e) {
      debugPrint('Livestock local save failed: $e');

      Fluttertoast.showToast(
        msg: 'Local save failed: ${e.toString()}',
        backgroundColor: AppTheme.error,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  /// Helper widget for the error dialog rows.
  Widget _errorRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
              ),
            ),
            TextSpan(
              text: value,
              style: GoogleFonts.manrope(
                fontSize: 11,
                color: Colors.grey.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteRecord(LivestockPestDiseaseRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Delete Record',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Delete "${record.pestDiseaseName}" (${record.livestockName})?',
          style: GoogleFonts.manrope(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: GoogleFonts.manrope()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.error),
            child: Text(
              'Delete',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final db = LocalDatabaseService.instance;

      if (!db.isAvailable) {
        throw StateError('Local database is unavailable');
      }

      await db.queuePestDiseaseDeletion(
        surveyId: widget.surveyId,
        householdId: widget.householdId,
        recordId: record.id,
      );

      await db.deletePestDisease(record.id);

      if (mounted) {
        setState(() {
          _records.removeWhere((r) => r.id == record.id);
        });
      }

      Fluttertoast.showToast(
        msg: ConnectivityService.instance.isOnline
            ? 'Record deleted locally; server deletion queued'
            : 'Record deleted locally; will sync when online',
        backgroundColor: AppTheme.warning,
        textColor: Colors.white,
      );
    } catch (e) {
      debugPrint('Livestock pest/disease delete error: $e');

      Fluttertoast.showToast(
        msg: 'Failed to delete record. Please try again.',
        backgroundColor: AppTheme.error,
        textColor: Colors.white,
      );
    }
  }

  void _openAddEditDialog({
    LivestockPestDiseaseRecord? existing,
    required String type,
  }) {
    // For new records: assign a stable client-generated UUID now, before the
    // dialog opens. This UUID travels with the record through UI state and
    // into the DB upsert — it is never replaced.
    // For existing records: the UUID is preserved from the loaded/saved record.
    final recordForDialog =
        existing ??
        LivestockPestDiseaseRecord(
          id: _uuid.v4(),
          incidentType: type,
          livestockName: '',
          pestDiseaseName: '',
        );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _LivestockFormDialog(
        incidentType: type,
        existing: recordForDialog,
        onSave: (record) {
          Navigator.pop(ctx);
          _saveRecord(record);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pestRecords = _records
        .where((r) => r.incidentType == 'livestock_pest')
        .toList();
    final diseaseRecords = _records
        .where((r) => r.incidentType == 'livestock_disease')
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.teal.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.teal.withAlpha(60)),
          ),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'F: Livestock Pest & Disease Management',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.teal.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          // ── F.1 Livestock Pest Incidence ────────────────────────
          _buildSubsectionHeader(
            context,
            'F.1 Livestock Pest Incidence',
            Icons.pest_control_outlined,
            Colors.orange.shade700,
          ),
          if (pestRecords.isEmpty)
            _buildEmptyState('No livestock pest records added yet.')
          else
            ...pestRecords.map(
              (r) => _buildRecordCard(context, record: r, theme: theme),
            ),
          if (!widget.isReadOnly)
            _buildAddButton(
              label: 'Add Livestock Pest Record',
              color: Colors.orange.shade700,
              onTap: () => _openAddEditDialog(type: 'livestock_pest'),
            ),

          const SizedBox(height: 8),

          // ── F.2 Livestock Disease Incidence ─────────────────────
          _buildSubsectionHeader(
            context,
            'F.2 Livestock Disease Incidence',
            Icons.vaccines_outlined,
            Colors.red.shade700,
          ),
          if (diseaseRecords.isEmpty)
            _buildEmptyState('No livestock disease records added yet.')
          else
            ...diseaseRecords.map(
              (r) => _buildRecordCard(context, record: r, theme: theme),
            ),
          if (!widget.isReadOnly)
            _buildAddButton(
              label: 'Add Livestock Disease Record',
              color: Colors.red.shade700,
              onTap: () => _openAddEditDialog(type: 'livestock_disease'),
            ),

          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildSubsectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Text(
        message,
        style: GoogleFonts.manrope(
          fontSize: 12,
          color: Colors.grey.shade500,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildAddButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: OutlinedButton.icon(
        onPressed: _isSaving ? null : onTap,
        icon: Icon(Icons.add_circle_outline, size: 16, color: color),
        label: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withAlpha(150)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildRecordCard(
    BuildContext context, {
    required LivestockPestDiseaseRecord record,
    required ThemeData theme,
  }) {
    final isPest = record.incidentType == 'livestock_pest';
    final accentColor = isPest ? Colors.orange.shade700 : Colors.red.shade700;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accentColor.withAlpha(80)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.pestDiseaseName.isNotEmpty
                          ? record.pestDiseaseName
                          : '(unnamed)',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Livestock: ${record.livestockName.isNotEmpty ? record.livestockName : "—"}',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!widget.isReadOnly) ...[
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppTheme.primary,
                  ),
                  onPressed: () => _openAddEditDialog(
                    existing: record,
                    type: record.incidentType,
                  ),
                  tooltip: 'Edit',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: AppTheme.error,
                  ),
                  onPressed: () => _deleteRecord(record),
                  tooltip: 'Delete',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              if (record.animalStage != null && record.animalStage!.isNotEmpty)
                _chip('Stage: ${record.animalStage!}', accentColor),
              if (isPest) ...[
                if (record.infestationLevel != null &&
                    record.infestationLevel!.isNotEmpty)
                  _chip(
                    'Infestation: ${record.infestationLevel!}',
                    accentColor,
                  ),
                if (record.attackFrequency != null &&
                    record.attackFrequency!.isNotEmpty)
                  _chip('Frequency: ${record.attackFrequency!}', accentColor),
              ] else ...[
                if (record.diseaseType != null &&
                    record.diseaseType!.isNotEmpty)
                  _chip('Type: ${record.diseaseType!}', accentColor),
                if (record.severity != null && record.severity!.isNotEmpty)
                  _chip('Severity: ${record.severity!}', accentColor),
              ],
            ],
          ),
          if (record.symptoms != null && record.symptoms!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Symptoms: ${record.symptoms!}',
              style: GoogleFonts.manrope(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (!isPest &&
              record.controlMethod != null &&
              record.controlMethod!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Control: ${record.controlMethod!}',
              style: GoogleFonts.manrope(
                fontSize: 11,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add / Edit Form Dialog for Livestock Pest / Disease (Section F)
// ─────────────────────────────────────────────────────────────────────────────
class _LivestockFormDialog extends StatefulWidget {
  final String incidentType; // 'livestock_pest' | 'livestock_disease'
  /// Always non-null: caller pre-assigns a UUID for new records.
  final LivestockPestDiseaseRecord existing;
  final ValueChanged<LivestockPestDiseaseRecord> onSave;

  const _LivestockFormDialog({
    required this.incidentType,
    required this.existing,
    required this.onSave,
  });

  @override
  State<_LivestockFormDialog> createState() => _LivestockFormDialogState();
}

class _LivestockFormDialogState extends State<_LivestockFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _livestockNameCtrl;
  late final TextEditingController _pestDiseaseNameCtrl;
  late final TextEditingController _symptomsCtrl;
  late final TextEditingController _controlMethodCtrl;

  String? _animalStage;
  String? _infestationLevel;
  String? _attackFrequency;
  String? _severity;
  String? _diseaseType;

  static const _animalStages = [
    'Young',
    'Adult',
    'Pregnancy',
    'Old',
    'All time',
  ];
  static const _infestationLevels = ['Low', 'Medium', 'High'];
  static const _attackFrequencies = ['Rare', 'Seasonal', 'Frequent'];
  static const _severities = ['Mild', 'Moderate', 'Severe'];
  static const _diseaseTypes = ['Fungal', 'Bacterial', 'Viral'];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _livestockNameCtrl = TextEditingController(text: e.livestockName);
    _pestDiseaseNameCtrl = TextEditingController(text: e.pestDiseaseName);
    _symptomsCtrl = TextEditingController(text: e.symptoms ?? '');
    _controlMethodCtrl = TextEditingController(text: e.controlMethod ?? '');
    _animalStage = e.animalStage;
    _infestationLevel = e.infestationLevel;
    _attackFrequency = e.attackFrequency;
    _severity = e.severity;
    _diseaseType = e.diseaseType;
  }

  @override
  void dispose() {
    _livestockNameCtrl.dispose();
    _pestDiseaseNameCtrl.dispose();
    _symptomsCtrl.dispose();
    _controlMethodCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final isPest = widget.incidentType == 'livestock_pest';
    // existing is always non-null: _openAddEditDialog always supplies a record
    // (with a pre-assigned UUID for new records, or the loaded UUID for edits).
    final record = LivestockPestDiseaseRecord(
      id: widget.existing.id,
      incidentType: widget.incidentType,
      livestockName: _livestockNameCtrl.text.trim(),
      pestDiseaseName: _pestDiseaseNameCtrl.text.trim(),
      animalStage: _animalStage,
      infestationLevel: isPest ? _infestationLevel : null,
      attackFrequency: isPest ? _attackFrequency : null,
      symptoms: _symptomsCtrl.text.trim().isEmpty
          ? null
          : _symptomsCtrl.text.trim(),
      diseaseType: isPest ? null : _diseaseType,
      severity: isPest ? null : _severity,
      controlMethod: isPest
          ? null
          : (_controlMethodCtrl.text.trim().isEmpty
                ? null
                : _controlMethodCtrl.text.trim()),
    );
    widget.onSave(record);
  }

  @override
  Widget build(BuildContext context) {
    final isPest = widget.incidentType == 'livestock_pest';
    final title = isPest
        ? 'F.1 — Add Livestock Pest Record'
        : 'F.2 — Add Livestock Disease Record';
    final editTitle = isPest
        ? 'F.1 — Edit Livestock Pest Record'
        : 'F.2 — Edit Livestock Disease Record';
    final accentColor = isPest ? Colors.orange.shade700 : Colors.red.shade700;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
              decoration: BoxDecoration(
                color: accentColor.withAlpha(25),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isPest
                        ? Icons.pest_control_outlined
                        : Icons.vaccines_outlined,
                    color: accentColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      editTitle,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: accentColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
                ],
              ),
            ),

            // Form body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Livestock name (repurposed crop_name column)
                      _buildTextField(
                        controller: _livestockNameCtrl,
                        label: 'Name of the livestock *',
                        hint: 'e.g. Cattle, Pig, Poultry',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Livestock name is required'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // Pest / Disease name
                      _buildTextField(
                        controller: _pestDiseaseNameCtrl,
                        label: isPest
                            ? 'Name of major insect pests observed in livestock *'
                            : 'Name of major diseases observed in livestock *',
                        hint: isPest
                            ? 'e.g. Ticks, Lice, Mites'
                            : 'e.g. FMD, Swine fever, Newcastle disease',
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'This field is required'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // Animal stage
                      _buildDropdown(
                        label: 'Stage when animal affected',
                        value: _animalStage,
                        items: _animalStages,
                        onChanged: (v) => setState(() => _animalStage = v),
                      ),
                      const SizedBox(height: 12),

                      // Pest-specific fields
                      if (isPest) ...[
                        _buildDropdown(
                          label: 'Level of pest infestation',
                          value: _infestationLevel,
                          items: _infestationLevels,
                          onChanged: (v) =>
                              setState(() => _infestationLevel = v),
                        ),
                        const SizedBox(height: 12),
                        _buildDropdown(
                          label: 'Frequency of pest attack',
                          value: _attackFrequency,
                          items: _attackFrequencies,
                          onChanged: (v) =>
                              setState(() => _attackFrequency = v),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Disease-specific fields
                      if (!isPest) ...[
                        _buildDropdown(
                          label: 'Type of disease',
                          value: _diseaseType,
                          items: _diseaseTypes,
                          onChanged: (v) => setState(() => _diseaseType = v),
                        ),
                        const SizedBox(height: 12),
                        _buildDropdown(
                          label: 'Severity of disease',
                          value: _severity,
                          items: _severities,
                          onChanged: (v) => setState(() => _severity = v),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Symptoms
                      _buildTextField(
                        controller: _symptomsCtrl,
                        label: 'Symptoms observed',
                        hint: 'Describe visible symptoms',
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),

                      // Control method (disease only)
                      if (!isPest) ...[
                        _buildTextField(
                          controller: _controlMethodCtrl,
                          label: 'Methods used to control',
                          hint: 'e.g. Vaccination, Veterinary treatment',
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Update',
                        style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.manrope(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
            ),
            isDense: true,
          ),
          style: GoogleFonts.manrope(fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item, style: GoogleFonts.manrope(fontSize: 13)),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
            ),
            isDense: true,
          ),
          hint: Text(
            'Select...',
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
          ),
          isExpanded: true,
          style: GoogleFonts.manrope(fontSize: 13, color: Colors.grey.shade800),
          dropdownColor: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
        ),
      ],
    );
  }
}

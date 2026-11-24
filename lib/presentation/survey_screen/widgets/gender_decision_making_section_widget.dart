import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../../theme/app_theme.dart';

// ─── Constants ───────────────────────────────────────────────────────────────

/// The five fixed activity rows for R-02.
const List<Map<String, String>> _kActivities = [
  {'code': 'crop_selection', 'label': 'Crop selection'},
  {'code': 'input_purchase', 'label': 'Input purchase'},
  {'code': 'sale_of_produce', 'label': 'Sale of produce'},
  {'code': 'livestock_management', 'label': 'Livestock management'},
  {'code': 'use_of_income', 'label': 'Use of income'},
];

// ─── Data model for R-02 activity row ────────────────────────────────────────

class _ActivityRow {
  /// Stable client-generated UUID — generated once, reused on every reopen.
  final String id;
  final String activityCode;
  final String activityLabel;

  /// 'male' | 'female' | 'joint' | ''
  String decision;

  /// Free text remarks (stored as empty string when blank).
  String remarks;

  _ActivityRow({
    required this.id,
    required this.activityCode,
    required this.activityLabel,
    this.decision = '',
    this.remarks = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'activity_code': activityCode,
    'activity_label': activityLabel,
    'decision': decision,
    'remarks': remarks,
  };

  factory _ActivityRow.fromJson(Map<String, dynamic> json) {
    final persistedId = (json['id'] as String?)?.trim() ?? '';
    return _ActivityRow(
      id: persistedId.isNotEmpty ? persistedId : const Uuid().v4(),
      activityCode: (json['activity_code'] as String?) ?? '',
      activityLabel: (json['activity_label'] as String?) ?? '',
      decision: (json['decision'] as String?) ?? '',
      remarks: (json['remarks'] as String?) ?? '',
    );
  }
}

// ─── Widget ───────────────────────────────────────────────────────────────────

/// Section R — Gender & Decision Making.
///
/// Handles R-01 through R-05 as a single logical screen.
/// All answers are stored under the key [kGenderDecisionMakingKey] in
/// surveys.responses as a JSON map.
///
/// Usage:
///   GenderDecisionMakingSectionWidget(
///     answer: _answers[kGenderDecisionMakingKey],
///     onAnswer: (value) => _onAnswer(kGenderDecisionMakingKey, value),
///     isReadOnly: false,
///   )
const String kGenderDecisionMakingKey = 'R-GENDER-DECISION-MAKING';

class GenderDecisionMakingSectionWidget extends StatefulWidget {
  /// The current stored answer (a Map or JSON string from surveys.responses).
  final dynamic answer;

  /// Called whenever any field changes; receives the updated Map.
  final ValueChanged<Map<String, dynamic>> onAnswer;

  /// When true, all fields are read-only.
  final bool isReadOnly;

  const GenderDecisionMakingSectionWidget({
    super.key,
    required this.answer,
    required this.onAnswer,
    this.isReadOnly = false,
  });

  @override
  State<GenderDecisionMakingSectionWidget> createState() =>
      _GenderDecisionMakingSectionWidgetState();
}

class _GenderDecisionMakingSectionWidgetState
    extends State<GenderDecisionMakingSectionWidget> {
  // ── R-01 ──────────────────────────────────────────────────────────────────
  String _r01 = ''; // 'male' | 'female' | 'both'

  // ── R-02 ──────────────────────────────────────────────────────────────────
  late List<_ActivityRow> _activityRows;

  // ── R-03 ──────────────────────────────────────────────────────────────────
  String _r03 = ''; // 'yes' | 'no'

  // ── R-04 ──────────────────────────────────────────────────────────────────
  String _r04 = ''; // 'male' | 'female' | 'joint'

  // ── R-05 ──────────────────────────────────────────────────────────────────
  String _r05 = ''; // 'yes' | 'no' | 'with_permission_only'

  // ── Remarks controllers (one per activity row) ────────────────────────────
  late final List<TextEditingController> _remarksControllers;

  @override
  void initState() {
    super.initState();
    _initActivityRows();
    _loadFromAnswer(widget.answer);
    _remarksControllers = List.generate(
      _activityRows.length,
      (i) => TextEditingController(text: _activityRows[i].remarks),
    );
  }

  @override
  void didUpdateWidget(GenderDecisionMakingSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync if external answer changed (e.g. loaded from DB after init)
    if (oldWidget.answer != widget.answer) {
      _loadFromAnswer(widget.answer);
      for (int i = 0; i < _activityRows.length; i++) {
        if (_remarksControllers[i].text != _activityRows[i].remarks) {
          _remarksControllers[i].text = _activityRows[i].remarks;
        }
      }
    }
  }

  @override
  void dispose() {
    for (final c in _remarksControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Initialise activity rows with stable UUIDs ────────────────────────────

  void _initActivityRows() {
    _activityRows = _kActivities
        .map(
          (a) => _ActivityRow(
            id: const Uuid().v4(),
            activityCode: a['code']!,
            activityLabel: a['label']!,
          ),
        )
        .toList();
  }

  // ── Load from persisted answer ────────────────────────────────────────────

  void _loadFromAnswer(dynamic raw) {
    if (raw == null) return;

    Map<String, dynamic>? data;
    if (raw is Map) {
      data = Map<String, dynamic>.from(raw);
    } else if (raw is String && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) data = Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    if (data == null) return;

    _r01 = (data['r01'] as String?) ?? '';
    _r03 = (data['r03'] as String?) ?? '';
    _r04 = (data['r04'] as String?) ?? '';
    _r05 = (data['r05'] as String?) ?? '';

    // Restore R-02 rows, preserving stable UUIDs
    final rawRows = data['r02'];
    if (rawRows is List && rawRows.isNotEmpty) {
      final loadedRows = rawRows
          .map((e) {
            if (e is Map) {
              return _ActivityRow.fromJson(Map<String, dynamic>.from(e));
            }
            return null;
          })
          .whereType<_ActivityRow>()
          .toList();

      // Merge loaded rows into _activityRows by activity_code,
      // preserving the stable UUID from the persisted data.
      for (int i = 0; i < _activityRows.length; i++) {
        final code = _activityRows[i].activityCode;
        final loaded = loadedRows.firstWhere(
          (r) => r.activityCode == code,
          orElse: () => _ActivityRow(
            id: _activityRows[i].id, // keep existing UUID if not found
            activityCode: code,
            activityLabel: _activityRows[i].activityLabel,
          ),
        );
        _activityRows[i] = _ActivityRow(
          id: loaded.id, // use persisted UUID
          activityCode: loaded.activityCode,
          activityLabel: _kActivities.firstWhere(
            (a) => a['code'] == code,
            orElse: () => {'code': code, 'label': loaded.activityLabel},
          )['label']!,
          decision: loaded.decision,
          remarks: loaded.remarks,
        );
      }
    }
  }

  // ── Build answer map and notify parent ───────────────────────────────────

  void _notify() {
    final map = <String, dynamic>{
      'r01': _r01,
      'r02': _activityRows.map((r) => r.toJson()).toList(),
      'r03': _r03,
      'r04': _r04,
      'r05': _r05,
    };
    widget.onAnswer(map);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(theme),
        const SizedBox(height: 16),
        _buildR01Card(theme),
        const SizedBox(height: 12),
        _buildR02Card(theme),
        const SizedBox(height: 12),
        _buildR03Card(theme),
        const SizedBox(height: 12),
        _buildR04Card(theme),
        const SizedBox(height: 12),
        _buildR05Card(theme),
        const SizedBox(height: 8),
      ],
    );
  }

  // ── Section header ────────────────────────────────────────────────────────

  Widget _buildSectionHeader(ThemeData theme) {
    return Container(
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
            'R. Gender & Decision Making',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Record gender roles and decision-making patterns in the household.',
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: AppTheme.primary.withAlpha(179),
            ),
          ),
        ],
      ),
    );
  }

  // ── Card wrapper ──────────────────────────────────────────────────────────

  Widget _buildCard({required ThemeData theme, required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }

  // ── Question label badge ──────────────────────────────────────────────────

  Widget _buildQuestionLabel(String code, String text, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            code,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  // ── R-01 ──────────────────────────────────────────────────────────────────

  Widget _buildR01Card(ThemeData theme) {
    return _buildCard(
      theme: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionLabel(
            'R-01',
            'Who performs major farm activities?',
            theme,
          ),
          const SizedBox(height: 12),
          ...[('male', 'Male'), ('female', 'Female'), ('both', 'Both')].map(
            (opt) => _buildRadioRow(
              theme: theme,
              value: opt.$1,
              label: opt.$2,
              groupValue: _r01,
              onChanged: widget.isReadOnly
                  ? null
                  : (v) {
                      setState(() => _r01 = v ?? '');
                      _notify();
                    },
            ),
          ),
        ],
      ),
    );
  }

  // ── R-02 ──────────────────────────────────────────────────────────────────

  Widget _buildR02Card(ThemeData theme) {
    return _buildCard(
      theme: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionLabel('R-02', 'Activity-wise decision making', theme),
          const SizedBox(height: 16),
          ...List.generate(_activityRows.length, (i) {
            final row = _activityRows[i];
            return Column(
              children: [
                _buildActivityCard(theme, row, i),
                if (i < _activityRows.length - 1)
                  Divider(height: 20, color: theme.colorScheme.outlineVariant),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActivityCard(ThemeData theme, _ActivityRow row, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Activity label
        Text(
          row.activityLabel,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        // Male / Female / Joint radio buttons on one line
        Row(
          children: [
            _buildCompactRadio(
              theme: theme,
              value: 'male',
              label: 'Male',
              groupValue: row.decision,
              onChanged: widget.isReadOnly
                  ? null
                  : (v) {
                      setState(() => _activityRows[index].decision = v ?? '');
                      _notify();
                    },
            ),
            const SizedBox(width: 4),
            _buildCompactRadio(
              theme: theme,
              value: 'female',
              label: 'Female',
              groupValue: row.decision,
              onChanged: widget.isReadOnly
                  ? null
                  : (v) {
                      setState(() => _activityRows[index].decision = v ?? '');
                      _notify();
                    },
            ),
            const SizedBox(width: 4),
            _buildCompactRadio(
              theme: theme,
              value: 'joint',
              label: 'Joint',
              groupValue: row.decision,
              onChanged: widget.isReadOnly
                  ? null
                  : (v) {
                      setState(() => _activityRows[index].decision = v ?? '');
                      _notify();
                    },
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Remarks field
        widget.isReadOnly
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withAlpha(51),
                  ),
                ),
                child: Text(
                  row.remarks.isEmpty ? '—' : row.remarks,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: row.remarks.isEmpty
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.colorScheme.onSurface,
                  ),
                ),
              )
            : TextField(
                controller: _remarksControllers[index],
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter remarks (optional)',
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
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
                onChanged: (v) {
                  _activityRows[index].remarks = v;
                  _notify();
                },
              ),
      ],
    );
  }

  // ── R-03 ──────────────────────────────────────────────────────────────────

  Widget _buildR03Card(ThemeData theme) {
    return _buildCard(
      theme: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionLabel(
            'R-03',
            'Are women involved in financial decisions?',
            theme,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildRadioRow(
                  theme: theme,
                  value: 'yes',
                  label: 'Yes',
                  groupValue: _r03,
                  onChanged: widget.isReadOnly
                      ? null
                      : (v) {
                          setState(() => _r03 = v ?? '');
                          _notify();
                        },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildRadioRow(
                  theme: theme,
                  value: 'no',
                  label: 'No',
                  groupValue: _r03,
                  onChanged: widget.isReadOnly
                      ? null
                      : (v) {
                          setState(() => _r03 = v ?? '');
                          _notify();
                        },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── R-04 ──────────────────────────────────────────────────────────────────

  Widget _buildR04Card(ThemeData theme) {
    return _buildCard(
      theme: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionLabel(
            'R-04',
            'Who controls major household income?',
            theme,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildRadioRow(
                  theme: theme,
                  value: 'male',
                  label: 'Male',
                  groupValue: _r04,
                  onChanged: widget.isReadOnly
                      ? null
                      : (v) {
                          setState(() => _r04 = v ?? '');
                          _notify();
                        },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildRadioRow(
                  theme: theme,
                  value: 'female',
                  label: 'Female',
                  groupValue: _r04,
                  onChanged: widget.isReadOnly
                      ? null
                      : (v) {
                          setState(() => _r04 = v ?? '');
                          _notify();
                        },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildRadioRow(
                  theme: theme,
                  value: 'joint',
                  label: 'Joint',
                  groupValue: _r04,
                  onChanged: widget.isReadOnly
                      ? null
                      : (v) {
                          setState(() => _r04 = v ?? '');
                          _notify();
                        },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── R-05 ──────────────────────────────────────────────────────────────────

  Widget _buildR05Card(ThemeData theme) {
    return _buildCard(
      theme: theme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuestionLabel(
            'R-05',
            'Can women independently visit market or training programs?',
            theme,
          ),
          const SizedBox(height: 12),
          ...[
            ('yes', 'Yes'),
            ('no', 'No'),
            ('with_permission_only', 'With permission only'),
          ].map(
            (opt) => _buildRadioRow(
              theme: theme,
              value: opt.$1,
              label: opt.$2,
              groupValue: _r05,
              onChanged: widget.isReadOnly
                  ? null
                  : (v) {
                      setState(() => _r05 = v ?? '');
                      _notify();
                    },
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared radio row ──────────────────────────────────────────────────────

  Widget _buildRadioRow({
    required ThemeData theme,
    required String value,
    required String label,
    required String groupValue,
    required ValueChanged<String?>? onChanged,
  }) {
    final isSelected = groupValue == value;
    return InkWell(
      onTap: onChanged != null ? () => onChanged(value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withAlpha(15)
              : theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.primary.withAlpha(102)
                : theme.colorScheme.outline.withAlpha(51),
          ),
        ),
        child: RadioGroup<String>(
          groupValue: groupValue,
          onChanged: onChanged ?? (_) {},
          child: Row(
            children: [
              Radio<String>(
                value: value,
                activeColor: AppTheme.primary,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? AppTheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Compact radio for R-02 row ────────────────────────────────────────────

  Widget _buildCompactRadio({
    required ThemeData theme,
    required String value,
    required String label,
    required String groupValue,
    required ValueChanged<String?>? onChanged,
  }) {
    final isSelected = groupValue == value;
    return Expanded(
      child: InkWell(
        onTap: onChanged != null ? () => onChanged(value) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary.withAlpha(15)
                : theme.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primary.withAlpha(102)
                  : theme.colorScheme.outline.withAlpha(51),
            ),
          ),
          child: RadioGroup<String>(
            groupValue: groupValue,
            onChanged: onChanged ?? (_) {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: value,
                  activeColor: AppTheme.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                Flexible(
                  child: Text(
                    label,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppTheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Read-only review widget ──────────────────────────────────────────────────

/// Compact read-only view of Section R for the survey review screen.
class GenderDecisionMakingReviewWidget extends StatelessWidget {
  final dynamic answer;

  const GenderDecisionMakingReviewWidget({super.key, required this.answer});

  Map<String, dynamic>? _parseAnswer() {
    if (answer == null) return null;
    if (answer is Map) return Map<String, dynamic>.from(answer as Map);
    if (answer is String && (answer as String).isNotEmpty) {
      try {
        final decoded = jsonDecode(answer as String);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    return null;
  }

  String _label(String code) {
    switch (code) {
      case 'male':
        return 'Male';
      case 'female':
        return 'Female';
      case 'both':
        return 'Both';
      case 'joint':
        return 'Joint';
      case 'yes':
        return 'Yes';
      case 'no':
        return 'No';
      case 'with_permission_only':
        return 'With permission only';
      default:
        return code.isEmpty ? '—' : code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = _parseAnswer();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'R. Gender & Decision Making',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: data == null
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Not answered',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildReviewRow(
                        theme,
                        'R-01',
                        'Who performs major farm activities?',
                        _label((data['r01'] as String?) ?? ''),
                        showDivider: true,
                      ),
                      // R-02 activity rows
                      _buildR02Review(theme, data),
                      _buildReviewRow(
                        theme,
                        'R-03',
                        'Are women involved in financial decisions?',
                        _label((data['r03'] as String?) ?? ''),
                        showDivider: true,
                      ),
                      _buildReviewRow(
                        theme,
                        'R-04',
                        'Who controls major household income?',
                        _label((data['r04'] as String?) ?? ''),
                        showDivider: true,
                      ),
                      _buildReviewRow(
                        theme,
                        'R-05',
                        'Can women independently visit market or training programs?',
                        _label((data['r05'] as String?) ?? ''),
                        showDivider: false,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewRow(
    ThemeData theme,
    String code,
    String question,
    String answer, {
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: answer == '—'
                      ? theme.colorScheme.outline
                      : AppTheme.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '[$code] $question',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      answer,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: answer == '—'
                            ? theme.colorScheme.outline
                            : theme.colorScheme.onSurface,
                        fontStyle: answer == '—'
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 32,
            color: theme.colorScheme.outlineVariant,
          ),
      ],
    );
  }

  Widget _buildR02Review(ThemeData theme, Map<String, dynamic> data) {
    final rawRows = data['r02'];
    final List<_ActivityRow> rows = [];

    if (rawRows is List) {
      // Build rows from persisted data, falling back to fixed activity list
      final Map<String, _ActivityRow> byCode = {};
      for (final e in rawRows) {
        if (e is Map) {
          final r = _ActivityRow.fromJson(Map<String, dynamic>.from(e));
          byCode[r.activityCode] = r;
        }
      }
      for (final a in _kActivities) {
        final code = a['code']!;
        rows.add(
          byCode[code] ??
              _ActivityRow(
                id: const Uuid().v4(),
                activityCode: code,
                activityLabel: a['label']!,
              ),
        );
      }
    } else {
      // No data — show empty rows
      for (final a in _kActivities) {
        rows.add(
          _ActivityRow(
            id: const Uuid().v4(),
            activityCode: a['code']!,
            activityLabel: a['label']!,
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 1, indent: 32, color: theme.colorScheme.outlineVariant),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
          child: Text(
            '[R-02] Activity-wise decision making',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        ...rows.map((row) {
          final decisionLabel = row.decision.isEmpty
              ? '—'
              : _label(row.decision);
          final hasRemarks = row.remarks.isNotEmpty;
          return Padding(
            padding: const EdgeInsets.fromLTRB(32, 4, 14, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: row.decision.isEmpty
                        ? theme.colorScheme.outline
                        : AppTheme.success,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        row.activityLabel,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        decisionLabel,
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: row.decision.isEmpty
                              ? theme.colorScheme.outline
                              : theme.colorScheme.onSurface,
                          fontStyle: row.decision.isEmpty
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                      if (hasRemarks)
                        Text(
                          'Remarks: ${row.remarks}',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        Divider(height: 1, indent: 32, color: theme.colorScheme.outlineVariant),
      ],
    );
  }
}

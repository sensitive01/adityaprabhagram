import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

// ─── Response key ─────────────────────────────────────────────────────────────

const String kBorderSpecificConstraintsKey = 'X-BORDER-SPECIFIC-CONSTRAINTS';

// ─── Stable deterministic codes for the 10 constraint rows ───────────────────
// Fixed at compile time so edits/reopens never create duplicate logical rows.

const List<Map<String, String>> _kConstraints = [
  {'code': 'X-C01', 'label': 'Security restrictions'},
  {'code': 'X-C02', 'label': 'Market access (Inputs/Products)'},
  {'code': 'X-C03', 'label': 'Mobility issues'},
  {'code': 'X-C04', 'label': 'Poor connectivity (Transportation)'},
  {'code': 'X-C05', 'label': 'Poor connectivity (Communication)'},
  {'code': 'X-C06', 'label': 'Financial Constraints / Source of finance'},
  {'code': 'X-C07', 'label': 'Health Facilities'},
  {'code': 'X-C08', 'label': 'Availing Govt. Scheme'},
  {'code': 'X-C09', 'label': 'Lack of Extension advisory services'},
  {'code': 'X-C10', 'label': 'Others'},
];

const List<String> _kSeriousnessOptions = [
  'Most Serious',
  'Serious',
  'Not Serious',
];

// ─── Data model for one constraint row ───────────────────────────────────────

class _ConstraintRow {
  final String code;
  final String label;
  final bool isOthers;
  String seriousness = ''; // one of _kSeriousnessOptions or ''
  String othersText = ''; // only used when isOthers == true

  _ConstraintRow({
    required this.code,
    required this.label,
    required this.isOthers,
  });

  Map<String, dynamic> toJson() => {
    'code': code,
    'label': label,
    'seriousness': seriousness,
    if (isOthers) 'othersText': othersText,
  };
}

// ─── Main Widget ──────────────────────────────────────────────────────────────

class BorderSpecificConstraintsSectionWidget extends StatefulWidget {
  final dynamic answer;
  final ValueChanged<Map<String, dynamic>> onAnswer;
  final bool isReadOnly;

  const BorderSpecificConstraintsSectionWidget({
    super.key,
    required this.answer,
    required this.onAnswer,
    this.isReadOnly = false,
  });

  @override
  State<BorderSpecificConstraintsSectionWidget> createState() =>
      _BorderSpecificConstraintsSectionWidgetState();
}

class _BorderSpecificConstraintsSectionWidgetState
    extends State<BorderSpecificConstraintsSectionWidget> {
  // Q1: Does border location affect livelihood?
  String _q1 = '';

  // Q2: Has agricultural income been affected due to border-related issues?
  String _q2 = '';

  // Constraint rows (only relevant when _q2 == 'Yes')
  late List<_ConstraintRow> _rows;
  late TextEditingController _othersTextController;

  @override
  void initState() {
    super.initState();
    _initRows();
    _loadFromAnswer(widget.answer);
    _othersTextController = TextEditingController(text: _rows.last.othersText);
  }

  @override
  void didUpdateWidget(BorderSpecificConstraintsSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.answer != widget.answer) {
      _initRows();
      _loadFromAnswer(widget.answer);
      if (_othersTextController.text != _rows.last.othersText) {
        _othersTextController.text = _rows.last.othersText;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _othersTextController.dispose();
    super.dispose();
  }

  void _initRows() {
    _rows = _kConstraints.map((c) {
      return _ConstraintRow(
        code: c['code']!,
        label: c['label']!,
        isOthers: c['code'] == 'X-C10',
      );
    }).toList();
  }

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

    _q1 = (data['q1'] as String?) ?? '';
    _q2 = (data['q2'] as String?) ?? '';

    final rawConstraints = data['constraints'];
    if (rawConstraints is List) {
      for (final item in rawConstraints) {
        if (item is! Map) continue;
        final itemMap = Map<String, dynamic>.from(item);
        final code = itemMap['code'] as String?;
        if (code == null) continue;
        final rowIdx = _rows.indexWhere((r) => r.code == code);
        if (rowIdx < 0) continue;
        _rows[rowIdx].seriousness = (itemMap['seriousness'] as String?) ?? '';
        if (_rows[rowIdx].isOthers) {
          _rows[rowIdx].othersText = (itemMap['othersText'] as String?) ?? '';
        }
      }
    }
  }

  void _emitAnswer() {
    // Only include constraint data when q2 == 'Yes'
    final constraintsPayload = _q2 == 'Yes'
        ? _rows.map((r) => r.toJson()).toList()
        : <Map<String, dynamic>>[];

    final payload = {'q1': _q1, 'q2': _q2, 'constraints': constraintsPayload};
    widget.onAnswer(payload);
  }

  void _setQ1(String val) {
    if (widget.isReadOnly) return;
    setState(() => _q1 = val);
    _emitAnswer();
  }

  void _setQ2(String val) {
    if (widget.isReadOnly) return;
    setState(() => _q2 = val);
    _emitAnswer();
  }

  void _setSeriousness(int rowIdx, String val) {
    if (widget.isReadOnly) return;
    setState(() => _rows[rowIdx].seriousness = val);
    _emitAnswer();
  }

  Widget _buildYesNoCard({
    required ThemeData theme,
    required String questionText,
    required String currentValue,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questionText,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          ...['Yes', 'No'].map((opt) {
            final isSelected = currentValue == opt;
            return GestureDetector(
              onTap: () => onChanged(opt),
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary.withAlpha(15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primary
                        : theme.colorScheme.outlineVariant,
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primary
                              : theme.colorScheme.outline,
                          width: isSelected ? 2 : 1.5,
                        ),
                        color: isSelected
                            ? AppTheme.primary
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.circle,
                              size: 10,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      opt,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? AppTheme.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildConstraintCard(
    BuildContext context,
    ThemeData theme,
    int idx,
    _ConstraintRow row,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Constraint label
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Text(
              row.label,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),

          // "Others" text field
          if (row.isOthers)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: TextField(
                controller: _othersTextController,
                readOnly: widget.isReadOnly,
                decoration: InputDecoration(
                  hintText: 'Specify constraint…',
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 12,
                    color: theme.colorScheme.outline,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
                  ),
                ),
                style: GoogleFonts.manrope(fontSize: 13),
                onChanged: (val) {
                  if (widget.isReadOnly) return;
                  _rows[idx].othersText = val;
                  _emitAnswer();
                },
              ),
            ),

          // Seriousness options
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: Column(
              children: _kSeriousnessOptions.map((opt) {
                final isSelected = row.seriousness == opt;
                return GestureDetector(
                  onTap: () => _setSeriousness(idx, opt),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary.withAlpha(15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primary
                            : theme.colorScheme.outlineVariant,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primary
                                  : theme.colorScheme.outline,
                              width: isSelected ? 2 : 1.5,
                            ),
                            color: isSelected
                                ? AppTheme.primary
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          opt,
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? AppTheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Section header ──────────────────────────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.primary.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primary.withAlpha(40)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Section X',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Border-Specific Constraints',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Understand the impact of border-related issues on livelihood and agriculture.',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Q1: Does border location affect livelihood? ─────────────────────
        _buildYesNoCard(
          theme: theme,
          questionText: 'Does border location affect livelihood?',
          currentValue: _q1,
          onChanged: _setQ1,
        ),

        // ── Q2: Has agricultural income been affected? ──────────────────────
        _buildYesNoCard(
          theme: theme,
          questionText:
              'Has your agricultural income been affected due to border-related issues?',
          currentValue: _q2,
          onChanged: _setQ2,
        ),

        // ── Constraints section (only when Q2 == Yes) ───────────────────────
        if (_q2 == 'Yes') ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'If Yes, indicate the seriousness of the following constraints',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                ..._rows.asMap().entries.map((entry) {
                  return _buildConstraintCard(
                    context,
                    theme,
                    entry.key,
                    entry.value,
                  );
                }),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Review Widget ────────────────────────────────────────────────────────────

class BorderSpecificConstraintsReviewWidget extends StatelessWidget {
  final dynamic answer;

  const BorderSpecificConstraintsReviewWidget({
    super.key,
    required this.answer,
  });

  Map<String, dynamic> _parseData(dynamic raw) {
    if (raw == null) return {};
    if (raw is Map) return Map<String, dynamic>.from(raw);
    if (raw is String && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    return {};
  }

  List<_ConstraintRow> _parseConstraints(dynamic raw) {
    final rows = _kConstraints.map((c) {
      return _ConstraintRow(
        code: c['code']!,
        label: c['label']!,
        isOthers: c['code'] == 'X-C10',
      );
    }).toList();

    if (raw == null) return rows;
    Map<String, dynamic>? data;
    if (raw is Map) {
      data = Map<String, dynamic>.from(raw);
    } else if (raw is String && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map) data = Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }
    if (data == null) return rows;

    final rawConstraints = data['constraints'];
    if (rawConstraints is List) {
      for (final item in rawConstraints) {
        if (item is! Map) continue;
        final itemMap = Map<String, dynamic>.from(item);
        final code = itemMap['code'] as String?;
        if (code == null) continue;
        final rowIdx = rows.indexWhere((r) => r.code == code);
        if (rowIdx < 0) continue;
        rows[rowIdx].seriousness = (itemMap['seriousness'] as String?) ?? '';
        if (rows[rowIdx].isOthers) {
          rows[rowIdx].othersText = (itemMap['othersText'] as String?) ?? '';
        }
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = _parseData(answer);
    final q1 = (data['q1'] as String?) ?? '';
    final q2 = (data['q2'] as String?) ?? '';
    final rows = _parseConstraints(answer);

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
                Expanded(
                  child: Text(
                    'Border-Specific Constraints',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
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
            child: Column(
              children: [
                // Q1
                _buildReviewRow(
                  theme: theme,
                  label: 'Does border location affect livelihood?',
                  value: q1,
                  isLast: false,
                ),
                // Q2
                _buildReviewRow(
                  theme: theme,
                  label:
                      'Has your agricultural income been affected due to border-related issues?',
                  value: q2,
                  isLast: q2 != 'Yes',
                ),
                // Constraints (only when q2 == Yes)
                if (q2 == 'Yes') ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                    child: Text(
                      'Seriousness of constraints:',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  ...rows.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final row = entry.value;
                    final displayValue = row.seriousness.isNotEmpty
                        ? (row.isOthers && row.othersText.isNotEmpty
                              ? '${row.seriousness} (${row.othersText})'
                              : row.seriousness)
                        : (row.isOthers && row.othersText.isNotEmpty
                              ? row.othersText
                              : '');
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
                                  color: displayValue.isNotEmpty
                                      ? AppTheme.success
                                      : theme.colorScheme.outline,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      row.label,
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    displayValue.isNotEmpty
                                        ? Text(
                                            displayValue,
                                            style: GoogleFonts.manrope(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                          )
                                        : Text(
                                            'Not answered',
                                            style: GoogleFonts.manrope(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: theme.colorScheme.outline,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (idx < rows.length - 1)
                          Divider(
                            height: 1,
                            indent: 32,
                            color: theme.colorScheme.outlineVariant,
                          ),
                      ],
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewRow({
    required ThemeData theme,
    required String label,
    required String value,
    required bool isLast,
  }) {
    final isAnswered = value.isNotEmpty;
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
                  color: isAnswered
                      ? AppTheme.success
                      : theme.colorScheme.outline,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    isAnswered
                        ? Text(
                            value,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          )
                        : Text(
                            'Not answered',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.outline,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 32,
            color: theme.colorScheme.outlineVariant,
          ),
      ],
    );
  }
}

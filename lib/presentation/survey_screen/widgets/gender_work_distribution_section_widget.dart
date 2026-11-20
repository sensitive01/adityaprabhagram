import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

// ─── Response key ─────────────────────────────────────────────────────────────

const String kGenderWorkDistributionKey = 'T-GENDER-WORK-DISTRIBUTION';

// ─── Stable deterministic codes for the 18 activity rows ─────────────────────
// Fixed at compile time so edits/reopens never create duplicate logical rows.

const List<Map<String, String>> _kActivities = [
  {'code': 'T-01', 'label': 'Sowing of seeds'},
  {'code': 'T-02', 'label': 'Weeding'},
  {'code': 'T-03', 'label': 'Harvesting'},
  {'code': 'T-04', 'label': 'Threshing'},
  {'code': 'T-05', 'label': 'Storage of grains'},
  {'code': 'T-06', 'label': 'Winnowing'},
  {'code': 'T-07', 'label': 'Traditional health care to animals'},
  {'code': 'T-08', 'label': 'Collection of fuel/firewood'},
  {'code': 'T-09', 'label': 'Procurement of feed'},
  {'code': 'T-10', 'label': "Cleaning animal's shed"},
  {'code': 'T-11', 'label': 'Feeding animals'},
  {'code': 'T-12', 'label': 'Getting green fodder from fields'},
  {'code': 'T-13', 'label': 'Milking'},
  {'code': 'T-14', 'label': 'Milk disposal'},
  {'code': 'T-15', 'label': 'Breeding of animals'},
  {'code': 'T-16', 'label': 'Selling of green fodder in market'},
  {'code': 'T-17', 'label': 'Taking care of Children'},
  {'code': 'T-18', 'label': 'Other'},
];

const List<String> _kFrequencies = [
  'Never',
  'Rarely',
  'Sometimes',
  'Frequently',
  'Always',
];

// ─── Data model for one activity row ─────────────────────────────────────────

class _ActivityRow {
  final String code;
  final String label;
  final bool isOther;
  String frequency; // one of _kFrequencies or ''
  String otherText; // only used when isOther == true

  _ActivityRow({
    required this.code,
    required this.label,
    required this.isOther,
    this.frequency = '',
    this.otherText = '',
  });

  Map<String, dynamic> toJson() => {
    'code': code,
    'label': label,
    'frequency': frequency,
    if (isOther) 'otherText': otherText,
  };

  factory _ActivityRow.fromJson(
    Map<String, dynamic> json,
    String code,
    String label,
    bool isOther,
  ) {
    return _ActivityRow(
      code: code,
      label: label,
      isOther: isOther,
      frequency: (json['frequency'] as String?) ?? '',
      otherText: (json['otherText'] as String?) ?? '',
    );
  }
}

// ─── Main Widget ──────────────────────────────────────────────────────────────

class GenderWorkDistributionSectionWidget extends StatefulWidget {
  final dynamic answer;
  final ValueChanged<Map<String, dynamic>> onAnswer;
  final bool isReadOnly;

  const GenderWorkDistributionSectionWidget({
    super.key,
    required this.answer,
    required this.onAnswer,
    this.isReadOnly = false,
  });

  @override
  State<GenderWorkDistributionSectionWidget> createState() =>
      _GenderWorkDistributionSectionWidgetState();
}

class _GenderWorkDistributionSectionWidgetState
    extends State<GenderWorkDistributionSectionWidget> {
  late List<_ActivityRow> _rows;
  late TextEditingController _otherTextController;

  @override
  void initState() {
    super.initState();
    _initRows();
    _loadFromAnswer(widget.answer);
    _otherTextController = TextEditingController(text: _rows.last.otherText);
  }

  @override
  void didUpdateWidget(GenderWorkDistributionSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.answer != widget.answer) {
      _loadFromAnswer(widget.answer);
      if (_otherTextController.text != _rows.last.otherText) {
        _otherTextController.text = _rows.last.otherText;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _otherTextController.dispose();
    super.dispose();
  }

  void _initRows() {
    _rows = _kActivities.map((act) {
      return _ActivityRow(
        code: act['code']!,
        label: act['label']!,
        isOther: act['code'] == 'T-18',
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

    final rawActivities = data['activities'];
    if (rawActivities is List) {
      for (final item in rawActivities) {
        if (item is! Map) continue;
        final itemMap = Map<String, dynamic>.from(item);
        final code = itemMap['code'] as String?;
        if (code == null) continue;
        final rowIdx = _rows.indexWhere((r) => r.code == code);
        if (rowIdx < 0) continue;
        _rows[rowIdx].frequency = (itemMap['frequency'] as String?) ?? '';
        if (_rows[rowIdx].isOther) {
          _rows[rowIdx].otherText = (itemMap['otherText'] as String?) ?? '';
        }
      }
    }
  }

  void _emitAnswer() {
    final payload = {'activities': _rows.map((r) => r.toJson()).toList()};
    widget.onAnswer(payload);
  }

  void _setFrequency(int rowIdx, String freq) {
    if (widget.isReadOnly) return;
    setState(() {
      _rows[rowIdx].frequency = freq;
    });
    _emitAnswer();
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
          child: Row(
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
                  'Section T',
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
                  'Gender based work distribution /\nfarm activity participation',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Activity rows ───────────────────────────────────────────────────
        ..._rows.asMap().entries.map((entry) {
          final idx = entry.key;
          final row = entry.value;
          return _buildActivityCard(context, theme, idx, row);
        }),
      ],
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    ThemeData theme,
    int idx,
    _ActivityRow row,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // Activity title row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppTheme.primary.withAlpha(60)),
                  ),
                  child: Text(
                    row.code,
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
                    row.label,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),

          // "Other" text field
          if (row.isOther)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
              child: TextField(
                controller: _otherTextController,
                readOnly: widget.isReadOnly,
                decoration: InputDecoration(
                  hintText: 'Specify activity…',
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 12,
                    color: theme.colorScheme.outline,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
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
                  _rows[idx].otherText = val;
                  _emitAnswer();
                },
              ),
            ),

          // Frequency options
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
            child: Column(
              children: _kFrequencies.map((freq) {
                final isSelected = row.frequency == freq;
                return GestureDetector(
                  onTap: () => _setFrequency(idx, freq),
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
                          freq,
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
}

// ─── Review Widget ────────────────────────────────────────────────────────────

class GenderWorkDistributionReviewWidget extends StatelessWidget {
  final dynamic answer;

  const GenderWorkDistributionReviewWidget({super.key, required this.answer});

  List<_ActivityRow> _parseRows(dynamic raw) {
    final rows = _kActivities.map((act) {
      return _ActivityRow(
        code: act['code']!,
        label: act['label']!,
        isOther: act['code'] == 'T-18',
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

    final rawActivities = data['activities'];
    if (rawActivities is List) {
      for (final item in rawActivities) {
        if (item is! Map) continue;
        final itemMap = Map<String, dynamic>.from(item);
        final code = itemMap['code'] as String?;
        if (code == null) continue;
        final rowIdx = rows.indexWhere((r) => r.code == code);
        if (rowIdx < 0) continue;
        rows[rowIdx].frequency = (itemMap['frequency'] as String?) ?? '';
        if (rows[rowIdx].isOther) {
          rows[rowIdx].otherText = (itemMap['otherText'] as String?) ?? '';
        }
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = _parseRows(answer);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  'Gender based work distribution / farm activity participation',
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
            child: Column(
              children: rows.asMap().entries.map((entry) {
                final idx = entry.key;
                final row = entry.value;
                final hasAnswer =
                    row.frequency.isNotEmpty ||
                    (row.isOther && row.otherText.isNotEmpty);
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
                              color: hasAnswer
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
                                  '${row.code}  ${row.label}',
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (row.frequency.isNotEmpty)
                                  Text(
                                    row.isOther && row.otherText.isNotEmpty
                                        ? '${row.frequency} (${row.otherText})'
                                        : row.frequency,
                                    style: GoogleFonts.manrope(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  )
                                else if (row.isOther &&
                                    row.otherText.isNotEmpty)
                                  Text(
                                    row.otherText,
                                    style: GoogleFonts.manrope(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  )
                                else
                                  Text(
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
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

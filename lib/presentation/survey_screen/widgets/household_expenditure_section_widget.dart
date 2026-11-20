import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../../theme/app_theme.dart';

// ─── Response key ─────────────────────────────────────────────────────────────

const String kHouseholdExpenditureKey = 'S-HOUSEHOLD-EXPENDITURE';

// ─── Stable UUIDs for the 8 expenditure rows ─────────────────────────────────
// These are fixed at compile time so edits never create duplicates.

const List<Map<String, String>> _kExpenditureCategories = [
  {
    'uuid': 'e1a00001-s001-4000-8000-000000000001',
    'code': 'health',
    'label': 'Health (medicine, treatment)',
  },
  {
    'uuid': 'e1a00002-s001-4000-8000-000000000002',
    'code': 'agriculture_inputs',
    'label': 'Agriculture inputs\n(seed, fertilizer, labour)',
  },
  {
    'uuid': 'e1a00003-s001-4000-8000-000000000003',
    'code': 'livestock_expenses',
    'label': 'Livestock expenses\n(feed, veterinary care)',
  },
  {
    'uuid': 'e1a00004-s001-4000-8000-000000000004',
    'code': 'household_items',
    'label': 'Household items\n(clothing, utilities, fuel)',
  },
  {
    'uuid': 'e1a00005-s001-4000-8000-000000000005',
    'code': 'social_religious',
    'label': 'Social & religious\nfunctions/Obligations',
  },
  {
    'uuid': 'e1a00006-s001-4000-8000-000000000006',
    'code': 'transport_communication',
    'label': 'Transport & communication',
  },
  {
    'uuid': 'e1a00007-s001-4000-8000-000000000007',
    'code': 'loan_repayment',
    'label': 'Loan repayment',
  },
  {
    'uuid': 'e1a00008-s001-4000-8000-000000000008',
    'code': 'other',
    'label': 'Other',
  },
];

// ─── S-02 options ─────────────────────────────────────────────────────────────

const List<Map<String, String>> _kHighestCategoryOptions = [
  {'value': 'food', 'label': 'Food'},
  {'value': 'agricultural_activities', 'label': 'Agricultural activities'},
  {'value': 'health', 'label': 'Health'},
  {'value': 'education', 'label': 'Education'},
  {'value': 'social_functions', 'label': 'Social functions'},
  {'value': 'others', 'label': 'Others'},
];

// ─── S-03 options ─────────────────────────────────────────────────────────────

const List<Map<String, String>> _kHigherExpenseMonthOptions = [
  {'value': 'jan_mar', 'label': 'Jan–Mar'},
  {'value': 'apr_jun', 'label': 'Apr–Jun'},
  {'value': 'jul_sep', 'label': 'Jul–Sep'},
  {'value': 'oct_dec', 'label': 'Oct–Dec'},
];

// ─── S-04 options ─────────────────────────────────────────────────────────────

const List<Map<String, String>> _kDifficultyOptions = [
  {'value': 'always', 'label': 'Always'},
  {'value': 'sometimes', 'label': 'Sometimes'},
  {'value': 'rarely', 'label': 'Rarely'},
  {'value': 'never', 'label': 'Never'},
];

// ─── S-05 options ─────────────────────────────────────────────────────────────

const List<Map<String, String>> _kManageOptions = [
  {'value': 'borrowing', 'label': 'Borrowing'},
  {'value': 'using_savings', 'label': 'Using savings'},
  {'value': 'selling_assets', 'label': 'Selling assets'},
  {'value': 'reducing_consumption', 'label': 'Reducing consumption'},
  {'value': 'other', 'label': 'Other'},
];

// ─── Data model for one expenditure row ──────────────────────────────────────

class _ExpenditureRow {
  final String id; // stable UUID
  final String code;
  final String label;
  String amount; // stored as string
  String rank; // stored as string

  _ExpenditureRow({
    required this.id,
    required this.code,
    required this.label,
    this.amount = '',
    this.rank = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'label': label,
    'amount': amount,
    'rank': rank,
  };

  factory _ExpenditureRow.fromJson(Map<String, dynamic> json) {
    return _ExpenditureRow(
      id: (json['id'] as String?) ?? const Uuid().v4(),
      code: (json['code'] as String?) ?? '',
      label: (json['label'] as String?) ?? '',
      amount: (json['amount'] as String?) ?? '',
      rank: (json['rank'] as String?) ?? '',
    );
  }
}

// ─── Main Widget ──────────────────────────────────────────────────────────────

class HouseholdExpenditureSectionWidget extends StatefulWidget {
  final dynamic answer;
  final ValueChanged<Map<String, dynamic>> onAnswer;
  final bool isReadOnly;

  const HouseholdExpenditureSectionWidget({
    super.key,
    required this.answer,
    required this.onAnswer,
    this.isReadOnly = false,
  });

  @override
  State<HouseholdExpenditureSectionWidget> createState() =>
      _HouseholdExpenditureSectionWidgetState();
}

class _HouseholdExpenditureSectionWidgetState
    extends State<HouseholdExpenditureSectionWidget> {
  // ── S-01 rows ──────────────────────────────────────────────────────────────
  late List<_ExpenditureRow> _rows;
  late List<TextEditingController> _amountControllers;
  late List<TextEditingController> _rankControllers;

  // ── S-02 ──────────────────────────────────────────────────────────────────
  String _s02 = '';

  // ── S-03 ──────────────────────────────────────────────────────────────────
  String _s03 = '';

  // ── S-04 ──────────────────────────────────────────────────────────────────
  String _s04 = '';

  // ── S-05 (up to 2 selections) ─────────────────────────────────────────────
  List<String> _s05 = [];

  @override
  void initState() {
    super.initState();
    _initRows();
    _loadFromAnswer(widget.answer);
    _amountControllers = List.generate(
      _rows.length,
      (i) => TextEditingController(text: _rows[i].amount),
    );
    _rankControllers = List.generate(
      _rows.length,
      (i) => TextEditingController(text: _rows[i].rank),
    );
  }

  @override
  void didUpdateWidget(HouseholdExpenditureSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.answer != widget.answer) {
      _loadFromAnswer(widget.answer);
      for (int i = 0; i < _rows.length; i++) {
        if (_amountControllers[i].text != _rows[i].amount) {
          _amountControllers[i].text = _rows[i].amount;
        }
        if (_rankControllers[i].text != _rows[i].rank) {
          _rankControllers[i].text = _rows[i].rank;
        }
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    for (final c in _amountControllers) {
      c.dispose();
    }
    for (final c in _rankControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _initRows() {
    _rows = _kExpenditureCategories
        .map(
          (cat) => _ExpenditureRow(
            id: cat['uuid']!,
            code: cat['code']!,
            label: cat['label']!,
          ),
        )
        .toList();
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

    _s02 = (data['s02'] as String?) ?? '';
    _s03 = (data['s03'] as String?) ?? '';
    _s04 = (data['s04'] as String?) ?? '';
    final rawS05 = data['s05'];
    if (rawS05 is List) {
      _s05 = rawS05.map((e) => e.toString()).toList();
    }

    // Restore S-01 rows by code, preserving stable UUIDs
    final rawRows = data['s01'];
    if (rawRows is List) {
      final loadedRows = rawRows
          .map((e) {
            if (e is Map) {
              return _ExpenditureRow.fromJson(Map<String, dynamic>.from(e));
            }
            return null;
          })
          .whereType<_ExpenditureRow>()
          .toList();

      for (int i = 0; i < _rows.length; i++) {
        final code = _rows[i].code;
        final loaded = loadedRows.firstWhere(
          (r) => r.code == code,
          orElse: () => _ExpenditureRow(
            id: _rows[i].id,
            code: code,
            label: _rows[i].label,
          ),
        );
        _rows[i] = _ExpenditureRow(
          id: _rows[i].id, // always use the compile-time stable UUID
          code: code,
          label: _rows[i].label,
          amount: loaded.amount,
          rank: loaded.rank,
        );
      }
    }
  }

  void _notify() {
    final map = <String, dynamic>{
      's01': _rows.map((r) => r.toJson()).toList(),
      's02': _s02,
      's03': _s03,
      's04': _s04,
      's05': _s05,
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
        _buildS01Card(theme),
        const SizedBox(height: 16),
        _buildS02Card(theme),
        const SizedBox(height: 16),
        _buildS03Card(theme),
        const SizedBox(height: 16),
        _buildS04Card(theme),
        const SizedBox(height: 16),
        _buildS05Card(theme),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary.withAlpha(31),
            AppTheme.primary.withAlpha(10),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primary.withAlpha(51)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Section S',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Major Household Expenditure\n(Annual Estimate)',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── S-01 ──────────────────────────────────────────────────────────────────

  Widget _buildS01Card(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(51)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _questionBadge('S-01'),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expenditure Category (Annual Estimate)',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Enter the estimated annual expenditure and rank the categories from highest to lowest (1, 2, 3 ...).',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Info banner
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primary.withAlpha(15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primary.withAlpha(51)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Rank 1 for the highest expenditure, 2 for the next, and so on.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Rows
          const Divider(height: 1),
          ...List.generate(_rows.length, (i) => _buildExpenditureRow(theme, i)),
        ],
      ),
    );
  }

  Widget _buildExpenditureRow(ThemeData theme, int i) {
    final row = _rows[i];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                row.label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount (Rs.)',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _amountControllers[i],
                          readOnly: widget.isReadOnly,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: GoogleFonts.inter(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Enter amount',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppTheme.primary),
                            ),
                            filled: true,
                            fillColor: widget.isReadOnly
                                ? theme.colorScheme.surfaceContainerHighest
                                      .withAlpha(77)
                                : theme.colorScheme.surface,
                          ),
                          onChanged: (v) {
                            _rows[i].amount = v;
                            _notify();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rank',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _rankControllers[i],
                          readOnly: widget.isReadOnly,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: GoogleFonts.inter(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Enter rank',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 12,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppTheme.primary),
                            ),
                            filled: true,
                            fillColor: widget.isReadOnly
                                ? theme.colorScheme.surfaceContainerHighest
                                      .withAlpha(77)
                                : theme.colorScheme.surface,
                          ),
                          onChanged: (v) {
                            _rows[i].rank = v;
                            _notify();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (i < _rows.length - 1)
          Divider(height: 1, color: theme.colorScheme.outline.withAlpha(26)),
      ],
    );
  }

  // ── S-02 ──────────────────────────────────────────────────────────────────

  Widget _buildS02Card(ThemeData theme) {
    return _buildChoiceCard(
      theme: theme,
      badge: 'S-02',
      question: 'Which category takes the highest share of your expenditure?',
      options: _kHighestCategoryOptions,
      selected: _s02,
      onChanged: (v) {
        setState(() => _s02 = v);
        _notify();
      },
      columns: 3,
    );
  }

  // ── S-03 ──────────────────────────────────────────────────────────────────

  Widget _buildS03Card(ThemeData theme) {
    return _buildChoiceCard(
      theme: theme,
      badge: 'S-03',
      question: 'In which months do you have higher expenses?',
      options: _kHigherExpenseMonthOptions,
      selected: _s03,
      onChanged: (v) {
        setState(() => _s03 = v);
        _notify();
      },
      columns: 4,
    );
  }

  // ── S-04 ──────────────────────────────────────────────────────────────────

  Widget _buildS04Card(ThemeData theme) {
    return _buildChoiceCard(
      theme: theme,
      badge: 'S-04',
      question: 'Do you face difficulty in meeting household expenses?',
      options: _kDifficultyOptions,
      selected: _s04,
      onChanged: (v) {
        setState(() => _s04 = v);
        _notify();
      },
      columns: 4,
    );
  }

  // ── S-05 ──────────────────────────────────────────────────────────────────

  Widget _buildS05Card(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(51)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _questionBadge('S-05'),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How do you manage during high expenditure periods?',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '(Select up to 2)',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _kManageOptions.map((opt) {
                final value = opt['value']!;
                final label = opt['label']!;
                final isSelected = _s05.contains(value);
                return GestureDetector(
                  onTap: widget.isReadOnly
                      ? null
                      : () {
                          setState(() {
                            if (isSelected) {
                              _s05.remove(value);
                            } else if (_s05.length < 2) {
                              _s05.add(value);
                            }
                          });
                          _notify();
                        },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary.withAlpha(26)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primary
                            : theme.colorScheme.outline.withAlpha(77),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primary
                                  : theme.colorScheme.outline.withAlpha(128),
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: GoogleFonts.inter(
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
          ],
        ),
      ),
    );
  }

  // ── Shared helpers ────────────────────────────────────────────────────────

  Widget _questionBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(31),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  Widget _buildChoiceCard({
    required ThemeData theme,
    required String badge,
    required String question,
    required List<Map<String, String>> options,
    required String selected,
    required ValueChanged<String> onChanged,
    int columns = 3,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(51)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _questionBadge(badge),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    question,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((opt) {
                final value = opt['value']!;
                final label = opt['label']!;
                final isSelected = selected == value;
                return GestureDetector(
                  onTap: widget.isReadOnly
                      ? null
                      : () => onChanged(isSelected ? '' : value),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primary.withAlpha(26)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primary
                            : theme.colorScheme.outline.withAlpha(77),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppTheme.primary
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primary
                                  : theme.colorScheme.outline.withAlpha(128),
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.circle,
                                  size: 8,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: GoogleFonts.inter(
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
          ],
        ),
      ),
    );
  }
}

// ─── Review Widget ────────────────────────────────────────────────────────────

class HouseholdExpenditureReviewWidget extends StatelessWidget {
  final dynamic answer;

  const HouseholdExpenditureReviewWidget({super.key, required this.answer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Map<String, dynamic>? data;
    if (answer is Map) {
      data = Map<String, dynamic>.from(answer as Map);
    } else if (answer is String && (answer as String).isNotEmpty) {
      try {
        final decoded = jsonDecode(answer as String);
        if (decoded is Map) data = Map<String, dynamic>.from(decoded);
      } catch (_) {}
    }

    if (data == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(77),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Section S not answered.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: theme.colorScheme.onSurface.withAlpha(128),
            ),
          ),
        ),
      );
    }

    final s02 = (data['s02'] as String?) ?? '';
    final s03 = (data['s03'] as String?) ?? '';
    final s04 = (data['s04'] as String?) ?? '';
    final rawS05 = data['s05'];
    final s05 = rawS05 is List
        ? rawS05.map((e) => e.toString()).toList()
        : <String>[];

    // Restore rows
    final rows = <_ExpenditureRow>[];
    final rawRows = data['s01'];
    if (rawRows is List) {
      for (final cat in _kExpenditureCategories) {
        final loaded = (rawRows).firstWhere(
          (e) => e is Map && (e)['code'] == cat['code'],
          orElse: () => null,
        );
        if (loaded != null && loaded is Map) {
          rows.add(
            _ExpenditureRow(
              id: cat['uuid']!,
              code: cat['code']!,
              label: cat['label']!,
              amount: (loaded['amount'] as String?) ?? '',
              rank: (loaded['rank'] as String?) ?? '',
            ),
          );
        } else {
          rows.add(
            _ExpenditureRow(
              id: cat['uuid']!,
              code: cat['code']!,
              label: cat['label']!,
            ),
          );
        }
      }
    } else {
      for (final cat in _kExpenditureCategories) {
        rows.add(
          _ExpenditureRow(
            id: cat['uuid']!,
            code: cat['code']!,
            label: cat['label']!,
          ),
        );
      }
    }

    String labelFor(List<Map<String, String>> opts, String value) {
      return opts.firstWhere(
        (o) => o['value'] == value,
        orElse: () => {'label': value},
      )['label']!;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'S. Major Household Expenditure (Annual Estimate)',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // S-01 table
          Text(
            'S-01. Expenditure Category (Annual Estimate)',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withAlpha(51),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: List.generate(rows.length, (i) {
                final row = rows[i];
                final hasData = row.amount.isNotEmpty || row.rank.isNotEmpty;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              row.label,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: Text(
                              row.amount.isNotEmpty ? 'Rs. ${row.amount}' : '—',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: hasData
                                    ? theme.colorScheme.onSurface
                                    : theme.colorScheme.onSurface.withValues(
                                        alpha: 0.4,
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 40,
                            child: Text(
                              row.rank.isNotEmpty ? '#${row.rank}' : '—',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: row.rank.isNotEmpty
                                    ? AppTheme.primary
                                    : theme.colorScheme.onSurface.withValues(
                                        alpha: 0.4,
                                      ),
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i < rows.length - 1)
                      Divider(
                        height: 1,
                        color: theme.colorScheme.outline.withAlpha(26),
                      ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 12),

          // S-02
          _reviewRow(
            theme,
            'S-02',
            'Highest expenditure category',
            s02.isNotEmpty ? labelFor(_kHighestCategoryOptions, s02) : '—',
          ),
          const SizedBox(height: 8),

          // S-03
          _reviewRow(
            theme,
            'S-03',
            'Higher-expense months',
            s03.isNotEmpty ? labelFor(_kHigherExpenseMonthOptions, s03) : '—',
          ),
          const SizedBox(height: 8),

          // S-04
          _reviewRow(
            theme,
            'S-04',
            'Difficulty meeting expenses',
            s04.isNotEmpty ? labelFor(_kDifficultyOptions, s04) : '—',
          ),
          const SizedBox(height: 8),

          // S-05
          _reviewRow(
            theme,
            'S-05',
            'How household manages high-expenditure periods',
            s05.isNotEmpty
                ? s05.map((v) => labelFor(_kManageOptions, v)).join(', ')
                : '—',
          ),
        ],
      ),
    );
  }

  Widget _reviewRow(
    ThemeData theme,
    String badge,
    String question,
    String answer,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          decoration: BoxDecoration(
            color: AppTheme.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            badge,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withAlpha(153),
                ),
              ),
              Text(
                answer,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

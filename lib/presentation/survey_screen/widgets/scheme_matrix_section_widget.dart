import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../../theme/app_theme.dart';

/// A single scheme/service item in the matrix.
class _SchemeItem {
  /// Stable client-generated UUID — generated once, reused on every reopen.
  final String id;
  final String schemeCode;
  String schemeName; // mutable for "other"
  String status; // "availed" | "not_availed" | ""
  String utility;
  String reason;

  _SchemeItem({
    required this.id,
    required this.schemeCode,
    required this.schemeName,
    this.status = '',
    this.utility = '',
    this.reason = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'scheme_code': schemeCode,
    'scheme_name': schemeName,
    'status': status,
    'utility': utility,
    'reason': reason,
  };

  factory _SchemeItem.fromJson(Map<String, dynamic> json) {
    // Reuse the persisted id if present; otherwise generate a new stable one.
    final persistedId = (json['id'] as String?)?.trim() ?? '';
    return _SchemeItem(
      id: persistedId.isNotEmpty ? persistedId : const Uuid().v4(),
      schemeCode: (json['scheme_code'] as String?) ?? '',
      schemeName: (json['scheme_name'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      utility: (json['utility'] as String?) ?? '',
      reason: (json['reason'] as String?) ?? '',
    );
  }
}

/// The 9 fixed scheme definitions (code → default display name).
const List<Map<String, String>> _kFixedSchemes = [
  {'code': 'ration_card', 'name': 'Ration card'},
  {'code': 'kisan_credit_card', 'name': 'Kisan Credit Card'},
  {'code': 'mgnrega_job_card', 'name': 'MGNREGA Job Card'},
  {'code': 'pm_kisan_samman_nidhi', 'name': 'PM-Kisan Samman Nidhi'},
  {'code': 'shg_membership', 'name': 'SHG membership'},
  {'code': 'fpo_membership', 'name': 'FPO membership'},
  {
    'code': 'health_insurance_pmjay',
    'name': 'Health insurance (Ayushman Bharat - PM-JAY)',
  },
  {'code': 'namo_drone_didi', 'name': 'Namo Drone Didi scheme'},
  {'code': 'other', 'name': ''},
];

/// Section O — combined screen: O-01 (awareness), O-02 (availed any), and
/// Scheme / Service Details matrix widget.
///
/// All three are shown on ONE logical screen.
/// Stores the matrix as a JSON list under the key "O-SCHEME-MATRIX" via
/// [onMatrixAnswer].
class SchemeMatrixSectionWidget extends StatefulWidget {
  // ── O-01 ──────────────────────────────────────────────────────────────────
  /// Current answer for O-01 (awareness question).
  final dynamic o01Answer;

  /// O-01 question text (loaded from DB).
  final String o01QuestionText;

  /// O-01 options (loaded from DB).
  final List<String> o01Options;

  /// Called when O-01 answer changes.
  final ValueChanged<dynamic> onO01Answer;

  // ── O-02 ──────────────────────────────────────────────────────────────────
  /// Current answer for O-02 (have you availed any scheme?).
  final dynamic o02Answer;

  /// O-02 question text (loaded from DB).
  final String o02QuestionText;

  /// Called when O-02 answer changes.
  final ValueChanged<dynamic> onO02Answer;

  // ── Matrix ────────────────────────────────────────────────────────────────
  /// The current value of `_answers['O-SCHEME-MATRIX']`.
  final dynamic answer;

  /// Called whenever any scheme item changes.
  final ValueChanged<dynamic> onMatrixAnswer;

  final bool isReadOnly;

  const SchemeMatrixSectionWidget({
    super.key,
    required this.o01Answer,
    required this.o01QuestionText,
    required this.o01Options,
    required this.onO01Answer,
    required this.o02Answer,
    required this.o02QuestionText,
    required this.onO02Answer,
    required this.answer,
    required this.onMatrixAnswer,
    this.isReadOnly = false,
  });

  // Legacy constructor alias kept for backward compatibility (review widget).
  // Callers that only need the matrix (read-only review) can use this.
  factory SchemeMatrixSectionWidget.reviewOnly({
    Key? key,
    required dynamic answer,
    required dynamic o01Answer,
    required String o01QuestionText,
    required List<String> o01Options,
    required dynamic o02Answer,
    required String o02QuestionText,
  }) {
    return SchemeMatrixSectionWidget(
      key: key,
      o01Answer: o01Answer,
      o01QuestionText: o01QuestionText,
      o01Options: o01Options,
      onO01Answer: (_) {},
      o02Answer: o02Answer,
      o02QuestionText: o02QuestionText,
      onO02Answer: (_) {},
      answer: answer,
      onMatrixAnswer: (_) {},
      isReadOnly: true,
    );
  }

  @override
  State<SchemeMatrixSectionWidget> createState() =>
      _SchemeMatrixSectionWidgetState();
}

class _SchemeMatrixSectionWidgetState extends State<SchemeMatrixSectionWidget> {
  late List<_SchemeItem> _items;
  int? _expandedIndex; // null = all collapsed

  // Text controllers for free-text fields (keyed by scheme_code + field)
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _items = _buildInitialItems();
    _initControllers();
  }

  @override
  void didUpdateWidget(SchemeMatrixSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.answer != widget.answer) {
      // Re-parse if the answer was loaded from DB after widget was created
      final newItems = _buildInitialItems();
      for (int i = 0; i < _items.length; i++) {
        final newItem = newItems[i];
        _items[i].status = newItem.status;
        _items[i].utility = newItem.utility;
        _items[i].reason = newItem.reason;
        if (_items[i].schemeCode == 'other') {
          _items[i].schemeName = newItem.schemeName;
        }
        _syncController(_items[i]);
      }
    }
  }

  /// Builds the initial list of scheme items, merging saved data if available.
  /// Stable UUIDs are restored from saved data; new items get a fresh UUID.
  List<_SchemeItem> _buildInitialItems() {
    // Parse saved matrix from answer
    final Map<String, _SchemeItem> savedByCode = {};
    final raw = widget.answer;
    if (raw != null) {
      List<dynamic>? list;
      if (raw is List) {
        list = raw;
      } else if (raw is String && raw.isNotEmpty) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is List) list = decoded;
        } catch (_) {}
      }
      if (list != null) {
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            final parsed = _SchemeItem.fromJson(item);
            if (parsed.schemeCode.isNotEmpty) {
              savedByCode[parsed.schemeCode] = parsed;
            }
          }
        }
      }
    }

    return _kFixedSchemes.map((def) {
      final code = def['code']!;
      final defaultName = def['name']!;
      final saved = savedByCode[code];
      if (saved != null) {
        // Reuse the persisted item (including its stable id)
        return _SchemeItem(
          id: saved.id,
          schemeCode: code,
          schemeName: saved.schemeName.isNotEmpty
              ? saved.schemeName
              : defaultName,
          status: saved.status,
          utility: saved.utility,
          reason: saved.reason,
        );
      }
      // New item — generate a stable UUID now (will be persisted on first save)
      return _SchemeItem(
        id: const Uuid().v4(),
        schemeCode: code,
        schemeName: defaultName,
      );
    }).toList();
  }

  void _initControllers() {
    for (final item in _items) {
      _controllers['${item.schemeCode}_utility'] = TextEditingController(
        text: item.utility,
      );
      _controllers['${item.schemeCode}_reason'] = TextEditingController(
        text: item.reason,
      );
      if (item.schemeCode == 'other') {
        _controllers['other_name'] = TextEditingController(
          text: item.schemeName,
        );
      }
    }
  }

  void _syncController(_SchemeItem item) {
    final utilityKey = '${item.schemeCode}_utility';
    final reasonKey = '${item.schemeCode}_reason';
    if (_controllers[utilityKey]?.text != item.utility) {
      _controllers[utilityKey]?.text = item.utility;
    }
    if (_controllers[reasonKey]?.text != item.reason) {
      _controllers[reasonKey]?.text = item.reason;
    }
    if (item.schemeCode == 'other') {
      if (_controllers['other_name']?.text != item.schemeName) {
        _controllers['other_name']?.text = item.schemeName;
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _notifyChange() {
    final matrix = _items.map((i) => i.toJson()).toList();
    widget.onMatrixAnswer(matrix);
  }

  void _onStatusChanged(_SchemeItem item, String newStatus) {
    setState(() {
      if (newStatus == 'availed') {
        item.reason = '';
        _controllers['${item.schemeCode}_reason']?.text = '';
      } else if (newStatus == 'not_availed') {
        item.utility = '';
        _controllers['${item.schemeCode}_utility']?.text = '';
      }
      item.status = newStatus;
    });
    _notifyChange();
  }

  void _onUtilityChanged(_SchemeItem item, String value) {
    item.utility = value;
    _notifyChange();
  }

  void _onReasonChanged(_SchemeItem item, String value) {
    item.reason = value;
    _notifyChange();
  }

  void _onOtherNameChanged(_SchemeItem item, String value) {
    item.schemeName = value;
    _notifyChange();
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'O.  Access to Schemes & Services',
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── O-01: Awareness of Govt. schemes ───────────────────────────────
        _buildO01Card(theme),
        const SizedBox(height: 12),

        // ── O-02: Have you availed any scheme? ─────────────────────────────
        _buildO02Card(theme),
        const SizedBox(height: 16),

        // ── Scheme / Service Details heading ───────────────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.blue.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue.withAlpha(51)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: Colors.blue[700],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tap a scheme to expand it and enter details.',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // ── Scheme cards ────────────────────────────────────────────────────
        for (int i = 0; i < _items.length; i++) ...[
          _buildSchemeCard(theme, i),
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  // ── O-01 card ─────────────────────────────────────────────────────────────

  Widget _buildO01Card(ThemeData theme) {
    final questionText = widget.o01QuestionText.isNotEmpty
        ? widget.o01QuestionText
        : 'Awareness of Govt. schemes:';
    final options = widget.o01Options.isNotEmpty
        ? widget.o01Options
        : ['Fully aware', 'Partially aware', 'Not aware'];
    final currentAnswer = widget.o01Answer?.toString() ?? '';

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'O-01',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  questionText,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((opt) {
              final isSelected =
                  currentAnswer.trim().toLowerCase() ==
                  opt.trim().toLowerCase();
              return GestureDetector(
                onTap: widget.isReadOnly ? null : () => widget.onO01Answer(opt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primary.withAlpha(26)
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primary.withAlpha(153)
                          : theme.colorScheme.outline.withAlpha(51),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    opt,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected
                          ? AppTheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── O-02 card ─────────────────────────────────────────────────────────────

  Widget _buildO02Card(ThemeData theme) {
    final questionText = widget.o02QuestionText.isNotEmpty
        ? widget.o02QuestionText
        : 'Have you availed any scheme?';
    // Normalise: stored as option_value from DB (e.g. "yes"/"no") or
    // display text ("Yes"/"No"). Compare case-insensitively.
    final rawAnswer = widget.o02Answer?.toString().trim().toLowerCase() ?? '';
    final isYes = rawAnswer == 'yes';
    final isNo = rawAnswer == 'no';

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'O-02',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  questionText,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildYesNoButton(
                  theme: theme,
                  label: 'Yes',
                  isSelected: isYes,
                  selectedColor: AppTheme.success,
                  onTap: () => widget.onO02Answer('yes'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildYesNoButton(
                  theme: theme,
                  label: 'No',
                  isSelected: isNo,
                  selectedColor: AppTheme.error,
                  onTap: () => widget.onO02Answer('no'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildYesNoButton({
    required ThemeData theme,
    required String label,
    required bool isSelected,
    required Color selectedColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: widget.isReadOnly ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withAlpha(26)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? selectedColor.withAlpha(153)
                : theme.colorScheme.outline.withAlpha(51),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? selectedColor
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  // ── Scheme card ───────────────────────────────────────────────────────────

  Widget _buildSchemeCard(ThemeData theme, int index) {
    final item = _items[index];
    final isExpanded = _expandedIndex == index;
    final isOther = item.schemeCode == 'other';
    final displayName = isOther
        ? (item.schemeName.isNotEmpty ? item.schemeName : 'Other (if any)')
        : item.schemeName;

    // Status indicator color
    Color? statusColor;
    if (item.status == 'availed') {
      statusColor = AppTheme.success;
    } else if (item.status == 'not_availed') {
      statusColor = AppTheme.error;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExpanded
              ? AppTheme.primary.withAlpha(128)
              : theme.colorScheme.outline.withAlpha(51),
          width: isExpanded ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isExpanded ? 15 : 8),
            blurRadius: isExpanded ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row (always visible)
          InkWell(
            onTap: widget.isReadOnly
                ? null
                : () {
                    setState(() {
                      _expandedIndex = isExpanded ? null : index;
                    });
                  },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Index badge
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? AppTheme.primary
                          : AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isExpanded ? Colors.white : AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Scheme name
                  Expanded(
                    child: Text(
                      displayName,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Status chip
                  if (item.status.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor?.withAlpha(26),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              statusColor?.withAlpha(102) ?? Colors.transparent,
                        ),
                      ),
                      child: Text(
                        item.status == 'availed' ? 'Availed' : 'Not availed',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  const SizedBox(width: 6),
                  // Chevron
                  AnimatedRotation(
                    turns: isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: isExpanded
                          ? AppTheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (isExpanded) ...[
            Divider(
              height: 1,
              thickness: 1,
              color: AppTheme.primary.withAlpha(51),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Other" scheme name field
                  if (isOther) ...[
                    Text(
                      'Scheme / Service Name',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _controllers['other_name']!,
                      hint: 'Enter scheme or service name',
                      onChanged: (v) => _onOtherNameChanged(item, v),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Status selection
                  Text(
                    'Status',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusButton(
                          label: 'Availed',
                          icon: Icons.check_circle_outline_rounded,
                          isSelected: item.status == 'availed',
                          selectedColor: AppTheme.success,
                          onTap: () => _onStatusChanged(item, 'availed'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildStatusButton(
                          label: 'Not availed',
                          icon: Icons.cancel_outlined,
                          isSelected: item.status == 'not_availed',
                          selectedColor: AppTheme.error,
                          onTap: () => _onStatusChanged(item, 'not_availed'),
                        ),
                      ),
                    ],
                  ),

                  // Utility field (shown when availed)
                  if (item.status == 'availed') ...[
                    const SizedBox(height: 16),
                    Text(
                      'Utility',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _controllers['${item.schemeCode}_utility']!,
                      hint: 'Describe how this scheme was useful',
                      onChanged: (v) => _onUtilityChanged(item, v),
                      maxLines: 3,
                    ),
                  ],

                  // Reason field (shown when not availed)
                  if (item.status == 'not_availed') ...[
                    const SizedBox(height: 16),
                    Text(
                      'Reason for not availing',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _controllers['${item.schemeCode}_reason']!,
                      hint: 'Explain why this scheme was not availed',
                      onChanged: (v) => _onReasonChanged(item, v),
                      maxLines: 3,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color selectedColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: widget.isReadOnly ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withAlpha(26)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? selectedColor.withAlpha(153)
                : theme.colorScheme.outline.withAlpha(51),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? selectedColor
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? selectedColor
                      : theme.colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: widget.isReadOnly,
      style: GoogleFonts.manrope(
        fontSize: 13,
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.manrope(
          fontSize: 12,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withAlpha(102),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withAlpha(77),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
        ),
        filled: true,
        fillColor: widget.isReadOnly
            ? theme.colorScheme.surfaceContainerHighest
            : theme.colorScheme.surfaceContainerLowest,
      ),
      onChanged: onChanged,
    );
  }
}

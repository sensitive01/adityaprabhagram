import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

// ─── Response key ─────────────────────────────────────────────────────────────

const String kEnumeratorObservationKey = 'Z-ENUMERATOR-OBSERVATION';

// ─── Main Widget ──────────────────────────────────────────────────────────────

class EnumeratorObservationSectionWidget extends StatefulWidget {
  final dynamic answer;
  final ValueChanged<Map<String, dynamic>> onAnswer;
  final bool isReadOnly;

  const EnumeratorObservationSectionWidget({
    super.key,
    required this.answer,
    required this.onAnswer,
    this.isReadOnly = false,
  });

  @override
  State<EnumeratorObservationSectionWidget> createState() =>
      _EnumeratorObservationSectionWidgetState();
}

class _EnumeratorObservationSectionWidgetState
    extends State<EnumeratorObservationSectionWidget> {
  late TextEditingController _rank1Controller;
  late TextEditingController _rank2Controller;
  late TextEditingController _rank3Controller;

  @override
  void initState() {
    super.initState();
    final data = _parseData(widget.answer);
    _rank1Controller = TextEditingController(
      text: data['rank1'] as String? ?? '',
    );
    _rank2Controller = TextEditingController(
      text: data['rank2'] as String? ?? '',
    );
    _rank3Controller = TextEditingController(
      text: data['rank3'] as String? ?? '',
    );
  }

  @override
  void didUpdateWidget(EnumeratorObservationSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.answer != widget.answer) {
      final data = _parseData(widget.answer);
      final r1 = data['rank1'] as String? ?? '';
      final r2 = data['rank2'] as String? ?? '';
      final r3 = data['rank3'] as String? ?? '';
      if (_rank1Controller.text != r1) _rank1Controller.text = r1;
      if (_rank2Controller.text != r2) _rank2Controller.text = r2;
      if (_rank3Controller.text != r3) _rank3Controller.text = r3;
    }
  }

  @override
  void dispose() {
    _rank1Controller.dispose();
    _rank2Controller.dispose();
    _rank3Controller.dispose();
    super.dispose();
  }

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

  void _emitAnswer() {
    widget.onAnswer({
      'rank1': _rank1Controller.text,
      'rank2': _rank2Controller.text,
      'rank3': _rank3Controller.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primary.withAlpha(15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primary.withAlpha(40)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  color: AppTheme.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Section Z',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                    Text(
                      'Enumerator Observation',
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Instruction card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A73E8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instruction',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A73E8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'To be filled by the enumerator based on field observation',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Rank 1
        _buildRankField(
          theme: theme,
          rank: 1,
          controller: _rank1Controller,
          hint: 'Enter first priority need',
        ),
        const SizedBox(height: 16),

        // Rank 2
        _buildRankField(
          theme: theme,
          rank: 2,
          controller: _rank2Controller,
          hint: 'Enter second priority need',
        ),
        const SizedBox(height: 16),

        // Rank 3
        _buildRankField(
          theme: theme,
          rank: 3,
          controller: _rank3Controller,
          hint: 'Enter third priority need',
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildRankField({
    required ThemeData theme,
    required int rank,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$rank.',
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.error,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: widget.isReadOnly,
          maxLength: 200,
          maxLines: 2,
          minLines: 1,
          onChanged: (_) => _emitAnswer(),
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.manrope(
              fontSize: 14,
              color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
            ),
            counterStyle: GoogleFonts.manrope(
              fontSize: 11,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Review Widget ────────────────────────────────────────────────────────────

class EnumeratorObservationReviewWidget extends StatelessWidget {
  final dynamic answer;

  const EnumeratorObservationReviewWidget({super.key, required this.answer});

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = _parseData(answer);
    final rank1 = (data['rank1'] as String?) ?? '';
    final rank2 = (data['rank2'] as String?) ?? '';
    final rank3 = (data['rank3'] as String?) ?? '';

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
                Expanded(
                  child: Text(
                    'Enumerator Observation',
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
                _buildReviewRow(theme, 'Rank 1', rank1, false),
                _buildReviewRow(theme, 'Rank 2', rank2, false),
                _buildReviewRow(theme, 'Rank 3', rank3, true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewRow(
    ThemeData theme,
    String label,
    String value,
    bool isLast,
  ) {
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

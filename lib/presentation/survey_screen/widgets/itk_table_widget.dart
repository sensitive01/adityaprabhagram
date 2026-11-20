import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

/// A dynamic table widget for I-07 (ITK — Indigenous Technical Knowledge).
///
/// Columns: S. No. | ITK Practice | Purpose/Use | Materials Used
///
/// The answer value is a JSON-encoded List of objects:
/// [{"itk_practice":"...","purpose_use":"...","materials_used":"..."}]
///
/// Pass [answer] (the current stored value) and [onAnswer] to wire into the
/// survey answer flow.
class ItkTableWidget extends StatefulWidget {
  final dynamic answer;
  final ValueChanged<dynamic> onAnswer;
  final bool isReadOnly;

  const ItkTableWidget({
    super.key,
    required this.answer,
    required this.onAnswer,
    this.isReadOnly = false,
  });

  @override
  State<ItkTableWidget> createState() => _ItkTableWidgetState();
}

class _ItkTableRow {
  final TextEditingController itkPractice;
  final TextEditingController purposeUse;
  final TextEditingController materialsUsed;

  _ItkTableRow({
    String itkPractice = '',
    String purposeUse = '',
    String materialsUsed = '',
  }) : itkPractice = TextEditingController(text: itkPractice),
       purposeUse = TextEditingController(text: purposeUse),
       materialsUsed = TextEditingController(text: materialsUsed);

  void dispose() {
    itkPractice.dispose();
    purposeUse.dispose();
    materialsUsed.dispose();
  }
}

class _ItkTableWidgetState extends State<ItkTableWidget> {
  final List<_ItkTableRow> _rows = [];

  @override
  void initState() {
    super.initState();
    _initFromAnswer(widget.answer);
    if (_rows.isEmpty) {
      _rows.add(_ItkTableRow());
    }
  }

  @override
  void didUpdateWidget(ItkTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only re-init if the question changed (different answer object identity
    // from a different question load — not from our own edits).
    if (oldWidget.answer != widget.answer && widget.answer != _encodeAnswer()) {
      _disposeRows();
      _initFromAnswer(widget.answer);
      if (_rows.isEmpty) {
        _rows.add(_ItkTableRow());
      }
    }
  }

  void _initFromAnswer(dynamic answer) {
    if (answer == null) return;
    try {
      List<dynamic> parsed;
      if (answer is String && answer.isNotEmpty) {
        // Legacy plain-text value (e.g. "Ant, storage pest") — ignore, start fresh
        final trimmed = answer.trim();
        if (!trimmed.startsWith('[')) return;
        parsed = jsonDecode(trimmed) as List<dynamic>;
      } else if (answer is List) {
        parsed = answer;
      } else {
        return;
      }
      for (final item in parsed) {
        if (item is Map) {
          _rows.add(
            _ItkTableRow(
              itkPractice: (item['itk_practice'] as String?) ?? '',
              purposeUse: (item['purpose_use'] as String?) ?? '',
              materialsUsed: (item['materials_used'] as String?) ?? '',
            ),
          );
        }
      }
    } catch (_) {
      // Malformed — start fresh
    }
  }

  void _disposeRows() {
    for (final r in _rows) {
      r.dispose();
    }
    _rows.clear();
  }

  @override
  void dispose() {
    _disposeRows();
    super.dispose();
  }

  /// Encodes current rows to a JSON string for storage.
  String _encodeAnswer() {
    final list = _rows
        .map(
          (r) => {
            'itk_practice': r.itkPractice.text.trim(),
            'purpose_use': r.purposeUse.text.trim(),
            'materials_used': r.materialsUsed.text.trim(),
          },
        )
        .toList();
    return jsonEncode(list);
  }

  void _notifyAnswer() {
    widget.onAnswer(_encodeAnswer());
  }

  void _addRow() {
    setState(() {
      _rows.add(_ItkTableRow());
    });
    // No answer notification needed for adding an empty row
  }

  void _removeRow(int index) {
    setState(() {
      _rows[index].dispose();
      _rows.removeAt(index);
      if (_rows.isEmpty) {
        _rows.add(_ItkTableRow());
      }
    });
    _notifyAnswer();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Horizontally scrollable table
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: _buildTable(theme),
        ),
        const SizedBox(height: 12),
        if (!widget.isReadOnly) _buildAddRowButton(theme),
      ],
    );
  }

  Widget _buildTable(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.primaryContainer, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        defaultColumnWidth: const IntrinsicColumnWidth(),
        border: TableBorder(
          horizontalInside: BorderSide(
            color: AppTheme.primaryContainer,
            width: 1,
          ),
          verticalInside: BorderSide(
            color: AppTheme.primaryContainer,
            width: 1,
          ),
        ),
        children: [
          _buildHeaderRow(theme),
          ..._rows.asMap().entries.map((e) => _buildDataRow(theme, e.key)),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow(ThemeData theme) {
    const headers = ['S. No.', 'ITK Practice', 'Purpose/Use', 'Materials Used'];
    return TableRow(
      decoration: BoxDecoration(color: AppTheme.primaryContainer),
      children: [
        ...headers.map(
          (h) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              h,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
              textAlign: h == 'S. No.' ? TextAlign.center : TextAlign.left,
            ),
          ),
        ),
        // Delete column header (empty)
        if (!widget.isReadOnly) const SizedBox(width: 36),
      ],
    );
  }

  TableRow _buildDataRow(ThemeData theme, int index) {
    final row = _rows[index];
    final sNo = index + 1;

    return TableRow(
      decoration: BoxDecoration(
        color: index.isEven
            ? theme.colorScheme.surface
            : AppTheme.primaryContainer.withAlpha(40),
      ),
      children: [
        // S. No.
        Container(
          width: 52,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '$sNo',
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
        ),
        // ITK Practice
        _buildCell(row.itkPractice, 'Enter text...'),
        // Purpose/Use
        _buildCell(row.purposeUse, 'Enter text...'),
        // Materials Used
        _buildCell(row.materialsUsed, 'Enter text...'),
        // Delete button
        if (!widget.isReadOnly)
          InkWell(
            onTap: () => _removeRow(index),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Icon(
                Icons.remove_circle_outline_rounded,
                size: 18,
                color: AppTheme.error.withAlpha(180),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCell(TextEditingController controller, String hint) {
    if (widget.isReadOnly) {
      return Container(
        width: 140,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Text(
          controller.text.isEmpty ? '—' : controller.text,
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: controller.text.isEmpty
                ? Colors.grey.shade400
                : Colors.black87,
          ),
        ),
      );
    }
    return SizedBox(
      width: 140,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: TextField(
          controller: controller,
          onChanged: (_) => _notifyAnswer(),
          style: GoogleFonts.manrope(fontSize: 13, color: Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.manrope(
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            filled: true,
            fillColor: Colors.white,
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
          ),
          maxLines: 2,
          minLines: 1,
        ),
      ),
    );
  }

  Widget _buildAddRowButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _addRow,
        icon: const Icon(Icons.add_rounded, size: 18),
        label: Text(
          'Add Row',
          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primary,
          side: BorderSide(color: AppTheme.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

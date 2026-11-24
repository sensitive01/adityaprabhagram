import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

/// Reusable data table for admin screens
class AdminDataTable extends StatelessWidget {
  final List<String> columns;
  final List<List<dynamic>> rows;
  final void Function(int index)? onRowTap;

  const AdminDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onRowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            AppTheme.surfaceVariantLight,
          ),
          dataRowMinHeight: 44,
          dataRowMaxHeight: 56,
          headingRowHeight: 44,
          columnSpacing: 20,
          horizontalMargin: 16,
          columns: columns
              .map(
                (c) => DataColumn(
                  label: Text(
                    c,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4A5568),
                    ),
                  ),
                ),
              )
              .toList(),
          rows: rows.asMap().entries.map((entry) {
            final i = entry.key;
            final row = entry.value;
            return DataRow(
              onSelectChanged: onRowTap != null ? (_) => onRowTap!(i) : null,
              cells: row.map((cell) {
                if (cell is Widget) return DataCell(cell);
                final text = cell.toString();
                return DataCell(
                  Text(
                    text,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      color: const Color(0xFF374151),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }
}

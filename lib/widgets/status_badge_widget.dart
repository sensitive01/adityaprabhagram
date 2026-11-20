import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class StatusBadgeWidget extends StatelessWidget {
  final String status;
  final double fontSize;
  final EdgeInsets? padding;

  const StatusBadgeWidget({
    super.key,
    required this.status,
    this.fontSize = 11,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.statusColor(status);
    final containerColor = AppTheme.statusContainerColor(status);

    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: GoogleFonts.manrope(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

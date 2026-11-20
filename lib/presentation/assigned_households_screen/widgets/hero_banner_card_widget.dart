import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class HeroBannerCardWidget extends StatelessWidget {
  final int totalAssigned;
  final int pendingCount;
  final int correctionCount;
  final int approvedCount;

  const HeroBannerCardWidget({
    super.key,
    required this.totalAssigned,
    required this.pendingCount,
    required this.correctionCount,
    required this.approvedCount,
  });

  @override
  Widget build(BuildContext context) {
    final completionPct = totalAssigned > 0
        ? ((approvedCount / totalAssigned) * 100).round()
        : 0;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withAlpha(77),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
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
                      'Today\'s Assignment',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withAlpha(179),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$approvedCount',
                          style: GoogleFonts.manrope(
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1,
                            fontFeatures: [const FontFeature.tabularFigures()],
                          ),
                        ),
                        Text(
                          ' / $totalAssigned',
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withAlpha(153),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Surveys Approved',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withAlpha(204),
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: totalAssigned > 0
                          ? approvedCount / totalAssigned
                          : 0,
                      backgroundColor: Colors.white.withAlpha(51),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF74C69D),
                      ),
                      strokeWidth: 6,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Text(
                    '$completionPct%',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: totalAssigned > 0 ? approvedCount / totalAssigned : 0,
              backgroundColor: Colors.white.withAlpha(51),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF74C69D),
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatChip(
                label: 'Pending',
                count: pendingCount,
                color: Colors.white.withAlpha(204),
                bgColor: Colors.white.withAlpha(31),
              ),
              const SizedBox(width: 8),
              _StatChip(
                label: 'Corrections',
                count: correctionCount,
                color: const Color(0xFFFCD34D),
                bgColor: const Color(0xFFFCD34D).withAlpha(38),
              ),
              const SizedBox(width: 8),
              _StatChip(
                label: 'Total',
                count: totalAssigned,
                color: Colors.white.withAlpha(204),
                bgColor: Colors.white.withAlpha(31),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final Color bgColor;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color.withAlpha(204),
            ),
          ),
        ],
      ),
    );
  }
}

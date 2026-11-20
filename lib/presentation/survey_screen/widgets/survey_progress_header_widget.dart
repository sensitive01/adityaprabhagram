import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SurveyProgressHeaderWidget extends StatelessWidget {
  final int currentSection;
  final int totalSections;
  final String sectionTitle;
  final int answeredCount;
  final int totalQuestions;
  final double progressPercent;
  final int currentQuestionIndex;
  final int totalInSection;

  const SurveyProgressHeaderWidget({
    super.key,
    required this.currentSection,
    required this.totalSections,
    required this.sectionTitle,
    required this.answeredCount,
    required this.totalQuestions,
    required this.progressPercent,
    required this.currentQuestionIndex,
    required this.totalInSection,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = (progressPercent * 100).round().clamp(0, 100);

    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Section $currentSection of $totalSections',
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
                  sectionTitle,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$answeredCount/$totalQuestions',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                widthFactor: progressPercent.clamp(0.0, 1.0),
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: progressPercent > 0.8
                        ? AppTheme.success
                        : AppTheme.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$pct% complete',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${totalQuestions - answeredCount} remaining',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class SurveyNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final bool isReviewMode;
  final bool isSubmitting;
  final bool canGoNext;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback? onReview;
  final VoidCallback? onSubmit;
  final VoidCallback onSaveDraft;

  const SurveyNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
    required this.isReviewMode,
    required this.isSubmitting,
    required this.canGoNext,
    this.onPrev,
    this.onNext,
    this.onReview,
    this.onSubmit,
    required this.onSaveDraft,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastQuestion = currentIndex == totalQuestions - 1;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline.withAlpha(51)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          if (onPrev != null)
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: onPrev,
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurface,
                  side: BorderSide(
                    color: theme.colorScheme.outline.withAlpha(128),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: Text(
                  isReviewMode ? 'Back to Edit' : 'Previous',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 8),
          const Spacer(),
          if (!isReviewMode)
            Text(
              '${currentIndex + 1} / $totalQuestions',
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
          const Spacer(),
          if (isReviewMode && onSubmit != null)
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: isSubmitting ? null : onSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: AppTheme.success.withAlpha(153),
                ),
                icon: isSubmitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded, size: 18),
                label: Text(
                  isSubmitting ? 'Submitting...' : 'Submit Survey',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          else if (isLastQuestion && onReview != null)
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: onReview,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.rate_review_rounded, size: 18),
                label: Text(
                  'Review',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          else if (onNext != null)
            SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: canGoNext ? onNext : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: AppTheme.primary.withAlpha(102),
                ),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: Text(
                  'Next',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

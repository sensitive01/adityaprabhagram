import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';
import '../survey_screen.dart';

class SurveyReviewWidget extends StatelessWidget {
  final List<SurveyQuestion> questions;
  final Map<String, dynamic> answers;
  final ValueChanged<int>? onEditQuestion;
  final bool isReadOnly;

  /// Ordered list of all active sections from survey_sections, each entry:
  /// { 'id': String, 'title': String, 'code': String, 'displayOrder': int }
  /// Used to position [pestWidget] at its correct display_order slot.
  final List<Map<String, dynamic>> orderedSections;

  /// The Section E structured widget (PestDiseaseSectionWidget).
  /// Rendered at the position of the section with section_code == 'E'.
  final Widget? pestWidget;

  /// The Section F structured widget (LivestockPestDiseaseSectionWidget).
  /// Rendered at the position of the section with section_code == 'SEC-F'.
  final Widget? livestockWidget;

  /// The Section O combined widget (SchemeMatrixSectionWidget in read-only mode).
  /// Rendered at the position of the section with section_code == 'O' or 'SEC-O'.
  final Widget? schemeMatrixWidget;

  /// The Section P combined widget (P2TrainingNeedsSectionWidget in read-only mode).
  /// Rendered at the position of the section with section_code == 'P' or 'SEC-P'.
  final Widget? p2TrainingNeedsWidget;

  /// The Section R combined widget (GenderDecisionMakingReviewWidget in read-only mode).
  /// Rendered at the position of the section with section_code == 'R' or 'SEC-R'.
  final Widget? genderDecisionMakingWidget;

  /// The Section S combined widget (HouseholdExpenditureReviewWidget in read-only mode).
  /// Rendered at the position of the section with section_code == 'S' or 'SEC-S'.
  final Widget? householdExpenditureWidget;

  /// The Section T combined widget (GenderWorkDistributionReviewWidget in read-only mode).
  /// Rendered at the position of the section with section_code == 'T' or 'SEC-T'.
  final Widget? genderWorkDistributionWidget;

  /// The Section X combined widget (BorderSpecificConstraintsReviewWidget in read-only mode).
  /// Rendered at the position of the section with section_code == 'X'.
  final Widget? borderSpecificConstraintsWidget;

  /// The Section Y combined widget (HouseholdPriorityNeedsReviewWidget in read-only mode).
  /// Rendered at the position of the section with section_code == 'Y'.
  final Widget? householdPriorityNeedsWidget;

  /// The Section Z combined widget (EnumeratorObservationReviewWidget in read-only mode).
  /// Rendered at the position of the section with section_code == 'Z'.
  final Widget? enumeratorObservationWidget;

  /// The Section A structured widget (RespondentDetailsSectionWidget in read-only mode).
  /// Rendered at the position of the section with section_code == 'A' or 'SEC-A'.
  final Widget? respondentDetailsWidget;

  /// The Section B structured widget (HouseholdProfileSectionWidget in read-only mode).
  /// Rendered at the position of the section with section_code == 'B' or 'SEC-B'.
  final Widget? householdProfileWidget;

  /// The Section C structured widget (HouseholdAssetsSectionWidget in read-only mode).
  /// Rendered at the position of the section with section_code == 'C' or 'SEC-C'.
  final Widget? householdAssetsWidget;

  const SurveyReviewWidget({
    super.key,
    required this.questions,
    required this.answers,
    this.onEditQuestion,
    this.isReadOnly = false,
    this.orderedSections = const [],
    this.pestWidget,
    this.livestockWidget,
    this.schemeMatrixWidget,
    this.p2TrainingNeedsWidget,
    this.genderDecisionMakingWidget,
    this.householdExpenditureWidget,
    this.genderWorkDistributionWidget,
    this.borderSpecificConstraintsWidget,
    this.householdPriorityNeedsWidget,
    this.enumeratorObservationWidget,
    this.respondentDetailsWidget,
    this.householdProfileWidget,
    this.householdAssetsWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Mirror the same conditional-visibility logic used in survey_screen.dart.
    bool isVisible(SurveyQuestion q) {
      final parentId = q.conditionalOnQuestionId;
      final requiredValue = q.conditionalOnValue;
      if (parentId == null || parentId.isEmpty) return true;
      if (requiredValue == null || requiredValue.isEmpty) return true;
      final parentAnswer = answers[parentId];
      if (parentAnswer == null) return false;
      final parentStr = parentAnswer.toString().trim().toLowerCase();
      return parentStr == requiredValue.trim().toLowerCase();
    }

    final visibleQuestions = questions.where(isVisible).toList();

    // Build a map: sectionTitle → questions (preserving section order from DB)
    // When schemeMatrixWidget is provided, exclude O-01 and O-02 from the
    // regular question map (they are rendered inside schemeMatrixWidget).
    final oQuestionIds = schemeMatrixWidget != null
        ? const {
            'cf094f24-5672-42be-8de1-9752cc08d93c',
            'd4f5d4b5-505d-4046-aacc-4ef39210da52',
          }
        : const <String>{};
    final sections = <String, List<SurveyQuestion>>{};
    for (final q in visibleQuestions) {
      if (oQuestionIds.contains(q.id)) continue;
      if (respondentDetailsWidget != null &&
          (q.sectionTitle.toLowerCase().contains('respondent') ||
           q.sectionTitle.startsWith('A:') ||
           q.sectionTitle.startsWith('A -') ||
           (q.questionCode != null && q.questionCode!.startsWith('A-')))) {
        continue;
      }
      if (householdProfileWidget != null &&
          (q.sectionTitle.toLowerCase().contains('household profile') ||
           q.sectionTitle.startsWith('B:') ||
           q.sectionTitle.startsWith('B -') ||
           (q.questionCode != null && q.questionCode!.startsWith('B-')) ||
           q.id.startsWith('B1_'))) {
        continue;
      }
      sections.putIfAbsent(q.sectionTitle, () => []).add(q);
    }

    final unansweredRequired = visibleQuestions.where((q) {
      if (!q.isRequired) return false;
      if (respondentDetailsWidget != null &&
          (q.sectionTitle.toLowerCase().contains('respondent') ||
           q.sectionTitle.startsWith('A:') ||
           q.sectionTitle.startsWith('A -') ||
           (q.questionCode != null && q.questionCode!.startsWith('A-')))) {
        return false;
      }
      if (householdProfileWidget != null &&
          (q.sectionTitle.toLowerCase().contains('household profile') ||
           q.sectionTitle.startsWith('B:') ||
           q.sectionTitle.startsWith('B -') ||
           (q.questionCode != null && q.questionCode!.startsWith('B-')) ||
           q.id.startsWith('B1_'))) {
        return false;
      }
      final ans = answers[q.id];
      if (ans == null) return true;
      if (ans is String) return ans.isEmpty;
      if (ans is List) return (ans).isEmpty;
      // Q-G-03 / Q-G-09 Map format: unanswered if selections is empty
      if (ans is Map && ans.containsKey('selections')) {
        return ((ans['selections'] as List?) ?? []).isEmpty;
      }
      return false;
    }).length;

    // Build the ordered list of section slivers, inserting pestWidget at the
    // correct position according to orderedSections display_order.
    //
    // Strategy:
    //   1. Walk orderedSections in display_order order.
    //   2. For each section:
    //      a. If section_code == 'E' and pestWidget != null → emit pestWidget sliver.
    //      b. Otherwise, if the section title exists in the questions map → emit
    //         the normal question-list sliver.
    //      c. Sections with no questions AND no special widget are skipped.
    //   3. Any section titles in `sections` that were NOT matched by orderedSections
    //      are appended at the end (safety fallback).

    final List<Widget> sectionSlivers = [];
    final handledTitles = <String>{};

    if (orderedSections.isNotEmpty) {
      for (final sec in orderedSections) {
        final code = (sec['code'] as String? ?? '').toUpperCase();
        final title = sec['title'] as String? ?? '';

        // Section A: render the combined respondent details widget
        if ((code == 'A' || code == 'SEC-A' || code.startsWith('A-')) &&
            respondentDetailsWidget != null) {
          handledTitles.add(title);
          sectionSlivers.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: respondentDetailsWidget!,
            ),
          );
          continue;
        }

        // Section B: render the combined household profile widget
        if ((code == 'B' || code == 'SEC-B' || code.startsWith('B-') || code == 'B1' || code == 'SEC-B1') &&
            householdProfileWidget != null) {
          handledTitles.add(title);
          sectionSlivers.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: householdProfileWidget!,
            ),
          );
          continue;
        }

        // Section C: render the combined household assets / land / livestock widget
        if ((code == 'C' || code == 'SEC-C' || code.startsWith('C-') || code == 'C10' || code == 'SEC-C10') &&
            householdAssetsWidget != null) {
          handledTitles.add(title);
          sectionSlivers.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: householdAssetsWidget!,
            ),
          );
          continue;
        }

        if ((code == 'E' || code == 'SEC-E') && pestWidget != null) {
          sectionSlivers.add(pestWidget!);
          continue;
        }

        if ((code == 'F' || code == 'SEC-F') && livestockWidget != null) {
          sectionSlivers.add(livestockWidget!);
          continue;
        }

        // Section O: render the combined scheme matrix widget (includes O-01, O-02, matrix)
        if ((code == 'O' || code == 'SEC-O') && schemeMatrixWidget != null) {
          handledTitles.add(title);
          sectionSlivers.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: schemeMatrixWidget!,
            ),
          );
          continue;
        }

        // Section P: render the P2 training needs widget
        if ((code == 'P' || code == 'SEC-P') && p2TrainingNeedsWidget != null) {
          handledTitles.add(title);
          sectionSlivers.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: p2TrainingNeedsWidget!,
            ),
          );
          continue;
        }

        // Section R: render the gender & decision making widget
        if ((code == 'R' || code == 'SEC-R') &&
            genderDecisionMakingWidget != null) {
          handledTitles.add(title);
          sectionSlivers.add(genderDecisionMakingWidget!);
          continue;
        }

        // Section S: render the household expenditure widget
        if ((code == 'S' || code == 'SEC-S') &&
            householdExpenditureWidget != null) {
          handledTitles.add(title);
          sectionSlivers.add(householdExpenditureWidget!);
          continue;
        }

        // Section T: render the gender work distribution widget
        if ((code == 'T' || code == 'SEC-T') &&
            genderWorkDistributionWidget != null) {
          handledTitles.add(title);
          sectionSlivers.add(genderWorkDistributionWidget!);
          continue;
        }

        // Section X: render the border-specific constraints widget
        if (code == 'X' && borderSpecificConstraintsWidget != null) {
          handledTitles.add(title);
          sectionSlivers.add(borderSpecificConstraintsWidget!);
          continue;
        }

        // Section Y: render the household priority needs widget
        if (code == 'Y' && householdPriorityNeedsWidget != null) {
          handledTitles.add(title);
          sectionSlivers.add(householdPriorityNeedsWidget!);
          continue;
        }

        // Section Z: render the enumerator observation widget
        if (code == 'Z' && enumeratorObservationWidget != null) {
          handledTitles.add(title);
          sectionSlivers.add(enumeratorObservationWidget!);
          continue;
        }

        if (sections.containsKey(title)) {
          // For Section O, filter out O-01 and O-02 if schemeMatrixWidget handles them
          final sectionQs = sections[title]!;
          final filteredQs =
              (code == 'O' || code == 'SEC-O') && schemeMatrixWidget != null
              ? sectionQs
                    .where(
                      (q) =>
                          q.id != 'cf094f24-5672-42be-8de1-9752cc08d93c' &&
                          q.id != 'd4f5d4b5-505d-4046-aacc-4ef39210da52',
                    )
                    .toList()
              : sectionQs;
          if (filteredQs.isNotEmpty) {
            handledTitles.add(title);
            sectionSlivers.add(
              _buildSectionSliver(
                context,
                theme,
                title,
                filteredQs,
                visibleQuestions,
              ),
            );
          } else {
            handledTitles.add(title);
          }
        }
      }

      // Fallback: emit any section titles not covered by orderedSections
      for (final entry in sections.entries) {
        if (!handledTitles.contains(entry.key)) {
          sectionSlivers.add(
            _buildSectionSliver(
              context,
              theme,
              entry.key,
              entry.value,
              visibleQuestions,
            ),
          );
        }
      }
    } else {
      // No orderedSections provided — fall back to original behaviour:
      // render question sections in the order they appear, then pestWidget last.
      for (final entry in sections.entries) {
        sectionSlivers.add(
          _buildSectionSliver(
            context,
            theme,
            entry.key,
            entry.value,
            visibleQuestions,
          ),
        );
      }
      if (pestWidget != null) {
        sectionSlivers.add(pestWidget!);
      }
      if (livestockWidget != null) {
        sectionSlivers.add(livestockWidget!);
      }
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isReadOnly)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: unansweredRequired > 0
                          ? AppTheme.warningContainer
                          : AppTheme.successContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          unansweredRequired > 0
                              ? Icons.warning_amber_rounded
                              : Icons.check_circle_rounded,
                          color: unansweredRequired > 0
                              ? AppTheme.warning
                              : AppTheme.success,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                unansweredRequired > 0
                                    ? '$unansweredRequired required question(s) unanswered'
                                    : 'All required questions answered',
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: unansweredRequired > 0
                                      ? AppTheme.warning
                                      : AppTheme.success,
                                ),
                              ),
                              Text(
                                unansweredRequired > 0
                                    ? 'Please go back and complete the required fields'
                                    : 'Review your answers and submit when ready',
                                style: GoogleFonts.manrope(
                                  fontSize: 11,
                                  color: unansweredRequired > 0
                                      ? AppTheme.warning.withAlpha(204)
                                      : AppTheme.success.withAlpha(204),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!isReadOnly) const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        ...sectionSlivers.map((w) => SliverToBoxAdapter(child: w)),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildSectionSliver(
    BuildContext context,
    ThemeData theme,
    String sectionTitle,
    List<SurveyQuestion> sectionQuestions,
    List<SurveyQuestion> visibleQuestions,
  ) {
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
                  sectionTitle,
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
              children: sectionQuestions.asMap().entries.map((e) {
                final idx = e.key;
                final q = e.value;
                final globalIndex = visibleQuestions.indexOf(q);
                final ans = answers[q.id];
                final isAnswered =
                    ans != null &&
                    (ans is! String || (ans).isNotEmpty) &&
                    (ans is! List || (ans).isNotEmpty);

                return Column(
                  children: [
                    InkWell(
                      onTap: onEditQuestion != null && !isReadOnly
                          ? () => onEditQuestion!(globalIndex)
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
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
                                color: !isAnswered && q.isRequired
                                    ? AppTheme.error
                                    : isAnswered
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
                                    q.questionText,
                                    style: GoogleFonts.manrope(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  isAnswered
                                      ? Text(
                                          _formatAnswer(ans),
                                          style: GoogleFonts.manrope(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        )
                                      : Text(
                                          q.isRequired
                                              ? 'Not answered — Required'
                                              : 'Not answered',
                                          style: GoogleFonts.manrope(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: q.isRequired
                                                ? AppTheme.error
                                                : theme.colorScheme.outline,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (!isReadOnly)
                              Icon(
                                Icons.edit_rounded,
                                size: 14,
                                color: theme.colorScheme.outline,
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (idx < sectionQuestions.length - 1)
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

  String _formatAnswer(dynamic ans) {
    if (ans is List) return (ans).join(', ');
    if (ans is Map) {
      // Q-G-03 / Q-G-09 specify answer format
      if (ans.containsKey('selections')) {
        final selections = (ans['selections'] as List?)?.cast<String>() ?? [];
        final specifyText = (ans['specifyText'] as String?) ?? '';
        final base = selections.join(', ');
        if (specifyText.isNotEmpty) return '$base (Specify: $specifyText)';
        return base;
      }
      // GPS answer format
      if (ans.containsKey('lat')) {
        return 'GPS: ${(ans['lat'] as double).toStringAsFixed(4)}, ${(ans['lng'] as double).toStringAsFixed(4)}';
      }
    }
    if (ans is String && ans.startsWith('photo_captured_')) {
      return 'Photo captured ✓';
    }
    return ans.toString();
  }
}

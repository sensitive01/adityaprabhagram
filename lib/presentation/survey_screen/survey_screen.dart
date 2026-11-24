import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../services/supabase_service.dart';
import '../../services/local_database_service.dart';
import '../../services/connectivity_service.dart';
import '../../theme/app_theme.dart';
import './widgets/respondent_details_section_widget.dart';
import './widgets/household_profile_section_widget.dart';
import './widgets/household_assets_section_widget.dart';
import './widgets/pest_disease_section_widget.dart';
import './widgets/employment_seasonality_section_widget.dart';
import './widgets/asset_matrix_section_widget.dart';
import './widgets/livestock_section_widget.dart';
import './widgets/cropping_pattern_section_widget.dart';
import './widgets/agricultural_information_section_widget.dart';
import './widgets/question_card_widget.dart';
import './widgets/itk_table_widget.dart';
import './widgets/scheme_matrix_section_widget.dart';
import './widgets/p2_training_needs_section_widget.dart';
import './widgets/gender_decision_making_section_widget.dart';
import './widgets/household_expenditure_section_widget.dart';
import './widgets/gender_work_distribution_section_widget.dart';
import './widgets/border_specific_constraints_section_widget.dart';
import './widgets/household_priority_needs_section_widget.dart';
import './widgets/enumerator_observation_section_widget.dart';
import './widgets/survey_nav_bar_widget.dart';
import './widgets/survey_progress_header_widget.dart';
import './widgets/survey_review_widget.dart';

// --- DATA MODELS ---

enum QuestionType {
  text,
  number,
  yesNo,
  singleChoice,
  multipleChoice,
  date,
  photo,
  gps,
}

class SurveyQuestion {
  final String id;
  final String sectionId;
  final String sectionTitle;
  final String questionText;
  final QuestionType type;
  final bool isRequired;
  final List<String>? options;
  final String? hint;
  final String? questionCode;
  // Conditional logic fields (populated from DB)
  final String? conditionalOnQuestionId;
  final String? conditionalOnValue;

  /// Parallel list to [options]: stores the option_value for each option_text.
  /// Used to remap stored option_values back to option_texts on draft resume.
  final List<String>? optionValues;

  const SurveyQuestion({
    required this.id,
    required this.sectionId,
    required this.sectionTitle,
    required this.questionText,
    required this.type,
    this.isRequired = true,
    this.options,
    this.hint,
    this.questionCode,
    this.conditionalOnQuestionId,
    this.conditionalOnValue,
    this.optionValues,
  });

  factory SurveyQuestion.fromMap(Map<String, dynamic> map) {
    return SurveyQuestion(
      id: map['id'] as String,
      sectionId: map['sectionId'] as String,
      sectionTitle: map['sectionTitle'] as String,
      questionText: map['questionText'] as String,
      type: _typeFromString(map['type'] as String),
      isRequired: map['isRequired'] as bool? ?? true,
      options: (map['options'] as List?)?.cast<String>(),
      hint: map['hint'] as String?,
    );
  }

  /// Creates a SurveyQuestion from a Supabase DB row.
  /// The row must include the joined section title and answer options.
  factory SurveyQuestion.fromDbRow(Map<String, dynamic> row) {
    // Extract options from the nested survey_question_options join
    List<String>? options;
    List<String>? optionValues;
    final rawOptions = row['survey_question_options'];
    if (rawOptions is List && rawOptions.isNotEmpty) {
      // Sort by display_order and extract option_text
      final sorted =
          List<Map<String, dynamic>>.from(
            rawOptions.map((o) => Map<String, dynamic>.from(o as Map)),
          )..sort(
            (a, b) => ((a['display_order'] as int?) ?? 0).compareTo(
              (b['display_order'] as int?) ?? 0,
            ),
          );
      final active = sorted.where((o) => o['is_active'] == true).toList();
      options = active
          .map((o) => (o['option_text'] as String?) ?? '')
          .where((t) => t.isNotEmpty)
          .toList();
      optionValues = active
          .map((o) => (o['option_value'] as String?) ?? '')
          .toList();
    }

    // Extract section title from the nested survey_sections join
    final sectionRow = row['survey_sections'];
    final sectionTitle =
        (sectionRow is Map ? (sectionRow['section_title'] as String?) : null) ??
        'Survey';
    final sectionId = (row['section_id'] as String?) ?? '';

    return SurveyQuestion(
      id: (row['id'] as String?) ?? '',
      sectionId: sectionId,
      sectionTitle: sectionTitle,
      questionText: (row['question_text'] as String?) ?? '',
      type: _typeFromString((row['question_type'] as String?) ?? 'text'),
      isRequired: (row['required'] as bool?) ?? false,
      options: options,
      hint: row['help_text'] as String?,
      questionCode: row['question_code'] as String?,
      conditionalOnQuestionId: row['conditional_on_question_id'] as String?,
      conditionalOnValue: row['conditional_on_value'] as String?,
      optionValues: optionValues,
    );
  }

  static QuestionType _typeFromString(String v) {
    switch (v) {
      case 'number':
        return QuestionType.number;
      case 'yes_no':
      case 'yesNo':
        return QuestionType.yesNo;
      case 'single_choice':
      case 'singleChoice':
        return QuestionType.singleChoice;
      case 'multiple_choice':
      case 'multipleChoice':
        return QuestionType.multipleChoice;
      case 'date':
        return QuestionType.date;
      case 'photo':
        return QuestionType.photo;
      case 'gps':
        return QuestionType.gps;
      default:
        return QuestionType.text;
    }
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'sectionId': sectionId,
    'sectionTitle': sectionTitle,
    'questionText': questionText,
    'type': type.name,
    'isRequired': isRequired,
    'options': options,
    'hint': hint,
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// B.1 HOUSEHOLD COMPOSITION — Virtual question builder
// ─────────────────────────────────────────────────────────────────────────────

/// Sentinel section ID used for all B.1 virtual questions.
const String _kB1SectionId = 'VIRTUAL_B1';
const String _kB1SectionTitle = 'B.1: Household Composition';

/// I-07 question UUID — rendered as a dynamic ITK table instead of a plain text input.
const String _kI07QuestionId = '93aefa43-08d1-499b-a2e6-b0ee251d6d8f';

/// The response key used to store the Section O scheme matrix in surveys.responses.
const String _kOSchemeMatrixKey = 'O-SCHEME-MATRIX';

/// O-01 question UUID (Awareness of Govt. schemes).
const String _kO01QuestionId = 'cf094f24-5672-42be-8de1-9752cc08d93c';

/// O-02 question UUID (Have you availed any scheme?).
const String _kO02QuestionId = 'd4f5d4b5-505d-4046-aacc-4ef39210da52';

/// The response key used to store the P2 training needs matrix in surveys.responses.
const String _kP2TrainingNeedsKey = 'P2-TRAINING-NEEDS';

/// The response key used to store the Section R gender/decision-making data in surveys.responses.
const String _kRGenderDecisionMakingKey = kGenderDecisionMakingKey;

/// The response key used to store the Section S household expenditure data in surveys.responses.
const String _kSHouseholdExpenditureKey = kHouseholdExpenditureKey;

/// The response key used to store the Section T gender work distribution data in surveys.responses.
const String _kTGenderWorkDistributionKey = kGenderWorkDistributionKey;

/// The response key used to store the Section X border-specific constraints data in surveys.responses.
const String _kXBorderSpecificConstraintsKey = kBorderSpecificConstraintsKey;

/// The response key used to store the Section Y household priority needs data in surveys.responses.
const String _kYHouseholdPriorityNeedsKey = kHouseholdPriorityNeedsKey;

/// The response key used to store the Section Z enumerator observation data in surveys.responses.
const String _kZEnumeratorObservationKey = kEnumeratorObservationKey;

// ─────────────────────────────────────────────────────────────────────────────
// SPECIALIZED NAVIGATION REGISTRY
// ─────────────────────────────────────────────────────────────────────────────

/// Describes a specialized screen that is inserted into the navigation sequence
/// immediately after a specific trigger question.
///
/// To add a new specialized screen, register a new [_SpecializedNavEntry] in
/// [_SurveyScreenState._specializedScreenRegistry]. No changes to [_goNext] or
/// [_goPrev] are required.
class _SpecializedNavEntry {
  /// The question ID after which this screen is inserted.
  final String triggerQuestionId;

  /// A human-readable key (also used as the responses map key).
  final String key;

  /// Returns true when this specialized screen is currently active.
  final bool Function() isActive;

  /// Activates this specialized screen.
  final void Function() activate;

  /// Deactivates this specialized screen.
  final void Function() deactivate;

  /// Advances past this specialized screen (called from _goNext while active).
  /// Should deactivate the screen and navigate to the next position.
  final void Function() onNext;

  /// Goes back from this specialized screen (called from _goPrev while active).
  /// Should deactivate the screen and navigate to the previous position.
  final void Function() onPrev;

  _SpecializedNavEntry({
    required this.triggerQuestionId,
    required this.key,
    required this.isActive,
    required this.activate,
    required this.deactivate,
    required this.onNext,
    required this.onPrev,
  });
}

// --- SCREEN ---

class SurveyScreen extends StatefulWidget {
  final String householdId;
  final String householdName;
  final String? surveyId;

  /// 'start'      – no existing survey, open blank editable questionnaire
  /// 'edit'       – existing draft, resume with saved answers (editable)
  /// 'correction' – correction_required, load saved answers, allow edit+resubmit
  /// 'submitted'  – submitted/under_review, show answers read-only (awaiting review)
  /// 'view'       – approved, show answers read-only
  final String surveyMode;

  /// When true, this survey is opened by a HOUSEHOLD user for read-only viewing.
  /// Hides all Field Agent-specific status chips and controls in the app bar.
  final bool isHouseholdView;

  const SurveyScreen({
    super.key,
    required this.householdId,
    required this.householdName,
    this.surveyId,
    this.surveyMode = 'start',
    this.isHouseholdView = false,
  });

  static SurveyScreen create({
    required String householdId,
    required String householdName,
    String? surveyId,
    String surveyMode = 'start',
    bool isHouseholdView = false,
  }) {
    return SurveyScreen(
      householdId: householdId,
      householdName: householdName,
      surveyId: surveyId,
      surveyMode: surveyMode,
      isHouseholdView: isHouseholdView,
    );
  }

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  /// The full ordered question list including injected B.1 virtual questions.
  late List<SurveyQuestion> _questions;

  /// DB-loaded questions (without B.1 virtual questions).
  /// Used as the stable base when rebuilding B.1 on family-size changes.
  List<SurveyQuestion> _dbQuestions = [];

  final Map<String, dynamic> _answers = {};
  int _currentQuestionIndex = 0;
  bool _isReviewMode = false;
  bool _isSubmitting = false;
  bool _isLoadingAnswers = false;
  bool _isSavingDraft = false;
  // Dynamic question loading state
  bool _isLoadingQuestions = true;
  String? _questionLoadError;

  /// Ordered sections from survey_sections (display_order ascending).
  /// Each entry: { 'id': String, 'title': String, 'code': String, 'displayOrder': int }
  List<Map<String, dynamic>> _orderedSections = [];

  /// True when the questionnaire is showing Section E (PestDiseaseSectionWidget)
  /// between section D's last question and section G's first question.
  bool _isPestSectionMode = false;

  /// True when the questionnaire is showing Section F (LivestockPestDiseaseSectionWidget).
  /// Completely independent of _isPestSectionMode — Section E is never affected.
  bool _isFSectionMode = false;

  /// True when the questionnaire is showing Section C (Asset Matrix)
  /// as a single structured matrix screen.
  bool _isAssetMatrixMode = false;

  /// Sub-page index for Section C (0: Land, 1: Water, 2: Assets, 3: Livestock).
  int _cSectionPageIndex = 0;

  /// True when the questionnaire is showing C-10 (Livestock / Enterprises owned)
  /// as a single structured screen, immediately after the Asset Matrix.
  bool _isLivestockSectionMode = false;

  /// True when the questionnaire is showing Section D Q9 (Cropping Pattern)
  /// as a single structured screen, after the last D question.
  bool _isCroppingPatternMode = false;

  /// True when the questionnaire is showing Section K (Household Income Distribution)
  /// as a single grouped screen with all active K numeric questions.
  bool _isKSectionMode = false;

  /// True when the questionnaire is showing Section L (Employment Seasonality)
  /// as a single structured matrix screen.
  bool _isLSectionMode = false;

  /// True when the questionnaire is showing Section O (Government Schemes)
  /// scheme matrix as a single structured screen, after O-01 and O-02.
  bool _isOSectionMode = false;

  /// True when the questionnaire is showing Section P (Extension Services)
  /// P2 training needs matrix as a single structured screen.
  bool _isPSectionMode = false;

  /// True when the questionnaire is showing Section R (Gender & Decision Making)
  /// as a single structured screen.
  bool _isRSectionMode = false;

  /// True when the questionnaire is showing Section S (Major Household Expenditure)
  /// as a single structured screen.
  bool _isSSectionMode = false;

  /// True when the questionnaire is showing Section T (Gender Work Distribution)
  /// as a single structured screen.
  bool _isTSectionMode = false;

  /// True when the questionnaire is showing Section X (Border-Specific Constraints)
  /// as a single structured screen.
  bool _isXSectionMode = false;

  /// True when the questionnaire is showing Section Y (Household Priority Needs)
  /// as a single structured screen.
  bool _isYSectionMode = false;

  /// True when the questionnaire is showing Section Z (Enumerator Observation)
  /// as a single structured screen.
  bool _isZSectionMode = false;

  /// GlobalKey for the Section L widget so we can call saveData() on draft save.
  final GlobalKey<EmploymentSeasonalitySectionWidgetState> _lSectionKey =
      GlobalKey<EmploymentSeasonalitySectionWidgetState>();

  /// GlobalKey for the Asset Matrix widget so we can call saveData() on draft save.
  final GlobalKey<AssetMatrixSectionWidgetState> _assetMatrixKey =
      GlobalKey<AssetMatrixSectionWidgetState>();

  /// GlobalKey for the C-10 Livestock widget so we can call saveData() on draft save.
  final GlobalKey<LivestockSectionWidgetState> _livestockSectionKey =
      GlobalKey<LivestockSectionWidgetState>();

  /// GlobalKey for the Q9 Cropping Pattern widget so we can call saveData() on draft save.
  final GlobalKey<CroppingPatternSectionWidgetState> _croppingPatternKey =
      GlobalKey<CroppingPatternSectionWidgetState>();

  /// GlobalKey for Section A (Respondent Details) widget so we can call saveData() / validateAndSave().
  final GlobalKey<RespondentDetailsSectionWidgetState> _respondentDetailsKey =
      GlobalKey<RespondentDetailsSectionWidgetState>();

  /// GlobalKey for Section B (Household Profile) widget so we can call saveData() / validateAndSave().
  final GlobalKey<HouseholdProfileSectionWidgetState> _householdProfileKey =
      GlobalKey<HouseholdProfileSectionWidgetState>();

  /// GlobalKey for Section C (Household Assets / Land / Livestock) widget.
  final GlobalKey<HouseholdAssetsSectionWidgetState> _householdAssetsKey =
      GlobalKey<HouseholdAssetsSectionWidgetState>();

  /// GlobalKey for Section D (Agricultural Information) widget.
  final GlobalKey<AgriculturalInformationSectionWidgetState> _agriculturalInfoKey =
      GlobalKey<AgriculturalInformationSectionWidgetState>();

  /// Sub-page index for Section D (0: Practices & Seeds, 1: Cropping Matrix & Crop Details).
  int _dSectionPageIndex = 0;

  /// Tracks the survey UUID for the current session.
  /// Initialised from widget.surveyId; updated after a new draft is created.
  String? _currentSurveyId;

  /// True when the field agent cannot edit answers (view / submitted modes).
  bool get _isReadOnly =>
      widget.surveyMode == 'view' || widget.surveyMode == 'submitted';

  /// True when this is a correction workflow (load answers, allow edit+resubmit).
  bool get _isCorrectionMode => widget.surveyMode == 'correction';

  /// Label shown in the app-bar subtitle.
  String get _modeLabel {
    switch (widget.surveyMode) {
      case 'view':
        return 'Approved Survey';
      case 'submitted':
        return 'Awaiting Review';
      case 'correction':
        return 'Correction Required';
      case 'edit':
        return 'Resume Draft';
      default:
        return 'Socio-Economics Baseline Survey';
    }
  }

  // ── B.1 Household Composition helpers ─────────────────────────────────────

  /// Returns the question whose code is Q-BASIC-01 (family size question).
  SurveyQuestion? get _familySizeQuestion {
    for (final q in _dbQuestions) {
      if (q.questionCode == 'Q-BASIC-01') return q;
    }
    return null;
  }

  /// Returns the current family size from the answers map.
  /// Returns 0 if not answered or invalid.
  int get _currentFamilySize {
    final fsq = _familySizeQuestion;
    if (fsq == null) return 0;
    final ans = _answers[fsq.id];
    if (ans == null) return 0;
    final parsed = int.tryParse(ans.toString().trim());
    if (parsed == null || parsed <= 0) return 0;
    return parsed;
  }

  /// Rebuilds _questions by injecting B.1 virtual questions between
  /// Q-BASIC-01 and Q-B-OCC-01 based on the current family size answer.
  ///
  /// Preserves _currentQuestionIndex as best as possible.
  void _rebuildQuestionsWithB1({bool preserveIndex = true}) {
    final familySize = _currentFamilySize;
    final b1Questions = _buildB1VirtualQuestions(familySize);

    // Find insertion point: after Q-BASIC-01 in _dbQuestions
    int insertAfterIdx = -1;
    for (int i = 0; i < _dbQuestions.length; i++) {
      if (_dbQuestions[i].questionCode == 'Q-BASIC-01') {
        insertAfterIdx = i;
        break;
      }
    }

    final newQuestions = <SurveyQuestion>[];
    if (insertAfterIdx < 0) {
      // Q-BASIC-01 not found — just use DB questions as-is
      newQuestions.addAll(_dbQuestions);
    } else {
      newQuestions.addAll(_dbQuestions.sublist(0, insertAfterIdx + 1));
      newQuestions.addAll(b1Questions);
      newQuestions.addAll(_dbQuestions.sublist(insertAfterIdx + 1));
    }

    if (!preserveIndex) {
      _questions = newQuestions;
      return;
    }

    // Try to keep the current question visible after rebuild
    final currentId =
        (_questions.isNotEmpty && _currentQuestionIndex < _questions.length)
        ? _questions[_currentQuestionIndex].id
        : null;

    _questions = newQuestions;

    if (currentId != null) {
      final newIdx = _questions.indexWhere((q) => q.id == currentId);
      if (newIdx >= 0) {
        _currentQuestionIndex = newIdx;
      } else if (_currentQuestionIndex >= _questions.length) {
        _currentQuestionIndex = _questions.length - 1;
      }
    }
    if (_currentQuestionIndex < 0) _currentQuestionIndex = 0;
  }

  // ── B.1 virtual section helpers ────────────────────────────────────────────

  /// True when B.1 virtual questions exist in the current question list.
  bool get _hasB1Section => _questions.any((q) => q.sectionId == _kB1SectionId);

  // ── Existing section helpers ───────────────────────────────────────────────

  List<String> get _sectionIds {
    final ids = <String>[];
    for (final q in _questions) {
      if (!ids.contains(q.sectionId)) ids.add(q.sectionId);
    }
    return ids;
  }

  /// Returns true when Section E (section_code == 'E') exists in the active
  /// sections list AND a valid survey ID is available (so records can be saved).
  bool get _hasPestSection =>
      _currentSurveyId != null &&
      _orderedSections.any((s) {
        final c = s['code'] as String;
        return c == 'E' || c == 'SEC-E';
      });

  /// The display_order of Section E, or -1 if not found.
  int get _pestSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'E' || c == 'SEC-E') {
        return (s['displayOrder'] as int? ?? -1);
      }
    }
    return -1;
  }

  /// Returns the section_id of the last section whose display_order is strictly
  /// less than Section E's display_order (i.e. the section just before E).
  String? get _sectionBeforePest {
    final pestOrder = _pestSectionDisplayOrder;
    if (pestOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order < pestOrder) {
        if (best == null || order > (best['displayOrder'] as int? ?? 0)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  /// Returns the section_id of the first section whose display_order is strictly
  /// greater than Section E's display_order (i.e. the section just after E).
  String? get _sectionAfterPest {
    final pestOrder = _pestSectionDisplayOrder;
    if (pestOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > pestOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  // ── Section F (Livestock) helpers ─────────────────────────────────────────

  /// Returns true when Section F (section_code == 'SEC-F') exists and a
  /// valid survey ID is available. Does not affect Section E logic.
  bool get _hasFSection =>
      _currentSurveyId != null &&
      _orderedSections.any((s) {
        final c = s['code'] as String;
        return c == 'F' || c == 'SEC-F';
      });

  int get _fSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'F' || c == 'SEC-F') {
        return (s['displayOrder'] as int? ?? -1);
      }
    }
    return -1;
  }

  /// Section immediately before SEC-F (by display_order).
  String? get _sectionBeforeF {
    final fOrder = _fSectionDisplayOrder;
    if (fOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order < fOrder) {
        if (best == null || order > (best['displayOrder'] as int? ?? 0)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  /// Section immediately after SEC-F (by display_order).
  String? get _sectionAfterF {
    final fOrder = _fSectionDisplayOrder;
    if (fOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > fOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  // ── Section K (Household Income Distribution) helpers ─────────────────────

  /// Returns true when Section K (section_code == 'K') exists in the active sections.
  bool get _hasKSection => _orderedSections.any((s) {
    final c = s['code'] as String;
    return c == 'K';
  });

  /// The section_id of Section K, or null if not found.
  String? get _kSectionId {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'K') return s['id'] as String?;
    }
    return null;
  }

  /// The display_order of Section K, or -1 if not found.
  int get _kSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'K') return (s['displayOrder'] as int? ?? -1);
    }
    return -1;
  }

  /// Section immediately before Section K (by display_order).
  String? get _sectionBeforeK {
    final kOrder = _kSectionDisplayOrder;
    if (kOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order < kOrder) {
        if (best == null || order > (best['displayOrder'] as int? ?? 0)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  /// Section immediately after Section K (by display_order).
  String? get _sectionAfterK {
    final kOrder = _kSectionDisplayOrder;
    if (kOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > kOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  /// All active numeric questions belonging to Section K, in display_order.
  List<SurveyQuestion> get _kNumericQuestions {
    final kId = _kSectionId;
    if (kId == null) return [];
    return _questions
        .where((q) => q.sectionId == kId && q.type == QuestionType.number)
        .toList();
  }

  // ── Section L (Employment Seasonality) helpers ────────────────────────────

  /// Returns true when Section L (section_code == 'L') exists and a valid
  /// survey ID is available.
  bool get _hasLSection =>
      _currentSurveyId != null &&
      _orderedSections.any((s) {
        final c = s['code'] as String;
        return c == 'L' || c == 'SEC-L';
      });

  /// The section_id of Section L, or null if not found.
  String? get _lSectionId {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'L' || c == 'SEC-L') return s['id'] as String?;
    }
    return null;
  }

  /// The display_order of Section L, or -1 if not found.
  int get _lSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'L' || c == 'SEC-L') return (s['displayOrder'] as int? ?? -1);
    }
    return -1;
  }

  /// Section immediately before Section L (by display_order).
  String? get _sectionBeforeL {
    final lOrder = _lSectionDisplayOrder;
    if (lOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order < lOrder) {
        if (best == null || order > (best['displayOrder'] as int? ?? 0)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  /// Section immediately after Section L (by display_order).
  String? get _sectionAfterL {
    final lOrder = _lSectionDisplayOrder;
    if (lOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > lOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  // ── Section A (Respondent Details) helpers ───────────────────────────────

  /// Returns true when Section A (section_code == 'SEC-A' or 'A') exists.
  bool get _hasASection => _orderedSections.any((s) {
    final c = (s['code'] as String? ?? '').toUpperCase();
    return c == 'A' || c == 'SEC-A' || c.startsWith('A-');
  });

  /// The section_id of Section A, or null if not found.
  String? get _aSectionId {
    for (final s in _orderedSections) {
      final c = (s['code'] as String? ?? '').toUpperCase();
      if (c == 'A' || c == 'SEC-A' || c.startsWith('A-')) return s['id'] as String?;
    }
    return null;
  }

  /// The display_order of Section A, or -1 if not found.
  int get _aSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = (s['code'] as String? ?? '').toUpperCase();
      if (c == 'A' || c == 'SEC-A' || c.startsWith('A-')) {
        return (s['displayOrder'] as int? ?? -1);
      }
    }
    return -1;
  }

  /// Section immediately after Section A (by display_order).
  String? get _sectionAfterA {
    final aOrder = _aSectionDisplayOrder;
    if (aOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > aOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  /// True when the questionnaire is showing Section A (Respondent Details)
  /// as a consolidated single page.
  bool get _isASectionMode {
    if (_isReviewMode) return false;
    if (_questions.isEmpty) return false;
    final aId = _aSectionId;
    if (aId == null) return false;
    return _currentSectionId == aId;
  }

  // ── Section B (Household Profile) helpers ─────────────────────────────────

  /// Returns true when Section B exists in active sections.
  bool get _hasBSection => _orderedSections.any((s) {
    final c = (s['code'] as String? ?? '').toUpperCase();
    return c == 'B' || c == 'SEC-B' || c.startsWith('B-') || c == 'B1' || c == 'SEC-B1';
  });

  /// The section_id of Section B, or null if not found.
  String? get _bSectionId {
    for (final s in _orderedSections) {
      final c = (s['code'] as String? ?? '').toUpperCase();
      if (c == 'B' || c == 'SEC-B' || c.startsWith('B-') || c == 'B1' || c == 'SEC-B1') {
        return s['id'] as String?;
      }
    }
    return null;
  }

  /// The display_order of Section B, or -1 if not found.
  int get _bSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = (s['code'] as String? ?? '').toUpperCase();
      if (c == 'B' || c == 'SEC-B' || c.startsWith('B-') || c == 'B1' || c == 'SEC-B1') {
        return (s['displayOrder'] as int? ?? -1);
      }
    }
    return -1;
  }

  /// Section immediately after Section B (by display_order).
  String? get _sectionAfterB {
    final bOrder = _bSectionDisplayOrder;
    if (bOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > bOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  /// True when the questionnaire is showing Section B (Household Profile)
  /// as a consolidated single page.
  bool get _isBSectionMode {
    if (_isReviewMode) return false;
    if (_questions.isEmpty) return false;
    final bId = _bSectionId;
    if (bId == null) return false;
    return _currentSectionId == bId;
  }

  /// Returns true when Section C exists in the active sections.
  bool get _hasCSection => _orderedSections.any((s) {
    final c = (s['code'] as String? ?? '').toUpperCase();
    return c == 'C' || c == 'SEC-C' || c.startsWith('C-') || c == 'C10' || c == 'SEC-C10';
  });

  /// The section_id of Section C, or null if not found.
  String? get _cSectionId {
    for (final s in _orderedSections) {
      final c = (s['code'] as String? ?? '').toUpperCase();
      if (c == 'C' || c == 'SEC-C' || c.startsWith('C-') || c == 'C10' || c == 'SEC-C10') {
        return s['id'] as String?;
      }
    }
    return null;
  }

  /// The display_order of Section C, or -1 if not found.
  int get _cSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = (s['code'] as String? ?? '').toUpperCase();
      if (c == 'C' || c == 'SEC-C' || c.startsWith('C-') || c == 'C10' || c == 'SEC-C10') {
        return (s['displayOrder'] as int? ?? -1);
      }
    }
    return -1;
  }

  /// Section immediately after Section C (by display_order).
  String? get _sectionAfterC {
    final cOrder = _cSectionDisplayOrder;
    if (cOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > cOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  /// True when the questionnaire is showing Section C (Household Assets / Land / Livestock)
  /// as a consolidated 4-page structured experience.
  bool get _isCSectionMode {
    if (_isReviewMode) return false;
    if (_questions.isEmpty) return false;
    final cId = _cSectionId;
    if (cId == null) return false;
    return _currentSectionId == cId;
  }

  /// Returns true when Section D exists in the active sections.
  bool get _hasDSection => _orderedSections.any((s) {
    final c = (s['code'] as String? ?? '').toUpperCase();
    return c == 'D' || c == 'SEC-D' || c.startsWith('D-');
  });

  /// True when the questionnaire is showing Section D (Agricultural Information)
  /// as a unified 2-page experience (Practices/Seeds & Cropping Pattern/Repeatable Crops).
  bool get _isDSectionMode {
    if (_isReviewMode) return false;
    if (_questions.isEmpty) return false;
    final dId = _dSectionId;
    if (dId == null) return false;
    return _currentSectionId == dId;
  }

  // ── Section O (Government Schemes) helpers ────────────────────────────────

  /// Returns true when Section O (section_code == 'SEC-O' or 'O') exists.
  bool get _hasOSection => _orderedSections.any((s) {
    final c = s['code'] as String;
    return c == 'O' || c == 'SEC-O';
  });

  /// The section_id of Section O, or null if not found.
  String? get _oSectionId {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'O' || c == 'SEC-O') return s['id'] as String?;
    }
    return null;
  }

  /// The display_order of Section O, or -1 if not found.
  int get _oSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'O' || c == 'SEC-O') return (s['displayOrder'] as int? ?? -1);
    }
    return -1;
  }

  /// Section immediately after Section O (by display_order).
  String? get _sectionAfterO {
    final oOrder = _oSectionDisplayOrder;
    if (oOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > oOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  // ── Section P (Extension Services / P2 Training Needs) helpers ───────────

  /// Returns true when Section P (section_code == 'SEC-P' or 'P') exists.
  bool get _hasPSection => _orderedSections.any((s) {
    final c = s['code'] as String;
    return c == 'P' || c == 'SEC-P';
  });

  /// The section_id of Section P, or null if not found.
  String? get _pSectionId {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'P' || c == 'SEC-P') return s['id'] as String?;
    }
    return null;
  }

  /// The display_order of Section P, or -1 if not found.
  int get _pSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'P' || c == 'SEC-P') return (s['displayOrder'] as int? ?? -1);
    }
    return -1;
  }

  /// Section immediately after Section P (by display_order).
  String? get _sectionAfterP {
    final pOrder = _pSectionDisplayOrder;
    if (pOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > pOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  // ── Section R (Gender & Decision Making) helpers ──────────────────────────

  /// Returns true when Section R (section_code == 'R' or 'SEC-R') exists.
  bool get _hasRSection => _orderedSections.any((s) {
    final c = s['code'] as String;
    return c == 'R' || c == 'SEC-R';
  });

  /// The section_id of Section R, or null if not found.
  String? get _rSectionId {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'R' || c == 'SEC-R') return s['id'] as String?;
    }
    return null;
  }

  /// The display_order of Section R, or -1 if not found.
  int get _rSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'R' || c == 'SEC-R') return (s['displayOrder'] as int? ?? -1);
    }
    return -1;
  }

  /// Section immediately after Section R (by display_order).
  String? get _sectionAfterR {
    final rOrder = _rSectionDisplayOrder;
    if (rOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > rOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  /// Section immediately before Section R (by display_order).
  String? get _sectionBeforeR {
    final rOrder = _rSectionDisplayOrder;
    if (rOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order < rOrder) {
        if (best == null || order > (best['displayOrder'] as int? ?? 0)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  // ── Section S (Major Household Expenditure) helpers ──────────────────────

  /// Returns true when Section S (section_code == 'S' or 'SEC-S') exists.
  bool get _hasSSSection => _orderedSections.any((s) {
    final c = s['code'] as String;
    return c == 'S' || c == 'SEC-S';
  });

  /// The section_id of Section S, or null if not found.
  String? get _sSectionId {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'S' || c == 'SEC-S') return s['id'] as String?;
    }
    return null;
  }

  /// The display_order of Section S, or -1 if not found.
  int get _sSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'S' || c == 'SEC-S') return (s['displayOrder'] as int? ?? -1);
    }
    return -1;
  }

  /// Section immediately after Section S (by display_order).
  String? get _sectionAfterS {
    final sOrder = _sSectionDisplayOrder;
    if (sOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > sOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  /// Section immediately before Section S (by display_order).
  String? get _sectionBeforeS {
    final sOrder = _sSectionDisplayOrder;
    if (sOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order < sOrder) {
        if (best == null || order > (best['displayOrder'] as int? ?? 0)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  // ── Section T (Gender Work Distribution) helpers ──────────────────────────

  /// Returns true when Section T (section_code == 'T' or 'SEC-T') exists.
  bool get _hasTSection => _orderedSections.any((s) {
    final c = s['code'] as String;
    return c == 'T' || c == 'SEC-T';
  });

  /// The section_id of Section T, or null if not found.
  String? get _tSectionId {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'T' || c == 'SEC-T') return s['id'] as String?;
    }
    return null;
  }

  /// The display_order of Section T, or -1 if not found.
  int get _tSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'T' || c == 'SEC-T') return (s['displayOrder'] as int? ?? -1);
    }
    return -1;
  }

  /// Section immediately after Section T (by display_order).
  String? get _sectionAfterT {
    final tOrder = _tSectionDisplayOrder;
    if (tOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > tOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  /// Section immediately before Section T (by display_order).
  String? get _sectionBeforeT {
    final tOrder = _tSectionDisplayOrder;
    if (tOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order < tOrder) {
        if (best == null || order > (best['displayOrder'] as int? ?? 0)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  // ── Section X (Border-Specific Constraints) helpers ───────────────────────

  /// Returns true when Section X (section_code == 'X') exists.
  bool get _hasXSection => _orderedSections.any((s) {
    final c = s['code'] as String;
    return c == 'X';
  });

  /// The display_order of Section X, or -1 if not found.
  int get _xSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'X') return (s['displayOrder'] as int? ?? -1);
    }
    return -1;
  }

  /// Section immediately after Section X (by display_order).
  String? get _sectionAfterX {
    final xOrder = _xSectionDisplayOrder;
    if (xOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > xOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  /// Section immediately before Section X (by display_order).
  String? get _sectionBeforeX {
    final xOrder = _xSectionDisplayOrder;
    if (xOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order < xOrder) {
        if (best == null || order > (best['displayOrder'] as int? ?? 0)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  // ── Section Y (Household Priority Needs) helpers ──────────────────────────

  /// Returns true when Section Y (section_code == 'Y') exists.
  bool get _hasYSection => _orderedSections.any((s) {
    final c = s['code'] as String;
    return c == 'Y';
  });

  /// The display_order of Section Y, or -1 if not found.
  int get _ySectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'Y') return (s['displayOrder'] as int? ?? -1);
    }
    return -1;
  }

  /// Section immediately after Section Y (by display_order).
  String? get _sectionAfterY {
    final yOrder = _ySectionDisplayOrder;
    if (yOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > yOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  /// Section immediately before Section Y (by display_order).
  String? get _sectionBeforeY {
    final yOrder = _ySectionDisplayOrder;
    if (yOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order < yOrder) {
        if (best == null || order > (best['displayOrder'] as int? ?? 0)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  // ── Section Z (Enumerator Observation) helpers ────────────────────────────

  /// Returns true when Section Z (section_code == 'Z') exists.
  bool get _hasZSection => _orderedSections.any((s) {
    final c = s['code'] as String;
    return c == 'Z';
  });

  /// The display_order of Section Z, or -1 if not found.
  int get _zSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'Z') return (s['displayOrder'] as int? ?? -1);
    }
    return -1;
  }

  /// Section immediately after Section Z (by display_order).
  String? get _sectionAfterZ {
    final zOrder = _zSectionDisplayOrder;
    if (zOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > zOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  /// Section immediately before Section Z (by display_order).
  String? get _sectionBeforeZ {
    final zOrder = _zSectionDisplayOrder;
    if (zOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order < zOrder) {
        if (best == null || order > (best['displayOrder'] as int? ?? 0)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  // ── Specialized screen registry ───────────────────────────────────────────
  //
  // To add a new specialized screen, append a new _SpecializedNavEntry here.
  // No changes to _goNext() or _goPrev() are required.
  //
  // Each entry declares:
  //   triggerQuestionId – the question ID after which the screen appears
  //   key               – the responses map key (e.g. 'O-SCHEME-MATRIX')
  //   isActive          – returns true when this screen is currently shown
  //   activate          – called by _goNext when the trigger question is passed
  //   deactivate        – called when leaving this screen
  //   onNext            – what to do when Next is pressed while this screen is active
  //   onPrev            – what to do when Prev is pressed while this screen is active
  //
  List<_SpecializedNavEntry> get _specializedScreenRegistry => [
    // ── O-SCHEME-MATRIX: appears after O-02 ──────────────────────────────
    _SpecializedNavEntry(
      triggerQuestionId: _kO02QuestionId,
      key: _kOSchemeMatrixKey,
      isActive: () => _isOSectionMode,
      activate: () => setState(() => _isOSectionMode = true),
      deactivate: () => setState(() => _isOSectionMode = false),
      onNext: () {
        // Advance to the first question of the section after O (or P questions,
        // or the next registered specialized screen, or review).
        final afterOId = _sectionAfterO;
        if (afterOId != null) {
          final firstIdx = _questions.indexWhere(
            (q) => q.sectionId == afterOId,
          );
          if (firstIdx >= 0) {
            setState(() {
              _isOSectionMode = false;
              _currentQuestionIndex = firstIdx;
            });
            return;
          }
        }
        // No normal questions after O — check if P section has questions
        if (_hasPSection) {
          final pId = _pSectionId;
          if (pId != null) {
            final firstPIdx = _questions.indexWhere((q) => q.sectionId == pId);
            if (firstPIdx >= 0) {
              setState(() {
                _isOSectionMode = false;
                _currentQuestionIndex = firstPIdx;
              });
              return;
            }
          }
        }
        // Check if R comes after O
        if (_hasRSection) {
          final oOrder = _oSectionDisplayOrder;
          final rOrder = _rSectionDisplayOrder;
          if (rOrder > oOrder) {
            setState(() {
              _isOSectionMode = false;
              _isRSectionMode = true;
            });
            return;
          }
        }
        setState(() {
          _isOSectionMode = false;
          _isReviewMode = true;
        });
      },
      onPrev: () {
        // Return to O-02
        final o02Idx = _questions.indexWhere((q) => q.id == _kO02QuestionId);
        if (o02Idx >= 0) {
          setState(() {
            _isOSectionMode = false;
            _currentQuestionIndex = o02Idx;
          });
          return;
        }
        // Fallback: last visible O question
        final oId = _oSectionId;
        if (oId != null) {
          int lastOIdx = -1;
          for (int i = _questions.length - 1; i >= 0; i--) {
            if (_questions[i].sectionId == oId &&
                _isQuestionVisible(_questions[i])) {
              lastOIdx = i;
              break;
            }
          }
          if (lastOIdx >= 0) {
            setState(() {
              _isOSectionMode = false;
              _currentQuestionIndex = lastOIdx;
            });
            return;
          }
        }
        setState(() => _isOSectionMode = false);
      },
    ),

    // ── P2-TRAINING-NEEDS: appears after the last P question (P-06) ───────
    _SpecializedNavEntry(
      triggerQuestionId: _kLastPQuestionId,
      key: _kP2TrainingNeedsKey,
      isActive: () => _isPSectionMode,
      activate: () => setState(() => _isPSectionMode = true),
      deactivate: () => setState(() => _isPSectionMode = false),
      onNext: () {
        final afterPId = _sectionAfterP;
        if (afterPId != null) {
          final firstIdx = _questions.indexWhere(
            (q) => q.sectionId == afterPId,
          );
          if (firstIdx >= 0) {
            setState(() {
              _isPSectionMode = false;
              _currentQuestionIndex = firstIdx;
            });
            return;
          }
          // afterP section exists but has no questions — check if it's Section R
          final rId = _rSectionId;
          if (_hasRSection && afterPId == rId) {
            setState(() {
              _isPSectionMode = false;
              _isRSectionMode = true;
            });
            return;
          }
        }
        // No section after P with questions — check if R comes after P
        if (_hasRSection) {
          final pOrder = _pSectionDisplayOrder;
          final rOrder = _rSectionDisplayOrder;
          if (rOrder > pOrder) {
            setState(() {
              _isPSectionMode = false;
              _isRSectionMode = true;
            });
            return;
          }
        }
        setState(() {
          _isPSectionMode = false;
          _isReviewMode = true;
        });
      },
      onPrev: () {
        // Return to the last visible P question (P-06)
        final pId = _pSectionId;
        if (pId != null) {
          int lastPIdx = -1;
          for (int i = _questions.length - 1; i >= 0; i--) {
            if (_questions[i].sectionId == pId &&
                _isQuestionVisible(_questions[i])) {
              lastPIdx = i;
              break;
            }
          }
          if (lastPIdx >= 0) {
            setState(() {
              _isPSectionMode = false;
              _currentQuestionIndex = lastPIdx;
            });
            return;
          }
        }
        setState(() => _isPSectionMode = false);
      },
    ),
  ];

  /// Returns the ID of the last question in Section P, or an empty string if
  /// Section P has no questions. Used as the trigger for P2-TRAINING-NEEDS.
  String get _kLastPQuestionId {
    final pId = _pSectionId;
    if (pId == null) return '';
    for (int i = _questions.length - 1; i >= 0; i--) {
      if (_questions[i].sectionId == pId) return _questions[i].id;
    }
    return '';
  }

  // ── Section D (Cropping Pattern Q9) helpers ───────────────────────────────

  /// Returns true when Section D (section_code == 'D' or 'SEC-D') exists and
  /// a valid survey ID is available.
  bool get _hasCroppingPatternSection =>
      _currentSurveyId != null &&
      _orderedSections.any((s) {
        final c = s['code'] as String;
        return c == 'D' || c == 'SEC-D';
      });

  /// The section_id of Section D, or null if not found.
  String? get _dSectionId {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'D' || c == 'SEC-D') return s['id'] as String?;
    }
    return null;
  }

  /// The display_order of Section D, or -1 if not found.
  int get _dSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'D' || c == 'SEC-D') return (s['displayOrder'] as int? ?? -1);
    }
    return -1;
  }

  /// Section immediately after Section D (by display_order).
  String? get _sectionAfterD {
    final dOrder = _dSectionDisplayOrder;
    if (dOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > dOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  // ── Section C (Asset Matrix) helpers ──────────────────────────────────────
  /// Returns true when Section C (section_code == 'C' or 'SEC-C') exists in the active sections.
  bool get _hasAssetMatrixSection => _orderedSections.any((s) {
    final c = s['code'] as String;
    return c == 'C' || c == 'SEC-C';
  });

  /// The display_order of Section C, or -1 if not found.
  int get _assetMatrixSectionDisplayOrder {
    for (final s in _orderedSections) {
      final c = s['code'] as String;
      if (c == 'C' || c == 'SEC-C') {
        return (s['displayOrder'] as int? ?? -1);
      }
    }
    return -1;
  }

  /// Section immediately before Section C (by display_order).
  String? get _sectionBeforeAssetMatrix {
    final cOrder = _assetMatrixSectionDisplayOrder;
    if (cOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order < cOrder) {
        if (best == null || order > (best['displayOrder'] as int? ?? 0)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  /// Section immediately after Section C (by display_order).
  String? get _sectionAfterAssetMatrix {
    final cOrder = _assetMatrixSectionDisplayOrder;
    if (cOrder < 0) return null;
    Map<String, dynamic>? best;
    for (final s in _orderedSections) {
      final order = s['displayOrder'] as int? ?? 0;
      if (order > cOrder) {
        if (best == null || order < (best['displayOrder'] as int? ?? 999)) {
          best = s;
        }
      }
    }
    return best?['id'] as String?;
  }

  // ── Section title / number helpers ────────────────────────────────────────

  String get _currentSectionId => _questions[_currentQuestionIndex].sectionId;
  String get _currentSectionTitle {
    if (_isASectionMode) {
      return (_orderedSections.firstWhere((s) {
            final c = (s['code'] as String? ?? '').toUpperCase();
            return c == 'A' || c == 'SEC-A' || c.startsWith('A-');
          }, orElse: () => {'title': 'A: Respondent Details'})['title']
          as String);
    }
    if (_isBSectionMode) {
      return (_orderedSections.firstWhere((s) {
            final c = (s['code'] as String? ?? '').toUpperCase();
            return c == 'B' || c == 'SEC-B' || c.startsWith('B-') || c == 'B1' || c == 'SEC-B1';
          }, orElse: () => {'title': 'B: Household Profile'})['title']
          as String);
    }
    if (_isCSectionMode) {
      const subTitles = [
        'C: Land Details (C1 – C10)',
        'C: Water & Irrigation (C11 – C13)',
        'C: Tools & Household Assets (C14)',
        'C: Livestock & Enterprises (C15)',
      ];
      final subTitle = _cSectionPageIndex < subTitles.length
          ? subTitles[_cSectionPageIndex]
          : 'C: Land, Water, Assets & Livestock';
      return (_orderedSections.firstWhere((s) {
            final c = (s['code'] as String? ?? '').toUpperCase();
            return c == 'C' || c == 'SEC-C' || c.startsWith('C-');
          }, orElse: () => {'title': subTitle})['title']
          as String);
    }
    if (_isAssetMatrixMode) {
      return (_orderedSections.firstWhere((s) {
            final c = s['code'] as String;
            return c == 'C' || c == 'SEC-C';
          }, orElse: () => {'title': 'C: Asset Matrix'})['title']
          as String);
    }
    if (_isLivestockSectionMode) {
      return (_orderedSections.firstWhere((s) {
            final c = s['code'] as String;
            return c == 'C' || c == 'SEC-C';
          }, orElse: () => {'title': 'C: Livestock / Enterprises'})['title']
          as String);
    }
    if (_isCroppingPatternMode) {
      return (_orderedSections.firstWhere((s) {
            final c = s['code'] as String;
            return c == 'D' || c == 'SEC-D';
          }, orElse: () => {'title': 'D: Cropping Pattern'})['title']
          as String);
    }
    if (_isPestSectionMode) {
      return (_orderedSections.firstWhere(
            (s) {
              final c = s['code'] as String;
              return c == 'E' || c == 'SEC-E';
            },
            orElse: () => {'title': 'E: Crop Pest & Disease Management'},
          )['title']
          as String);
    }
    if (_isFSectionMode) {
      return (_orderedSections.firstWhere((s) {
            final c = s['code'] as String;
            return c == 'F' || c == 'SEC-F';
          }, orElse: () => {'title': 'F: Livestock Pest & Disease'})['title']
          as String);
    }
    if (_isKSectionMode) {
      return (_orderedSections.firstWhere(
            (s) => (s['code'] as String) == 'K',
            orElse: () => {'title': 'K: Household Income Distribution'},
          )['title']
          as String);
    }
    if (_isLSectionMode) {
      return (_orderedSections.firstWhere(
            (s) {
              final c = s['code'] as String;
              return c == 'L' || c == 'SEC-L';
            },
            orElse: () => {'title': 'L: Seasonality – Employment Calendar'},
          )['title']
          as String);
    }
    if (_isOSectionMode) {
      return (_orderedSections.firstWhere((s) {
            final c = s['code'] as String;
            return c == 'O' || c == 'SEC-O';
          }, orElse: () => {'title': 'O: Government Schemes'})['title']
          as String);
    }
    if (_isPSectionMode) {
      return (_orderedSections.firstWhere((s) {
            final c = s['code'] as String;
            return c == 'P' || c == 'SEC-P';
          }, orElse: () => {'title': 'P: Extension Services'})['title']
          as String);
    }
    if (_isRSectionMode) {
      return (_orderedSections.firstWhere((s) {
            final c = s['code'] as String;
            return c == 'R' || c == 'SEC-R';
          }, orElse: () => {'title': 'R: Gender & Decision Making'})['title']
          as String);
    }
    if (_isSSectionMode) {
      return (_orderedSections.firstWhere((s) {
            final c = s['code'] as String;
            return c == 'S' || c == 'SEC-S';
          }, orElse: () => {'title': 'S: Major Household Expenditure'})['title']
          as String);
    }
    if (_isTSectionMode) {
      return (_orderedSections.firstWhere((s) {
            final c = s['code'] as String;
            return c == 'T' || c == 'SEC-T';
          }, orElse: () => {'title': 'T: Gender Work Distribution'})['title']
          as String);
    }
    if (_isXSectionMode) {
      return (_orderedSections.firstWhere(
            (s) => (s['code'] as String) == 'X',
            orElse: () => {'title': 'X: Border-Specific Constraints'},
          )['title']
          as String);
    }
    if (_isYSectionMode) {
      return (_orderedSections.firstWhere(
            (s) => (s['code'] as String) == 'Y',
            orElse: () => {'title': 'Y: Household Priority Needs'},
          )['title']
          as String);
    }
    if (_isZSectionMode) {
      return (_orderedSections.firstWhere(
            (s) => (s['code'] as String) == 'Z',
            orElse: () => {'title': 'Z: Enumerator Observation'},
          )['title']
          as String);
    }
    return _questions[_currentQuestionIndex].sectionTitle;
  }

  int get _currentSectionNumber {
    if (_isASectionMode) {
      for (int i = 0; i < _orderedSections.length; i++) {
        final c = (_orderedSections[i]['code'] as String? ?? '').toUpperCase();
        if (c == 'A' || c == 'SEC-A' || c.startsWith('A-')) return i + 1;
      }
      return 1;
    }
    if (_isBSectionMode) {
      for (int i = 0; i < _orderedSections.length; i++) {
        final c = (_orderedSections[i]['code'] as String? ?? '').toUpperCase();
        if (c == 'B' || c == 'SEC-B' || c.startsWith('B-') || c == 'B1' || c == 'SEC-B1') return i + 1;
      }
      return 2;
    }
    if (_isPestSectionMode) {
      for (int i = 0; i < _orderedSections.length; i++) {
        final c2 = _orderedSections[i]['code'] as String;
        if (c2 == 'E' || c2 == 'SEC-E') return i + 1;
      }
    }
    if (_isFSectionMode) {
      for (int i = 0; i < _orderedSections.length; i++) {
        final c2 = _orderedSections[i]['code'] as String;
        if (c2 == 'F' || c2 == 'SEC-F') return i + 1;
      }
    }
    if (_isKSectionMode) {
      for (int i = 0; i < _orderedSections.length; i++) {
        if ((_orderedSections[i]['code'] as String) == 'K') return i + 1;
      }
    }
    if (_isLSectionMode) {
      for (int i = 0; i < _orderedSections.length; i++) {
        final c = _orderedSections[i]['code'] as String;
        if (c == 'L' || c == 'SEC-L') return i + 1;
      }
    }
    // B.1 virtual section: find its position relative to DB sections
    if (_currentSectionId == _kB1SectionId) {
      // B.1 appears after Q-BASIC-01's section — find that section's position
      final fsq = _familySizeQuestion;
      if (fsq != null) {
        for (int i = 0; i < _orderedSections.length; i++) {
          if (_orderedSections[i]['id'] == fsq.sectionId) return i + 2;
        }
      }
      return _sectionIds.indexOf(_currentSectionId) + 1;
    }
    // Map the current question's sectionId to its position in _orderedSections
    final secId = _currentSectionId;
    for (int i = 0; i < _orderedSections.length; i++) {
      if (_orderedSections[i]['id'] == secId) return i + 1;
    }
    return _sectionIds.indexOf(_currentSectionId) + 1;
  }

  int get _totalSections => _orderedSections.isNotEmpty
      ? _orderedSections.length + (_hasB1Section ? 1 : 0)
      : _sectionIds.length;

  int get _answeredCount => _answers.values.where((v) {
    if (v == null) return false;
    if (v is String) return v.isNotEmpty;
    if (v is List) return (v).isNotEmpty;
    // Q-G-03 / Q-G-09 Map format
    if (v is Map && v.containsKey('selections')) {
      return ((v['selections'] as List?) ?? []).isNotEmpty;
    }
    return true;
  }).length;

  bool get _canGoNext {
    if (_isASectionMode) {
      return true; // Section A validation is executed when clicking Next via FormKey
    }
    if (_isBSectionMode) {
      return true; // Section B validation is executed when clicking Next via FormKey
    }
    if (_isKSectionMode) {
      return true; // K section: all fields optional to proceed
    }
    if (_isLSectionMode) {
      return true; // L section: all fields optional to proceed
    }
    if (_isOSectionMode) {
      return true; // O section matrix: all fields optional to proceed
    }
    if (_isPSectionMode) {
      return true; // P2 training needs: all fields optional to proceed
    }
    if (_isRSectionMode) {
      return true; // R gender/decision making: all fields optional to proceed
    }
    if (_isSSectionMode) {
      return true; // S household expenditure: all fields optional to proceed
    }
    if (_isTSectionMode) {
      return true; // T gender work distribution: all fields optional to proceed
    }
    if (_isXSectionMode) {
      return true; // X border-specific constraints: all fields optional to proceed
    }
    if (_isYSectionMode) {
      return true; // Y household priority needs: all fields optional to proceed
    }
    if (_isZSectionMode) {
      return true; // Z enumerator observation: all fields optional to proceed
    }
    if (_isCSectionMode) {
      return true; // Section C: validated via its own validation per page
    }
    if (_isAssetMatrixMode) {
      return true; // Asset Matrix: all fields optional to proceed
    }
    if (_isLivestockSectionMode) {
      return true; // C-10 Livestock: all fields optional to proceed
    }
    if (_isCroppingPatternMode) {
      return true; // Q9 Cropping Pattern: all fields optional to proceed
    }
    final q = _questions[_currentQuestionIndex];
    // Hidden conditional questions are always passable
    if (!_isQuestionVisible(q)) return true;
    if (!q.isRequired) return true;
    final ans = _answers[q.id];
    if (ans == null) return false;
    if (ans is String) return ans.isNotEmpty;
    if (ans is List) return (ans).isNotEmpty;
    // Map format used by multipleChoice questions with an "Other" option
    if (ans is Map && ans.containsKey('selections')) {
      final selections = (ans['selections'] as List?) ?? [];
      if (selections.isEmpty) return false;
      // If "Other" is selected, specifyText must also be non-empty
      final otherSelected = selections.any(
        (s) => (s as String).trim().toLowerCase().startsWith('other'),
      );
      if (otherSelected) {
        final specifyText = (ans['specifyText'] as String?) ?? '';
        return specifyText.trim().isNotEmpty;
      }
      return true;
    }
    return true;
  }

  /// Logical total questions for the nav bar counter.
  /// Section K, L, and O each count as 1 logical screen.
  int get _logicalTotalQuestions {
    int total = _questions.length;

    // K section: all K questions are one logical screen.
    if (_hasKSection) {
      final kId = _kSectionId;
      if (kId != null) {
        final kCount = _questions.where((q) => q.sectionId == kId).length;
        if (kCount > 0) {
          total = total - kCount + 1;
        }
      }
    }

    // L section: all L questions are one logical screen.
    if (_hasLSection) {
      final lId = _lSectionId;
      if (lId != null) {
        final lCount = _questions.where((q) => q.sectionId == lId).length;
        if (lCount > 0) {
          total = total - lCount + 1;
        }
      }
    }

    // Each registered specialized screen is one additional logical item.
    for (final entry in _specializedScreenRegistry) {
      final triggerExists = _questions.any(
        (q) => q.id == entry.triggerQuestionId,
      );
      if (triggerExists) {
        total += 1;
      }
    }

    // Section R has no survey_questions but is one logical screen.
    if (_hasRSection) {
      total += 1;
    }

    // Section S has no survey_questions but is one logical screen.
    if (_hasSSSection) {
      total += 1;
    }

    // Section T has no survey_questions but is one logical screen.
    if (_hasTSection) {
      total += 1;
    }

    // Section X has no survey_questions but is one logical screen.
    if (_hasXSection) {
      total += 1;
    }

    // Section Y has no survey_questions but is one logical screen.
    if (_hasYSection) {
      total += 1;
    }

    // Section Z has no survey_questions but is one logical screen.
    if (_hasZSection) {
      total += 1;
    }

    return total;
  }

  /// Helper: subtract collapsed-section offsets for questions before [rawIndex].
  int _adjustedIndex(int rawIndex) {
    int offset = 0;
    // K section: all K questions collapse to 1
    if (_hasKSection) {
      final kId = _kSectionId;
      if (kId != null) {
        final kCount = _questions.where((q) => q.sectionId == kId).length;
        final firstKIdx = _questions.indexWhere((q) => q.sectionId == kId);
        if (firstKIdx >= 0 && rawIndex > firstKIdx) {
          offset += kCount - 1;
        }
      }
    }
    // L section: all L questions collapse to 1
    if (_hasLSection) {
      final lId = _lSectionId;
      if (lId != null) {
        final lCount = _questions.where((q) => q.sectionId == lId).length;
        final firstLIdx = _questions.indexWhere((q) => q.sectionId == lId);
        if (firstLIdx >= 0 && rawIndex > firstLIdx) {
          offset += lCount - 1;
        }
      }
    }

    // Add one logical position for every registered specialized screen
    // whose trigger question occurs before this normal question.
    int specializedBefore = 0;

    for (final entry in _specializedScreenRegistry) {
      final triggerIdx = _questions.indexWhere(
        (q) => q.id == entry.triggerQuestionId,
      );

      if (triggerIdx >= 0 && triggerIdx < rawIndex) {
        specializedBefore++;
      }
    }

    return rawIndex - offset + specializedBefore + 1; // 1-based
  }

  /// Computes the logical 1-based display position for a specialized section
  /// (R, S, T, X, Y, Z) that has no survey_questions, using only
  /// [_orderedSections] and [_questions] — never calls indexWhere on a
  /// zero-question section.
  ///
  /// [targetDisplayOrder] is the display_order of the specialized section.
  int _logicalPositionOfSection(int targetDisplayOrder) {
    if (targetDisplayOrder < 0) return 1;

    // Count normal questions in sections whose display_order < targetDisplayOrder.
    int questionsBeforeTarget = 0;
    for (final q in _questions) {
      final secOrder =
          (_orderedSections.firstWhere(
                (s) => s['id'] == q.sectionId,
                orElse: () => {'displayOrder': -1},
              )['displayOrder']
              as int?) ??
          -1;
      if (secOrder >= 0 && secOrder < targetDisplayOrder) {
        questionsBeforeTarget++;
      }
    }

    // Subtract K/L collapse offsets for sections before target.
    int collapseOffset = 0;
    if (_hasKSection) {
      final kId = _kSectionId;
      if (kId != null) {
        final kOrder = _kSectionDisplayOrder;
        if (kOrder >= 0 && kOrder < targetDisplayOrder) {
          final kCount = _questions.where((q) => q.sectionId == kId).length;
          if (kCount > 0) collapseOffset += kCount - 1;
        }
      }
    }
    if (_hasLSection) {
      final lId = _lSectionId;
      if (lId != null) {
        final lOrder = _lSectionDisplayOrder;
        if (lOrder >= 0 && lOrder < targetDisplayOrder) {
          final lCount = _questions.where((q) => q.sectionId == lId).length;
          if (lCount > 0) collapseOffset += lCount - 1;
        }
      }
    }

    // Count registry specialized screens whose trigger question belongs to a
    // section with display_order < targetDisplayOrder.
    int specializedBefore = 0;
    for (final entry in _specializedScreenRegistry) {
      final triggerIdx = _questions.indexWhere(
        (q) => q.id == entry.triggerQuestionId,
      );
      if (triggerIdx >= 0) {
        final triggerSecOrder =
            (_orderedSections.firstWhere(
                  (s) => s['id'] == _questions[triggerIdx].sectionId,
                  orElse: () => {'displayOrder': -1},
                )['displayOrder']
                as int?) ??
            -1;
        if (triggerSecOrder >= 0 && triggerSecOrder < targetDisplayOrder) {
          specializedBefore++;
        }
      }
    }

    // Count non-registry specialized sections (R, S, T, X, Y, Z) that come
    // before targetDisplayOrder.
    int nonRegistryBefore = 0;
    if (_hasRSection) {
      final rOrder = _rSectionDisplayOrder;
      if (rOrder >= 0 && rOrder < targetDisplayOrder) nonRegistryBefore++;
    }
    if (_hasSSSection) {
      final sOrder = _sSectionDisplayOrder;
      if (sOrder >= 0 && sOrder < targetDisplayOrder) nonRegistryBefore++;
    }
    if (_hasTSection) {
      final tOrder = _tSectionDisplayOrder;
      if (tOrder >= 0 && tOrder < targetDisplayOrder) nonRegistryBefore++;
    }
    if (_hasXSection) {
      final xOrder = _xSectionDisplayOrder;
      if (xOrder >= 0 && xOrder < targetDisplayOrder) nonRegistryBefore++;
    }
    if (_hasYSection) {
      final yOrder = _ySectionDisplayOrder;
      if (yOrder >= 0 && yOrder < targetDisplayOrder) nonRegistryBefore++;
    }
    if (_hasZSection) {
      final zOrder = _zSectionDisplayOrder;
      if (zOrder >= 0 && zOrder < targetDisplayOrder) nonRegistryBefore++;
    }

    return questionsBeforeTarget -
        collapseOffset +
        specializedBefore +
        nonRegistryBefore +
        1;
  }

  /// Logical index for the nav bar counter (1-based display).
  int get _logicalDisplayIndex {
    // Section R has no trigger question in the registry — handle it directly.
    if (_isRSectionMode) {
      return _logicalPositionOfSection(_rSectionDisplayOrder);
    }
    // Section S has no trigger question in the registry — handle it directly.
    if (_isSSectionMode) {
      return _logicalPositionOfSection(_sSectionDisplayOrder);
    }
    // Section T has no trigger question in the registry — handle it directly.
    if (_isTSectionMode) {
      return _logicalPositionOfSection(_tSectionDisplayOrder);
    }
    // Section X has no trigger question in the registry — handle it directly.
    if (_isXSectionMode) {
      return _logicalPositionOfSection(_xSectionDisplayOrder);
    }
    // Section Y has no trigger question in the registry — handle it directly.
    if (_isYSectionMode) {
      return _logicalPositionOfSection(_ySectionDisplayOrder);
    }
    // Section Z has no trigger question in the registry — handle it directly.
    if (_isZSectionMode) {
      return _logicalPositionOfSection(_zSectionDisplayOrder);
    }
    // Generic: if any registered specialized screen is active, show its position
    // as one step after its trigger question.
    for (final entry in _specializedScreenRegistry) {
      if (entry.isActive()) {
        final triggerIdx = _questions.indexWhere(
          (q) => q.id == entry.triggerQuestionId,
        );
        if (triggerIdx >= 0) return _adjustedIndex(triggerIdx) + 1;
      }
    }
    if (_isKSectionMode) {
      final kId = _kSectionId;
      if (kId != null) {
        final firstKIdx = _questions.indexWhere((q) => q.sectionId == kId);
        if (firstKIdx >= 0) return _adjustedIndex(firstKIdx);
      }
    }
    if (_isLSectionMode) {
      final lId = _lSectionId;
      if (lId != null) {
        final firstLIdx = _questions.indexWhere((q) => q.sectionId == lId);
        if (firstLIdx >= 0) return _adjustedIndex(firstLIdx);
      }
    }
    return _adjustedIndex(_currentQuestionIndex);
  }

  /// Builds the list of B.1 virtual questions for [familySize] members.
  /// Each member gets a set of household composition questions (Name, Age,
  /// Gender, Relationship, Education, Occupation, Living Status, Migration Reason).
  List<SurveyQuestion> _buildB1VirtualQuestions(int familySize) {
    if (familySize <= 0) return [];
    final questions = <SurveyQuestion>[];
    for (int m = 1; m <= familySize; m++) {
      final prefix = 'B1_M$m';
      questions.addAll([
        SurveyQuestion(
          id: '${prefix}_NAME',
          sectionId: _kB1SectionId,
          sectionTitle: _kB1SectionTitle,
          questionText: 'Member $m: Full Name',
          type: QuestionType.text,
          isRequired: false,
        ),
        SurveyQuestion(
          id: '${prefix}_AGE',
          sectionId: _kB1SectionId,
          sectionTitle: _kB1SectionTitle,
          questionText: 'Member $m: Age (years)',
          type: QuestionType.number,
          isRequired: false,
        ),
        SurveyQuestion(
          id: '${prefix}_GENDER',
          sectionId: _kB1SectionId,
          sectionTitle: _kB1SectionTitle,
          questionText: 'Member $m: Gender',
          type: QuestionType.singleChoice,
          isRequired: false,
          options: ['Male', 'Female', 'Other'],
        ),
        SurveyQuestion(
          id: '${prefix}_RELATIONSHIP',
          sectionId: _kB1SectionId,
          sectionTitle: _kB1SectionTitle,
          questionText: 'Member $m: Relationship to Head',
          type: QuestionType.singleChoice,
          isRequired: false,
          options: [
            'Head',
            'Spouse',
            'Son/Daughter',
            'Parent',
            'Sibling',
            'Other',
          ],
        ),
        SurveyQuestion(
          id: '${prefix}_EDUCATION',
          sectionId: _kB1SectionId,
          sectionTitle: _kB1SectionTitle,
          questionText: 'Member $m: Education Level',
          type: QuestionType.singleChoice,
          isRequired: false,
          options: [
            'Illiterate',
            'Primary',
            'Middle',
            'Secondary',
            'Higher Secondary',
            'Graduate',
            'Post Graduate',
          ],
        ),
        SurveyQuestion(
          id: '${prefix}_OCCUPATION',
          sectionId: _kB1SectionId,
          sectionTitle: _kB1SectionTitle,
          questionText: 'Member $m: Occupation',
          type: QuestionType.text,
          isRequired: false,
        ),
        SurveyQuestion(
          id: '${prefix}_LIVING_STATUS',
          sectionId: _kB1SectionId,
          sectionTitle: _kB1SectionTitle,
          questionText: 'Member $m: Currently living in household?',
          type: QuestionType.yesNo,
          isRequired: false,
        ),
        SurveyQuestion(
          id: '${prefix}_MIGRATION_REASON',
          sectionId: _kB1SectionId,
          sectionTitle: _kB1SectionTitle,
          questionText: 'Member $m: Reason for migration',
          type: QuestionType.text,
          isRequired: false,
          conditionalOnQuestionId: '${prefix}_LIVING_STATUS',
          conditionalOnValue: 'no',
        ),
      ]);
    }
    return questions;
  }

  @override
  void initState() {
    super.initState();
    // Initialize with empty list — questions are loaded from DB
    _questions = [];
    _dbQuestions = [];
    // Normalize empty string to null — an empty string is not a valid UUID
    final rawSurveyId = widget.surveyId;
    _currentSurveyId = (rawSurveyId != null && rawSurveyId.isNotEmpty)
        ? rawSurveyId
        : null;
    // For read-only modes that have NO survey id, go straight to review mode.
    if (_isReadOnly && _currentSurveyId == null) {
      _isReviewMode = true;
    } else if (_isReadOnly) {
      // read-only — no GPS banner to set
    }
    // Load questions from DB, then load existing answers if needed
    _loadQuestionsFromDb();
  }

  /// Loads active survey questions from the database.
  ///
  /// Queries the active survey template → active sections → active questions
  /// (ordered by display_order) with their answer options.
  ///
  /// Only questions with is_active = true are loaded.
  /// Deactivated questions never appear in new surveys.
  /// No special FA code is needed when additional questions are activated
  /// via Admin — they will appear automatically on the next survey load.
  Future<void> _loadQuestionsFromDb() async {
    if (!mounted) return;
    setState(() {
      _isLoadingQuestions = true;
      _questionLoadError = null;
    });

    // ── Offline path: load from questionnaire cache ───────────────────────
    final isOnline = ConnectivityService.instance.isOnline;
    if (!isOnline) {
      await _loadQuestionsFromCache();
      return;
    }

    try {
      final client = SupabaseService.instance.client;

      // Step 1: Get the active survey template
      final templateRow = await client
          .from('survey_templates')
          .select('id')
          .eq('is_active', true)
          .order('created_at', ascending: true)
          .limit(1)
          .maybeSingle();

      if (templateRow == null) {
        if (mounted) {
          setState(() {
            _isLoadingQuestions = false;
            _questionLoadError =
                'No active survey template found. Please contact your administrator.';
          });
        }
        return;
      }

      final templateId = templateRow['id'] as String;

      // Step 2: Get active sections for this template, ordered by display_order
      final sectionsData = await client
          .from('survey_sections')
          .select('id, section_title, section_code, display_order')
          .eq('template_id', templateId)
          .eq('is_active', true)
          .order('display_order', ascending: true);

      if (sectionsData.isEmpty) {
        if (mounted) {
          setState(() {
            _isLoadingQuestions = false;
            _questionLoadError =
                'No active sections found in the survey template.';
          });
        }
        return;
      }

      // Build a section_id → section_title lookup map
      final sectionTitles = <String, String>{};
      final List<Map<String, dynamic>> orderedSecs = [];
      for (final sec in sectionsData) {
        final secId = sec['id'] as String;
        final secTitle = (sec['section_title'] as String?) ?? 'Section';
        sectionTitles[secId] = secTitle;
        orderedSecs.add({
          'id': secId,
          'title': secTitle,
          'code': ((sec['section_code'] as String?) ?? '').toUpperCase(),
          'displayOrder': (sec['display_order'] as int?) ?? 0,
        });
      }
      final sectionIds = sectionTitles.keys.toList();

      // Step 3: Get all active questions for these sections, with options
      final List<SurveyQuestion> loadedQuestions = [];

      for (final sectionId in sectionIds) {
        final questionsData = await client
            .from('survey_questions')
            .select(
              'id, section_id, question_code, question_text, question_type, '
              'required, display_order, help_text, is_active, '
              'conditional_on_question_id, conditional_on_value, '
              'survey_question_options(id, option_text, option_value, display_order, is_active)',
            )
            .eq('section_id', sectionId)
            .eq('is_active', true)
            .order('display_order', ascending: true);

        for (final qRow in questionsData) {
          final rowWithSection = Map<String, dynamic>.from(qRow);
          // Inject section_title into the row for fromDbRow factory
          rowWithSection['survey_sections'] = {
            'section_title': sectionTitles[sectionId] ?? 'Section',
          };
          loadedQuestions.add(SurveyQuestion.fromDbRow(rowWithSection));
        }
      }

      if (!mounted) return;

      setState(() {
        _dbQuestions = loadedQuestions;
        _orderedSections = orderedSecs;
        _isLoadingQuestions = false;
        // Build initial _questions with B.1 injected (family size = 0 initially)
        _rebuildQuestionsWithB1(preserveIndex: false);
      });

      // ── Cache the questionnaire for offline use ───────────────────────────
      _cacheQuestionnaire(
        templateId: templateId,
        sections: orderedSecs,
        questions: loadedQuestions,
      );

      // After questions are loaded, load existing answers if needed
      if (_currentSurveyId != null &&
          (widget.surveyMode == 'view' ||
              widget.surveyMode == 'submitted' ||
              widget.surveyMode == 'correction' ||
              widget.surveyMode == 'edit')) {
        setState(() => _isLoadingAnswers = true);
        _loadExistingAnswers();
      }
    } catch (e) {
      debugPrint('Survey question load error: $e');
      // ── Supabase failed — try cache fallback ─────────────────────────────
      if (mounted) {
        await _loadQuestionsFromCache(
          fallbackError:
              'Failed to load survey questions. Please check your connection and try again.',
        );
      }
    }
  }

  /// Saves the loaded questionnaire to the local cache for offline use.
  /// Runs in the background — never blocks the UI.
  void _cacheQuestionnaire({
    required String templateId,
    required List<Map<String, dynamic>> sections,
    required List<SurveyQuestion> questions,
  }) {
    if (!LocalDatabaseService.instance.isAvailable) return;
    final cachePayload = {
      'templateId': templateId,
      'sections': sections,
      'questions': questions
          .map(
            (q) => {
              'id': q.id,
              'sectionId': q.sectionId,
              'sectionTitle': q.sectionTitle,
              'questionText': q.questionText,
              'type': q.type.name,
              'isRequired': q.isRequired,
              'options': q.options,
              'optionValues': q.optionValues,
              'hint': q.hint,
              'questionCode': q.questionCode,
              'conditionalOnQuestionId': q.conditionalOnQuestionId,
              'conditionalOnValue': q.conditionalOnValue,
            },
          )
          .toList(),
    };
    final configJson = jsonEncode(cachePayload);
    // Save under the templateId key AND under 'latest' for offline lookup
    LocalDatabaseService.instance
        .saveQuestionnaireCache(cacheKey: templateId, configJson: configJson)
        .then((_) {
          return LocalDatabaseService.instance.saveQuestionnaireCache(
            cacheKey: 'latest',
            configJson: configJson,
          );
        })
        .then(
          (_) => debugPrint(
            '[LocalDB] Questionnaire cached (key=$templateId + latest).',
          ),
        )
        .catchError(
          (e) => debugPrint('[LocalDB] Cache write failed (non-fatal): $e'),
        );
  }

  /// Loads questionnaire from the local cache.
  /// Shows a clear error if no cache exists.
  Future<void> _loadQuestionsFromCache({String? fallbackError}) async {
    if (!LocalDatabaseService.instance.isAvailable) {
      if (mounted) {
        setState(() {
          _isLoadingQuestions = false;
          _questionLoadError =
              fallbackError ??
              'You are offline. No cached questionnaire is available. '
                  'Please connect to the internet to load the survey.';
        });
      }
      return;
    }

    try {
      // Find the most recently cached questionnaire (we don't know the templateId
      // without Supabase, so we look for any cached entry).
      // We store the templateId in the payload itself, so we query by a known
      // convention: try the most recent cache entry.
      // Use the surveyId's cached templateId if available, otherwise use a
      // generic lookup. We query the raw DB for the most recent cache entry.
      Map<String, dynamic>? cacheRow;

      // Try to find any cached questionnaire
      if (LocalDatabaseService.instance.isAvailable) {
        // We need to find the cache key. Since we don't have the templateId
        // offline, we use a sentinel key 'latest' that we also write on cache.
        cacheRow = await LocalDatabaseService.instance.getQuestionnaireCache(
          'latest',
        );
      }

      if (cacheRow == null) {
        if (mounted) {
          setState(() {
            _isLoadingQuestions = false;
            _questionLoadError =
                fallbackError ??
                'You are offline and no cached questionnaire is available. '
                    'Please connect to the internet to load the survey.';
          });
        }
        return;
      }

      final configJson = cacheRow['config_json'] as String;
      final config = jsonDecode(configJson) as Map<String, dynamic>;

      final rawSections = (config['sections'] as List?) ?? [];
      final rawQuestions = (config['questions'] as List?) ?? [];

      final orderedSecs = rawSections
          .map((s) => Map<String, dynamic>.from(s as Map))
          .toList();

      final loadedQuestions = rawQuestions.map((q) {
        final qMap = Map<String, dynamic>.from(q as Map);
        return SurveyQuestion(
          id: qMap['id'] as String,
          sectionId: qMap['sectionId'] as String,
          sectionTitle: qMap['sectionTitle'] as String,
          questionText: qMap['questionText'] as String,
          type: SurveyQuestion._typeFromString(qMap['type'] as String),
          isRequired: qMap['isRequired'] as bool? ?? false,
          options: (qMap['options'] as List?)?.cast<String>(),
          optionValues: (qMap['optionValues'] as List?)?.cast<String>(),
          hint: qMap['hint'] as String?,
          questionCode: qMap['questionCode'] as String?,
          conditionalOnQuestionId: qMap['conditionalOnQuestionId'] as String?,
          conditionalOnValue: qMap['conditionalOnValue'] as String?,
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        _dbQuestions = loadedQuestions;
        _orderedSections = orderedSecs;
        _isLoadingQuestions = false;
        _rebuildQuestionsWithB1(preserveIndex: false);
      });

      debugPrint('[LocalDB] Questionnaire loaded from cache (offline).');

      // Load existing answers from local DB when offline
      if (_currentSurveyId != null &&
          (widget.surveyMode == 'view' ||
              widget.surveyMode == 'submitted' ||
              widget.surveyMode == 'correction' ||
              widget.surveyMode == 'edit')) {
        setState(() => _isLoadingAnswers = true);
        _loadExistingAnswers();
      }
    } catch (e) {
      debugPrint('_loadQuestionsFromCache error: $e');
      if (mounted) {
        setState(() {
          _isLoadingQuestions = false;
          _questionLoadError =
              fallbackError ??
              'Failed to load cached questionnaire. Please connect to the internet.';
        });
      }
    }
  }

  /// Loads saved survey answers from the surveys.responses JSONB column.
  /// When offline, falls back to the local_surveys table.
  Future<void> _loadExistingAnswers() async {
    // Guard: only proceed with a valid non-empty UUID
    if (_currentSurveyId == null || _currentSurveyId!.isEmpty) return;
    // _isLoadingAnswers is already true (set synchronously in initState)
    try {
      // ── Offline path: load from local DB ─────────────────────────────────
      final isOnline = ConnectivityService.instance.isOnline;
      if (!isOnline) {
        await _loadExistingAnswersFromLocal();
        return;
      }

      final client = SupabaseService.instance.client;
      final row = await client
          .from('surveys')
          .select('responses')
          .eq('id', _currentSurveyId!)
          .maybeSingle();
      if (row != null) {
        final responses = row['responses'];
        if (responses is Map) {
          final loaded = <String, dynamic>{};
          responses.forEach((key, value) {
            if (key is String) loaded[key] = value;
          });

          // ── Remap option_value → option_text for multipleChoice answers ──
          for (final q in _dbQuestions) {
            if (q.type != QuestionType.multipleChoice) continue;
            final raw = loaded[q.id];
            if (raw == null) continue;

            List<dynamic> rawList;
            if (raw is List) {
              rawList = raw;
            } else if (raw is Map) {
              final sel = raw['selections'];
              if (sel is List) {
                rawList = sel;
              } else {
                continue;
              }
            } else {
              continue;
            }

            final optVals = q.optionValues;
            final optTexts = q.options;
            if (optVals == null ||
                optTexts == null ||
                optVals.length != optTexts.length) {
              continue;
            }
            final valueToText = <String, String>{};
            for (int i = 0; i < optVals.length; i++) {
              if (optVals[i].isNotEmpty) {
                valueToText[optVals[i]] = optTexts[i];
              }
            }
            if (valueToText.isEmpty) continue;

            final remapped = rawList.map((item) {
              final s = item?.toString() ?? '';
              return valueToText[s] ?? s;
            }).toList();

            if (raw is Map) {
              loaded[q.id] = {
                'selections': remapped,
                'specifyText': (raw['specifyText'] as String?) ?? '',
              };
            } else {
              loaded[q.id] = remapped;
            }
          }
          // ── End remap ────────────────────────────────────────────────────

          if (mounted) {
            setState(() {
              _answers.addAll(loaded);
              _rebuildQuestionsWithB1(preserveIndex: false);
            });
          }
        }
      }
      if (mounted) {
        setState(() {
          _isLoadingAnswers = false;
          if (_isReadOnly) {
            _isReviewMode = true;
          }
        });
      }
    } catch (e) {
      debugPrint('_loadExistingAnswers error (surveyId=$_currentSurveyId): $e');
      // ── Supabase failed — try local DB ────────────────────────────────────
      if (mounted) {
        await _loadExistingAnswersFromLocal();
      }
    }
  }

  /// Loads existing answers from the local SQLite database.
  Future<void> _loadExistingAnswersFromLocal() async {
    if (_currentSurveyId == null || _currentSurveyId!.isEmpty) {
      if (mounted) setState(() => _isLoadingAnswers = false);
      return;
    }
    try {
      final localRow = await LocalDatabaseService.instance.getSurvey(
        _currentSurveyId!,
      );
      if (localRow != null) {
        final responsesJson = localRow['responses_json'] as String? ?? '{}';
        final responses = jsonDecode(responsesJson);
        if (responses is Map) {
          final loaded = <String, dynamic>{};
          responses.forEach((key, value) {
            if (key is String) loaded[key] = value;
          });
          if (mounted) {
            setState(() {
              _answers.addAll(loaded);
              _rebuildQuestionsWithB1(preserveIndex: false);
            });
          }
          debugPrint('[LocalDB] Answers loaded from local DB (offline).');
        }
      }
    } catch (e) {
      debugPrint('_loadExistingAnswersFromLocal error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAnswers = false;
          if (_isReadOnly) _isReviewMode = true;
        });
      }
    }
  }

  void _onAnswer(String questionId, dynamic value) {
    setState(() {
      _answers[questionId] = value;

      // When Q-BASIC-01 (family size) changes, rebuild B.1 virtual questions.
      final fsq = _familySizeQuestion;
      if (fsq != null && questionId == fsq.id) {
        _rebuildQuestionsWithB1(preserveIndex: true);
      }
    });
  }

  void _goNext() {
    if (_isReviewMode) return;

    // ── Section A (Respondent Details) mode: save data and advance to section after A ──
    if (_isASectionMode) {
      final isValid =
          _respondentDetailsKey.currentState?.validateAndSave() ?? true;
      if (!isValid) {
        Fluttertoast.showToast(
          msg: 'Please fill in all required fields in Section A',
        );
        return;
      }
      _respondentDetailsKey.currentState?.saveData();
      final afterAId = _sectionAfterA;
      if (afterAId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterAId);
        if (firstIdx >= 0) {
          setState(() {
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
      }
      // Fallback: first question whose sectionId != _aSectionId
      final nextIdx = _questions.indexWhere((q) => q.sectionId != _aSectionId);
      if (nextIdx >= 0) {
        setState(() {
          _currentQuestionIndex = nextIdx;
        });
        return;
      }
      setState(() {
        _isReviewMode = true;
      });
      return;
    }

    // ── Section B (Household Profile) mode: save data and advance to section after B ──
    if (_isBSectionMode) {
      final isValid =
          _householdProfileKey.currentState?.validateAndSave() ?? true;
      if (!isValid) {
        Fluttertoast.showToast(
          msg: 'Please fill in all required fields in Section B',
        );
        return;
      }
      _householdProfileKey.currentState?.saveData();
      final afterBId = _sectionAfterB;
      if (afterBId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterBId);
        if (firstIdx >= 0) {
          setState(() {
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
      }
      // If Section C exists
      final cId = _cSectionId;
      if (cId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == cId);
        if (firstIdx >= 0) {
          setState(() {
            _cSectionPageIndex = 0;
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
      }
      final nextIdx = _questions.indexWhere(
          (q) => q.sectionId != _bSectionId && q.sectionId != _aSectionId);
      if (nextIdx >= 0) {
        setState(() {
          _currentQuestionIndex = nextIdx;
        });
        return;
      }
      setState(() {
        _isReviewMode = true;
      });
      return;
    }

    // ── Section C (Land, Water, Assets, Livestock) mode ───────────
    if (_isCSectionMode) {
      final state = _householdAssetsKey.currentState;
      if (state != null) {
        if (!state.validateCurrentPage()) return;
        if (_cSectionPageIndex < 3) {
          setState(() {
            _cSectionPageIndex++;
            state.goToPage(_cSectionPageIndex);
          });
          return;
        }
        state.saveData();
      }
      _cSectionPageIndex = 0;
      final afterCId = _sectionAfterC ?? _sectionAfterAssetMatrix;
      if (afterCId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterCId);
        if (firstIdx >= 0) {
          setState(() {
            _dSectionPageIndex = 0;
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
      }
      final nextIdx = _questions.indexWhere(
          (q) => q.sectionId != _cSectionId && q.sectionId != _bSectionId && q.sectionId != _aSectionId);
      if (nextIdx >= 0) {
        setState(() {
          _dSectionPageIndex = 0;
          _currentQuestionIndex = nextIdx;
        });
        return;
      }
      setState(() {
        _isReviewMode = true;
      });
      return;
    }

    // ── Section D (Agricultural Information / Cropping System) mode ───────
    if (_isDSectionMode) {
      final state = _agriculturalInfoKey.currentState;
      if (state != null) {
        if (!state.validateCurrentPage()) return;
        if (_dSectionPageIndex < 1) {
          setState(() {
            _dSectionPageIndex++;
            state.goToPage(_dSectionPageIndex);
          });
          return;
        }
        state.saveData();
      }
      _dSectionPageIndex = 0;
      final afterDId = _sectionAfterD;
      if (afterDId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterDId);
        if (firstIdx >= 0) {
          setState(() {
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
      }
      final nextIdx = _questions.indexWhere(
          (q) => q.sectionId != _dSectionId && q.sectionId != _cSectionId && q.sectionId != _bSectionId && q.sectionId != _aSectionId);
      if (nextIdx >= 0) {
        setState(() {
          _currentQuestionIndex = nextIdx;
        });
        return;
      }
      setState(() {
        _isReviewMode = true;
      });
      return;
    }

    // ── Asset Matrix mode: save data and advance to C-10 Livestock ────────
    if (_isAssetMatrixMode) {
      _assetMatrixKey.currentState?.saveData();
      setState(() {
        _isAssetMatrixMode = false;
        _isLivestockSectionMode = true;
      });
      return;
    }

    // ── C-10 Livestock mode: save data and advance to section after C ─────
    if (_isLivestockSectionMode) {
      _livestockSectionKey.currentState?.saveData();
      final afterCId = _sectionAfterAssetMatrix;
      if (afterCId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterCId);
        if (firstIdx >= 0) {
          setState(() {
            _isLivestockSectionMode = false;
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
      }
      setState(() {
        _isLivestockSectionMode = false;
        _isReviewMode = true;
      });
      return;
    }

    // ── Q9 Cropping Pattern mode: save data and advance to section after D ─
    if (_isCroppingPatternMode) {
      _croppingPatternKey.currentState?.saveData();
      final afterDId = _sectionAfterD;
      // ── TEMPORARY DIAGNOSTIC ──────────────────────────────────────────────
      debugPrint('=== D NEXT DEBUG ===');
      debugPrint('afterDId: $afterDId');
      debugPrint('has O section: $_hasOSection');
      debugPrint('O section id: $_oSectionId');
      debugPrint('has P section: $_hasPSection');
      debugPrint('P section id: $_pSectionId');
      if (afterDId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterDId);
        debugPrint('first question index after D: $firstIdx');
        if (firstIdx >= 0) {
          debugPrint('  questionText: ${_questions[firstIdx].questionText}');
          debugPrint('  sectionId: ${_questions[firstIdx].sectionId}');
        }
      }
      // ── END TEMPORARY DIAGNOSTIC ──────────────────────────────────────────
      if (afterDId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterDId);
        if (firstIdx >= 0) {
          setState(() {
            _isCroppingPatternMode = false;
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
      }
      // No section after D — check if E/F/L/K sections exist
      if (_hasPestSection) {
        setState(() {
          _isCroppingPatternMode = false;
          _isPestSectionMode = true;
        });
        return;
      }
      if (_hasFSection) {
        setState(() {
          _isCroppingPatternMode = false;
          _isFSectionMode = true;
        });
        return;
      }
      if (_hasLSection) {
        setState(() {
          _isCroppingPatternMode = false;
          _isLSectionMode = true;
        });
        return;
      }
      setState(() {
        _isCroppingPatternMode = false;
        _isReviewMode = true;
      });
      return;
    }

    // ── Section L mode: save data and advance to section after L ───────────
    if (_isLSectionMode) {
      // Auto-save Section L data when navigating away
      _lSectionKey.currentState?.saveData();
      final afterLId = _sectionAfterL;
      if (afterLId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterLId);
        if (firstIdx >= 0) {
          setState(() {
            _isLSectionMode = false;
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
      }
      setState(() {
        _isLSectionMode = false;
        _isReviewMode = true;
      });
      return;
    }

    // ── Section R mode: advance to section after R (or review) ───────────
    if (_isRSectionMode) {
      final afterRId = _sectionAfterR;
      if (afterRId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterRId);
        if (firstIdx >= 0) {
          setState(() {
            _isRSectionMode = false;
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
        // afterR section has no questions — check if it's Section S
        final sId = _sSectionId;
        if (_hasSSSection && afterRId == sId) {
          setState(() {
            _isRSectionMode = false;
            _isSSectionMode = true;
          });
          return;
        }
        // afterR section has no questions — check if it's Section T
        final tId = _tSectionId;
        if (_hasTSection && afterRId == tId) {
          setState(() {
            _isRSectionMode = false;
            _isTSectionMode = true;
          });
          return;
        }
      }
      // No section after R with questions — check if S comes after R
      if (_hasSSSection) {
        final rOrder = _rSectionDisplayOrder;
        final sOrder = _sSectionDisplayOrder;
        if (sOrder > rOrder) {
          setState(() {
            _isRSectionMode = false;
            _isSSectionMode = true;
          });
          return;
        }
      }
      // No section after R with questions — check if T comes after R
      if (_hasTSection) {
        final rOrder = _rSectionDisplayOrder;
        final tOrder = _tSectionDisplayOrder;
        if (tOrder > rOrder) {
          setState(() {
            _isRSectionMode = false;
            _isTSectionMode = true;
          });
          return;
        }
      }
      setState(() {
        _isRSectionMode = false;
        _isReviewMode = true;
      });
      return;
    }

    // ── Section S mode: advance to section after S (or review) ───────────
    if (_isSSectionMode) {
      final afterSId = _sectionAfterS;
      if (afterSId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterSId);
        if (firstIdx >= 0) {
          setState(() {
            _isSSectionMode = false;
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
        // afterS section has no questions — check if it's Section T
        final tId = _tSectionId;
        if (_hasTSection && afterSId == tId) {
          setState(() {
            _isSSectionMode = false;
            _isTSectionMode = true;
          });
          return;
        }
      }
      // No section after S with questions — check if T comes after S
      if (_hasTSection) {
        final sOrder = _sSectionDisplayOrder;
        final tOrder = _tSectionDisplayOrder;
        if (tOrder > sOrder) {
          setState(() {
            _isSSectionMode = false;
            _isTSectionMode = true;
          });
          return;
        }
      }
      setState(() {
        _isSSectionMode = false;
        _isReviewMode = true;
      });
      return;
    }

    // ── Section T mode: advance to section after T (or review) ───────────
    if (_isTSectionMode) {
      final afterTId = _sectionAfterT;
      if (afterTId != null) {
        // Find the next section's code to dispatch to the right specialized mode
        final nextSection = _orderedSections.firstWhere(
          (s) => s['id'] == afterTId,
          orElse: () => <String, dynamic>{},
        );
        final nextCode = nextSection['code'] as String? ?? '';
        if (nextCode == 'X') {
          setState(() {
            _isTSectionMode = false;
            _isXSectionMode = true;
          });
          return;
        }
        if (nextCode == 'Y') {
          setState(() {
            _isTSectionMode = false;
            _isYSectionMode = true;
          });
          return;
        }
        if (nextCode == 'Z') {
          setState(() {
            _isTSectionMode = false;
            _isZSectionMode = true;
          });
          return;
        }
        // Normal section with questions
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterTId);
        if (firstIdx >= 0) {
          setState(() {
            _isTSectionMode = false;
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
      }
      // No section after T (or no questions found) — go to review
      setState(() {
        _isTSectionMode = false;
        _isReviewMode = true;
      });
      return;
    }

    // ── Section X mode: advance to section after X (or review) ───────────
    if (_isXSectionMode) {
      final xOrder = _xSectionDisplayOrder;
      // Check Y → Z in display_order sequence
      if (_hasYSection && _ySectionDisplayOrder > xOrder) {
        setState(() {
          _isXSectionMode = false;
          _isYSectionMode = true;
        });
        return;
      }
      if (_hasZSection && _zSectionDisplayOrder > xOrder) {
        setState(() {
          _isXSectionMode = false;
          _isZSectionMode = true;
        });
        return;
      }
      // No Y/Z after X — check for normal questions after X
      final afterXId = _sectionAfterX;
      if (afterXId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterXId);
        if (firstIdx >= 0) {
          setState(() {
            _isXSectionMode = false;
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
      }
      setState(() {
        _isXSectionMode = false;
        _isReviewMode = true;
      });
      return;
    }

    // ── Section Y mode: advance to section after Y (or review) ───────────
    if (_isYSectionMode) {
      final yOrder = _ySectionDisplayOrder;
      // Check Z in display_order sequence
      if (_hasZSection && _zSectionDisplayOrder > yOrder) {
        setState(() {
          _isYSectionMode = false;
          _isZSectionMode = true;
        });
        return;
      }
      // No Z after Y — check for normal questions after Y
      final afterYId = _sectionAfterY;
      if (afterYId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterYId);
        if (firstIdx >= 0) {
          setState(() {
            _isYSectionMode = false;
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
      }
      setState(() {
        _isYSectionMode = false;
        _isReviewMode = true;
      });
      return;
    }

    // ── Section Z mode: advance to section after Z (or review) ───────────
    if (_isZSectionMode) {
      final afterZId = _sectionAfterZ;
      if (afterZId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterZId);
        if (firstIdx >= 0) {
          setState(() {
            _isZSectionMode = false;
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
      }
      setState(() {
        _isZSectionMode = false;
        _isReviewMode = true;
      });
      return;
    }

    // ── Registered specialized screens (O-SCHEME-MATRIX, P2-TRAINING-NEEDS, …) ──
    // Generic: if any registered specialized screen is currently active, delegate
    // its Next action to the registry entry. No hard-coded O/P logic here.
    for (final entry in _specializedScreenRegistry) {
      if (entry.isActive()) {
        entry.onNext();
        return;
      }
    }

    // ── Section K mode: advance to section after K ──────────────────────────
    if (_isKSectionMode) {
      final afterKId = _sectionAfterK;
      if (afterKId != null) {
        // Check if the section after K is Section L (which has no normal questions)
        if (afterKId == _lSectionId && _hasLSection) {
          setState(() {
            _isKSectionMode = false;
            _isLSectionMode = true;
          });
          return;
        }
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterKId);
        if (firstIdx >= 0) {
          setState(() {
            _isKSectionMode = false;
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
      }
      // No section after K — go to review or next special section
      if (_hasPestSection) {
        setState(() {
          _isKSectionMode = false;
          _isPestSectionMode = true;
        });
        return;
      }
      if (_hasFSection) {
        setState(() {
          _isKSectionMode = false;
          _isFSectionMode = true;
        });
        return;
      }
      if (_hasLSection) {
        setState(() {
          _isKSectionMode = false;
          _isLSectionMode = true;
        });
        return;
      }
      setState(() {
        _isKSectionMode = false;
        _isReviewMode = true;
      });
      return;
    }

    // ── Section F mode: advance to section after F ──────────────────────
    if (_isFSectionMode) {
      final afterId = _sectionAfterF;
      if (afterId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterId);
        if (firstIdx >= 0) {
          setState(() {
            _isFSectionMode = false;
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
      }
      if (_hasLSection) {
        setState(() {
          _isFSectionMode = false;
          _isLSectionMode = true;
        });
        return;
      }
      setState(() {
        _isFSectionMode = false;
        _isReviewMode = true;
      });
      return;
    }

    // ── Section E mode: advance to section after E ───────────────────────
    if (_isPestSectionMode) {
      final afterId = _sectionAfterPest;
      if (afterId != null) {
        final firstIdx = _questions.indexWhere((q) => q.sectionId == afterId);
        if (firstIdx >= 0) {
          setState(() {
            _isPestSectionMode = false;
            _currentQuestionIndex = firstIdx;
          });
          return;
        }
      }
      // No section after E — check if F section should appear next
      if (_hasFSection) {
        setState(() {
          _isPestSectionMode = false;
          _isFSectionMode = true;
        });
        return;
      }
      if (_hasLSection) {
        setState(() {
          _isPestSectionMode = false;
          _isLSectionMode = true;
        });
        return;
      }
      setState(() {
        _isPestSectionMode = false;
        _isReviewMode = true;
      });
      return;
    }

    final q = _questions[_currentQuestionIndex];
    if (_isQuestionVisible(q) && q.isRequired && !_canGoNext) {
      Fluttertoast.showToast(
        msg: 'This field is required before proceeding',
        backgroundColor: AppTheme.warning,
        textColor: Colors.white,
      );
      return;
    }
    int next = _currentQuestionIndex + 1;

    while (next < _questions.length && !_isQuestionVisible(_questions[next])) {
      next++;
    }

    if (next < _questions.length) {
      // Check Section L boundary: entering L section → enter L mode
      if (_hasLSection) {
        final lId = _lSectionId;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        final nextSecId = _questions[next].sectionId;
        if (lId != null && nextSecId == lId && currentSecId != lId) {
          setState(() => _isLSectionMode = true);
          return;
        }
        // Skip through L questions if somehow we land inside L
        if (lId != null && currentSecId == lId) {
          final afterLId = _sectionAfterL;
          if (afterLId != null) {
            final firstAfterL = _questions.indexWhere(
              (q2) => q2.sectionId == afterLId,
            );
            if (firstAfterL >= 0) {
              setState(() => _currentQuestionIndex = firstAfterL);
              return;
            }
          }
          setState(() => _isReviewMode = true);
          return;
        }
      }
      // ── Registered specialized screens: trigger check ─────────────────────
      // Generic: if the current question is the trigger for any registered
      // specialized screen, activate that screen instead of advancing normally.
      // To add a new specialized screen, register it in _specializedScreenRegistry.
      for (final entry in _specializedScreenRegistry) {
        if (_questions[_currentQuestionIndex].id == entry.triggerQuestionId) {
          entry.activate();
          return;
        }
      }
      // Check Section K boundary: entering K section → enter K mode
      if (_hasKSection) {
        final kId = _kSectionId;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        final nextSecId = _questions[next].sectionId;
        if (kId != null && nextSecId == kId && currentSecId != kId) {
          setState(() => _isKSectionMode = true);
          return;
        }
        // Skip through K questions if somehow we land inside K
        if (kId != null && currentSecId == kId) {
          // Find first question after K
          final afterKId = _sectionAfterK;
          if (afterKId != null) {
            final firstAfterK = _questions.indexWhere(
              (q2) => q2.sectionId == afterKId,
            );
            if (firstAfterK >= 0) {
              setState(() => _currentQuestionIndex = firstAfterK);
              return;
            }
          }
          setState(() => _isReviewMode = true);
          return;
        }
      }
      // Check Section C (Asset Matrix) boundary: after last C question → show Asset Matrix
      if (_hasAssetMatrixSection && !_isAssetMatrixMode) {
        final cSec = _orderedSections.firstWhere((s) {
          final c = s['code'] as String;
          return c == 'C' || c == 'SEC-C';
        }, orElse: () => <String, dynamic>{});
        final cSecId = cSec['id'] as String?;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        final nextSecId = _questions[next].sectionId;
        // Trigger Asset Matrix when leaving Section C (current in C, next not in C)
        if (cSecId != null && currentSecId == cSecId && nextSecId != cSecId) {
          setState(() => _isAssetMatrixMode = true);
          return;
        }
      }
      // Check Section D (Cropping Pattern Q9) boundary: after last D question → show Q9
      if (_hasCroppingPatternSection && !_isCroppingPatternMode) {
        final dSecId = _dSectionId;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        final nextSecId = _questions[next].sectionId;
        if (dSecId != null && currentSecId == dSecId && nextSecId != dSecId) {
          setState(() => _isCroppingPatternMode = true);
          return;
        }
      }
      // Check Section E boundary
      if (_hasPestSection) {
        final beforeId = _sectionBeforePest;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        final nextSecId = _questions[next].sectionId;
        if (beforeId != null &&
            currentSecId == beforeId &&
            nextSecId != beforeId) {
          setState(() => _isPestSectionMode = true);
          return;
        }
      }
      // Check Section F boundary (questions in SEC-F are marker-only; skip them)
      if (_hasFSection) {
        final beforeFId = _sectionBeforeF;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        final nextSecId = _questions[next].sectionId;
        // Detect crossing into SEC-F question territory — enter F mode instead
        final fSec = _orderedSections.firstWhere((s) {
          final c = s['code'] as String;
          return c == 'F' || c == 'SEC-F';
        }, orElse: () => <String, dynamic>{});
        final fSecId = fSec['id'] as String?;
        if (fSecId != null && nextSecId == fSecId) {
          setState(() => _isFSectionMode = true);
          return;
        }
        // Also handle: leaving section before F when no F questions exist in DB
        if (beforeFId != null &&
            currentSecId == beforeFId &&
            nextSecId != beforeFId &&
            fSecId != null &&
            nextSecId != fSecId) {
          // next section skips F entirely — enter F mode first
          setState(() => _isFSectionMode = true);
          return;
        }
      }
      // Check Section R boundary: when leaving section before R → enter R mode.
      // R has no survey_questions, so we detect the boundary by display_order.
      if (_hasRSection && !_isRSectionMode) {
        final beforeRId = _sectionBeforeR;
        final currentSecId2 = _questions[_currentQuestionIndex].sectionId;
        if (beforeRId != null && currentSecId2 == beforeRId) {
          // We are at the last question of the section before R.
          // Check that next question is NOT in the section before R
          // (i.e. we are crossing a section boundary).
          final nextSecId2 = _questions[next].sectionId;
          if (nextSecId2 != beforeRId) {
            setState(() => _isRSectionMode = true);
            return;
          }
        }
      }
      // Check Section S boundary: when leaving section before S → enter S mode.
      if (_hasSSSection && !_isSSectionMode) {
        final beforeSId = _sectionBeforeS;
        final currentSecId3 = _questions[_currentQuestionIndex].sectionId;
        if (beforeSId != null && currentSecId3 == beforeSId) {
          final nextSecId3 = _questions[next].sectionId;
          if (nextSecId3 != beforeSId) {
            setState(() => _isSSectionMode = true);
            return;
          }
        }
      }
      // Check Section T boundary: when leaving section before T → enter T mode.
      if (_hasTSection && !_isTSectionMode) {
        final beforeTId = _sectionBeforeT;
        final currentSecId4 = _questions[_currentQuestionIndex].sectionId;
        if (beforeTId != null && currentSecId4 == beforeTId) {
          final nextSecId4 = _questions[next].sectionId;
          if (nextSecId4 != beforeTId) {
            setState(() => _isTSectionMode = true);
            return;
          }
        }
      }
      // Check Section X boundary: when leaving section before X → enter X mode.
      if (_hasXSection && !_isXSectionMode) {
        final beforeXId = _sectionBeforeX;
        final currentSecId5 = _questions[_currentQuestionIndex].sectionId;
        if (beforeXId != null && currentSecId5 == beforeXId) {
          final nextSecId5 = _questions[next].sectionId;
          if (nextSecId5 != beforeXId) {
            setState(() => _isXSectionMode = true);
            return;
          }
        }
      }
      // Check Section Y boundary: when leaving section before Y → enter Y mode.
      if (_hasYSection && !_isYSectionMode) {
        final beforeYId = _sectionBeforeY;
        final currentSecIdY = _questions[_currentQuestionIndex].sectionId;
        if (beforeYId != null && currentSecIdY == beforeYId) {
          final nextSecIdY = _questions[next].sectionId;
          if (nextSecIdY != beforeYId) {
            setState(() => _isYSectionMode = true);
            return;
          }
        }
      }
      // Check Section Z boundary: when leaving section before Z → enter Z mode.
      if (_hasZSection && !_isZSectionMode) {
        final beforeZId = _sectionBeforeZ;
        final currentSecIdZ = _questions[_currentQuestionIndex].sectionId;
        if (beforeZId != null && currentSecIdZ == beforeZId) {
          final nextSecIdZ = _questions[next].sectionId;
          if (nextSecIdZ != beforeZId) {
            setState(() => _isZSectionMode = true);
            return;
          }
        }
      }
      setState(() => _currentQuestionIndex = next);
    } else {
      // No more questions
      if (_hasAssetMatrixSection && !_isAssetMatrixMode) {
        final cSec = _orderedSections.firstWhere((s) {
          final c = s['code'] as String;
          return c == 'C' || c == 'SEC-C';
        }, orElse: () => <String, dynamic>{});
        final cSecId = cSec['id'] as String?;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (cSecId != null && currentSecId == cSecId) {
          setState(() => _isAssetMatrixMode = true);
          return;
        }
      }
      if (_hasCroppingPatternSection && !_isCroppingPatternMode) {
        final dSecId = _dSectionId;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (dSecId != null && currentSecId == dSecId) {
          setState(() => _isCroppingPatternMode = true);
          return;
        }
      }
      if (_hasLSection && !_isLSectionMode) {
        final lId = _lSectionId;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (lId != null && currentSecId == lId) {
          setState(() => _isLSectionMode = true);
          return;
        }
      }
      if (_hasKSection && !_isKSectionMode) {
        final kId = _kSectionId;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (kId != null && currentSecId == kId) {
          // We're on the last K question — enter K mode (shouldn't normally happen)
          setState(() => _isKSectionMode = true);
          return;
        }
      }
      if (_hasPestSection && !_isPestSectionMode) {
        final beforeId = _sectionBeforePest;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (beforeId == null || currentSecId == beforeId) {
          setState(() => _isPestSectionMode = true);
          return;
        }
      }
      if (_hasFSection && !_isFSectionMode) {
        final beforeFId = _sectionBeforeF;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (beforeFId == null || currentSecId == beforeFId) {
          setState(() => _isFSectionMode = true);
          return;
        }
      }
      if (_hasLSection && !_isLSectionMode) {
        // Only enter L mode if the current section is BEFORE Section L
        // in display order. If we are already past L (e.g. in Section Q),
        // skip the L fallback and proceed directly to Preview Survey.
        final lOrder = _lSectionDisplayOrder;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        final currentSecOrder =
            (_orderedSections.firstWhere(
                  (s) => s['id'] == currentSecId,
                  orElse: () => {'displayOrder': -1},
                )['displayOrder']
                as int?) ??
            -1;
        if (lOrder >= 0 && currentSecOrder < lOrder) {
          setState(() => _isLSectionMode = true);
          return;
        }
      }
      // Fallback: check registered specialized screens — if the current question
      // is the trigger for any registered screen, activate it before going to review.
      for (final entry in _specializedScreenRegistry) {
        if (_questions[_currentQuestionIndex].id == entry.triggerQuestionId) {
          entry.activate();
          return;
        }
      }
      // Fallback: if Section R exists and the current section is the section
      // immediately before R (by display_order), enter R mode.
      if (_hasRSection && !_isRSectionMode) {
        final beforeRId = _sectionBeforeR;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (beforeRId != null && currentSecId == beforeRId) {
          setState(() => _isRSectionMode = true);
          return;
        }
        // Also: if R is the very first section and there are no questions before it
        if (beforeRId == null) {
          setState(() => _isRSectionMode = true);
          return;
        }
      }
      // Fallback: if Section S exists and the current section is the section
      // immediately before S (by display_order), enter S mode.
      if (_hasSSSection && !_isSSectionMode) {
        final beforeSId = _sectionBeforeS;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (beforeSId != null && currentSecId == beforeSId) {
          setState(() => _isSSectionMode = true);
          return;
        }
        if (beforeSId == null) {
          setState(() => _isSSectionMode = true);
          return;
        }
      }
      // Fallback: if Section T exists and the current section is the section
      // immediately before T (by display_order), enter T mode.
      if (_hasTSection && !_isTSectionMode) {
        final beforeTId = _sectionBeforeT;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (beforeTId != null && currentSecId == beforeTId) {
          setState(() => _isTSectionMode = true);
          return;
        }
        if (beforeTId == null) {
          setState(() => _isTSectionMode = true);
          return;
        }
      }
      // Fallback: if Section X exists and the current section is the section
      // immediately before X (by display_order), enter X mode.
      if (_hasXSection && !_isXSectionMode) {
        final beforeXId = _sectionBeforeX;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (beforeXId != null && currentSecId == beforeXId) {
          setState(() => _isXSectionMode = true);
          return;
        }
        if (beforeXId == null) {
          setState(() => _isXSectionMode = true);
          return;
        }
      }
      // Fallback: if Section Y exists and the current section is the section
      // immediately before Y (by display_order), enter Y mode.
      if (_hasYSection && !_isYSectionMode) {
        final beforeYId = _sectionBeforeY;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (beforeYId != null && currentSecId == beforeYId) {
          setState(() => _isYSectionMode = true);
          return;
        }
        if (beforeYId == null) {
          setState(() => _isYSectionMode = true);
          return;
        }
      }
      // Fallback: if Section Z exists and the current section is the section
      // immediately before Z (by display_order), enter Z mode.
      if (_hasZSection && !_isZSectionMode) {
        final beforeZId = _sectionBeforeZ;
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (beforeZId != null && currentSecId == beforeZId) {
          setState(() => _isZSectionMode = true);
          return;
        }
        if (beforeZId == null) {
          setState(() => _isZSectionMode = true);
          return;
        }
      }
      setState(() => _isReviewMode = true);
    }
  }

  void _goPrev() {
    if (_isReviewMode) {
      // Going back from review: find the last logical screen before review.
      // Walk _orderedSections in reverse display_order to find the last
      // section that is either a specialized screen or has visible questions.
      //
      // Helper: returns true when there are visible questions in any section
      // whose display_order is strictly greater than [afterOrder].
      bool hasVisibleQuestionsAfterOrder(int afterOrder) {
        for (final q in _questions) {
          if (!_isQuestionVisible(q)) continue;
          final secOrder =
              (_orderedSections.firstWhere(
                    (s) => s['id'] == q.sectionId,
                    orElse: () => {'displayOrder': -1},
                  )['displayOrder']
                  as int?) ??
              -1;
          if (secOrder > afterOrder) return true;
        }
        return false;
      }

      // Check Section Z first (it is the last specialized section).
      if (_hasZSection) {
        final zOrder = _zSectionDisplayOrder;
        if (!hasVisibleQuestionsAfterOrder(zOrder)) {
          setState(() {
            _isReviewMode = false;
            _isZSectionMode = true;
          });
          return;
        }
      }
      // Check Section Y (comes before Z).
      if (_hasYSection) {
        final yOrder = _ySectionDisplayOrder;
        if (!hasVisibleQuestionsAfterOrder(yOrder)) {
          setState(() {
            _isReviewMode = false;
            _isYSectionMode = true;
          });
          return;
        }
      }
      // Check Section X (comes after T).
      if (_hasXSection) {
        final xOrder = _xSectionDisplayOrder;
        if (!hasVisibleQuestionsAfterOrder(xOrder)) {
          setState(() {
            _isReviewMode = false;
            _isXSectionMode = true;
          });
          return;
        }
      }
      // Check Section T (comes after S).
      if (_hasTSection) {
        final tOrder = _tSectionDisplayOrder;
        if (!hasVisibleQuestionsAfterOrder(tOrder)) {
          setState(() {
            _isReviewMode = false;
            _isTSectionMode = true;
          });
          return;
        }
      }
      // Check Section S (comes after R).
      if (_hasSSSection) {
        final sOrder = _sSectionDisplayOrder;
        if (!hasVisibleQuestionsAfterOrder(sOrder)) {
          setState(() {
            _isReviewMode = false;
            _isSSectionMode = true;
          });
          return;
        }
      }
      // Check Section R — it has no survey_questions so it cannot be
      // detected via the registry's trigger-question mechanism.
      if (_hasRSection) {
        final rOrder = _rSectionDisplayOrder;
        if (!hasVisibleQuestionsAfterOrder(rOrder)) {
          setState(() {
            _isReviewMode = false;
            _isRSectionMode = true;
          });
          return;
        }
      }
      // Registered specialized screens (O, P, …) are checked generically.
      // Check in reverse registry order (last registered = last in sequence).
      final registry = _specializedScreenRegistry;
      for (int i = registry.length - 1; i >= 0; i--) {
        final entry = registry[i];
        // Determine if this specialized screen is the last thing before review.
        // It is "last" when there are no normal questions after its trigger question
        // that belong to a section after the trigger's section.
        final triggerIdx = _questions.indexWhere(
          (q) => q.id == entry.triggerQuestionId,
        );
        if (triggerIdx < 0) continue;
        // Check if any visible question exists after the trigger question
        bool hasQuestionsAfterTrigger = false;
        for (int j = triggerIdx + 1; j < _questions.length; j++) {
          if (_isQuestionVisible(_questions[j])) {
            hasQuestionsAfterTrigger = true;
            break;
          }
        }
        if (!hasQuestionsAfterTrigger) {
          // This specialized screen is the last thing before review
          setState(() {
            _isReviewMode = false;
            entry.activate();
          });
          return;
        }
      }
      if (_hasLSection) {
        // Check if L is the last section (no section after L)
        final afterLId = _sectionAfterL;
        if (afterLId == null) {
          setState(() {
            _isReviewMode = false;
            _isLSectionMode = true;
          });
          return;
        }
        // If there are sections after L, fall through to normal handling
      }
      if (_hasFSection) {
        setState(() {
          _isReviewMode = false;
          _isFSectionMode = true;
        });
        return;
      }
      if (_hasPestSection) {
        setState(() {
          _isReviewMode = false;
          _isPestSectionMode = true;
        });
        return;
      }
      // Check if last question before review is in K section
      if (_hasKSection) {
        final kId = _kSectionId;
        if (kId != null) {
          final afterKId = _sectionAfterK;
          // If there's no section after K, K is the last section before review
          if (afterKId == null) {
            setState(() {
              _isReviewMode = false;
              _isKSectionMode = true;
            });
            return;
          }
        }
      }
      setState(() => _isReviewMode = false);
      return;
    }

    // ── In Section D (Agricultural Information) mode ─────────────
    if (_isDSectionMode) {
      final state = _agriculturalInfoKey.currentState;
      if (_dSectionPageIndex > 0) {
        setState(() {
          _dSectionPageIndex--;
          state?.goToPage(_dSectionPageIndex);
        });
        return;
      }
      // On page 0: go back to Section C!
      _agriculturalInfoKey.currentState?.saveData();
      final cId = _cSectionId;
      if (cId != null) {
        final cIdx = _questions.indexWhere((q) => q.sectionId == cId);
        if (cIdx >= 0) {
          setState(() {
            _cSectionPageIndex = 3;
            _currentQuestionIndex = cIdx;
          });
          return;
        }
      }
      setState(() {
        _currentQuestionIndex = 0;
      });
      return;
    }

    // ── In Section C (Land, Water, Assets, Livestock) mode ───────
    if (_isCSectionMode) {
      final state = _householdAssetsKey.currentState;
      if (_cSectionPageIndex > 0) {
        setState(() {
          _cSectionPageIndex--;
          state?.goToPage(_cSectionPageIndex);
        });
        return;
      }
      // On page 0: go back to Section B!
      _householdAssetsKey.currentState?.saveData();
      final bId = _bSectionId;
      if (bId != null) {
        final bIdx = _questions.indexWhere((q) => q.sectionId == bId);
        if (bIdx >= 0) {
          setState(() {
            _currentQuestionIndex = bIdx;
          });
          return;
        }
      }
      setState(() {
        _currentQuestionIndex = 0;
      });
      return;
    }

    // ── In Asset Matrix mode: go back to last C question ──────────────────
    if (_isAssetMatrixMode) {
      final cSec = _orderedSections.firstWhere((s) {
        final c = s['code'] as String;
        return c == 'C' || c == 'SEC-C';
      }, orElse: () => <String, dynamic>{});
      final cSecId = cSec['id'] as String?;
      if (cSecId != null) {
        int lastCIdx = -1;
        for (int i = _questions.length - 1; i >= 0; i--) {
          if (_questions[i].sectionId == cSecId &&
              _isQuestionVisible(_questions[i])) {
            lastCIdx = i;
            break;
          }
        }
        if (lastCIdx >= 0) {
          setState(() {
            _isAssetMatrixMode = false;
            _currentQuestionIndex = lastCIdx;
          });
          return;
        }
      }
      // Fallback: go to section before C
      if (_hasBSection) {
        final bId = _bSectionId;
        final firstBIdx = _questions.indexWhere((q) => q.sectionId == bId);
        if (firstBIdx >= 0) {
          setState(() {
            _isAssetMatrixMode = false;
            _currentQuestionIndex = firstBIdx;
          });
          return;
        }
      }
      final beforeCId = _sectionBeforeAssetMatrix;
      if (beforeCId != null) {
        int lastIdx = -1;
        for (int i = _questions.length - 1; i >= 0; i--) {
          if (_questions[i].sectionId == beforeCId &&
              _isQuestionVisible(_questions[i])) {
            lastIdx = i;
            break;
          }
        }
        if (lastIdx >= 0) {
          setState(() {
            _isAssetMatrixMode = false;
            _currentQuestionIndex = lastIdx;
          });
          return;
        }
      }
      setState(() {
        _isAssetMatrixMode = false;
        _currentQuestionIndex = 0;
      });
      return;
    }

    // ── In Section B (Household Profile) mode: go back to Section A ──────────
    if (_isBSectionMode) {
      _householdProfileKey.currentState?.saveData();
      final aId = _aSectionId;
      if (aId != null) {
        final firstAIdx = _questions.indexWhere((q) => q.sectionId == aId);
        if (firstAIdx >= 0) {
          setState(() {
            _currentQuestionIndex = firstAIdx;
          });
          return;
        }
      }
      setState(() {
        _currentQuestionIndex = 0;
      });
      return;
    }

    // ── In C-10 Livestock mode: go back to Asset Matrix ───────────────────
    if (_isLivestockSectionMode) {
      setState(() {
        _isLivestockSectionMode = false;
        _isAssetMatrixMode = true;
      });
      return;
    }

    // ── In Q9 Cropping Pattern mode: go back to last D question ───────────
    if (_isCroppingPatternMode) {
      final dSecId = _dSectionId;
      if (dSecId != null) {
        int lastDIdx = -1;
        for (int i = _questions.length - 1; i >= 0; i--) {
          if (_questions[i].sectionId == dSecId &&
              _isQuestionVisible(_questions[i])) {
            lastDIdx = i;
            break;
          }
        }
        if (lastDIdx >= 0) {
          setState(() {
            _isCroppingPatternMode = false;
            _currentQuestionIndex = lastDIdx;
          });
          return;
        }
      }
      // Fallback: go to first question
      setState(() {
        _isCroppingPatternMode = false;
        _currentQuestionIndex = 0;
      });
      return;
    }

    // ── In Section X mode: go back to T or section before X ──────────────
    if (_isXSectionMode) {
      // Check if T comes before X
      if (_hasTSection) {
        final tOrder = _tSectionDisplayOrder;
        final xOrder = _xSectionDisplayOrder;
        if (tOrder < xOrder && tOrder >= 0) {
          setState(() {
            _isXSectionMode = false;
            _isTSectionMode = true;
          });
          return;
        }
      }
      // Check if S comes before X (and no T between them)
      if (_hasSSSection) {
        final sOrder = _sSectionDisplayOrder;
        final xOrder = _xSectionDisplayOrder;
        if (sOrder < xOrder && sOrder >= 0) {
          setState(() {
            _isXSectionMode = false;
            _isSSectionMode = true;
          });
          return;
        }
      }
      // Check if R comes before X
      if (_hasRSection) {
        final rOrder = _rSectionDisplayOrder;
        final xOrder = _xSectionDisplayOrder;
        if (rOrder < xOrder && rOrder >= 0) {
          setState(() {
            _isXSectionMode = false;
            _isRSectionMode = true;
          });
          return;
        }
      }
      final beforeXId = _sectionBeforeX;
      if (beforeXId != null) {
        int lastIdx = -1;
        for (int i = _questions.length - 1; i >= 0; i--) {
          if (_questions[i].sectionId == beforeXId &&
              _isQuestionVisible(_questions[i])) {
            lastIdx = i;
            break;
          }
        }
        if (lastIdx >= 0) {
          setState(() {
            _isXSectionMode = false;
            _currentQuestionIndex = lastIdx;
          });
          return;
        }
      }
      setState(() {
        _isXSectionMode = false;
        _currentQuestionIndex = _questions.isNotEmpty
            ? _questions.length - 1
            : 0;
      });
      return;
    }

    // ── In Section Y mode: go back to X or section before Y ──────────────
    if (_isYSectionMode) {
      // Check if X comes before Y
      if (_hasXSection) {
        final xOrder = _xSectionDisplayOrder;
        final yOrder = _ySectionDisplayOrder;
        if (xOrder < yOrder && xOrder >= 0) {
          setState(() {
            _isYSectionMode = false;
            _isXSectionMode = true;
          });
          return;
        }
      }
      // Check if T comes before Y
      if (_hasTSection) {
        final tOrder = _tSectionDisplayOrder;
        final yOrder = _ySectionDisplayOrder;
        if (tOrder < yOrder && tOrder >= 0) {
          setState(() {
            _isYSectionMode = false;
            _isTSectionMode = true;
          });
          return;
        }
      }
      // Check if S comes before Y
      if (_hasSSSection) {
        final sOrder = _sSectionDisplayOrder;
        final yOrder = _ySectionDisplayOrder;
        if (sOrder < yOrder && sOrder >= 0) {
          setState(() {
            _isYSectionMode = false;
            _isSSectionMode = true;
          });
          return;
        }
      }
      // Check if R comes before Y
      if (_hasRSection) {
        final rOrder = _rSectionDisplayOrder;
        final yOrder = _ySectionDisplayOrder;
        if (rOrder < yOrder && rOrder >= 0) {
          setState(() {
            _isYSectionMode = false;
            _isRSectionMode = true;
          });
          return;
        }
      }
      final beforeYId = _sectionBeforeY;
      if (beforeYId != null) {
        int lastIdx = -1;
        for (int i = _questions.length - 1; i >= 0; i--) {
          if (_questions[i].sectionId == beforeYId &&
              _isQuestionVisible(_questions[i])) {
            lastIdx = i;
            break;
          }
        }
        if (lastIdx >= 0) {
          setState(() {
            _isYSectionMode = false;
            _currentQuestionIndex = lastIdx;
          });
          return;
        }
      }
      setState(() {
        _isYSectionMode = false;
        _currentQuestionIndex = _questions.isNotEmpty
            ? _questions.length - 1
            : 0;
      });
      return;
    }

    // ── In Section Z mode: go back to Y or section before Z ──────────────
    if (_isZSectionMode) {
      // Check if Y comes before Z
      if (_hasYSection) {
        final yOrder = _ySectionDisplayOrder;
        final zOrder = _zSectionDisplayOrder;
        if (yOrder < zOrder && yOrder >= 0) {
          setState(() {
            _isZSectionMode = false;
            _isYSectionMode = true;
          });
          return;
        }
      }
      // Check if X comes before Z
      if (_hasXSection) {
        final xOrder = _xSectionDisplayOrder;
        final zOrder = _zSectionDisplayOrder;
        if (xOrder < zOrder && xOrder >= 0) {
          setState(() {
            _isZSectionMode = false;
            _isXSectionMode = true;
          });
          return;
        }
      }
      // Check if T comes before Z
      if (_hasTSection) {
        final tOrder = _tSectionDisplayOrder;
        final zOrder = _zSectionDisplayOrder;
        if (tOrder < zOrder && tOrder >= 0) {
          setState(() {
            _isZSectionMode = false;
            _isTSectionMode = true;
          });
          return;
        }
      }
      // Check if S comes before Z
      if (_hasSSSection) {
        final sOrder = _sSectionDisplayOrder;
        final zOrder = _zSectionDisplayOrder;
        if (sOrder < zOrder && sOrder >= 0) {
          setState(() {
            _isZSectionMode = false;
            _isSSectionMode = true;
          });
          return;
        }
      }
      // Check if R comes before Z
      if (_hasRSection) {
        final rOrder = _rSectionDisplayOrder;
        final zOrder = _zSectionDisplayOrder;
        if (rOrder < zOrder && rOrder >= 0) {
          setState(() {
            _isZSectionMode = false;
            _isRSectionMode = true;
          });
          return;
        }
      }
      final beforeZId = _sectionBeforeZ;
      if (beforeZId != null) {
        int lastIdx = -1;
        for (int i = _questions.length - 1; i >= 0; i--) {
          if (_questions[i].sectionId == beforeZId &&
              _isQuestionVisible(_questions[i])) {
            lastIdx = i;
            break;
          }
        }
        if (lastIdx >= 0) {
          setState(() {
            _isZSectionMode = false;
            _currentQuestionIndex = lastIdx;
          });
          return;
        }
      }
      setState(() {
        _isZSectionMode = false;
        _currentQuestionIndex = _questions.isNotEmpty
            ? _questions.length - 1
            : 0;
      });
      return;
    }

    // ── In Section T mode: go back to last question of section before T ────
    if (_isTSectionMode) {
      // Check if S comes before T
      if (_hasSSSection) {
        final sOrder = _sSectionDisplayOrder;
        final tOrder = _tSectionDisplayOrder;
        if (sOrder < tOrder && sOrder >= 0) {
          setState(() {
            _isTSectionMode = false;
            _isSSectionMode = true;
          });
          return;
        }
      }
      // Check if R comes before T (and no S between them)
      if (_hasRSection) {
        final rOrder = _rSectionDisplayOrder;
        final tOrder = _tSectionDisplayOrder;
        if (rOrder < tOrder && rOrder >= 0) {
          setState(() {
            _isTSectionMode = false;
            _isRSectionMode = true;
          });
          return;
        }
      }
      final beforeTId = _sectionBeforeT;
      if (beforeTId != null) {
        int lastIdx = -1;
        for (int i = _questions.length - 1; i >= 0; i--) {
          if (_questions[i].sectionId == beforeTId &&
              _isQuestionVisible(_questions[i])) {
            lastIdx = i;
            break;
          }
        }
        if (lastIdx >= 0) {
          setState(() {
            _isTSectionMode = false;
            _currentQuestionIndex = lastIdx;
          });
          return;
        }
      }
      setState(() {
        _isTSectionMode = false;
        _currentQuestionIndex = _questions.isNotEmpty
            ? _questions.length - 1
            : 0;
      });
      return;
    }

    // ── In Section S mode: go back to last question of section before S ────
    if (_isSSectionMode) {
      // Check if R comes before S
      if (_hasRSection) {
        final rOrder = _rSectionDisplayOrder;
        final sOrder = _sSectionDisplayOrder;
        if (rOrder < sOrder && rOrder >= 0) {
          setState(() {
            _isSSectionMode = false;
            _isRSectionMode = true;
          });
          return;
        }
      }
      final beforeSId = _sectionBeforeS;
      if (beforeSId != null) {
        int lastIdx = -1;
        for (int i = _questions.length - 1; i >= 0; i--) {
          if (_questions[i].sectionId == beforeSId &&
              _isQuestionVisible(_questions[i])) {
            lastIdx = i;
            break;
          }
        }
        if (lastIdx >= 0) {
          setState(() {
            _isSSectionMode = false;
            _currentQuestionIndex = lastIdx;
          });
          return;
        }
      }
      setState(() {
        _isSSectionMode = false;
        _currentQuestionIndex = _questions.isNotEmpty
            ? _questions.length - 1
            : 0;
      });
      return;
    }

    // ── In Section R mode: go back to last question of section before R ────
    if (_isRSectionMode) {
      final beforeRId = _sectionBeforeR;
      if (beforeRId != null) {
        int lastIdx = -1;
        for (int i = _questions.length - 1; i >= 0; i--) {
          if (_questions[i].sectionId == beforeRId &&
              _isQuestionVisible(_questions[i])) {
            lastIdx = i;
            break;
          }
        }
        if (lastIdx >= 0) {
          setState(() {
            _isRSectionMode = false;
            _currentQuestionIndex = lastIdx;
          });
          return;
        }
      }
      setState(() {
        _isRSectionMode = false;
        _currentQuestionIndex = _questions.isNotEmpty
            ? _questions.length - 1
            : 0;
      });
      return;
    }

    // ── In L section mode: go back to section before L ─────────────────────
    if (_isLSectionMode) {
      // Check if K section is immediately before L
      if (_hasKSection && _sectionBeforeL == _kSectionId) {
        setState(() {
          _isLSectionMode = false;
          _isKSectionMode = true;
        });
        return;
      }
      // Check if F section comes before L
      if (_hasFSection) {
        setState(() {
          _isLSectionMode = false;
          _isFSectionMode = true;
        });
        return;
      }
      if (_hasPestSection) {
        setState(() {
          _isLSectionMode = false;
          _isPestSectionMode = true;
        });
        return;
      }
      final beforeLId = _sectionBeforeL;
      if (beforeLId != null) {
        int lastIdx = -1;
        for (int i = _questions.length - 1; i >= 0; i--) {
          if (_questions[i].sectionId == beforeLId &&
              _isQuestionVisible(_questions[i])) {
            lastIdx = i;
            break;
          }
        }
        if (lastIdx >= 0) {
          setState(() {
            _isLSectionMode = false;
            _currentQuestionIndex = lastIdx;
          });
          return;
        }
      }
      setState(() {
        _isLSectionMode = false;
        _currentQuestionIndex = 0;
      });
      return;
    }

    // ── Registered specialized screens: Prev delegation ──────────────────
    // Generic: if any registered specialized screen is currently active, delegate
    // its Prev action to the registry entry.
    for (final entry in _specializedScreenRegistry) {
      if (entry.isActive()) {
        entry.onPrev();
        return;
      }
    }

    // ── In K section mode: go back to section before K ─────────────────────
    if (_isKSectionMode) {
      final beforeKId = _sectionBeforeK;
      if (beforeKId != null) {
        int lastIdx = -1;
        for (int i = _questions.length - 1; i >= 0; i--) {
          if (_questions[i].sectionId == beforeKId &&
              _isQuestionVisible(_questions[i])) {
            lastIdx = i;
            break;
          }
        }
        if (lastIdx >= 0) {
          setState(() {
            _isKSectionMode = false;
            _currentQuestionIndex = lastIdx;
          });
          return;
        }
      }
      setState(() {
        _isKSectionMode = false;
        _currentQuestionIndex = 0;
      });
      return;
    }

    // ── In F section mode: go back to E section or section before F ────────
    if (_isFSectionMode) {
      if (_hasPestSection) {
        setState(() {
          _isFSectionMode = false;
          _isPestSectionMode = true;
        });
        return;
      }
      final beforeFId = _sectionBeforeF;
      if (beforeFId != null) {
        int lastIdx = -1;
        for (int i = _questions.length - 1; i >= 0; i--) {
          if (_questions[i].sectionId == beforeFId &&
              _isQuestionVisible(_questions[i])) {
            lastIdx = i;
            break;
          }
        }
        if (lastIdx >= 0) {
          setState(() {
            _isFSectionMode = false;
            _currentQuestionIndex = lastIdx;
          });
          return;
        }
      }
      setState(() {
        _isFSectionMode = false;
        _currentQuestionIndex = 0;
      });
      return;
    }

    // ── In E section mode: go back to section before E ──────────────────
    if (_isPestSectionMode) {
      final beforeId = _sectionBeforePest;
      if (beforeId != null) {
        int lastIdx = -1;
        for (int i = _questions.length - 1; i >= 0; i--) {
          if (_questions[i].sectionId == beforeId &&
              _isQuestionVisible(_questions[i])) {
            lastIdx = i;
            break;
          }
        }
        if (lastIdx >= 0) {
          setState(() {
            _isPestSectionMode = false;
            _currentQuestionIndex = lastIdx;
          });
          return;
        }
      }
      setState(() {
        _isPestSectionMode = false;
        _currentQuestionIndex = 0;
      });
      return;
    }

    // ── At first question of section after R: go back into R mode ──────────
    if (_hasRSection) {
      final afterRId = _sectionAfterR;
      if (afterRId != null) {
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (currentSecId == afterRId) {
          final firstVisibleInAfterR = _questions.indexWhere(
            (q) => q.sectionId == afterRId && _isQuestionVisible(q),
          );
          if (firstVisibleInAfterR == _currentQuestionIndex) {
            // Check if S is between R and afterR
            if (_hasSSSection) {
              final sOrder2 = _sSectionDisplayOrder;
              final rOrder2 = _rSectionDisplayOrder;
              final afterROrder2 =
                  (_orderedSections.firstWhere(
                        (s) => s['id'] == afterRId,
                        orElse: () => {'displayOrder': -1},
                      )['displayOrder']
                      as int?) ??
                  -1;
              if (sOrder2 > rOrder2 && sOrder2 < afterROrder2) {
                setState(() => _isSSectionMode = true);
                return;
              }
            }
            // Check if T is between R and afterR (beyond S)
            if (_hasTSection) {
              final tOrder = _tSectionDisplayOrder;
              final rOrder2 = _rSectionDisplayOrder;
              final afterROrder2 =
                  (_orderedSections.firstWhere(
                        (s) => s['id'] == afterRId,
                        orElse: () => {'displayOrder': -1},
                      )['displayOrder']
                      as int?) ??
                  -1;
              final sOrder2 = _sSectionDisplayOrder;
              if (tOrder > rOrder2 && tOrder < afterROrder2) {
                // Check if S is also between R and afterR
                if (sOrder2 > rOrder2 && sOrder2 < tOrder) {
                  setState(() => _isSSectionMode = true);
                } else {
                  setState(() => _isTSectionMode = true);
                }
                return;
              }
            }
            setState(() => _isRSectionMode = true);
            return;
          }
        }
      }
    }

    // ── At first question of section after S: go back into S mode ──────────
    if (_hasSSSection) {
      final afterSId = _sectionAfterS;
      if (afterSId != null) {
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (currentSecId == afterSId) {
          final firstVisibleInAfterS = _questions.indexWhere(
            (q) => q.sectionId == afterSId && _isQuestionVisible(q),
          );
          if (firstVisibleInAfterS == _currentQuestionIndex) {
            // Check if T is between S and afterS
            if (_hasTSection) {
              final tOrder2 = _tSectionDisplayOrder;
              final sOrder2 = _sSectionDisplayOrder;
              final afterSOrder2 =
                  (_orderedSections.firstWhere(
                        (s) => s['id'] == afterSId,
                        orElse: () => {'displayOrder': -1},
                      )['displayOrder']
                      as int?) ??
                  -1;
              if (tOrder2 > sOrder2 && tOrder2 < afterSOrder2) {
                // Check if X is also between S and afterS
                if (_hasXSection) {
                  final xOrder2 = _xSectionDisplayOrder;
                  if (xOrder2 > tOrder2 && xOrder2 < afterSOrder2) {
                    setState(() => _isXSectionMode = true);
                    return;
                  }
                }
                setState(() => _isTSectionMode = true);
                return;
              }
            }
            // Check if X is between S and afterS
            if (_hasXSection) {
              final xOrder2 = _xSectionDisplayOrder;
              final sOrder2 = _sSectionDisplayOrder;
              final afterSOrder2 =
                  (_orderedSections.firstWhere(
                        (s) => s['id'] == afterSId,
                        orElse: () => {'displayOrder': -1},
                      )['displayOrder']
                      as int?) ??
                  -1;
              if (xOrder2 > sOrder2 && xOrder2 < afterSOrder2) {
                setState(() => _isXSectionMode = true);
                return;
              }
            }
            setState(() => _isSSectionMode = true);
            return;
          }
        }
      }
    }

    // ── At first question of section after T: go back into T mode ──────────
    // (handled generically via the section-before-X check above)

    // ── At first question of section after L: go back into L mode ──────────
    if (_hasLSection) {
      final afterLId = _sectionAfterL;
      if (afterLId != null) {
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (currentSecId == afterLId) {
          final firstVisibleInAfterL = _questions.indexWhere(
            (q) => q.sectionId == afterLId && _isQuestionVisible(q),
          );
          if (firstVisibleInAfterL == _currentQuestionIndex) {
            setState(() => _isLSectionMode = true);
            return;
          }
        }
      }
      // Also: if we're somehow inside L questions, enter L mode
      final lId = _lSectionId;
      if (lId != null) {
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (currentSecId == lId) {
          setState(() => _isLSectionMode = true);
          return;
        }
      }
    }

    // ── At first question of section after F: go back into F mode ──────────
    if (_hasFSection) {
      final afterFId = _sectionAfterF;
      if (afterFId != null) {
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (currentSecId == afterFId) {
          final firstVisibleInAfterF = _questions.indexWhere(
            (q) => q.sectionId == afterFId && _isQuestionVisible(q),
          );
          if (firstVisibleInAfterF == _currentQuestionIndex) {
            setState(() => _isFSectionMode = true);
            return;
          }
        }
      }
      // Also handle: at first question of section after E, but F exists between
      final fSec = _orderedSections.firstWhere((s) {
        final c = s['code'] as String;
        return c == 'F' || c == 'SEC-F';
      }, orElse: () => <String, dynamic>{});
      final fSecId = fSec['id'] as String?;
      if (fSecId != null) {
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (currentSecId == fSecId) {
          setState(() => _isFSectionMode = true);
          return;
        }
      }
    }

    // ── At first question of section after C: go back into Section C mode ──
    if (_hasCSection) {
      final afterCId = _sectionAfterC ?? _sectionAfterAssetMatrix;
      if (afterCId != null) {
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (currentSecId == afterCId) {
          final firstVisibleInAfterC = _questions.indexWhere(
            (q) => q.sectionId == afterCId && _isQuestionVisible(q),
          );
          if (firstVisibleInAfterC == _currentQuestionIndex) {
            final cId = _cSectionId;
            final cIdx = cId != null ? _questions.indexWhere((q) => q.sectionId == cId) : -1;
            setState(() {
              _cSectionPageIndex = 3;
              if (cIdx >= 0) _currentQuestionIndex = cIdx;
            });
            return;
          }
        }
      }
    } else if (_hasAssetMatrixSection) {
      final afterCId = _sectionAfterAssetMatrix;
      if (afterCId != null) {
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (currentSecId == afterCId) {
          final firstVisibleInAfterC = _questions.indexWhere(
            (q) => q.sectionId == afterCId && _isQuestionVisible(q),
          );
          if (firstVisibleInAfterC == _currentQuestionIndex) {
            setState(() => _isLivestockSectionMode = true);
            return;
          }
        }
      }
    }

    // ── At first question of section after D: go back into Section D mode ─────────
    if (_hasDSection) {
      final afterDId = _sectionAfterD;
      if (afterDId != null) {
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (currentSecId == afterDId) {
          final firstVisibleInAfterD = _questions.indexWhere(
            (q) => q.sectionId == afterDId && _isQuestionVisible(q),
          );
          if (firstVisibleInAfterD == _currentQuestionIndex) {
            final dId = _dSectionId;
            final dIdx = dId != null ? _questions.indexWhere((q) => q.sectionId == dId) : -1;
            setState(() {
              _dSectionPageIndex = 1;
              if (dIdx >= 0) _currentQuestionIndex = dIdx;
            });
            return;
          }
        }
      }
    } else if (_hasCroppingPatternSection) {
      final afterDId = _sectionAfterD;
      if (afterDId != null) {
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (currentSecId == afterDId) {
          final firstVisibleInAfterD = _questions.indexWhere(
            (q) => q.sectionId == afterDId && _isQuestionVisible(q),
          );
          if (firstVisibleInAfterD == _currentQuestionIndex) {
            setState(() => _isCroppingPatternMode = true);
            return;
          }
        }
      }
    }

    // ── At first question of section after E: go back into E mode ──────────
    if (_hasPestSection) {
      final afterId = _sectionAfterPest;
      if (afterId != null) {
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (currentSecId == afterId) {
          final firstVisibleInAfter = _questions.indexWhere(
            (q) => q.sectionId == afterId && _isQuestionVisible(q),
          );
          if (firstVisibleInAfter == _currentQuestionIndex) {
            setState(() => _isPestSectionMode = true);
            return;
          }
        }
      }
    }

    // ── At first question of section after K: go back into K mode ──────────
    if (_hasKSection) {
      final afterKId = _sectionAfterK;
      if (afterKId != null) {
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (currentSecId == afterKId) {
          final firstVisibleInAfterK = _questions.indexWhere(
            (q) => q.sectionId == afterKId && _isQuestionVisible(q),
          );
          if (firstVisibleInAfterK == _currentQuestionIndex) {
            setState(() => _isKSectionMode = true);
            return;
          }
        }
      }
      // Also: if we're somehow inside K questions, enter K mode
      final kId = _kSectionId;
      if (kId != null) {
        final currentSecId = _questions[_currentQuestionIndex].sectionId;
        if (currentSecId == kId) {
          setState(() => _isKSectionMode = true);
          return;
        }
      }
    }

    // ── Registered specialized screens: at first question after trigger ────
    // Generic: if the current question immediately follows a registered
    // specialized screen's trigger question, activate that screen on Prev.
    for (final entry in _specializedScreenRegistry) {
      final triggerIdx = _questions.indexWhere(
        (q) => q.id == entry.triggerQuestionId,
      );
      if (triggerIdx < 0) continue;
      // Find the first visible question after the trigger
      int firstAfterTrigger = -1;
      for (int j = triggerIdx + 1; j < _questions.length; j++) {
        if (_isQuestionVisible(_questions[j])) {
          firstAfterTrigger = j;
          break;
        }
      }
      if (firstAfterTrigger == _currentQuestionIndex) {
        entry.activate();
        return;
      }
    }

    int prev = _currentQuestionIndex - 1;
    while (prev >= 0 && !_isQuestionVisible(_questions[prev])) {
      prev--;
    }
    if (prev >= 0) {
      final aId = _aSectionId;
      if (aId != null && _questions[prev].sectionId == aId) {
        final firstAIdx = _questions.indexWhere((q) => q.sectionId == aId);
        setState(() => _currentQuestionIndex = firstAIdx >= 0 ? firstAIdx : prev);
        return;
      }
      setState(() => _currentQuestionIndex = prev);
    }
  }

  void _goToQuestion(int index) {
    setState(() {
      _currentQuestionIndex = index;
      _isReviewMode = false;
      _isPestSectionMode = false;
      _isFSectionMode = false;
      _isLSectionMode = false;
      _isOSectionMode = false;
      _isPSectionMode = false;
      _isRSectionMode = false;
      _isSSectionMode = false;
      _isTSectionMode = false;
      _isAssetMatrixMode = false;
      _isLivestockSectionMode = false;
      _isCroppingPatternMode = false;
      // If navigating to a K question, enter K mode
      if (_hasKSection) {
        final kId = _kSectionId;
        if (kId != null && _questions[index].sectionId == kId) {
          _isKSectionMode = true;
        } else {
          _isKSectionMode = false;
        }
      } else {
        _isKSectionMode = false;
      }
      // If navigating to an L question, enter L mode
      if (_hasLSection) {
        final lId = _lSectionId;
        if (lId != null && _questions[index].sectionId == lId) {
          _isLSectionMode = true;
        }
      }
    });
  }

  Future<void> _submitSurvey() async {
    final unanswered = _questions.where((q) {
      // Hidden conditional questions must not count as unanswered required questions
      if (!_isQuestionVisible(q)) return false;
      if (!q.isRequired) return false;
      final ans = _answers[q.id];
      if (ans == null) return true;
      if (ans is String) return ans.isEmpty;
      if (ans is List) return (ans).isEmpty;
      // Map format used by multipleChoice questions with an "Other" option
      if (ans is Map && ans.containsKey('selections')) {
        final selections = (ans['selections'] as List?) ?? [];
        if (selections.isEmpty) return true;
        // If "Other" is selected, specifyText must also be non-empty
        final otherSelected = selections.any(
          (s) => (s as String).trim().toLowerCase().startsWith('other'),
        );
        if (otherSelected) {
          final specifyText = (ans['specifyText'] as String?) ?? '';
          return specifyText.trim().isEmpty;
        }
        return false;
      }
      return false;
    }).toList();

    if (unanswered.isNotEmpty) {
      Fluttertoast.showToast(
        msg: '${unanswered.length} required question(s) still need answers',
        backgroundColor: AppTheme.error,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final client = SupabaseService.instance.client;
      final uid = SupabaseService.instance.currentUser?.id;
      if (uid == null) throw Exception('Not authenticated');

      // Determine the target status
      final targetStatus = 'submitted';

      if (_currentSurveyId != null) {
        // Update existing survey
        await client
            .from('surveys')
            .update({
              'status': targetStatus,
              'responses': _answers,
              'submitted_at': DateTime.now().toIso8601String(),
              'last_survey_date': DateTime.now().toIso8601String().substring(
                0,
                10,
              ),
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', _currentSurveyId!);
      } else {
        // Create new survey and submit immediately
        final inserted = await client
            .from('surveys')
            .insert({
              'household_id': widget.householdId,
              'agent_id': uid,
              'status': targetStatus,
              'responses': _answers,
              'last_survey_date': DateTime.now().toIso8601String().substring(
                0,
                10,
              ),
            })
            .select('id')
            .single();
        _currentSurveyId = inserted['id'] as String?;
      }

      if (mounted) setState(() => _isSubmitting = false);

      if (!mounted) return;
      final msg = _isCorrectionMode
          ? 'Correction resubmitted for ${widget.householdName}'
          : 'Survey submitted for ${widget.householdName}';
      Fluttertoast.showToast(
        msg: msg,
        backgroundColor: AppTheme.success,
        textColor: Colors.white,
      );
      context.pop();
    } catch (e) {
      if (mounted) setState(() => _isSubmitting = false);
      Fluttertoast.showToast(
        msg: 'Failed to submit survey. Please try again.',
        backgroundColor: AppTheme.error,
        textColor: Colors.white,
      );
    }
  }

  void _saveDraft() {
    _performSaveDraft();
  }

  Future<void> _performSaveDraft() async {
    if (_isSavingDraft) return;
    setState(() => _isSavingDraft = true);

    final uid = SupabaseService.instance.currentUser?.id;
    if (uid == null) {
      if (mounted) setState(() => _isSavingDraft = false);
      Fluttertoast.showToast(
        msg: 'Not authenticated. Please sign in again.',
        backgroundColor: AppTheme.error,
        textColor: Colors.white,
      );
      return;
    }

    final isOnline = ConnectivityService.instance.isOnline;

    if (!isOnline) {
      // ── Offline path: save to local DB only ──────────────────────────────
      await _performLocalDraftSave(uid: uid, status: 'draft');
      return;
    }

    // ── Online path: save to Supabase, then mirror to local DB ───────────
    try {
      final client = SupabaseService.instance.client;

      // ── Flush all active specialized widgets to _answers before saving ───
      _respondentDetailsKey.currentState?.saveData();
      _householdProfileKey.currentState?.saveData();
      _householdAssetsKey.currentState?.saveData();
      _lSectionKey.currentState?.saveData();
      _assetMatrixKey.currentState?.saveData();
      _livestockSectionKey.currentState?.saveData();
      _croppingPatternKey.currentState?.saveData();
      _agriculturalInfoKey.currentState?.saveData();

      // ── DIAGNOSTIC LOGGING (temporary) ──────────────────────────────────
      final authUser = SupabaseService.instance.currentUser;
      String diagRole = 'UNKNOWN';
      try {
        final profileRow = await client
            .from('user_profiles')
            .select('role')
            .eq('id', authUser?.id ?? '')
            .maybeSingle();
        diagRole = profileRow?['role']?.toString() ?? 'NOT_FOUND';
      } catch (profileErr) {
        diagRole = 'ERROR: $profileErr';
      }
      debugPrint('══════════ SAVE DRAFT DIAGNOSTIC ══════════');
      debugPrint('auth.uid        = ${authUser?.id}');
      debugPrint('email           = ${authUser?.email}');
      debugPrint('role            = $diagRole');
      debugPrint('household_id    = ${widget.householdId}');
      debugPrint('agent_id        = $uid');
      debugPrint('currentSurveyId = $_currentSurveyId');
      debugPrint('════════════════════════════════════════════');
      // ── END DIAGNOSTIC LOGGING ───────────────────────────────────────────

      final hasValidSurveyId =
          _currentSurveyId != null && _currentSurveyId!.isNotEmpty;

      if (hasValidSurveyId) {
        try {
          await client
              .from('surveys')
              .update({
                'responses': _answers,
                'updated_at': DateTime.now().toIso8601String(),
              })
              .eq('id', _currentSurveyId!);
        } catch (updateErr) {
          debugPrint('SAVE DRAFT ERROR (UPDATE path): $updateErr');
          rethrow;
        }
      } else {
        final existingQuery = _isCorrectionMode
            ? client
                  .from('surveys')
                  .select('id')
                  .eq('household_id', widget.householdId)
                  .eq('agent_id', uid)
                  .eq('status', 'correction_required')
                  .maybeSingle()
            : client
                  .from('surveys')
                  .select('id')
                  .eq('household_id', widget.householdId)
                  .eq('agent_id', uid)
                  .eq('status', 'draft')
                  .maybeSingle();

        final existing = await existingQuery;

        if (existing != null) {
          final existingId = existing['id'] as String?;
          if (existingId != null && existingId.isNotEmpty) {
            _currentSurveyId = existingId;
            try {
              await client
                  .from('surveys')
                  .update({
                    'responses': _answers,
                    'updated_at': DateTime.now().toIso8601String(),
                  })
                  .eq('id', _currentSurveyId!);
            } catch (updateErr2) {
              debugPrint(
                'SAVE DRAFT ERROR (UPDATE existing path): $updateErr2',
              );
              rethrow;
            }
          } else {
            debugPrint(
              'SAVE DRAFT: existing row has invalid id, falling through to INSERT',
            );
            if (_isCorrectionMode) {
              throw Exception(
                'Correction survey record not found. Please reload the household list.',
              );
            }
            final inserted = await client
                .from('surveys')
                .insert({
                  'household_id': widget.householdId,
                  'agent_id': uid,
                  'status': 'draft',
                  'responses': _answers,
                  'last_survey_date': DateTime.now()
                      .toIso8601String()
                      .substring(0, 10),
                })
                .select('id')
                .single();
            final newId = inserted['id'] as String?;
            if (newId != null && newId.isNotEmpty) {
              _currentSurveyId = newId;
            }
          }
        } else {
          if (_isCorrectionMode) {
            throw Exception(
              'Correction survey record not found. Please reload the household list.',
            );
          }
          debugPrint(
            'SAVE DRAFT: Attempting INSERT with household_id=${widget.householdId}, agent_id=$uid',
          );
          try {
            final inserted = await client
                .from('surveys')
                .insert({
                  'household_id': widget.householdId,
                  'agent_id': uid,
                  'status': 'draft',
                  'responses': _answers,
                  'last_survey_date': DateTime.now()
                      .toIso8601String()
                      .substring(0, 10),
                })
                .select('id')
                .single();
            final newId = inserted['id'] as String?;
            if (newId != null && newId.isNotEmpty) {
              _currentSurveyId = newId;
              debugPrint(
                'SAVE DRAFT: New survey created with id=$_currentSurveyId',
              );
            }
          } catch (insertErr) {
            debugPrint('SAVE DRAFT ERROR (INSERT path): $insertErr');
            rethrow;
          }
        }
      }

      if (mounted) setState(() => _isSavingDraft = false);

      // ── Mirror to local DB (dual-write) ───────────────────────────────────
      if (_currentSurveyId != null && _currentSurveyId!.isNotEmpty) {
        _mirrorDraftToLocalDb(uid: uid, status: 'draft');
        _respondentDetailsKey.currentState?.saveData();
        _householdProfileKey.currentState?.saveData();
        _householdAssetsKey.currentState?.saveData();
        _lSectionKey.currentState?.saveData();
        _assetMatrixKey.currentState?.saveData();
        _livestockSectionKey.currentState?.saveData();
        _croppingPatternKey.currentState?.saveData();
        _agriculturalInfoKey.currentState?.saveData();
      }

      Fluttertoast.showToast(
        msg: 'Draft saved — you can resume later',
        backgroundColor: AppTheme.primary,
        textColor: Colors.white,
      );
    } catch (e) {
      debugPrint('SAVE DRAFT FINAL CATCH: $e — attempting local fallback');
      // Fix 5: Remote save failed — fall back to local persistence and queue sync.
      if (LocalDatabaseService.instance.isAvailable) {
        try {
          // Generate a stable offline UUID if we don't have one yet.
          if (_currentSurveyId == null || _currentSurveyId!.isEmpty) {
            _currentSurveyId = const Uuid().v4();
          }
          _respondentDetailsKey.currentState?.saveData();
          _householdProfileKey.currentState?.saveData();
          _householdAssetsKey.currentState?.saveData();
          _lSectionKey.currentState?.saveData();
          _assetMatrixKey.currentState?.saveData();
          _livestockSectionKey.currentState?.saveData();
          _croppingPatternKey.currentState?.saveData();
          _agriculturalInfoKey.currentState?.saveData();

          await _mirrorDraftToLocalDb(uid: uid, status: 'draft');
          if (mounted) setState(() => _isSavingDraft = false);
          Fluttertoast.showToast(
            msg: 'Server unavailable — draft saved locally and queued for sync',
            backgroundColor: AppTheme.warning,
            textColor: Colors.white,
          );
          return;
        } catch (localErr) {
          debugPrint('SAVE DRAFT LOCAL FALLBACK FAILED: $localErr');
        }
      }
      if (mounted) setState(() => _isSavingDraft = false);
      Fluttertoast.showToast(
        msg: 'Failed to save draft. Please try again.',
        backgroundColor: AppTheme.error,
        textColor: Colors.white,
      );
    }
  }

  /// Saves the draft to the local SQLite database only (offline path).
  Future<void> _performLocalDraftSave({
    required String uid,
    required String status,
  }) async {
    if (!LocalDatabaseService.instance.isAvailable) {
      if (mounted) setState(() => _isSavingDraft = false);
      Fluttertoast.showToast(
        msg: 'Offline: local storage unavailable. Cannot save draft.',
        backgroundColor: AppTheme.error,
        textColor: Colors.white,
      );
      return;
    }

    try {
      // Generate a stable survey ID if we don't have one yet.
      // We use a proper UUID v4 so the ID is valid for Supabase's
      // surveys.id UUID column when the sync queue drains.
      // The same UUID is reused on every subsequent save for this session,
      // ensuring specialized records always reference the correct survey.
      if (_currentSurveyId == null || _currentSurveyId!.isEmpty) {
        _currentSurveyId = const Uuid().v4();
      }

      _respondentDetailsKey.currentState?.saveData();
      _householdProfileKey.currentState?.saveData();
      _householdAssetsKey.currentState?.saveData();
      _lSectionKey.currentState?.saveData();
      await _assetMatrixKey.currentState?.saveData();
      _livestockSectionKey.currentState?.saveData();
      _croppingPatternKey.currentState?.saveData();
      _agriculturalInfoKey.currentState?.saveData();

      await _mirrorDraftToLocalDb(uid: uid, status: status);
      if (mounted) setState(() => _isSavingDraft = false);
      Fluttertoast.showToast(
        msg: 'Draft saved locally — will sync when online',
        backgroundColor: AppTheme.primary,
        textColor: Colors.white,
      );
    } catch (e) {
      debugPrint('_performLocalDraftSave error: $e');
      if (mounted) setState(() => _isSavingDraft = false);
      Fluttertoast.showToast(
        msg: 'Failed to save draft locally.',
        backgroundColor: AppTheme.error,
        textColor: Colors.white,
      );
    }
  }

  /// Writes the current _answers and survey metadata to local_surveys.
  /// Also enqueues a sync operation for the surveys table.
  /// Fire-and-forget — errors are logged but not surfaced to the user.

  Future<void> _mirrorDraftToLocalDb({
    required String uid,
    required String status,
  }) async {
    if (!LocalDatabaseService.instance.isAvailable) {
      throw Exception('Local database is unavailable.');
    }

    final surveyId = _currentSurveyId;
    if (surveyId == null || surveyId.isEmpty) {
      throw Exception('Survey ID is missing.');
    }

    final responsesJson = jsonEncode(_answers);

    await LocalDatabaseService.instance.upsertSurvey(
      surveyId: surveyId,
      householdId: widget.householdId,
      agentId: uid,
      status: status,
      responsesJson: responsesJson,
    );

    final operationId = 'survey_${surveyId}_draft';
    final latestPayload = jsonEncode({
      'id': surveyId,
      'household_id': widget.householdId,
      'agent_id': uid,
      'status': status,
      'responses': _answers,
      'updated_at': DateTime.now().toIso8601String(),
    });

    await LocalDatabaseService.instance.enqueueSyncOperation(
      operationId: operationId,
      targetTable: 'surveys',
      operationType: 'upsert',
      surveyId: surveyId,
      householdId: widget.householdId,
      recordId: surveyId,
      payloadJson: latestPayload,
    );

    await LocalDatabaseService.instance.updatePendingSyncPayload(
      operationId: operationId,
      payloadJson: latestPayload,
    );

    // Verify that the saved answers can be read back from SQLite.
    final savedRow = await LocalDatabaseService.instance.getSurvey(surveyId);

    if (savedRow == null || savedRow['responses_json'] != responsesJson) {
      throw Exception('Local draft verification failed.');
    }

    debugPrint('[LocalDB] Draft saved and verified (surveyId=$surveyId).');
  }

  /// Returns true if the question should be shown to the user.
  ///
  /// For B.1 virtual migration-reason questions, visibility is determined
  /// by the corresponding member's LIVING_STATUS answer being "No".
  ///
  /// For all other questions, the standard DB-driven conditional logic applies.
  bool _isQuestionVisible(SurveyQuestion q) {
    // B.1 migration reason: conditional on LIVING_STATUS = "No"
    if (q.id.startsWith('B1_M') && q.id.endsWith('_MIGRATION_REASON')) {
      final memberPrefix = q.id.replaceAll('_MIGRATION_REASON', '');
      final livingStatusAnswer = _answers['${memberPrefix}_LIVING_STATUS'];
      if (livingStatusAnswer == null) return false;
      return livingStatusAnswer.toString().trim().toLowerCase() == 'no';
    }

    final parentId = q.conditionalOnQuestionId;
    final requiredValue = q.conditionalOnValue;
    if (parentId == null || parentId.isEmpty) return true;
    if (requiredValue == null || requiredValue.isEmpty) return true;
    final parentAnswer = _answers[parentId];
    if (parentAnswer == null) return false;
    final parentStr = parentAnswer.toString().trim().toLowerCase();
    return parentStr == requiredValue.trim().toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final theme = Theme.of(context);

    // Show loading spinner while questions are being fetched from DB
    if (_isLoadingQuestions) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(theme),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Loading survey questions...',
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show error state if questions failed to load
    if (_questionLoadError != null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(theme),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: AppTheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _questionLoadError!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadQuestionsFromDb,
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(
                            'Retry',
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show loading spinner while existing answers are being fetched
    if (_isLoadingAnswers) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(theme),
              const Expanded(child: Center(child: CircularProgressIndicator())),
            ],
          ),
        ),
      );
    }

    // Guard: if questions loaded but list is empty, show informative message
    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              _buildAppBar(theme),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 48,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No active questions found in the survey template.\n'
                          'Please contact your administrator to activate questions.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Determine if current question is a B.1 virtual question and extract member info
    final currentQ =
        _questions.isNotEmpty && _currentQuestionIndex < _questions.length
        ? _questions[_currentQuestionIndex]
        : null;
    final isB1Question = currentQ?.sectionId == _kB1SectionId;
    String? b1MemberLabel;
    if (isB1Question && currentQ != null) {
      // Extract member number from question ID (e.g. B1_M3_AGE → "Member 3")
      final idParts = currentQ.id.split('_');
      if (idParts.length >= 2) {
        final memberPart = idParts[1]; // e.g. "M3"
        if (memberPart.startsWith('M')) {
          final memberNum = memberPart.substring(1);
          b1MemberLabel = 'B.1 Household Composition — Member $memberNum';
        }
      }
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(theme),
            if (!_isReviewMode)
              SurveyProgressHeaderWidget(
                currentSection: _currentSectionNumber,
                totalSections: _totalSections,
                sectionTitle: isB1Question && b1MemberLabel != null
                    ? b1MemberLabel
                    : _currentSectionTitle,
                answeredCount: _answeredCount.clamp(0, _logicalTotalQuestions),
                totalQuestions: _logicalTotalQuestions,
                progressPercent: _logicalTotalQuestions > 0
                    ? (_answeredCount / _logicalTotalQuestions).clamp(0.0, 1.0)
                    : 0.0,
                currentQuestionIndex:
                    (_isKSectionMode ||
                        _isLSectionMode ||
                        _isOSectionMode ||
                        _isPSectionMode ||
                        _isRSectionMode ||
                        _isSSectionMode ||
                        _isTSectionMode ||
                        _isXSectionMode ||
                        _isYSectionMode ||
                        _isZSectionMode ||
                        _isDSectionMode ||
                        _isCSectionMode ||
                        _isAssetMatrixMode ||
                        _isLivestockSectionMode)
                    ? _logicalDisplayIndex - 1
                    : _currentQuestionIndex,
                totalInSection:
                    (_isASectionMode ||
                        _isBSectionMode ||
                        _isCSectionMode ||
                        _isPestSectionMode ||
                        _isFSectionMode ||
                        _isKSectionMode ||
                        _isLSectionMode ||
                        _isOSectionMode ||
                        _isPSectionMode ||
                        _isRSectionMode ||
                        _isAssetMatrixMode ||
                        _isLivestockSectionMode)
                    ? 0
                    : _questions
                          .where((q) => q.sectionId == _currentSectionId)
                          .length,
              ),
            Expanded(
              child: _isReviewMode
                  ? SurveyReviewWidget(
                      questions: _questions,
                      answers: _answers,
                      onEditQuestion: _isReadOnly ? null : _goToQuestion,
                      isReadOnly: _isReadOnly,
                      orderedSections: _orderedSections,
                      respondentDetailsWidget: _hasASection
                          ? RespondentDetailsSectionWidget(
                              householdId: widget.householdId,
                              initialHouseholdName: widget.householdName,
                              initialAnswers: _answers,
                              currentAgentName: SupabaseService.instance.currentUser?.userMetadata?['full_name'] as String? ?? 'Field Agent',
                              isReadOnly: true,
                              onSave: (_) {},
                            )
                          : null,
                      householdProfileWidget: _hasBSection
                          ? HouseholdProfileSectionWidget(
                              householdId: widget.householdId,
                              initialAnswers: _answers,
                              isReadOnly: true,
                              onSave: (_) {},
                            )
                          : null,
                      householdAssetsWidget: _hasAssetMatrixSection || _hasCSection
                          ? HouseholdAssetsSectionWidget(
                              householdId: widget.householdId,
                              surveyId: _currentSurveyId,
                              initialAnswers: _answers,
                              isReadOnly: true,
                            )
                          : null,
                      agriculturalInfoWidget: _hasDSection || _hasCroppingPatternSection
                          ? AgriculturalInformationSectionWidget(
                              householdId: widget.householdId,
                              surveyId: _currentSurveyId ?? '',
                              initialAnswers: _answers,
                              isReadOnly: true,
                            )
                          : null,
                      pestWidget: _currentSurveyId != null
                          ? PestDiseaseSectionWidget(
                              householdId: widget.householdId,
                              surveyId: _currentSurveyId!,
                              isReadOnly: _isReadOnly,
                            )
                          : null,
                      livestockWidget: _currentSurveyId != null
                          ? LivestockPestDiseaseSectionWidget(
                              householdId: widget.householdId,
                              surveyId: _currentSurveyId!,
                              isReadOnly: _isReadOnly,
                            )
                          : null,
                      schemeMatrixWidget: _hasOSection
                          ? SchemeMatrixSectionWidget.reviewOnly(
                              answer: _answers[_kOSchemeMatrixKey],
                              o01Answer: _answers[_kO01QuestionId],
                              o01QuestionText: () {
                                try {
                                  return _questions
                                      .firstWhere(
                                        (q) => q.id == _kO01QuestionId,
                                      )
                                      .questionText;
                                } catch (_) {
                                  return 'Awareness of Govt. schemes:';
                                }
                              }(),
                              o01Options: () {
                                try {
                                  return _questions
                                          .firstWhere(
                                            (q) => q.id == _kO01QuestionId,
                                          )
                                          .options ??
                                      [
                                        'Fully aware',
                                        'Partially aware',
                                        'Not aware',
                                      ];
                                } catch (_) {
                                  return [
                                    'Fully aware',
                                    'Partially aware',
                                    'Not aware',
                                  ];
                                }
                              }(),
                              o02Answer: _answers[_kO02QuestionId],
                              o02QuestionText: () {
                                try {
                                  return _questions
                                      .firstWhere(
                                        (q) => q.id == _kO02QuestionId,
                                      )
                                      .questionText;
                                } catch (_) {
                                  return 'Have you availed any scheme?';
                                }
                              }(),
                            )
                          : null,
                      p2TrainingNeedsWidget: _hasPSection
                          ? P2TrainingNeedsSectionWidget(
                              answer: _answers[_kP2TrainingNeedsKey],
                              onAnswer: (_) {},
                              isReadOnly: true,
                            )
                          : null,
                      genderDecisionMakingWidget: _hasRSection
                          ? GenderDecisionMakingReviewWidget(
                              answer: _answers[_kRGenderDecisionMakingKey],
                            )
                          : null,
                      householdExpenditureWidget: _hasSSSection
                          ? HouseholdExpenditureReviewWidget(
                              answer: _answers[_kSHouseholdExpenditureKey],
                            )
                          : null,
                      genderWorkDistributionWidget: _hasTSection
                          ? GenderWorkDistributionReviewWidget(
                              answer: _answers[_kTGenderWorkDistributionKey],
                            )
                          : null,
                      borderSpecificConstraintsWidget: _hasXSection
                          ? BorderSpecificConstraintsReviewWidget(
                              answer: _answers[_kXBorderSpecificConstraintsKey],
                            )
                          : null,
                      householdPriorityNeedsWidget: _hasYSection
                          ? HouseholdPriorityNeedsReviewWidget(
                              answer: _answers[_kYHouseholdPriorityNeedsKey],
                            )
                          : null,
                      enumeratorObservationWidget: _hasZSection
                          ? EnumeratorObservationReviewWidget(
                              answer: _answers[_kZEnumeratorObservationKey],
                            )
                          : null,
                    )
                  : _isPestSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: _currentSurveyId != null
                          ? PestDiseaseSectionWidget(
                              householdId: widget.householdId,
                              surveyId: _currentSurveyId!,
                              isReadOnly: _isReadOnly,
                            )
                          : const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Text(
                                  'Please save a draft first to record pest/disease data.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    )
                  : _isFSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: _currentSurveyId != null
                          ? LivestockPestDiseaseSectionWidget(
                              householdId: widget.householdId,
                              surveyId: _currentSurveyId!,
                              isReadOnly: _isReadOnly,
                            )
                          : const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Text(
                                  'Please save a draft first to record livestock data.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    )
                  : _isKSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: _buildKSectionWidget(theme),
                    )
                  : _isLSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: _currentSurveyId != null
                          ? EmploymentSeasonalitySectionWidget(
                              key: _lSectionKey,
                              householdId: widget.householdId,
                              surveyId: _currentSurveyId!,
                              isReadOnly: _isReadOnly,
                            )
                          : const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Text(
                                  'Please save a draft first to record employment seasonality data.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    )
                  : _isOSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: SchemeMatrixSectionWidget(
                        // O-01
                        o01Answer: _answers[_kO01QuestionId],
                        o01QuestionText: () {
                          try {
                            return _questions
                                .firstWhere((q) => q.id == _kO01QuestionId)
                                .questionText;
                          } catch (_) {
                            return 'Awareness of Govt. schemes:';
                          }
                        }(),
                        o01Options: () {
                          try {
                            return _questions
                                    .firstWhere((q) => q.id == _kO01QuestionId)
                                    .options ??
                                ['Fully aware', 'Partially aware', 'Not aware'];
                          } catch (_) {
                            return [
                              'Fully aware',
                              'Partially aware',
                              'Not aware',
                            ];
                          }
                        }(),
                        onO01Answer: _isReadOnly
                            ? (_) {}
                            : (value) => _onAnswer(_kO01QuestionId, value),
                        // O-02
                        o02Answer: _answers[_kO02QuestionId],
                        o02QuestionText: () {
                          try {
                            return _questions
                                .firstWhere((q) => q.id == _kO02QuestionId)
                                .questionText;
                          } catch (_) {
                            return 'Have you availed any scheme?';
                          }
                        }(),
                        onO02Answer: _isReadOnly
                            ? (_) {}
                            : (value) => _onAnswer(_kO02QuestionId, value),
                        // Matrix
                        answer: _answers[_kOSchemeMatrixKey],
                        onMatrixAnswer: _isReadOnly
                            ? (_) {}
                            : (value) => _onAnswer(_kOSchemeMatrixKey, value),
                        isReadOnly: _isReadOnly,
                      ),
                    )
                  : _isPSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: P2TrainingNeedsSectionWidget(
                        answer: _answers[_kP2TrainingNeedsKey],
                        onAnswer: _isReadOnly
                            ? (_) {}
                            : (value) => _onAnswer(_kP2TrainingNeedsKey, value),
                        isReadOnly: _isReadOnly,
                      ),
                    )
                  : _isRSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: GenderDecisionMakingSectionWidget(
                        answer: _answers[_kRGenderDecisionMakingKey],
                        onAnswer: _isReadOnly
                            ? (_) {}
                            : (value) =>
                                  _onAnswer(_kRGenderDecisionMakingKey, value),
                        isReadOnly: _isReadOnly,
                      ),
                    )
                  : _isSSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: HouseholdExpenditureSectionWidget(
                        answer: _answers[_kSHouseholdExpenditureKey],
                        onAnswer: _isReadOnly
                            ? (_) {}
                            : (value) =>
                                  _onAnswer(_kSHouseholdExpenditureKey, value),
                        isReadOnly: _isReadOnly,
                      ),
                    )
                  : _isTSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: GenderWorkDistributionSectionWidget(
                        answer: _answers[_kTGenderWorkDistributionKey],
                        onAnswer: _isReadOnly
                            ? (_) {}
                            : (value) => _onAnswer(
                                _kTGenderWorkDistributionKey,
                                value,
                              ),
                        isReadOnly: _isReadOnly,
                      ),
                    )
                  : _isXSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: BorderSpecificConstraintsSectionWidget(
                        answer: _answers[_kXBorderSpecificConstraintsKey],
                        onAnswer: _isReadOnly
                            ? (_) {}
                            : (value) => _onAnswer(
                                _kXBorderSpecificConstraintsKey,
                                value,
                              ),
                        isReadOnly: _isReadOnly,
                      ),
                    )
                  : _isYSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: HouseholdPriorityNeedsSectionWidget(
                        answer: _answers[_kYHouseholdPriorityNeedsKey],
                        onAnswer: _isReadOnly
                            ? (_) {}
                            : (value) => _onAnswer(
                                _kYHouseholdPriorityNeedsKey,
                                value,
                              ),
                        isReadOnly: _isReadOnly,
                      ),
                    )
                  : _isZSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: EnumeratorObservationSectionWidget(
                        answer: _answers[_kZEnumeratorObservationKey],
                        onAnswer: _isReadOnly
                            ? (_) {}
                            : (value) =>
                                  _onAnswer(_kZEnumeratorObservationKey, value),
                        isReadOnly: _isReadOnly,
                      ),
                    )
                  : _isDSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: AgriculturalInformationSectionWidget(
                        key: _agriculturalInfoKey,
                        householdId: widget.householdId,
                        surveyId: _currentSurveyId ?? '',
                        initialAnswers: _answers,
                        isReadOnly: _isReadOnly,
                        onDataChanged: (updated) {
                          setState(() {
                            _answers.addAll(updated);
                          });
                        },
                      ),
                    )
                  : _isCSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: HouseholdAssetsSectionWidget(
                        key: _householdAssetsKey,
                        householdId: widget.householdId,
                        surveyId: _currentSurveyId,
                        initialAnswers: _answers,
                        isReadOnly: _isReadOnly,
                        initialPage: _cSectionPageIndex,
                        onDataChanged: (updated) {
                          setState(() {
                            _answers.addAll(updated);
                          });
                        },
                      ),
                    )
                  : _isAssetMatrixMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: _currentSurveyId != null
                          ? AssetMatrixSectionWidget(
                              key: _assetMatrixKey,
                              householdId: widget.householdId,
                              surveyId: _currentSurveyId!,
                              isReadOnly: _isReadOnly,
                            )
                          : const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Text(
                                  'Please save a draft first to record asset data.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    )
                  : _isLivestockSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: _currentSurveyId != null
                          ? LivestockSectionWidget(
                              key: _livestockSectionKey,
                              householdId: widget.householdId,
                              surveyId: _currentSurveyId!,
                              isReadOnly: _isReadOnly,
                            )
                          : const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Text(
                                  'Please save a draft first to record livestock data.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    )
                  : _isCroppingPatternMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: _currentSurveyId != null
                          ? CroppingPatternSectionWidget(
                              key: _croppingPatternKey,
                              householdId: widget.householdId,
                              surveyId: _currentSurveyId!,
                              isReadOnly: _isReadOnly,
                            )
                          : const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Text(
                                  'Please save a draft first to record cropping pattern data.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    )
                  : _isASectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: RespondentDetailsSectionWidget(
                        key: _respondentDetailsKey,
                        householdId: widget.householdId,
                        initialHouseholdName: widget.householdName,
                        initialAnswers: _answers,
                        currentAgentName: SupabaseService
                                .instance.currentUser?.userMetadata?['full_name']
                                as String? ??
                            'Field Agent',
                        isReadOnly: _isReadOnly,
                        onSave: (map) {
                          setState(() {
                            _answers.addAll(map);
                          });
                        },
                      ),
                    )
                  : _isBSectionMode
                  ? SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child: HouseholdProfileSectionWidget(
                        key: _householdProfileKey,
                        householdId: widget.householdId,
                        initialAnswers: _answers,
                        isReadOnly: _isReadOnly,
                        onSave: (map) {
                          setState(() {
                            _answers.addAll(map);
                          });
                        },
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 16,
                        vertical: 16,
                      ),
                      child:
                          _questions[_currentQuestionIndex].id ==
                              _kI07QuestionId
                          ? _buildI07Card(isTablet)
                          : QuestionCardWidget(
                              question: _questions[_currentQuestionIndex],
                              answer:
                                  _answers[_questions[_currentQuestionIndex]
                                      .id],
                              onAnswer: _isReadOnly
                                  ? (_) {} // no-op in read-only mode
                                  : (value) => _onAnswer(
                                      _questions[_currentQuestionIndex].id,
                                      value,
                                    ),
                            ),
                    ),
            ),
            if (!_isReadOnly)
              SurveyNavBarWidget(
                currentIndex: _logicalDisplayIndex - 1,
                totalQuestions: _logicalTotalQuestions,
                isReviewMode: _isReviewMode,
                isSubmitting: _isSubmitting,
                canGoNext:
                    _canGoNext ||
                    _isASectionMode ||
                    _isBSectionMode ||
                    _isReviewMode ||
                    _isPestSectionMode ||
                    _isFSectionMode ||
                    _isKSectionMode ||
                    _isLSectionMode ||
                    _isOSectionMode ||
                    _isPSectionMode ||
                    _isRSectionMode ||
                    _isSSectionMode ||
                    _isTSectionMode ||
                    _isXSectionMode ||
                    _isYSectionMode ||
                    _isZSectionMode ||
                    _isDSectionMode ||
                    _isCSectionMode ||
                    _isAssetMatrixMode ||
                    _isLivestockSectionMode ||
                    _isCroppingPatternMode,
                onPrev:
                    _logicalDisplayIndex > 1 ||
                        _isReviewMode ||
                        _isBSectionMode ||
                        _isPestSectionMode ||
                        _isFSectionMode ||
                        _isKSectionMode ||
                        _isLSectionMode ||
                        _isOSectionMode ||
                        _isPSectionMode ||
                        _isRSectionMode ||
                        _isSSectionMode ||
                        _isTSectionMode ||
                        _isXSectionMode ||
                        _isYSectionMode ||
                        _isZSectionMode ||
                        _isDSectionMode ||
                        _isCSectionMode ||
                        _isAssetMatrixMode ||
                        _isLivestockSectionMode ||
                        _isCroppingPatternMode
                    ? _goPrev
                    : null,
                onNext: _isReviewMode ? null : _goNext,
                onReview: () {
                  if (_isReviewMode) return null;
                  // In Section C mode, show Review only if no section after C
                  if (_isCSectionMode) {
                    final afterCId = _sectionAfterAssetMatrix;
                    if (afterCId == null) {
                      return () => setState(() {
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  // In Asset Matrix mode, show Review only if no section after C
                  if (_isAssetMatrixMode) {
                    final afterCId = _sectionAfterAssetMatrix;
                    if (afterCId == null) {
                      return () => setState(() {
                        _isAssetMatrixMode = false;
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  // In C-10 Livestock mode, show Review only if no section after C
                  if (_isLivestockSectionMode) {
                    final afterCId = _sectionAfterAssetMatrix;
                    if (afterCId == null) {
                      return () => setState(() {
                        _isLivestockSectionMode = false;
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  // In Q9 Cropping Pattern mode, show Review only if no section after D
                  // and no E/F/L/K sections
                  if (_isCroppingPatternMode) {
                    final afterDId = _sectionAfterD;
                    if (afterDId == null &&
                        !_hasPestSection &&
                        !_hasFSection &&
                        !_hasLSection) {
                      return () => setState(() {
                        _isCroppingPatternMode = false;
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  // In L section mode, show Review only if no section after L
                  if (_isLSectionMode) {
                    final afterLId = _sectionAfterL;
                    if (afterLId == null) {
                      return () => setState(() {
                        _isLSectionMode = false;
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  // In O section mode, show Review only if no section after O
                  if (_isOSectionMode) {
                    final afterOId = _sectionAfterO;
                    if (afterOId == null) {
                      return () => setState(() {
                        _isOSectionMode = false;
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  // In P section mode, show Review only if no section after P
                  if (_isPSectionMode) {
                    final afterPId = _sectionAfterP;
                    if (afterPId == null) {
                      return () => setState(() {
                        _isPSectionMode = false;
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  // In R section mode, show Review only if no section after R
                  if (_isRSectionMode) {
                    final afterRId = _sectionAfterR;
                    if (afterRId == null) {
                      return () => setState(() {
                        _isRSectionMode = false;
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  // In S section mode, show Review only if no section after S
                  if (_isSSectionMode) {
                    final afterSId = _sectionAfterS;
                    if (afterSId == null) {
                      return () => setState(() {
                        _isSSectionMode = false;
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  // In T section mode, show Review only if no section after T
                  if (_isTSectionMode) {
                    final afterTId = _sectionAfterT;
                    if (afterTId == null) {
                      return () => setState(() {
                        _isTSectionMode = false;
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  // In X section mode, show Review only if no section after X
                  if (_isXSectionMode) {
                    final afterXId = _sectionAfterX;
                    if (afterXId == null) {
                      return () => setState(() {
                        _isXSectionMode = false;
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  // In Y section mode, show Review only if no section after Y
                  if (_isYSectionMode) {
                    final afterYId = _sectionAfterY;
                    if (afterYId == null) {
                      return () => setState(() {
                        _isYSectionMode = false;
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  // In Z section mode, show Review only if no section after Z
                  if (_isZSectionMode) {
                    final afterZId = _sectionAfterZ;
                    if (afterZId == null) {
                      return () => setState(() {
                        _isZSectionMode = false;
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  // In K section mode, show Review only if no section after K and no E/F/L
                  if (_isKSectionMode) {
                    final afterKId = _sectionAfterK;
                    if (afterKId == null &&
                        !_hasPestSection &&
                        !_hasFSection &&
                        !_hasLSection) {
                      return () => setState(() {
                        _isKSectionMode = false;
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  // In F section mode, show Review only if no section after F and no L
                  if (_isFSectionMode) {
                    final afterFId = _sectionAfterF;
                    if (afterFId == null && !_hasLSection) {
                      return () => setState(() {
                        _isFSectionMode = false;
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  // In pest section mode, show Review only if no section after E and no F/L
                  if (_isPestSectionMode) {
                    final afterId = _sectionAfterPest;
                    if (afterId == null && !_hasFSection && !_hasLSection) {
                      return () => setState(() {
                        _isPestSectionMode = false;
                        _isReviewMode = true;
                      });
                    }
                    return null;
                  }
                  int next = _currentQuestionIndex + 1;
                  while (next < _questions.length &&
                      !_isQuestionVisible(_questions[next])) {
                    next++;
                  }
                  final isLastVisible = next >= _questions.length;
                  if (!isLastVisible) return null;
                  if (_hasPestSection) return null;
                  if (_hasFSection) return null;
                  if (_hasLSection) return null;
                  if (_hasKSection) {
                    // If K is the last section, we'll enter K mode on next, not review
                    final kId = _kSectionId;
                    if (kId != null) {
                      final currentSecId =
                          _questions[_currentQuestionIndex].sectionId;
                      if (currentSecId != kId) return null;
                    }
                  }
                  return () => setState(() => _isReviewMode = true);
                }(),
                onSubmit: _isReviewMode ? _submitSurvey : null,
                onSaveDraft: _saveDraft,
              )
            else
              // Read-only bottom bar: just a close/back button
              Container(
                color: theme.colorScheme.surface,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    label: Text(
                      'Back to Households',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      side: const BorderSide(color: AppTheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds the I-07 ITK table card, styled like a QuestionCardWidget.
  Widget _buildI07Card(bool isTablet) {
    final theme = Theme.of(context);
    final q = _questions[_currentQuestionIndex];
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.table_chart_rounded,
                      size: 12,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Table',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Optional',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            q.questionText,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          ItkTableWidget(
            answer: _answers[q.id],
            onAnswer: _isReadOnly ? (_) {} : (value) => _onAnswer(q.id, value),
            isReadOnly: _isReadOnly,
          ),
        ],
      ),
    );
  }

  /// Builds the Section K grouped income distribution screen.
  /// Displays all active numeric questions for Section K on one screen,
  /// with a dynamically calculated read-only total at the bottom.
  Widget _buildKSectionWidget(ThemeData theme) {
    final kQuestions = _kNumericQuestions;

    // Calculate total from current answers
    double total = 0;
    for (final q in kQuestions) {
      final ans = _answers[q.id];
      if (ans != null) {
        final str = ans.toString().trim();
        if (str.isNotEmpty) {
          total += double.tryParse(str) ?? 0;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Household Income Distribution',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Enter annual income (in Rs.) for each source below.',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: AppTheme.primary.withAlpha(179),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Income source rows
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline.withAlpha(51)),
          ),
          child: Column(
            children: [
              for (int i = 0; i < kQuestions.length; i++) ...[
                _buildKIncomeRow(theme, kQuestions[i], i, kQuestions.length),
                if (i < kQuestions.length - 1)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: theme.colorScheme.outline.withAlpha(26),
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Total Annual Household Income (read-only, calculated)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.success.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.success.withAlpha(77),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Annual Household Income (Rs.)',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.success,
                      ),
                    ),
                    Text(
                      'Auto-calculated from all income sources above',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AppTheme.success.withAlpha(179),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.success.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.success.withAlpha(77)),
                ),
                child: Text(
                  _formatCurrency(total),
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.success,
                    fontFeatures: [const FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  /// Builds a single income source row with label and numeric input.
  Widget _buildKIncomeRow(
    ThemeData theme,
    SurveyQuestion question,
    int index,
    int total,
  ) {
    final currentValue = _answers[question.id]?.toString() ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Row number badge
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Income source label
          Expanded(
            flex: 3,
            child: Text(
              question.questionText,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Numeric input field
          Expanded(
            flex: 2,
            child: _isReadOnly
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.outline.withAlpha(51),
                      ),
                    ),
                    child: Text(
                      currentValue.isEmpty ? '—' : currentValue,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: currentValue.isEmpty
                            ? theme.colorScheme.onSurfaceVariant
                            : theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  )
                : _KIncomeInputField(
                    questionId: question.id,
                    initialValue: currentValue,
                    hint: question.hint ?? 'Rs.',
                    onChanged: (value) {
                      _onAnswer(question.id, value);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// Formats a number as Indian currency string (e.g. 11000 → "11,000").
  String _formatCurrency(double value) {
    if (value == 0) return '0';
    // Format with commas for Indian numbering
    final intVal = value.truncate();
    final fracVal = value - intVal;
    String result = intVal.toString();
    // Insert commas: last 3 digits, then groups of 2
    if (result.length > 3) {
      final last3 = result.substring(result.length - 3);
      String rest = result.substring(0, result.length - 3);
      final parts = <String>[];
      while (rest.length > 2) {
        parts.insert(0, rest.substring(rest.length - 2));
        rest = rest.substring(0, rest.length - 2);
      }
      if (rest.isNotEmpty) parts.insert(0, rest);
      result = '${parts.join(',')},$last3';
    }
    if (fracVal > 0) {
      result += '.${(fracVal * 100).round().toString().padLeft(2, '0')}';
    }
    return result;
  }

  Widget _buildAppBar(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              if (!_isReadOnly) _saveDraft();
              context.pop();
            },
            color: theme.colorScheme.onSurface,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.householdName,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'ID: ${widget.householdId} · $_modeLabel',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!_isReadOnly)
            TextButton.icon(
              onPressed: _saveDraft,
              icon: const Icon(Icons.save_outlined, size: 16),
              label: Text(
                'Save Draft',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
            )
          else if (!widget.isHouseholdView)
            // Show a status chip for read-only modes (Field Agent only)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _isReadOnly && widget.surveyMode == 'view'
                    ? AppTheme.statusApproved.withAlpha(26)
                    : AppTheme.statusSubmitted.withAlpha(26),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isReadOnly && widget.surveyMode == 'view'
                      ? AppTheme.statusApproved.withAlpha(102)
                      : AppTheme.statusSubmitted.withAlpha(102),
                ),
              ),
              child: Text(
                widget.surveyMode == 'view' ? 'Approved' : 'Awaiting Review',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: widget.surveyMode == 'view'
                      ? AppTheme.statusApproved
                      : AppTheme.statusSubmitted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Stateful input field for Section K income rows.
/// Uses its own TextEditingController to avoid rebuilding issues.
class _KIncomeInputField extends StatefulWidget {
  final String questionId;
  final String initialValue;
  final String hint;
  final ValueChanged<String> onChanged;

  const _KIncomeInputField({
    required this.questionId,
    required this.initialValue,
    required this.hint,
    required this.onChanged,
  });

  @override
  State<_KIncomeInputField> createState() => _KIncomeInputFieldState();
}

class _KIncomeInputFieldState extends State<_KIncomeInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_KIncomeInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller if external value changed (e.g. loaded from DB)
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.right,
      style: GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: GoogleFonts.manrope(
          fontSize: 12,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withAlpha(102),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withAlpha(77),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerLowest,
      ),
      onChanged: widget.onChanged,
    );
  }
}

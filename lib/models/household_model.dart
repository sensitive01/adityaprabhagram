enum SurveyStatus {
  noSurvey,
  draft,
  submitted,
  underReview,
  correctionRequired,
  approved,
}

extension SurveyStatusExt on SurveyStatus {
  String get label {
    switch (this) {
      case SurveyStatus.noSurvey:
        return 'Start Survey';
      case SurveyStatus.draft:
        return 'Draft';
      case SurveyStatus.submitted:
        return 'Submitted';
      case SurveyStatus.underReview:
        return 'Under Review';
      case SurveyStatus.correctionRequired:
        return 'Correction Required';
      case SurveyStatus.approved:
        return 'Approved';
    }
  }

  static SurveyStatus fromString(String v) {
    switch (v) {
      case 'draft':
        return SurveyStatus.draft;
      case 'submitted':
        return SurveyStatus.submitted;
      case 'under_review':
        return SurveyStatus.underReview;
      case 'correction_required':
        return SurveyStatus.correctionRequired;
      case 'approved':
        return SurveyStatus.approved;
      default:
        return SurveyStatus.noSurvey;
    }
  }
}

class HouseholdModel {
  final String id;
  final String name;
  final String headName;
  final String village;
  final String cluster;
  final String district;
  final SurveyStatus surveyStatus;
  final String lastSurveyDate;
  final int membersCount;
  final double lat;
  final double lng;
  final String? rejectionReason;
  final String avatarUrl;
  final String avatarSemanticLabel;
  final String? surveyId;

  /// True when this entry was loaded from local offline storage (not Supabase).
  final bool isLocalDraft;

  HouseholdModel({
    required this.id,
    required this.name,
    required this.headName,
    required this.village,
    required this.cluster,
    required this.district,
    required this.surveyStatus,
    required this.lastSurveyDate,
    required this.membersCount,
    required this.lat,
    required this.lng,
    this.rejectionReason,
    required this.avatarUrl,
    required this.avatarSemanticLabel,
    this.surveyId,
    this.isLocalDraft = false,
  });

  HouseholdModel copyWith({
    String? id,
    String? name,
    String? headName,
    String? village,
    String? cluster,
    String? district,
    SurveyStatus? surveyStatus,
    String? lastSurveyDate,
    int? membersCount,
    double? lat,
    double? lng,
    String? rejectionReason,
    String? avatarUrl,
    String? avatarSemanticLabel,
    String? surveyId,
    bool? isLocalDraft,
  }) {
    return HouseholdModel(
      id: id ?? this.id,
      name: name ?? this.name,
      headName: headName ?? this.headName,
      village: village ?? this.village,
      cluster: cluster ?? this.cluster,
      district: district ?? this.district,
      surveyStatus: surveyStatus ?? this.surveyStatus,
      lastSurveyDate: lastSurveyDate ?? this.lastSurveyDate,
      membersCount: membersCount ?? this.membersCount,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarSemanticLabel: avatarSemanticLabel ?? this.avatarSemanticLabel,
      surveyId: surveyId ?? this.surveyId,
      isLocalDraft: isLocalDraft ?? this.isLocalDraft,
    );
  }

  factory HouseholdModel.fromSupabase(Map<String, dynamic> map) {
    final survey = map['survey'] as Map<String, dynamic>?;
    final statusStr = survey?['status'] as String? ?? 'no_survey';
    return HouseholdModel(
      id: map['id'] as String,
      name: map['name'] as String,
      headName: map['head_name'] as String,
      village: map['village'] as String? ?? '',
      cluster: map['cluster'] as String? ?? 'Cluster A',
      district: map['district'] as String? ?? '',
      surveyStatus: SurveyStatusExt.fromString(statusStr),
      lastSurveyDate: survey?['last_survey_date'] as String? ?? 'Not started',
      membersCount:
          map['family_size'] as int? ?? map['members_count'] as int? ?? 1,
      lat: (map['lat'] as num?)?.toDouble() ?? 0,
      lng: (map['lng'] as num?)?.toDouble() ?? 0,
      rejectionReason: survey?['rejection_reason'] as String?,
      avatarUrl: map['avatar_url'] as String? ?? '',
      avatarSemanticLabel:
          map['avatar_semantic_label'] as String? ?? 'Household photo',
      surveyId: survey?['id'] as String?,
    );
  }

  factory HouseholdModel.fromLocalDraft({
    required String householdId,
    required String surveyId,
    required String updatedAt,
  }) {
    return HouseholdModel(
      id: householdId,
      name: 'Household $householdId',
      headName: '',
      village: '',
      cluster: 'Local Drafts',
      district: '',
      surveyStatus: SurveyStatus.draft,
      lastSurveyDate: updatedAt.length >= 10
          ? updatedAt.substring(0, 10)
          : updatedAt,
      membersCount: 0,
      lat: 0,
      lng: 0,
      avatarUrl: '',
      avatarSemanticLabel: 'Offline draft household',
      surveyId: surveyId,
      isLocalDraft: true,
    );
  }
}

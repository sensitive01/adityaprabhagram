import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../services/local_database_service.dart';
import '../../services/connectivity_service.dart';
import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_skeleton_widget.dart';
import './widgets/greeting_app_bar_widget.dart';
import './widgets/hero_banner_card_widget.dart';
import './widgets/household_card_widget.dart';
import './widgets/section_header_widget.dart';

// --- DATA MODELS ---

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
        // 'no_survey' or any unrecognised value → no survey exists yet
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

  /// Creates a HouseholdModel from a local offline draft row.
  /// Used when Supabase is unavailable or when a local draft has no
  /// corresponding Supabase entry yet.
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

// --- SCREEN ---

class AssignedHouseholdsScreen extends StatefulWidget {
  const AssignedHouseholdsScreen({super.key});

  @override
  State<AssignedHouseholdsScreen> createState() =>
      _AssignedHouseholdsScreenState();
}

class _AssignedHouseholdsScreenState extends State<AssignedHouseholdsScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<HouseholdModel> _allHouseholds = [];
  List<HouseholdModel> _filteredHouseholds = [];
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Agent profile info
  String _agentName = 'Field Agent';
  String _agentAvatarUrl = '';

  final List<String> _filters = [
    'All',
    'Start Survey',
    'Draft',
    'Submitted',
    'Under Review',
    'Correction Required',
    'Approved',
  ];

  @override
  void initState() {
    super.initState();
    _checkRoleAndLoad();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Guard: if the current user is not a FIELD_AGENT, redirect them.
  Future<void> _checkRoleAndLoad() async {
    final role = await SupabaseService.instance.fetchCurrentUserRole();
    if (!mounted) return;

    if (role == null) {
      // Not authenticated
      context.go(AppRoutes.signUpLoginScreen);
      return;
    }

    if (role == 'HOUSEHOLD') {
      // HOUSEHOLD users must not access this screen
      context.go(AppRoutes.householdDashboardScreen);
      return;
    }

    // Load agent profile
    final profile = await SupabaseService.instance.fetchCurrentUserProfile();
    if (mounted && profile != null) {
      setState(() {
        _agentName = profile['full_name'] as String? ?? 'Field Agent';
        _agentAvatarUrl = profile['avatar_url'] as String? ?? '';
      });
    }

    await _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final isOnline = ConnectivityService.instance.isOnline;
      List<HouseholdModel> households = [];

      if (isOnline) {
        final rawList = await SupabaseService.instance.fetchAgentHouseholds();
        households = rawList.map(HouseholdModel.fromSupabase).toList();

        // Fix 4: Merge local drafts that have no corresponding Supabase entry.
        // This handles the case where a draft was created offline and hasn't
        // synced yet — the household may appear as 'noSurvey' in Supabase.
        await _mergeLocalDrafts(households);
      } else {
        // Fully offline: try to load from local DB
        await _loadLocalDraftsOnly(households);
      }

      if (mounted) {
        setState(() {
          _allHouseholds = households;
          _filteredHouseholds = households;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Supabase failed — try local drafts as fallback
      final localHouseholds = <HouseholdModel>[];
      try {
        await _loadLocalDraftsOnly(localHouseholds);
      } catch (_) {}

      if (mounted) {
        setState(() {
          _allHouseholds = localHouseholds;
          _filteredHouseholds = localHouseholds;
          _errorMessage = localHouseholds.isEmpty
              ? 'Failed to load households. Pull down to retry.'
              : null;
          _isLoading = false;
        });
      }
    }
  }

  /// Merges local offline drafts into the already-loaded Supabase household list.
  /// Only adds a local draft entry if the household has no existing draft/submitted
  /// survey in Supabase (i.e. the local draft is the only record).
  Future<void> _mergeLocalDrafts(List<HouseholdModel> households) async {
    if (!LocalDatabaseService.instance.isAvailable) return;
    final uid = SupabaseService.instance.currentUser?.id;
    if (uid == null) return;

    try {
      // Collect all household IDs that already have a Supabase survey entry
      final supabaseHouseholdIds = households
          .where((h) => h.surveyId != null)
          .map((h) => h.id)
          .toSet();

      // Query all local draft surveys for this agent
      // We can't enumerate all households offline (no local households table),
      // so we iterate known household IDs from the Supabase list to find local drafts.
      for (final household in households) {
        if (household.surveyId != null) {
          continue; // already has a Supabase survey
        }
        final localRows = await LocalDatabaseService.instance
            .getSurveysForHousehold(household.id);
        if (localRows.isEmpty) continue;

        // Find the most recent local draft
        final latestLocal = localRows.reduce((a, b) {
          final aTime = a['updated_at'] as String? ?? '';
          final bTime = b['updated_at'] as String? ?? '';
          return aTime.compareTo(bTime) >= 0 ? a : b;
        });

        final localSurveyId = latestLocal['survey_id'] as String?;
        if (localSurveyId == null) continue;

        // Update the household entry to show the local draft
        final idx = households.indexOf(household);
        if (idx >= 0) {
          households[idx] = HouseholdModel(
            id: household.id,
            name: household.name,
            headName: household.headName,
            village: household.village,
            cluster: household.cluster,
            district: household.district,
            surveyStatus: SurveyStatus.draft,
            lastSurveyDate: (latestLocal['updated_at'] as String? ?? '')
                .substring(
                  0,
                  10.clamp(
                    0,
                    (latestLocal['updated_at'] as String? ?? '').length,
                  ),
                ),
            membersCount: household.membersCount,
            lat: household.lat,
            lng: household.lng,
            rejectionReason: household.rejectionReason,
            avatarUrl: household.avatarUrl,
            avatarSemanticLabel: household.avatarSemanticLabel,
            surveyId: localSurveyId,
            isLocalDraft: true,
          );
        }
      }
    } catch (e) {
      debugPrint(
        '[AssignedHouseholds] _mergeLocalDrafts error (non-fatal): $e',
      );
    }
  }

  /// Loads only local draft surveys when fully offline.

  /// Loads locally saved surveys when the app is offline.
  Future<void> _loadLocalDraftsOnly(List<HouseholdModel> households) async {
    if (!LocalDatabaseService.instance.isAvailable) return;

    try {
      final uid = SupabaseService.instance.currentUser?.id;
      if (uid == null) return;

      final localRows = await LocalDatabaseService.instance.getSurveysForAgent(
        uid,
      );
      debugPrint('[OfflineCheck] Local survey row count: ${localRows.length}');
      debugPrint('[OfflineCheck] Local survey rows: $localRows');

      final seenHouseholds = <String>{};

      for (final row in localRows) {
        final householdId = row['household_id'] as String?;
        final surveyId = row['survey_id'] as String?;
        final updatedAt = row['updated_at'] as String? ?? '';

        if (householdId == null ||
            householdId.isEmpty ||
            surveyId == null ||
            surveyId.isEmpty ||
            !seenHouseholds.add(householdId)) {
          continue;
        }

        households.add(
          HouseholdModel.fromLocalDraft(
            householdId: householdId,
            surveyId: surveyId,
            updatedAt: updatedAt,
          ),
        );
      }

      debugPrint(
        '[AssignedHouseholds] Loaded ${households.length} local households.',
      );
    } catch (e) {
      debugPrint('[AssignedHouseholds] Offline load failed: $e');
    }
  }

  Future<void> _handleLogout() async {
    await SupabaseService.instance.signOut();
    if (mounted) context.go(AppRoutes.signUpLoginScreen);
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      _applyFiltersAndSearch();
    });
  }

  void _applyFiltersAndSearch() {
    var list = _allHouseholds.where((h) {
      if (_selectedFilter != 'All' && h.surveyStatus.label != _selectedFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        return h.name.toLowerCase().contains(q) ||
            h.headName.toLowerCase().contains(q) ||
            h.village.toLowerCase().contains(q);
      }
      return true;
    }).toList();
    _filteredHouseholds = list;
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _applyFiltersAndSearch();
    });
  }

  Map<String, List<HouseholdModel>> _groupHouseholds() {
    final groups = <String, List<HouseholdModel>>{};
    for (final h in _filteredHouseholds) {
      groups.putIfAbsent(h.cluster, () => []).add(h);
    }
    return groups;
  }

  int get _pendingCount => _allHouseholds
      .where(
        (h) =>
            h.surveyStatus == SurveyStatus.draft ||
            h.surveyStatus == SurveyStatus.noSurvey,
      )
      .length;
  int get _correctionCount => _allHouseholds
      .where((h) => h.surveyStatus == SurveyStatus.correctionRequired)
      .length;
  int get _approvedCount => _allHouseholds
      .where((h) => h.surveyStatus == SurveyStatus.approved)
      .length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grouped = _groupHouseholds();

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: _loadData,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: GreetingAppBarWidget(
                  agentName: _agentName,
                  avatarUrl: _agentAvatarUrl.isNotEmpty
                      ? _agentAvatarUrl
                      : 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?w=80',
                  avatarSemanticLabel: 'Field agent profile photo: $_agentName',
                  notificationCount: _correctionCount,
                  onLogout: _handleLogout,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: HeroBannerCardWidget(
                    totalAssigned: _allHouseholds.length,
                    pendingCount: _pendingCount,
                    correctionCount: _correctionCount,
                    approvedCount: _approvedCount,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearch,
                    style: GoogleFonts.manrope(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search households, villages...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                _onSearch('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outline.withAlpha(128),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppTheme.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 52,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = filter == _selectedFilter;
                      return FilterChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (_) => _applyFilter(filter),
                        backgroundColor: theme.colorScheme.surface,
                        selectedColor: AppTheme.primaryContainer,
                        checkmarkColor: AppTheme.primary,
                        labelStyle: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: isSelected
                              ? AppTheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.primary.withAlpha(102)
                              : theme.colorScheme.outline.withAlpha(77),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                      );
                    },
                  ),
                ),
              ),
              if (_isLoading)
                const SliverToBoxAdapter(child: HouseholdListSkeleton())
              else if (_errorMessage != null)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: EmptyStateWidget(
                      icon: Icons.error_outline_rounded,
                      title: 'Could not load households',
                      subtitle: _errorMessage!,
                    ),
                  ),
                )
              else if (_filteredHouseholds.isEmpty)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: EmptyStateWidget(
                      icon: Icons.home_work_outlined,
                      title: 'No households found',
                      subtitle: _searchQuery.isNotEmpty
                          ? 'No households match your search. Try different keywords.'
                          : 'No households assigned for this filter. Pull down to refresh.',
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, sectionIndex) {
                    final clusterName = grouped.keys.elementAt(sectionIndex);
                    final households = grouped[clusterName]!;
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeaderWidget(
                            label: clusterName,
                            count: households.length,
                          ),
                          const SizedBox(height: 8),
                          ...List.generate(households.length, (i) {
                            final household = households[i];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: HouseholdCardWidget(
                                household: household,
                                animationDelay: Duration(milliseconds: i * 60),
                                onTap: () {
                                  final extra = _buildSurveyExtra(household);
                                  context
                                      .push(
                                        AppRoutes.surveyScreen,
                                        extra: extra,
                                      )
                                      .then((_) => _loadData());
                                },
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }, childCount: grouped.length),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Builds the navigation extra map based on the household's survey status.
Map<String, dynamic> _buildSurveyExtra(HouseholdModel household) {
  switch (household.surveyStatus) {
    case SurveyStatus.noSurvey:
      // No survey exists yet — start fresh, no surveyId
      return {
        'householdId': household.id,
        'householdName': household.name,
        'surveyId': null,
        'surveyMode': 'start',
      };
    case SurveyStatus.approved:
      // View-only: show saved answers, no editing
      return {
        'householdId': household.id,
        'householdName': household.name,
        'surveyId': household.surveyId,
        'surveyMode': 'view',
      };
    case SurveyStatus.submitted:
    case SurveyStatus.underReview:
      // Awaiting review: show submitted answers, read-only for field agent
      return {
        'householdId': household.id,
        'householdName': household.name,
        'surveyId': household.surveyId,
        'surveyMode': 'submitted',
      };
    case SurveyStatus.correctionRequired:
      // Correction workflow: load existing answers, allow editing and resubmit
      return {
        'householdId': household.id,
        'householdName': household.name,
        'surveyId': household.surveyId,
        'surveyMode': 'correction',
      };
    case SurveyStatus.draft:
      // Resume existing draft with saved answers
      // Fix 4: local drafts use surveyMode 'edit' so _loadExistingAnswers
      // will fall back to local DB when the survey isn't in Supabase yet.
      return {
        'householdId': household.id,
        'householdName': household.name,
        'surveyId': household.surveyId,
        'surveyMode': 'edit',
      };
  }
}

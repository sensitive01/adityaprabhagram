import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../bloc/blocs.dart';
import '../../models/household_model.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_skeleton_widget.dart';
import './widgets/greeting_app_bar_widget.dart';
import './widgets/hero_banner_card_widget.dart';
import './widgets/household_card_widget.dart';
import './widgets/section_header_widget.dart';

export '../../models/household_model.dart';

// --- SCREEN ---

class AssignedHouseholdsScreen extends StatefulWidget {
  const AssignedHouseholdsScreen({super.key});

  @override
  State<AssignedHouseholdsScreen> createState() =>
      _AssignedHouseholdsScreenState();
}

class _AssignedHouseholdsScreenState extends State<AssignedHouseholdsScreen> {
  final TextEditingController _searchController = TextEditingController();

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkRoleAndLoad();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _checkRoleAndLoad() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      if (authState.role == 'HOUSEHOLD') {
        context.go(AppRoutes.householdDashboardScreen);
        return;
      }
    }
    context.read<HouseholdsBloc>().add(const HouseholdsFetchRequested());
  }

  void _handleLogout() {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
    context.go(AppRoutes.signUpLoginScreen);
  }

  void _applyFilter(String filter) {
    context.read<HouseholdsBloc>().add(HouseholdsFilterChanged(filter));
  }

  void _onSearch(String query) {
    context.read<HouseholdsBloc>().add(HouseholdsSearchChanged(query));
  }

  Map<String, List<HouseholdModel>> _groupHouseholds(List<HouseholdModel> households) {
    final groups = <String, List<HouseholdModel>>{};
    for (final h in households) {
      groups.putIfAbsent(h.cluster, () => []).add(h);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = context.watch<AuthBloc>().state;
    final agentName = authState is AuthAuthenticated
        ? (authState.profile?['full_name'] as String? ?? 'Field Agent')
        : 'Field Agent';
    final agentAvatarUrl = authState is AuthAuthenticated
        ? (authState.profile?['avatar_url'] as String? ?? '')
        : '';

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: BlocBuilder<HouseholdsBloc, HouseholdsState>(
          builder: (context, state) {
            final isLoading = state is HouseholdsLoading || state is HouseholdsInitial;
            final errorMessage = state is HouseholdsError ? state.message : null;
            final loaded = state is HouseholdsLoaded ? state : null;

            final allHouseholds = loaded?.allHouseholds ?? [];
            final filteredHouseholds = loaded?.filteredHouseholds ?? [];
            final selectedFilter = loaded?.selectedFilter ?? 'All';
            final searchQuery = loaded?.searchQuery ?? '';
            final pendingCount = loaded?.pendingCount ?? 0;
            final correctionCount = loaded?.correctionCount ?? 0;
            final approvedCount = loaded?.approvedCount ?? 0;
            final grouped = _groupHouseholds(filteredHouseholds);

            return RefreshIndicator(
              color: AppTheme.primary,
              onRefresh: () async {
                context.read<HouseholdsBloc>().add(const HouseholdsFetchRequested());
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: GreetingAppBarWidget(
                      agentName: agentName,
                      avatarUrl: agentAvatarUrl.isNotEmpty
                          ? agentAvatarUrl
                          : 'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?w=80',
                      avatarSemanticLabel: 'Field agent profile photo: $agentName',
                      notificationCount: correctionCount,
                      onLogout: _handleLogout,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: HeroBannerCardWidget(
                        totalAssigned: allHouseholds.length,
                        pendingCount: pendingCount,
                        correctionCount: correctionCount,
                        approvedCount: approvedCount,
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
                          suffixIcon: searchQuery.isNotEmpty
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
                          final isSelected = filter == selectedFilter;
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
                  if (isLoading)
                    const SliverToBoxAdapter(child: HouseholdListSkeleton())
                  else if (errorMessage != null)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 300,
                        child: EmptyStateWidget(
                          icon: Icons.error_outline_rounded,
                          title: 'Could not load households',
                          subtitle: errorMessage,
                        ),
                      ),
                    )
                  else if (filteredHouseholds.isEmpty)
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 300,
                        child: EmptyStateWidget(
                          icon: Icons.home_work_outlined,
                          title: 'No households found',
                          subtitle: searchQuery.isNotEmpty
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
                                    onTap: () async {
                                      final extra = _buildSurveyExtra(household);
                                      await context.push(
                                        AppRoutes.surveyScreen,
                                        extra: extra,
                                      );
                                      if (!context.mounted) return;
                                      context.read<HouseholdsBloc>().add(
                                            const HouseholdsFetchRequested(),
                                          );
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
            );
          },
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

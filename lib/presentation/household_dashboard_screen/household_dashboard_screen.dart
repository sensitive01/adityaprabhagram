import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/empty_state_widget.dart';

class HouseholdDashboardScreen extends StatefulWidget {
  const HouseholdDashboardScreen({super.key});

  @override
  State<HouseholdDashboardScreen> createState() =>
      _HouseholdDashboardScreenState();
}

class _HouseholdDashboardScreenState extends State<HouseholdDashboardScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _householdData;

  // Bulletins
  List<Map<String, dynamic>> _bulletins = [];
  bool _bulletinsLoading = true;

  // Questions
  List<Map<String, dynamic>> _questions = [];
  bool _questionsLoading = true;
  final _questionCtrl = TextEditingController();
  bool _submittingQuestion = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _questionCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _bulletinsLoading = true;
      _questionsLoading = true;
    });
    debugPrint('[DIAG] HouseholdDashboard._loadData() called');
    debugPrint(
      '[DIAG] currentUser at _loadData start: ${SupabaseService.instance.currentUser?.id}',
    );
    debugPrint(
      '[DIAG] currentSession at _loadData start: ${SupabaseService.instance.client.auth.currentSession?.user.id}',
    );
    try {
      final data = await SupabaseService.instance.fetchMyHousehold();
      debugPrint(
        '[DIAG] fetchMyHousehold() returned: ${data == null ? "null (no household linked)" : "household id=${data['id']}"}',
      );
      if (mounted) {
        setState(() {
          _householdData = data;
          _isLoading = false;
        });
      }
      // Load bulletins and questions in parallel
      if (data != null) {
        final householdId = data['id'] as String;
        final results = await Future.wait([
          SupabaseService.instance.fetchHouseholdBulletins(),
          SupabaseService.instance.fetchHouseholdQuestions(householdId),
        ]);
        if (mounted) {
          setState(() {
            _bulletins = results[0];
            _questions = results[1];
            _bulletinsLoading = false;
            _questionsLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _bulletinsLoading = false;
            _questionsLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load household data. Pull down to retry.';
          _isLoading = false;
          _bulletinsLoading = false;
          _questionsLoading = false;
        });
      }
    }
  }

  Future<void> _submitQuestion() async {
    final text = _questionCtrl.text.trim();
    if (text.isEmpty || _householdData == null) return;
    setState(() => _submittingQuestion = true);
    try {
      await SupabaseService.instance.submitHouseholdQuestion(
        householdId: _householdData!['id'] as String,
        questionText: text,
      );
      _questionCtrl.clear();
      final questions = await SupabaseService.instance.fetchHouseholdQuestions(
        _householdData!['id'] as String,
      );
      if (mounted) {
        setState(() {
          _questions = questions;
          _submittingQuestion = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Question submitted successfully.',
              style: GoogleFonts.manrope(),
            ),
            backgroundColor: AppTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _submittingQuestion = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to submit question. Please try again.',
              style: GoogleFonts.manrope(),
            ),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  Future<void> _handleLogout() async {
    await SupabaseService.instance.signOut();
    if (mounted) context.go(AppRoutes.signUpLoginScreen);
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _surveyStatusLabel(String? status) {
    switch (status) {
      case 'draft':
        return 'Draft';
      case 'submitted':
        return 'Submitted';
      case 'under_review':
        return 'Under Review';
      case 'correction_required':
        return 'Correction Required';
      case 'approved':
        return 'Approved';
      default:
        return 'Not Started';
    }
  }

  Color _surveyStatusColor(String? status) {
    switch (status) {
      case 'draft':
        return AppTheme.statusDraft;
      case 'submitted':
        return AppTheme.statusSubmitted;
      case 'under_review':
        return AppTheme.statusUnderReview;
      case 'correction_required':
        return AppTheme.statusCorrection;
      case 'approved':
        return AppTheme.statusApproved;
      default:
        return AppTheme.statusDraft;
    }
  }

  Color _surveyStatusBgColor(String? status) {
    switch (status) {
      case 'draft':
        return AppTheme.statusDraftContainer;
      case 'submitted':
        return AppTheme.statusSubmittedContainer;
      case 'under_review':
        return AppTheme.statusUnderReviewContainer;
      case 'correction_required':
        return AppTheme.statusCorrectionContainer;
      case 'approved':
        return AppTheme.statusApprovedContainer;
      default:
        return AppTheme.statusDraftContainer;
    }
  }

  String _surveyActionLabel(String? status) {
    switch (status) {
      case 'draft':
        return 'Continue Survey';
      case 'submitted':
        return 'View Submission';
      case 'under_review':
        return 'View Submission';
      case 'correction_required':
        return 'Fix & Resubmit';
      case 'approved':
        return 'View Approved Survey';
      default:
        return 'Start Survey';
    }
  }

  IconData _surveyActionIcon(String? status) {
    switch (status) {
      case 'draft':
        return Icons.edit_note_rounded;
      case 'submitted':
        return Icons.visibility_outlined;
      case 'under_review':
        return Icons.visibility_outlined;
      case 'correction_required':
        return Icons.build_outlined;
      case 'approved':
        return Icons.check_circle_outline_rounded;
      default:
        return Icons.play_arrow_rounded;
    }
  }

  Color _surveyActionColor(String? status) {
    switch (status) {
      case 'correction_required':
        return AppTheme.statusCorrection;
      case 'approved':
        return AppTheme.statusApproved;
      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = SupabaseService.instance.currentUser;
    final userName =
        _householdData?['head_name'] as String? ??
        user?.email?.split('@').first ??
        'Farmer';

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppTheme.primary,
          onRefresh: _loadData,
          child: CustomScrollView(
            slivers: [
              // ── Header ──────────────────────────────────────────────────
              SliverToBoxAdapter(child: _buildHeader(theme, userName)),

              if (_isLoading)
                SliverToBoxAdapter(child: _buildSkeleton())
              else if (_errorMessage != null)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: EmptyStateWidget(
                      icon: Icons.error_outline_rounded,
                      title: 'Could not load data',
                      subtitle: _errorMessage!,
                    ),
                  ),
                )
              else if (_householdData == null)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: EmptyStateWidget(
                      icon: Icons.home_work_outlined,
                      title: 'No household linked',
                      subtitle:
                          'Your account is not linked to a household yet. Please contact your Field Agent.',
                    ),
                  ),
                )
              else ...[
                // ── Household Info Card ──────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: _buildHouseholdCard(theme),
                  ),
                ),
                // ── Household Details ────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _buildHouseholdDetailsCard(theme),
                  ),
                ),
                // ── Survey Status Card ───────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _buildSurveyCard(theme),
                  ),
                ),
                // ── Assigned Agent Card ──────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _buildAgentCard(theme),
                  ),
                ),
                // ── Bulletins Section ────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _buildBulletinsSection(theme),
                  ),
                ),
                // ── Ask a Question Section ───────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: _buildQuestionsSection(theme),
                  ),
                ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, String userName) {
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  userName,
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.home_outlined,
                      color: AppTheme.primary,
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Household / Farmer',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Avatar
          if (_householdData?['avatar_url'] != null &&
              (_householdData!['avatar_url'] as String).isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomImageWidget(
                imageUrl: _householdData!['avatar_url'] as String,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
                semanticLabel:
                    _householdData?['avatar_semantic_label'] as String? ??
                    'Household profile photo',
              ),
            ),
          const SizedBox(width: 10),
          // Logout button
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: _handleLogout,
              borderRadius: BorderRadius.circular(12),
              child: Icon(
                Icons.logout_rounded,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHouseholdCard(ThemeData theme) {
    final h = _householdData!;
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
                      'My Household',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withAlpha(179),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      h['name'] as String? ?? '',
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(31),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  h['id'] as String? ?? '',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.person_outline_rounded,
            'Head of Household',
            (h['household_head'] as String?)?.isNotEmpty == true
                ? h['household_head'] as String
                : (h['head_name'] as String? ?? ''),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  Icons.location_on_outlined,
                  'Village',
                  h['village'] as String? ?? '',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoRow(
                  Icons.map_outlined,
                  'District',
                  h['district'] as String? ?? '',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            Icons.people_outline_rounded,
            'Family Size',
            '${h['family_size'] ?? h['members_count'] ?? 0} members',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: Colors.white.withAlpha(153)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withAlpha(128),
                ),
              ),
              Text(
                value.isNotEmpty ? value : '—',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHouseholdDetailsCard(ThemeData theme) {
    final h = _householdData!;
    final surveyDate = h['survey_date'] as String?;
    String? formattedDate;
    if (surveyDate != null) {
      try {
        final dt = DateTime.parse(surveyDate);
        formattedDate = '${dt.day}/${dt.month}/${dt.year}';
      } catch (_) {
        formattedDate = surveyDate;
      }
    }

    final lat = h['latitude'] ?? h['lat'];
    final lng = h['longitude'] ?? h['lng'];
    final locationStr = (lat != null && lng != null && lat != 0 && lng != 0)
        ? '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}'
        : null;

    final survey = h['survey'] as Map<String, dynamic>?;
    final surveyStatus = survey?['status'] as String?;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(51)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 18,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Household Details',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildDetailGrid(theme, [
            _DetailItem(
              icon: Icons.person_rounded,
              label: 'Respondent Name',
              value: h['respondent_name'] as String?,
            ),
            _DetailItem(
              icon: Icons.phone_outlined,
              label: 'Contact Number',
              value: h['contact_number'] as String?,
            ),
            _DetailItem(
              icon: Icons.location_city_outlined,
              label: 'Block',
              value: h['block'] as String?,
            ),
            _DetailItem(
              icon: Icons.map_rounded,
              label: 'State',
              value: h['state'] as String?,
            ),
            _DetailItem(
              icon: Icons.hub_outlined,
              label: 'Cluster',
              value: h['cluster'] as String?,
            ),
            _DetailItem(
              icon: Icons.groups_outlined,
              label: 'Tribe / Community',
              value: h['tribe_community'] as String?,
            ),
            _DetailItem(
              icon: Icons.home_work_outlined,
              label: 'Household Type',
              value: h['household_type'] as String?,
            ),
            _DetailItem(
              icon: Icons.house_outlined,
              label: 'House Type',
              value: h['house_type'] as String?,
            ),
            if (locationStr != null)
              _DetailItem(
                icon: Icons.gps_fixed_rounded,
                label: 'Location (GPS)',
                value: locationStr,
              ),
            _DetailItem(
              icon: Icons.calendar_month_outlined,
              label: 'Survey Date',
              value: formattedDate,
            ),
            _DetailItem(
              icon: Icons.assignment_turned_in_outlined,
              label: 'Survey Status',
              value: _surveyStatusLabel(surveyStatus),
            ),
            if ((h['remarks'] as String?)?.isNotEmpty == true)
              _DetailItem(
                icon: Icons.notes_rounded,
                label: 'Remarks',
                value: h['remarks'] as String?,
                fullWidth: true,
              ),
          ]),
        ],
      ),
    );
  }

  Widget _buildDetailGrid(ThemeData theme, List<_DetailItem> items) {
    final fullWidthItems = items.where((i) => i.fullWidth).toList();
    final gridItems = items.where((i) => !i.fullWidth).toList();

    return Column(
      children: [
        // Two-column grid
        for (int i = 0; i < gridItems.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildDetailTile(theme, gridItems[i])),
                const SizedBox(width: 12),
                if (i + 1 < gridItems.length)
                  Expanded(child: _buildDetailTile(theme, gridItems[i + 1]))
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
        // Full-width items
        for (final item in fullWidthItems)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildDetailTile(theme, item, fullWidth: true),
          ),
      ],
    );
  }

  Widget _buildDetailTile(
    ThemeData theme,
    _DetailItem item, {
    bool fullWidth = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, size: 15, color: AppTheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  (item.value?.isNotEmpty == true) ? item.value! : '—',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: fullWidth ? 3 : 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurveyCard(ThemeData theme) {
    final survey = _householdData?['survey'] as Map<String, dynamic>?;
    final status = survey?['status'] as String?;

    // Determine the correct read-only surveyMode for the household user
    final surveyMode = (status == 'approved') ? 'view' : 'submitted';

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(51)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.assignment_outlined,
                size: 18,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Survey',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (survey == null || status == null)
            Text(
              'No survey data available.',
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else ...[
            Text(
              'Your household survey has been recorded. You can view the submitted answers below.',
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: FilledButton.icon(
                onPressed: () {
                  context.push(
                    AppRoutes.surveyScreen,
                    extra: {
                      'householdId': _householdData!['id'] as String,
                      'householdName': _householdData!['name'] as String,
                      'surveyId': survey['id'] as String?,
                      'surveyMode': surveyMode,
                      'isHouseholdView': true,
                    },
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: Text(
                  'View Survey',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAgentCard(ThemeData theme) {
    final agent = _householdData?['agent'] as Map<String, dynamic>?;
    final agentName = agent?['full_name'] as String? ?? 'Not assigned';
    final agentAvatarUrl = agent?['avatar_url'] as String? ?? '';

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(51)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: agentAvatarUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomImageWidget(
                      imageUrl: agentAvatarUrl,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      semanticLabel: 'Field agent profile photo',
                    ),
                  )
                : const Icon(
                    Icons.badge_outlined,
                    color: AppTheme.primary,
                    size: 22,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assigned Field Agent',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  agentName,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.verified_outlined,
                  size: 12,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Verified',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Bulletins Section ──────────────────────────────────────────────────────

  Widget _buildBulletinsSection(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(51)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.campaign_outlined,
                  size: 18,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Bulletins & Information',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (_bulletinsLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (_bulletins.isEmpty)
            _buildEmptyState(
              theme,
              icon: Icons.article_outlined,
              message: 'No bulletins at this time.',
            )
          else
            Column(
              children: _bulletins
                  .map((b) => _buildBulletinItem(theme, b))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildBulletinItem(ThemeData theme, Map<String, dynamic> b) {
    final publishedAt = b['published_at'] as String?;
    final createdAt = b['created_at'] as String?;
    final dateStr = publishedAt ?? createdAt;
    String? formattedDate;
    if (dateStr != null) {
      try {
        final dt = DateTime.parse(dateStr).toLocal();
        formattedDate = '${dt.day}/${dt.month}/${dt.year}';
      } catch (_) {}
    }
    final author = b['user_profiles'] as Map<String, dynamic>?;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_rounded,
                size: 16,
                color: Color(0xFF0284C7),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  b['title'] as String? ?? 'Bulletin',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0C4A6E),
                  ),
                ),
              ),
            ],
          ),
          if ((b['body'] as String?)?.isNotEmpty == true) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(
                b['body'] as String,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: const Color(0xFF075985),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 24),
              if (author?['full_name'] != null) ...[
                const Icon(
                  Icons.person_rounded,
                  size: 12,
                  color: Color(0xFF7DD3FC),
                ),
                const SizedBox(width: 4),
                Text(
                  author!['full_name'] as String,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: const Color(0xFF0369A1),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              if (formattedDate != null) ...[
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 12,
                  color: Color(0xFF7DD3FC),
                ),
                const SizedBox(width: 4),
                Text(
                  formattedDate,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: const Color(0xFF0369A1),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ── Ask a Question Section ─────────────────────────────────────────────────

  Widget _buildQuestionsSection(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withAlpha(51)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Ask a Question',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Send a question to your Cluster Head or Admin.',
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          // Input
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _questionCtrl,
                  minLines: 2,
                  maxLines: 4,
                  style: GoogleFonts.manrope(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Type your question here…',
                    hintStyle: GoogleFonts.manrope(
                      fontSize: 13,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.outline.withAlpha(80),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 44,
                child: FilledButton(
                  onPressed: _submittingQuestion ? null : _submitQuestion,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: _submittingQuestion
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Send',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Previous questions
          Text(
            'My Questions',
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          if (_questionsLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (_questions.isEmpty)
            _buildEmptyState(
              theme,
              icon: Icons.question_answer_outlined,
              message: 'No questions submitted yet.',
            )
          else
            Column(
              children: _questions
                  .map((q) => _buildQuestionItem(theme, q))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionItem(ThemeData theme, Map<String, dynamic> q) {
    final isAnswered = q['is_answered'] as bool? ?? false;
    final createdAt = q['created_at'] as String?;
    String? formattedDate;
    if (createdAt != null) {
      try {
        final dt = DateTime.parse(createdAt).toLocal();
        formattedDate = '${dt.day}/${dt.month}/${dt.year}';
      } catch (_) {}
    }
    final answers = q['question_answers'] as List?;
    final firstAnswer = (answers?.isNotEmpty == true)
        ? answers!.first as Map<String, dynamic>
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAnswered
              ? AppTheme.success.withAlpha(80)
              : theme.colorScheme.outline.withAlpha(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.help_rounded,
                  size: 15,
                  color: isAnswered
                      ? AppTheme.success
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    q['question_text'] as String? ?? '',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isAnswered
                        ? AppTheme.successContainer
                        : AppTheme.statusDraftContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isAnswered ? 'Answered' : 'Pending',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isAnswered
                          ? AppTheme.success
                          : AppTheme.statusDraft,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (formattedDate != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(36, 0, 14, 8),
              child: Text(
                'Asked on $formattedDate',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          // Answer
          if (firstAnswer != null) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.successContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.reply_rounded,
                        size: 14,
                        color: AppTheme.success,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Response',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.success,
                        ),
                      ),
                      const Spacer(),
                      if ((firstAnswer['user_profiles']
                              as Map?)?['full_name'] !=
                          null)
                        Text(
                          (firstAnswer['user_profiles'] as Map)['full_name']
                              as String,
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: AppTheme.success,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    firstAnswer['answer_text'] as String? ?? '',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ] else
            const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    ThemeData theme, {
    required IconData icon,
    required String message,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(
            message,
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(51),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(51),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(51),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 76,
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(51),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper data class for detail grid items.
class _DetailItem {
  final IconData icon;
  final String label;
  final String? value;
  final bool fullWidth;

  const _DetailItem({
    required this.icon,
    required this.label,
    this.value,
    this.fullWidth = false,
  });
}

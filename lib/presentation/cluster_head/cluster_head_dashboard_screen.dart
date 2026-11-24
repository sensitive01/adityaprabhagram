import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import './cluster_head_shell.dart';

class ClusterHeadDashboardScreen extends StatefulWidget {
  const ClusterHeadDashboardScreen({super.key});

  @override
  State<ClusterHeadDashboardScreen> createState() =>
      _ClusterHeadDashboardScreenState();
}

class _ClusterHeadDashboardScreenState
    extends State<ClusterHeadDashboardScreen> {
  bool _isLoading = true;
  String? _error;
  String _clusterName = '';
  Map<String, int> _stats = {};
  List<Map<String, dynamic>> _recentSurveys = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final uid = SupabaseService.instance.currentUser?.id;
      if (uid == null) throw Exception('Not authenticated');

      // Get cluster assignment
      final chRecord = await SupabaseService.instance.client
          .from('cluster_heads')
          .select('cluster_id, clusters(cluster_name)')
          .eq('user_id', uid)
          .eq('is_active', true)
          .maybeSingle();

      if (chRecord == null) {
        throw Exception('No active cluster assignment found');
      }

      final clusterId = chRecord['cluster_id'] as String;
      final cluster = chRecord['clusters'] as Map<String, dynamic>?;

      // Get agent IDs in this cluster
      final agentAssignments = await SupabaseService.instance.client
          .from('field_agent_cluster_assignments')
          .select('agent_id')
          .eq('cluster_id', clusterId)
          .eq('is_active', true);

      final agentIds = (agentAssignments as List)
          .map((a) => a['agent_id'] as String)
          .toList();

      // Get household IDs assigned to these agents
      List<String> householdIds = [];
      if (agentIds.isNotEmpty) {
        final hhData = await SupabaseService.instance.client
            .from('households')
            .select('id')
            .inFilter('assigned_agent_id', agentIds);
        householdIds = (hhData as List).map((h) => h['id'] as String).toList();
      }

      // Count members
      int memberCount = 0;
      if (householdIds.isNotEmpty) {
        final membersResp = await SupabaseService.instance.client
            .from('household_members')
            .select('id')
            .inFilter('household_id', householdIds)
            .count();
        memberCount = membersResp.count;
      }

      // Get surveys
      int submitted = 0,
          draft = 0,
          underReview = 0,
          correction = 0,
          approved = 0;
      List<Map<String, dynamic>> recentSurveys = [];
      if (householdIds.isNotEmpty) {
        final surveysData = await SupabaseService.instance.client
            .from('surveys')
            .select('id, status, households(hh_id, name), created_at')
            .inFilter('household_id', householdIds)
            .order('created_at', ascending: false)
            .limit(10);
        recentSurveys = List<Map<String, dynamic>>.from(surveysData as List);
        for (final s in recentSurveys) {
          switch (s['status']) {
            case 'submitted':
              submitted++;
              break;
            case 'draft':
              draft++;
              break;
            case 'under_review':
              underReview++;
              break;
            case 'correction_required':
              correction++;
              break;
            case 'approved':
              approved++;
              break;
          }
        }
      }

      // Open questions
      int openQuestions = 0;
      if (householdIds.isNotEmpty) {
        final qResp = await SupabaseService.instance.client
            .from('household_questions')
            .select('id')
            .inFilter('household_id', householdIds)
            .eq('is_answered', false)
            .count();
        openQuestions = qResp.count;
      }

      if (mounted) {
        setState(() {
          _clusterName = cluster?['cluster_name'] as String? ?? 'My Cluster';
          _stats = {
            'agents': agentIds.length,
            'households': householdIds.length,
            'members': memberCount,
            'submitted': submitted,
            'draft': draft,
            'underReview': underReview,
            'correction': correction,
            'approved': approved,
            'openQuestions': openQuestions,
          };
          _recentSurveys = recentSurveys;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load dashboard: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClusterHeadShell(selectedIndex: 0, child: _buildContent());
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                  child: Text(
                    _error!,
                    style: GoogleFonts.manrope(color: AppTheme.error),
                  ),
                )
              : _buildDashboard(),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        border: Border(bottom: BorderSide(color: const Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _clusterName.isNotEmpty ? _clusterName : 'Dashboard',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Cluster overview',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    final total =
        (_stats['submitted'] ?? 0) +
        (_stats['draft'] ?? 0) +
        (_stats['underReview'] ?? 0) +
        (_stats['correction'] ?? 0) +
        (_stats['approved'] ?? 0);
    final completionPct = total > 0 ? (_stats['approved']! / total * 100) : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cluster Summary',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossCount = constraints.maxWidth > 800 ? 4 : 2;
              return GridView.count(
                crossAxisCount: crossCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  _statCard(
                    'Field Agents',
                    _stats['agents'] ?? 0,
                    Icons.badge_rounded,
                    AppTheme.secondary,
                  ),
                  _statCard(
                    'Households',
                    _stats['households'] ?? 0,
                    Icons.home_work_rounded,
                    AppTheme.warning,
                  ),
                  _statCard(
                    'HH Members',
                    _stats['members'] ?? 0,
                    Icons.people_rounded,
                    const Color(0xFF7C3AED),
                  ),
                  _statCard(
                    'Open Questions',
                    _stats['openQuestions'] ?? 0,
                    Icons.help_outline_rounded,
                    AppTheme.error,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Survey Progress',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossCount = constraints.maxWidth > 800 ? 5 : 3;
              return GridView.count(
                crossAxisCount: crossCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.6,
                children: [
                  _statCard(
                    'Draft',
                    _stats['draft'] ?? 0,
                    Icons.edit_note_rounded,
                    AppTheme.statusDraft,
                  ),
                  _statCard(
                    'Submitted',
                    _stats['submitted'] ?? 0,
                    Icons.send_rounded,
                    AppTheme.statusSubmitted,
                  ),
                  _statCard(
                    'Under Review',
                    _stats['underReview'] ?? 0,
                    Icons.rate_review_rounded,
                    AppTheme.statusUnderReview,
                  ),
                  _statCard(
                    'Correction',
                    _stats['correction'] ?? 0,
                    Icons.warning_rounded,
                    AppTheme.statusCorrection,
                  ),
                  _statCard(
                    'Approved',
                    _stats['approved'] ?? 0,
                    Icons.check_circle_rounded,
                    AppTheme.statusApproved,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildRecentSurveys()),
              const SizedBox(width: 16),
              Expanded(child: _buildCompletionCard(completionPct)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, int value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withAlpha(31),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$value',
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: const Color(0xFF6B7280),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSurveys() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Surveys',
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          if (_recentSurveys.isEmpty)
            Text(
              'No surveys yet',
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: const Color(0xFF9CA3AF),
              ),
            )
          else
            ..._recentSurveys.take(8).map((s) {
              final hh = s['households'] as Map<String, dynamic>?;
              final status = s['status'] as String? ?? 'draft';
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        hh?['name'] as String? ?? '—',
                        style: GoogleFonts.manrope(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.statusContainerColor(
                          _statusLabel(status),
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _statusLabel(status),
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.statusColor(_statusLabel(status)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildCompletionCard(double pct) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Survey Completion',
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: pct / 100,
                    strokeWidth: 10,
                    backgroundColor: AppTheme.surfaceVariantLight,
                    valueColor: AlwaysStoppedAnimation(AppTheme.success),
                  ),
                ),
                Text(
                  '${pct.toStringAsFixed(0)}%',
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.success,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Approved surveys out of total',
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(String s) {
    switch (s) {
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
        return s;
    }
  }
}

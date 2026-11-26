import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import './admin_shell.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _isLoading = true;
  String? _error;
  Map<String, int> _stats = {};
  List<Map<String, dynamic>> _recentActivity = [];

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
      final client = SupabaseService.instance.client;

      // Fetch counts individually to avoid complex parallel typing issues
      final clustersResp = await client.from('clusters').select('id').count();
      final chResp = await client
          .from('cluster_heads')
          .select('id')
          .eq('is_active', true)
          .count();
      final agentsResp = await client
          .from('user_profiles')
          .select('id')
          .eq('role', 'FIELD_AGENT')
          .eq('is_active', true)
          .count();
      final hhResp = await client.from('households').select('id').count();
      final membersResp = await client
          .from('household_members')
          .select('id')
          .count();
      final submittedResp = await client
          .from('surveys')
          .select('id')
          .eq('status', 'submitted')
          .count();
      final draftResp = await client
          .from('surveys')
          .select('id')
          .eq('status', 'draft')
          .count();
      final reviewResp = await client
          .from('surveys')
          .select('id')
          .eq('status', 'under_review')
          .count();
      final correctionResp = await client
          .from('surveys')
          .select('id')
          .eq('status', 'correction_required')
          .count();
      final approvedResp = await client
          .from('surveys')
          .select('id')
          .eq('status', 'approved')
          .count();
      final openQResp = await client
          .from('household_questions')
          .select('id')
          .eq('is_answered', false)
          .count();

      final activity = await client
          .from('audit_log')
          .select('table_name, action, performed_by, created_at')
          .order('created_at', ascending: false)
          .limit(10);

      if (mounted) {
        setState(() {
          _stats = {
            'clusters': clustersResp.count,
            'clusterHeads': chResp.count,
            'fieldAgents': agentsResp.count,
            'households': hhResp.count,
            'members': membersResp.count,
            'submitted': submittedResp.count,
            'draft': draftResp.count,
            'underReview': reviewResp.count,
            'correction': correctionResp.count,
            'approved': approvedResp.count,
            'openQuestions': openQResp.count,
          };
          _recentActivity = List<Map<String, dynamic>>.from(activity as List);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load dashboard data: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(selectedIndex: 0, child: _buildContent());
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
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        border: Border(bottom: BorderSide(color: const Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: GoogleFonts.manrope(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  'System-wide overview',
                  style: GoogleFonts.manrope(
                    fontSize: isMobile ? 11 : 13,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.surfaceVariantLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Organisation',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 12),
          _buildStatsGrid([
            _StatCard(
              label: 'Clusters',
              value: _stats['clusters'] ?? 0,
              icon: Icons.hub_rounded,
              color: AppTheme.primary,
            ),
            _StatCard(
              label: 'Cluster Heads',
              value: _stats['clusterHeads'] ?? 0,
              icon: Icons.manage_accounts_rounded,
              color: AppTheme.info,
            ),
            _StatCard(
              label: 'Field Agents',
              value: _stats['fieldAgents'] ?? 0,
              icon: Icons.badge_rounded,
              color: AppTheme.secondary,
            ),
            _StatCard(
              label: 'Households',
              value: _stats['households'] ?? 0,
              icon: Icons.home_work_rounded,
              color: AppTheme.warning,
            ),
            _StatCard(
              label: 'HH Members',
              value: _stats['members'] ?? 0,
              icon: Icons.people_rounded,
              color: const Color(0xFF7C3AED),
            ),
          ]),
          const SizedBox(height: 24),
          Text(
            'Surveys',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 12),
          _buildStatsGrid([
            _StatCard(
              label: 'Draft',
              value: _stats['draft'] ?? 0,
              icon: Icons.edit_note_rounded,
              color: AppTheme.statusDraft,
            ),
            _StatCard(
              label: 'Submitted',
              value: _stats['submitted'] ?? 0,
              icon: Icons.send_rounded,
              color: AppTheme.statusSubmitted,
            ),
            _StatCard(
              label: 'Under Review',
              value: _stats['underReview'] ?? 0,
              icon: Icons.rate_review_rounded,
              color: AppTheme.statusUnderReview,
            ),
            _StatCard(
              label: 'Correction',
              value: _stats['correction'] ?? 0,
              icon: Icons.warning_rounded,
              color: AppTheme.statusCorrection,
            ),
            _StatCard(
              label: 'Approved',
              value: _stats['approved'] ?? 0,
              icon: Icons.check_circle_rounded,
              color: AppTheme.statusApproved,
            ),
          ]),
          const SizedBox(height: 24),
          if (isMobile) ...[
            _buildRecentActivity(),
            const SizedBox(height: 16),
            _buildQuickStats(),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildRecentActivity()),
                const SizedBox(width: 16),
                Expanded(child: _buildQuickStats()),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsGrid(List<_StatCard> cards) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossCount = constraints.maxWidth > 900
            ? 5
            : constraints.maxWidth > 600
            ? 3
            : 2;
        return GridView.count(
          crossAxisCount: crossCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isMobile ? 1.25 : 1.5,
          children: cards,
        );
      },
    );
  }

  Widget _buildRecentActivity() {
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
            'Recent Activity',
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          if (_recentActivity.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No recent activity',
                  style: GoogleFonts.manrope(color: const Color(0xFF9CA3AF)),
                ),
              ),
            )
          else
            ..._recentActivity.map((a) => _buildActivityRow(a)),
        ],
      ),
    );
  }

  Widget _buildActivityRow(Map<String, dynamic> a) {
    final action = a['action'] as String? ?? '';
    final table = a['table_name'] as String? ?? '';
    final createdAt = a['created_at'] as String? ?? '';
    final dt = createdAt.isNotEmpty ? DateTime.tryParse(createdAt) : null;
    final timeStr = dt != null
        ? '${dt.day}/${dt.month} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}'
        : '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$action on $table',
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: const Color(0xFF374151),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            timeStr,
            style: GoogleFonts.manrope(
              fontSize: 11,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
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
            'Quick Stats',
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildQuickStatRow(
            'Open HH Questions',
            '${_stats['openQuestions'] ?? 0}',
            Icons.help_outline_rounded,
            AppTheme.warning,
          ),
          const Divider(height: 20),
          _buildQuickStatRow(
            'Survey Completion',
            _surveyCompletionRate(),
            Icons.pie_chart_rounded,
            AppTheme.success,
          ),
        ],
      ),
    );
  }

  String _surveyCompletionRate() {
    final total =
        (_stats['draft'] ?? 0) +
        (_stats['submitted'] ?? 0) +
        (_stats['underReview'] ?? 0) +
        (_stats['correction'] ?? 0) +
        (_stats['approved'] ?? 0);
    if (total == 0) return '0%';
    return '${((_stats['approved'] ?? 0) / total * 100).toStringAsFixed(1)}%';
  }

  Widget _buildQuickStatRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: const Color(0xFF4A5568),
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
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
          const SizedBox(height: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$value',
                style: GoogleFonts.manrope(
                  fontSize: isMobile ? 20 : 22,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
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
}

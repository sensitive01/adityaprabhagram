import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import './admin_shell.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic> _reportData = {};

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
      final results = await Future.wait([
        client.from('clusters').select('id, cluster_name, is_active'),
        client
            .from('user_profiles')
            .select('id, full_name, role, is_active')
            .inFilter('role', ['FIELD_AGENT', 'CLUSTER_HEAD']),
        client.from('surveys').select('id, status, household_id'),
        client
            .from('households')
            .select('id, village, district, assigned_agent_id'),
      ]);
      if (mounted) {
        setState(() {
          _reportData = {
            'clusters': results[0] as List,
            'users': results[1] as List,
            'surveys': results[2] as List,
            'households': results[3] as List,
          };
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load reports: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedIndex: 9,
      child: Column(
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
                : _buildContent(),
          ),
        ],
      ),
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
                'Reports & Analytics',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'System-wide performance metrics',
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

  Widget _buildContent() {
    final surveys = _reportData['surveys'] as List? ?? [];
    final households = _reportData['households'] as List? ?? [];
    final clusters = _reportData['clusters'] as List? ?? [];

    final totalSurveys = surveys.length;
    final approvedSurveys = surveys
        .where((s) => s['status'] == 'approved')
        .length;
    final submittedSurveys = surveys
        .where((s) => s['status'] == 'submitted')
        .length;
    final correctionSurveys = surveys
        .where((s) => s['status'] == 'correction_required')
        .length;
    final draftSurveys = surveys.where((s) => s['status'] == 'draft').length;
    final underReviewSurveys = surveys
        .where((s) => s['status'] == 'under_review')
        .length;

    final assignedHouseholds = households
        .where((h) => h['assigned_agent_id'] != null)
        .length;
    final unassignedHouseholds = households.length - assignedHouseholds;

    final completionRate = totalSurveys > 0
        ? (approvedSurveys / totalSurveys * 100)
        : 0.0;
    final correctionRate = totalSurveys > 0
        ? (correctionSurveys / totalSurveys * 100)
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Survey Performance',
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _metricCard(
                  'Completion Rate',
                  '${completionRate.toStringAsFixed(1)}%',
                  Icons.check_circle_rounded,
                  AppTheme.success,
                  'Approved / Total',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _metricCard(
                  'Correction Rate',
                  '${correctionRate.toStringAsFixed(1)}%',
                  Icons.warning_rounded,
                  AppTheme.warning,
                  'Corrections / Total',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _metricCard(
                  'Total Surveys',
                  '$totalSurveys',
                  Icons.assignment_rounded,
                  AppTheme.primary,
                  'All survey instances',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _metricCard(
                  'Household Coverage',
                  '${households.isNotEmpty ? (assignedHouseholds / households.length * 100).toStringAsFixed(1) : 0}%',
                  Icons.home_work_rounded,
                  AppTheme.info,
                  'Assigned / Total HH',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildSurveyStatusTable(
                  draftSurveys,
                  submittedSurveys,
                  underReviewSurveys,
                  correctionSurveys,
                  approvedSurveys,
                  totalSurveys,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildHouseholdCoverageTable(
                  assignedHouseholds,
                  unassignedHouseholds,
                  households.length,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildClusterTable(clusters, surveys, households),
        ],
      ),
    );
  }

  Widget _metricCard(
    String label,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha(31),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.manrope(
              fontSize: 11,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurveyStatusTable(
    int draft,
    int submitted,
    int underReview,
    int correction,
    int approved,
    int total,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Survey Status Distribution',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _statusRow('Draft', draft, total, AppTheme.statusDraft),
          _statusRow('Submitted', submitted, total, AppTheme.statusSubmitted),
          _statusRow(
            'Under Review',
            underReview,
            total,
            AppTheme.statusUnderReview,
          ),
          _statusRow(
            'Correction',
            correction,
            total,
            AppTheme.statusCorrection,
          ),
          _statusRow('Approved', approved, total, AppTheme.statusApproved),
        ],
      ),
    );
  }

  Widget _statusRow(String label, int count, int total, Color color) {
    final pct = total > 0 ? count / total : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 110,
                child: Text(label, style: GoogleFonts.manrope(fontSize: 13)),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: color.withAlpha(26),
                    valueColor: AlwaysStoppedAnimation(color),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 40,
                child: Text(
                  '$count',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHouseholdCoverageTable(int assigned, int unassigned, int total) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Household Coverage',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _statusRow('Assigned', assigned, total, AppTheme.success),
          _statusRow('Unassigned', unassigned, total, AppTheme.error),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Households',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$total',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClusterTable(List clusters, List surveys, List households) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cluster Overview',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          if (clusters.isEmpty)
            Text(
              'No clusters created yet',
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: const Color(0xFF9CA3AF),
              ),
            )
          else
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariantLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  children: ['Cluster', 'Households', 'Surveys', 'Status']
                      .map(
                        (h) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Text(
                            h,
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF4A5568),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                ...clusters.map((c) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Text(
                          c['cluster_name'] as String? ?? '—',
                          style: GoogleFonts.manrope(fontSize: 13),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Text(
                          '—',
                          style: GoogleFonts.manrope(fontSize: 13),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Text(
                          '—',
                          style: GoogleFonts.manrope(fontSize: 13),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Text(
                          c['is_active'] == true ? 'Active' : 'Inactive',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: c['is_active'] == true
                                ? AppTheme.success
                                : AppTheme.error,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
        ],
      ),
    );
  }
}

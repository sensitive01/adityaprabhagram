import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/status_badge_widget.dart';
import '../admin/widgets/admin_data_table.dart';
import './cluster_head_shell.dart';
import './cluster_head_survey_review_screen.dart';

/// Cluster Head Survey Review — view and approve/reject surveys in their cluster
class ClusterHeadSurveysScreen extends StatefulWidget {
  const ClusterHeadSurveysScreen({super.key});

  @override
  State<ClusterHeadSurveysScreen> createState() =>
      _ClusterHeadSurveysScreenState();
}

class _ClusterHeadSurveysScreenState extends State<ClusterHeadSurveysScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _surveys = [];
  Map<String, dynamic>? _selectedSurvey;
  String _filterStatus = 'All';
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentPage = 0;
  static const int _pageSize = 20;

  final _statuses = [
    'All',
    'submitted',
    'under_review',
    'correction_required',
    'approved',
    'draft',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final uid = SupabaseService.instance.currentUser?.id;
      if (uid == null) throw Exception('Not authenticated');

      final chRecord = await SupabaseService.instance.client
          .from('cluster_heads')
          .select('cluster_id')
          .eq('user_id', uid)
          .eq('is_active', true)
          .maybeSingle();

      if (chRecord == null) throw Exception('No cluster assignment');

      final clusterId = chRecord['cluster_id'] as String;
      final agentAssignments = await SupabaseService.instance.client
          .from('field_agent_cluster_assignments')
          .select('agent_id')
          .eq('cluster_id', clusterId)
          .eq('is_active', true);

      final agentIds = (agentAssignments as List)
          .map((a) => a['agent_id'] as String)
          .toList();

      if (agentIds.isEmpty) {
        if (mounted) {
          setState(() {
            _surveys = [];
            _isLoading = false;
          });
        }
        return;
      }

      final hhData = await SupabaseService.instance.client
          .from('households')
          .select('id')
          .inFilter('assigned_agent_id', agentIds);
      final householdIds = (hhData as List)
          .map((h) => h['id'] as String)
          .toList();

      if (householdIds.isEmpty) {
        if (mounted) {
          setState(() {
            _surveys = [];
            _isLoading = false;
          });
        }
        return;
      }

      final data = await SupabaseService.instance.client
          .from('surveys')
          .select(
            '*, households(hh_id, name, village), user_profiles!agent_id(full_name)',
          )
          .inFilter('household_id', householdIds)
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _surveys = List<Map<String, dynamic>>.from(data as List);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load surveys: $e';
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> get _filtered {
    return _surveys.where((s) {
      if (_filterStatus != 'All' && s['status'] != _filterStatus) return false;
      if (_searchQuery.isNotEmpty) {
        final hh = s['households'] as Map<String, dynamic>?;
        final hhId = (hh?['hh_id'] as String? ?? '').toLowerCase();
        final name = (hh?['name'] as String? ?? '').toLowerCase();
        if (!hhId.contains(_searchQuery) && !name.contains(_searchQuery)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  List<Map<String, dynamic>> get _paginated {
    final f = _filtered;
    final start = _currentPage * _pageSize;
    if (start >= f.length) return [];
    return f.sublist(start, (start + _pageSize).clamp(0, f.length));
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

  @override
  Widget build(BuildContext context) {
    return ClusterHeadShell(
      selectedIndex: 3,
      child: _selectedSurvey != null
          ? ClusterHeadSurveyReviewScreen(
              survey: _selectedSurvey!,
              onBack: () => setState(() => _selectedSurvey = null),
              onUpdated: () {
                setState(() => _selectedSurvey = null);
                _loadData();
              },
            )
          : _buildListView(),
    );
  }

  Widget _buildListView() {
    return Column(
      children: [
        _buildTopBar(),
        _buildFilterBar(),
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
              : _buildTable(),
        ),
        _buildPagination(),
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
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Surveys',
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${_filtered.length} surveys in your cluster',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
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
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() {
                    _searchQuery = v.toLowerCase();
                    _currentPage = 0;
                  }),
                  decoration: InputDecoration(
                    hintText: 'Search by HH_ID, name...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 18),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    isDense: true,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Surveys',
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${_filtered.length} surveys in your cluster',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 240,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() {
                      _searchQuery = v.toLowerCase();
                      _currentPage = 0;
                    }),
                    decoration: InputDecoration(
                      hintText: 'Search by HH_ID, name...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 18),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh_rounded),
                  tooltip: 'Refresh',
                ),
              ],
            ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: AppTheme.surfaceVariantLight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _statuses.map((s) {
            final isSelected = _filterStatus == s;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  _statusLabel(s),
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => setState(() {
                  _filterStatus = s;
                  _currentPage = 0;
                }),
                selectedColor: AppTheme.infoContainer,
                checkmarkColor: AppTheme.info,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTable() {
    final rows = _paginated;
    if (rows.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.assignment_outlined,
        title: 'No surveys found',
        subtitle: 'There are no surveys matching your current filters.',
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AdminDataTable(
        columns: const [
          'HH_ID',
          'Household',
          'Village',
          'Field Agent',
          'Status',
          'Actions',
        ],
        rows: rows.map((s) {
          final hh = s['households'] as Map<String, dynamic>?;
          final agent = s['user_profiles'] as Map<String, dynamic>?;
          final status = s['status'] as String? ?? 'draft';
          return [
            hh?['hh_id'] ?? '—',
            hh?['name'] ?? '—',
            hh?['village'] ?? '—',
            agent?['full_name'] ?? '—',
            StatusBadgeWidget(status: _statusLabel(status)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => setState(() => _selectedSurvey = s),
                  icon: const Icon(Icons.rate_review_rounded, size: 16),
                  tooltip: 'Review',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 28,
                  ),
                ),
              ],
            ),
          ];
        }).toList(),
        onRowTap: (i) => setState(() => _selectedSurvey = rows[i]),
      ),
    );
  }

  Widget _buildPagination() {
    final total = _filtered.length;
    final totalPages = (total / _pageSize).ceil();
    if (totalPages <= 1) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        border: Border(top: BorderSide(color: const Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 0
                ? () => setState(() => _currentPage--)
                : null,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Text(
            'Page ${_currentPage + 1} of $totalPages',
            style: GoogleFonts.manrope(fontSize: 13),
          ),
          IconButton(
            onPressed: _currentPage < totalPages - 1
                ? () => setState(() => _currentPage++)
                : null,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

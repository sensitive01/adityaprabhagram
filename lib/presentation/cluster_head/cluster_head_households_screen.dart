import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import '../admin/widgets/admin_data_table.dart';
import '../admin/widgets/create_household_dialog.dart';
import './cluster_head_shell.dart';

class ClusterHeadHouseholdsScreen extends StatefulWidget {
  const ClusterHeadHouseholdsScreen({super.key});

  @override
  State<ClusterHeadHouseholdsScreen> createState() =>
      _ClusterHeadHouseholdsScreenState();
}

class _ClusterHeadHouseholdsScreenState
    extends State<ClusterHeadHouseholdsScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _households = [];
  String? _clusterId;
  List<Map<String, dynamic>> _clusterList = [];
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentPage = 0;
  static const int _pageSize = 20;

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
          .select(
            'cluster_id, clusters(id, cluster_name, cluster_code, district, state)',
          )
          .eq('user_id', uid)
          .eq('is_active', true)
          .maybeSingle();

      if (chRecord == null) throw Exception('No cluster assignment');

      final clusterId = chRecord['cluster_id'] as String;
      final clusterData = chRecord['clusters'] as Map<String, dynamic>?;

      final data = await SupabaseService.instance.client
          .from('households')
          .select(
            '*, user_profiles!assigned_agent_id(full_name), household_members(id), surveys(status)',
          )
          .eq('cluster_id', clusterId)
          .order('hh_id');
      final households = List<Map<String, dynamic>>.from(data as List);

      if (mounted) {
        setState(() {
          _clusterId = clusterId;
          _clusterList = clusterData != null
              ? [
                  {
                    'id': clusterData['id'],
                    'cluster_name': clusterData['cluster_name'],
                    'cluster_code': clusterData['cluster_code'],
                    'district': clusterData['district'],
                    'state': clusterData['state'],
                  },
                ]
              : [];
          _households = households;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load households: $e';
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> get _filtered {
    return _households.where((h) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return (h['hh_id'] as String? ?? '').toLowerCase().contains(q) ||
          (h['name'] as String? ?? '').toLowerCase().contains(q) ||
          (h['village'] as String? ?? '').toLowerCase().contains(q);
    }).toList();
  }

  List<Map<String, dynamic>> get _paginated {
    final f = _filtered;
    final start = _currentPage * _pageSize;
    if (start >= f.length) return [];
    return f.sublist(start, (start + _pageSize).clamp(0, f.length));
  }

  @override
  Widget build(BuildContext context) {
    return ClusterHeadShell(
      selectedIndex: 2,
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
                : _buildTable(),
          ),
          _buildPagination(),
        ],
      ),
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
                            'Households',
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${_filtered.length} households in your cluster',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _clusterId != null ? _showCreateHouseholdDialog : null,
                      icon: const Icon(Icons.add_circle_rounded, color: AppTheme.primary),
                      tooltip: 'Create Household',
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
                    hintText: 'Search by HH_ID, name, village...',
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
                      'Households',
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${_filtered.length} households in your cluster',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 260,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() {
                      _searchQuery = v.toLowerCase();
                      _currentPage = 0;
                    }),
                    decoration: InputDecoration(
                      hintText: 'Search by HH_ID, name, village...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 18),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _clusterId != null ? _showCreateHouseholdDialog : null,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(
                    '+ Create Household',
                    style: GoogleFonts.manrope(fontSize: 13),
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

  void _showCreateHouseholdDialog() {
    showDialog(
      context: context,
      builder: (_) => CreateHouseholdDialog(
        clusters: _clusterList,
        lockedClusterId: _clusterId,
        onCreated: _loadData,
      ),
    );
  }

  Widget _buildTable() {
    final rows = _paginated;
    if (rows.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.home_outlined,
        title: 'No households found',
        subtitle: 'There are no households assigned to your cluster.',
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AdminDataTable(
        columns: const [
          'HH_ID',
          'Name',
          'Village',
          'Block',
          'District',
          'Members',
          'Field Agent',
          'Survey Status',
        ],
        rows: rows.map((h) {
          final agent = h['user_profiles'] as Map<String, dynamic>?;
          final members = h['household_members'] as List?;
          final surveys = h['surveys'] as List?;
          final latestSurvey = surveys?.isNotEmpty == true
              ? surveys!.last
              : null;
          final surveyStatus =
              latestSurvey?['status'] as String? ?? 'No Survey';
          return [
            h['hh_id'] ?? '—',
            h['name'] ?? '—',
            h['village'] ?? '—',
            h['block'] ?? '—',
            h['district'] ?? '—',
            '${members?.length ?? 0}',
            agent?['full_name'] ?? '—',
            _surveyStatusChip(surveyStatus),
          ];
        }).toList(),
      ),
    );
  }

  Widget _surveyStatusChip(String status) {
    Color color;
    switch (status) {
      case 'approved':
        color = AppTheme.success;
        break;
      case 'submitted':
        color = AppTheme.info;
        break;
      case 'under_review':
        color = AppTheme.statusUnderReview;
        break;
      case 'correction_required':
        color = AppTheme.warning;
        break;
      case 'draft':
        color = AppTheme.statusDraft;
        break;
      default:
        color = AppTheme.statusDraft;
    }
    final label = status == 'No Survey'
        ? 'No Survey'
        : status
              .replaceAll('_', ' ')
              .split(' ')
              .map(
                (w) => w.isNotEmpty
                    ? '${w[0].toUpperCase()}${w.substring(1)}'
                    : '',
              )
              .join(' ');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(31),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
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

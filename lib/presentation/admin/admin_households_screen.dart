import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import './admin_shell.dart';
import './widgets/admin_data_table.dart';
import './widgets/create_household_dialog.dart';
import './widgets/household_detail_panel.dart';

class AdminHouseholdsScreen extends StatefulWidget {
  const AdminHouseholdsScreen({super.key});

  @override
  State<AdminHouseholdsScreen> createState() => _AdminHouseholdsScreenState();
}

class _AdminHouseholdsScreenState extends State<AdminHouseholdsScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _households = [];
  List<Map<String, dynamic>> _clusters = [];
  List<Map<String, dynamic>> _fieldAgents = [];
  Map<String, dynamic>? _selectedHousehold;

  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterCluster = 'All';
  String _filterAgent = 'All';

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
      final client = SupabaseService.instance.client;
      final results = await Future.wait([
        client
            .from('households')
            .select(
              '*, user_profiles!assigned_agent_id(full_name), household_members(id)',
            )
            .order('hh_id'),
        client
            .from('clusters')
            .select('id, cluster_name, cluster_code, district, state')
            .eq('is_active', true)
            .order('cluster_name'),
        client
            .from('user_profiles')
            .select('id, full_name')
            .eq('role', 'FIELD_AGENT')
            .order('full_name'),
      ]);
      if (mounted) {
        setState(() {
          _households = List<Map<String, dynamic>>.from(results[0] as List);
          _clusters = List<Map<String, dynamic>>.from(results[1] as List);
          _fieldAgents = List<Map<String, dynamic>>.from(results[2] as List);
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
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final hhId = (h['hh_id'] as String? ?? '').toLowerCase();
        final name = (h['name'] as String? ?? '').toLowerCase();
        final respondent = (h['respondent_name'] as String? ?? '')
            .toLowerCase();
        if (!hhId.contains(q) && !name.contains(q) && !respondent.contains(q)) {
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

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedIndex: 4,
      child: Row(
        children: [
          Expanded(child: _buildMainContent()),
          if (_selectedHousehold != null)
            HouseholdDetailPanel(
              household: _selectedHousehold!,
              fieldAgents: _fieldAgents,
              onClose: () => setState(() => _selectedHousehold = null),
              onUpdated: _loadData,
            ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
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
                'Households',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${_filtered.length} households',
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
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: _showCreateHouseholdDialog,
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
      builder: (_) =>
          CreateHouseholdDialog(clusters: _clusters, onCreated: _loadData),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      color: AppTheme.surfaceVariantLight,
      child: Row(
        children: [
          Text(
            'Filter by:',
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: const Color(0xFF4A5568),
            ),
          ),
          const SizedBox(width: 12),
          _buildDropdown(
            'Cluster',
            ['All', ..._clusters.map((c) => c['cluster_name'] as String)],
            _filterCluster,
            (v) => setState(() => _filterCluster = v ?? 'All'),
          ),
          const SizedBox(width: 12),
          _buildDropdown(
            'Field Agent',
            ['All', ..._fieldAgents.map((a) => a['full_name'] as String)],
            _filterAgent,
            (v) => setState(() => _filterAgent = v ?? 'All'),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String hint,
    List<String> items,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButton<String>(
      value: value,
      hint: Text(hint, style: GoogleFonts.manrope(fontSize: 13)),
      style: GoogleFonts.manrope(fontSize: 13, color: const Color(0xFF1A1A1A)),
      underline: const SizedBox(),
      items: items
          .map((i) => DropdownMenuItem(value: i, child: Text(i)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTable() {
    final rows = _paginated;
    if (rows.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.home_work_outlined,
        title: 'No households found',
        subtitle: 'No households match your current search or filter criteria.',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AdminDataTable(
        columns: const [
          'HH_ID',
          'Name',
          'Respondent',
          'Village',
          'Block',
          'District',
          'Members',
          'Field Agent',
          'Actions',
        ],
        rows: rows.map((h) {
          final agent = h['user_profiles'] as Map<String, dynamic>?;
          final members = h['household_members'] as List?;
          return [
            h['hh_id'] ?? '—',
            h['name'] ?? '—',
            h['respondent_name'] ?? '—',
            h['village'] ?? '—',
            h['block'] ?? '—',
            h['district'] ?? '—',
            '${members?.length ?? 0}',
            agent?['full_name'] ?? 'Unassigned',
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => setState(() => _selectedHousehold = h),
                  icon: const Icon(Icons.visibility_rounded, size: 16),
                  tooltip: 'View Details',
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
        onRowTap: (i) => setState(() => _selectedHousehold = rows[i]),
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import './admin_shell.dart';
import './widgets/admin_confirm_dialog.dart';
import './widgets/admin_create_user_dialog.dart';
import './widgets/admin_data_table.dart';

/// Combined management screen for Clusters, Cluster Heads, and Field Agents.
/// Tab index: 0=Clusters, 1=Cluster Heads, 2=Field Agents
class AdminManagementScreen extends StatefulWidget {
  final int initialTab;
  const AdminManagementScreen({super.key, this.initialTab = 0});

  @override
  State<AdminManagementScreen> createState() => _AdminManagementScreenState();
}

class _AdminManagementScreenState extends State<AdminManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> _clusters = [];
  List<Map<String, dynamic>> _clusterHeads = [];
  List<Map<String, dynamic>> _fieldAgents = [];

  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Shell nav index: Clusters=1, ClusterHeads=2, FieldAgents=3
  int get _shellIndex => widget.initialTab + 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _tabController.addListener(() => setState(() {}));
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAll() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final client = SupabaseService.instance.client;
      final results = await Future.wait([
        client
            .from('clusters')
            .select(
              '*, cluster_heads(user_id, is_active, user_profiles!cluster_heads_user_id_fkey(full_name))',
            )
            .order('cluster_name'),
        client
            .from('cluster_heads')
            .select(
              '*, user_profiles!cluster_heads_user_id_fkey(full_name, email, is_active), clusters(cluster_name)',
            )
            .eq('is_active', true)
            .order('assigned_at', ascending: false),
        client
            .from('user_profiles')
            .select(
              '*, field_agent_cluster_assignments!field_agent_cluster_assignments_agent_id_fkey(cluster_id, is_active, clusters(cluster_name))',
            )
            .eq('role', 'FIELD_AGENT')
            .order('full_name'),
      ]);
      if (mounted) {
        setState(() {
          _clusters = List<Map<String, dynamic>>.from(results[0] as List);
          _clusterHeads = List<Map<String, dynamic>>.from(results[1] as List);
          _fieldAgents = List<Map<String, dynamic>>.from(results[2] as List);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load data: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedIndex: _shellIndex,
      child: Column(
        children: [
          _buildTopBar(),
          _buildTabBar(),
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
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildClustersTab(),
                      _buildClusterHeadsTab(),
                      _buildFieldAgentsTab(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    final titles = ['Clusters', 'Cluster Heads', 'Field Agents'];
    final subtitles = [
      'Manage organisational clusters',
      'Manage cluster head assignments',
      'Manage field agent accounts',
    ];
    final idx = _tabController.index;
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
                titles[idx],
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitles[idx],
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
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search...',
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
            onPressed: () => _showCreateDialog(idx),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(
              'Create ${titles[idx].replaceAll('s', '')}',
              style: GoogleFonts.manrope(fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _loadAll,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.surfaceLight,
      child: TabBar(
        controller: _tabController,
        labelStyle: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        labelColor: AppTheme.primary,
        unselectedLabelColor: const Color(0xFF6B7280),
        indicatorColor: AppTheme.primary,
        tabs: const [
          Tab(text: 'Clusters'),
          Tab(text: 'Cluster Heads'),
          Tab(text: 'Field Agents'),
        ],
      ),
    );
  }

  // ─── CLUSTERS TAB ────────────────────────────────────────────────────────

  Widget _buildClustersTab() {
    final filtered = _clusters.where((c) {
      if (_searchQuery.isEmpty) return true;
      return (c['cluster_name'] as String? ?? '').toLowerCase().contains(
            _searchQuery,
          ) ||
          (c['cluster_code'] as String? ?? '').toLowerCase().contains(
            _searchQuery,
          );
    }).toList();

    if (filtered.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.device_hub_rounded,
        title: 'No clusters found',
        subtitle: 'No clusters match your search criteria.',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AdminDataTable(
        columns: const [
          'Code',
          'Name',
          'District',
          'State',
          'Cluster Head',
          'Status',
          'Actions',
        ],
        rows: filtered.map((c) {
          final heads = c['cluster_heads'] as List?;
          final activeHead = heads?.firstWhere(
            (h) => h['is_active'] == true,
            orElse: () => null,
          );
          final headName =
              activeHead?['user_profiles']?['full_name'] as String? ?? '—';
          return [
            c['cluster_code'] ?? '—',
            c['cluster_name'] ?? '—',
            c['district'] ?? '—',
            c['state'] ?? '—',
            headName,
            c['is_active'] == true ? 'Active' : 'Inactive',
            _buildActionButtons(
              onEdit: () => _showEditClusterDialog(c),
              onToggle: () => _toggleClusterStatus(c),
              isActive: c['is_active'] == true,
            ),
          ];
        }).toList(),
      ),
    );
  }

  // ─── CLUSTER HEADS TAB ───────────────────────────────────────────────────

  Widget _buildClusterHeadsTab() {
    final filtered = _clusterHeads.where((ch) {
      if (_searchQuery.isEmpty) return true;
      final name = (ch['user_profiles']?['full_name'] as String? ?? '')
          .toLowerCase();
      return name.contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.person_off_rounded,
        title: 'No cluster heads found',
        subtitle: 'No cluster heads match your search criteria.',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AdminDataTable(
        columns: const ['Name', 'Email', 'Cluster', 'Status', 'Actions'],
        rows: filtered.map((ch) {
          final profile = ch['user_profiles'] as Map<String, dynamic>?;
          final cluster = ch['clusters'] as Map<String, dynamic>?;
          return [
            profile?['full_name'] ?? '—',
            profile?['email'] ?? '—',
            cluster?['cluster_name'] ?? '—',
            profile?['is_active'] == true ? 'Active' : 'Inactive',
            _buildActionButtons(
              onEdit: () => _showEditClusterHeadDialog(ch),
              onToggle: () => _toggleUserStatus(
                profile?['id'] as String?,
                profile?['is_active'] == true,
              ),
              isActive: profile?['is_active'] == true,
            ),
          ];
        }).toList(),
      ),
    );
  }

  // ─── FIELD AGENTS TAB ────────────────────────────────────────────────────

  Widget _buildFieldAgentsTab() {
    final filtered = _fieldAgents.where((fa) {
      if (_searchQuery.isEmpty) return true;
      return (fa['full_name'] as String? ?? '').toLowerCase().contains(
            _searchQuery,
          ) ||
          (fa['email'] as String? ?? '').toLowerCase().contains(_searchQuery);
    }).toList();

    if (filtered.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.person_search_rounded,
        title: 'No field agents found',
        subtitle: 'No field agents match your search criteria.',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AdminDataTable(
        columns: const [
          'Name',
          'Email',
          'Username',
          'Cluster',
          'Status',
          'Actions',
        ],
        rows: filtered.map((fa) {
          final assignments = fa['field_agent_cluster_assignments'] as List?;
          final activeAssign = assignments?.firstWhere(
            (a) => a['is_active'] == true,
            orElse: () => null,
          );
          final clusterName =
              activeAssign?['clusters']?['cluster_name'] as String? ?? '—';
          return [
            fa['full_name'] ?? '—',
            fa['email'] ?? '—',
            fa['username'] ?? '—',
            clusterName,
            fa['is_active'] == true ? 'Active' : 'Inactive',
            _buildActionButtons(
              onEdit: () => _showEditFieldAgentDialog(fa),
              onToggle: () => _toggleUserStatus(
                fa['id'] as String?,
                fa['is_active'] == true,
              ),
              isActive: fa['is_active'] == true,
            ),
          ];
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons({
    required VoidCallback onEdit,
    required VoidCallback onToggle,
    required bool isActive,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit_rounded, size: 16),
          tooltip: 'Edit',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: onToggle,
          icon: Icon(
            isActive ? Icons.block_rounded : Icons.check_circle_rounded,
            size: 16,
            color: isActive ? AppTheme.error : AppTheme.success,
          ),
          tooltip: isActive ? 'Deactivate' : 'Activate',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
        ),
      ],
    );
  }

  // ─── DIALOGS ─────────────────────────────────────────────────────────────

  void _showCreateDialog(int tabIndex) {
    final types = ['cluster', 'cluster_head', 'field_agent'];
    showDialog(
      context: context,
      builder: (_) => AdminCreateUserDialog(
        type: types[tabIndex],
        clusters: _clusters,
        onCreated: _loadAll,
      ),
    );
  }

  void _showEditClusterDialog(Map<String, dynamic> cluster) {
    showDialog(
      context: context,
      builder: (_) => AdminCreateUserDialog(
        type: 'cluster',
        clusters: _clusters,
        existingData: cluster,
        onCreated: _loadAll,
      ),
    );
  }

  void _showEditClusterHeadDialog(Map<String, dynamic> ch) {
    showDialog(
      context: context,
      builder: (_) => AdminCreateUserDialog(
        type: 'cluster_head',
        clusters: _clusters,
        existingData: ch,
        onCreated: _loadAll,
      ),
    );
  }

  void _showEditFieldAgentDialog(Map<String, dynamic> fa) {
    showDialog(
      context: context,
      builder: (_) => AdminCreateUserDialog(
        type: 'field_agent',
        clusters: _clusters,
        existingData: fa,
        onCreated: _loadAll,
      ),
    );
  }

  Future<void> _toggleClusterStatus(Map<String, dynamic> cluster) async {
    final isActive = cluster['is_active'] == true;
    final confirmed = await AdminConfirmDialog.show(
      context,
      title: isActive ? 'Deactivate Cluster' : 'Activate Cluster',
      message:
          'Are you sure you want to ${isActive ? 'deactivate' : 'activate'} "${cluster['cluster_name']}"?',
    );
    if (confirmed != true) return;
    try {
      await SupabaseService.instance.client
          .from('clusters')
          .update({'is_active': !isActive})
          .eq('id', cluster['id'] as String);
      _loadAll();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  Future<void> _toggleUserStatus(String? userId, bool isActive) async {
    if (userId == null) return;
    final confirmed = await AdminConfirmDialog.show(
      context,
      title: isActive ? 'Deactivate User' : 'Activate User',
      message:
          'Are you sure you want to ${isActive ? 'deactivate' : 'activate'} this user?',
    );
    if (confirmed != true) return;
    try {
      await SupabaseService.instance.client
          .from('user_profiles')
          .update({'is_active': !isActive})
          .eq('id', userId);
      _loadAll();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }
}

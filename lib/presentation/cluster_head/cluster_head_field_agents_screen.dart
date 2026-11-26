import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import '../admin/widgets/admin_data_table.dart';
import './cluster_head_shell.dart';

class ClusterHeadFieldAgentsScreen extends StatefulWidget {
  const ClusterHeadFieldAgentsScreen({super.key});

  @override
  State<ClusterHeadFieldAgentsScreen> createState() =>
      _ClusterHeadFieldAgentsScreenState();
}

class _ClusterHeadFieldAgentsScreenState
    extends State<ClusterHeadFieldAgentsScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _agents = [];

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

      final chRecord = await SupabaseService.instance.client
          .from('cluster_heads')
          .select('cluster_id')
          .eq('user_id', uid)
          .eq('is_active', true)
          .maybeSingle();

      if (chRecord == null) throw Exception('No cluster assignment');

      final clusterId = chRecord['cluster_id'] as String;
      final assignments = await SupabaseService.instance.client
          .from('field_agent_cluster_assignments')
          .select(
            'agent_id, user_profiles!agent_id(id, full_name, email, username, is_active)',
          )
          .eq('cluster_id', clusterId)
          .eq('is_active', true);

      if (mounted) {
        setState(() {
          _agents = List<Map<String, dynamic>>.from(assignments as List);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load field agents: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClusterHeadShell(
      selectedIndex: 1,
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
                  'Field Agents',
                  style: GoogleFonts.manrope(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${_agents.length} agents in your cluster',
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
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final isMobile = MediaQuery.of(context).size.width < 768;
    if (_agents.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.group_off_rounded,
        title: 'No Field Agents',
        subtitle: 'No field agents assigned to your cluster',
      );
    }
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : 24),
      child: AdminDataTable(
        columns: const ['Name', 'Email', 'Username', 'Status'],
        rows: _agents.map((a) {
          final profile = a['user_profiles'] as Map<String, dynamic>?;
          final isActive = profile?['is_active'] as bool? ?? true;
          return [
            profile?['full_name'] ?? '—',
            profile?['email'] ?? '—',
            profile?['username'] ?? '—',
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: isActive
                    ? AppTheme.successContainer
                    : AppTheme.errorContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isActive ? 'Active' : 'Inactive',
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppTheme.success : AppTheme.error,
                ),
              ),
            ),
          ];
        }).toList(),
      ),
    );
  }
}

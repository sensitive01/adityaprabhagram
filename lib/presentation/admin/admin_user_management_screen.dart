import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import './admin_shell.dart';
import './widgets/admin_confirm_dialog.dart';
import './widgets/admin_data_table.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() =>
      _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _users = [];
  String _filterRole = 'All';
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final _roles = ['All', 'ADMIN', 'CLUSTER_HEAD', 'FIELD_AGENT', 'HOUSEHOLD'];

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
      final data = await SupabaseService.instance.client
          .from('user_profiles')
          .select()
          .order('created_at', ascending: false);
      if (mounted) {
        setState(() {
          _users = List<Map<String, dynamic>>.from(data as List);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load users: $e';
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> get _filtered {
    return _users.where((u) {
      if (_filterRole != 'All' && u['role'] != _filterRole) return false;
      if (_searchQuery.isNotEmpty) {
        final name = (u['full_name'] as String? ?? '').toLowerCase();
        final email = (u['email'] as String? ?? '').toLowerCase();
        if (!name.contains(_searchQuery) && !email.contains(_searchQuery)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  Future<void> _toggleUserStatus(Map<String, dynamic> user) async {
    final isActive = user['is_active'] as bool? ?? true;
    final confirmed = await AdminConfirmDialog.show(
      context,
      title: isActive ? 'Deactivate User' : 'Activate User',
      message:
          'Are you sure you want to ${isActive ? 'deactivate' : 'activate'} "${user['full_name']}"?',
      isDangerous: isActive,
    );
    if (confirmed != true) return;
    try {
      await SupabaseService.instance.client
          .from('user_profiles')
          .update({'is_active': !isActive})
          .eq('id', user['id'] as String);
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedIndex: 10,
      child: Column(
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
                            'User Management',
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${_filtered.length} users',
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
                  onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
                  decoration: InputDecoration(
                    hintText: 'Search by name, email...',
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
                      'User Management',
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${_filtered.length} users',
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
                      hintText: 'Search by name, email...',
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
    final isMobile = MediaQuery.of(context).size.width < 768;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: 8,
      ),
      color: AppTheme.surfaceVariantLight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _roles.map<Widget>((r) {
            final isSelected = _filterRole == r;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  r,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => setState(() => _filterRole = r),
                selectedColor: AppTheme.primaryContainer,
                checkmarkColor: AppTheme.primary,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTable() {
    final rows = _filtered;
    if (rows.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.people_outline_rounded,
        title: 'No users found',
        subtitle: 'No users match the current filter or search criteria.',
      );
    }
    final isMobile = MediaQuery.of(context).size.width < 768;
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : 24),
      child: AdminDataTable(
        columns: const [
          'Name',
          'Email',
          'Username',
          'Role',
          'Status',
          'Actions',
        ],
        rows: rows.map((u) {
          final isActive = u['is_active'] as bool? ?? true;
          return [
            u['full_name'] ?? '—',
            u['email'] ?? '—',
            u['username'] ?? '—',
            _roleChip(u['role'] as String? ?? '—'),
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
            IconButton(
              onPressed: () => _toggleUserStatus(u),
              icon: Icon(
                isActive ? Icons.block_rounded : Icons.check_circle_rounded,
                size: 16,
                color: isActive ? AppTheme.error : AppTheme.success,
              ),
              tooltip: isActive ? 'Deactivate' : 'Activate',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
          ];
        }).toList(),
      ),
    );
  }

  Widget _roleChip(String role) {
    Color color;
    switch (role) {
      case 'ADMIN':
        color = AppTheme.error;
        break;
      case 'CLUSTER_HEAD':
        color = AppTheme.info;
        break;
      case 'FIELD_AGENT':
        color = AppTheme.secondary;
        break;
      case 'HOUSEHOLD':
        color = AppTheme.warning;
        break;
      default:
        color = AppTheme.statusDraft;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(31),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        role,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

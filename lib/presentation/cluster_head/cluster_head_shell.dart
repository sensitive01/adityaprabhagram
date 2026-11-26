import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';

class ClusterHeadShell extends StatefulWidget {
  final Widget child;
  final int selectedIndex;

  const ClusterHeadShell({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  @override
  State<ClusterHeadShell> createState() => _ClusterHeadShellState();
}

class _ClusterHeadShellState extends State<ClusterHeadShell> {
  bool _sidebarCollapsed = false;
  String _chName = 'Cluster Head';
  String _clusterName = '';

  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.dashboard_rounded,
      label: 'Dashboard',
      route: AppRoutes.clusterHeadDashboard,
    ),
    _NavItem(
      icon: Icons.badge_rounded,
      label: 'Field Agents',
      route: AppRoutes.clusterHeadFieldAgents,
    ),
    _NavItem(
      icon: Icons.home_work_rounded,
      label: 'Households',
      route: AppRoutes.clusterHeadHouseholds,
    ),
    _NavItem(
      icon: Icons.assignment_rounded,
      label: 'Surveys',
      route: AppRoutes.clusterHeadSurveys,
    ),
    _NavItem(
      icon: Icons.help_outline_rounded,
      label: 'HH Questions',
      route: AppRoutes.clusterHeadQuestions,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await SupabaseService.instance.fetchCurrentUserProfile();
    if (mounted && profile != null) {
      setState(
        () => _chName = profile['full_name'] as String? ?? 'Cluster Head',
      );
    }
    // Load cluster name
    try {
      final uid = SupabaseService.instance.currentUser?.id;
      if (uid != null) {
        final ch = await SupabaseService.instance.client
            .from('cluster_heads')
            .select('clusters(cluster_name)')
            .eq('user_id', uid)
            .eq('is_active', true)
            .maybeSingle();
        if (mounted && ch != null) {
          final cluster = ch['clusters'] as Map<String, dynamic>?;
          setState(
            () => _clusterName = cluster?['cluster_name'] as String? ?? '',
          );
        }
      }
    } catch (_) {}
  }

  Future<void> _handleLogout() async {
    await SupabaseService.instance.signOut();
    if (mounted) context.go(AppRoutes.signUpLoginScreen);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(
          backgroundColor: const Color(0xFF1D4ED8),
          elevation: 0,
          title: Text(
            _clusterName.isNotEmpty ? _clusterName : 'Cluster Head Portal',
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
              tooltip: 'Navigation Menu',
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.white.withAlpha(51),
                  child: Text(
                    _chName.isNotEmpty ? _chName[0].toUpperCase() : 'C',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: _handleLogout,
              icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 20),
              tooltip: 'Logout',
            ),
          ],
        ),
        drawer: Drawer(
          child: _buildSidebar(isDrawer: true),
        ),
        body: widget.child,
      );
    }

    final sidebarWidth = _sidebarCollapsed ? 64.0 : 240.0;
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: sidebarWidth,
            child: _buildSidebar(isDrawer: false),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildSidebar({bool isDrawer = false}) {
    return Container(
      color: const Color(0xFF1D4ED8), // Blue for Cluster Head
      child: SafeArea(
        child: Column(
          children: [
            _buildSidebarHeader(isDrawer: isDrawer),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _navItems.length,
                itemBuilder: (context, i) =>
                    _buildNavTile(_navItems[i], i, isDrawer: isDrawer),
              ),
            ),
            _buildSidebarFooter(isDrawer: isDrawer),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarHeader({bool isDrawer = false}) {
    final collapsed = isDrawer ? false : _sidebarCollapsed;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withAlpha(38))),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.supervisor_account_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          if (!collapsed) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AdityaPrabhaGram',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _clusterName.isNotEmpty ? _clusterName : 'Cluster Head',
                    style: GoogleFonts.manrope(
                      color: Colors.white.withAlpha(179),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
          if (!isDrawer)
            IconButton(
              onPressed: () =>
                  setState(() => _sidebarCollapsed = !_sidebarCollapsed),
              icon: Icon(
                _sidebarCollapsed
                    ? Icons.chevron_right_rounded
                    : Icons.chevron_left_rounded,
                color: Colors.white.withAlpha(204),
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
        ],
      ),
    );
  }

  Widget _buildNavTile(_NavItem item, int index, {bool isDrawer = false}) {
    final isSelected = widget.selectedIndex == index;
    final collapsed = isDrawer ? false : _sidebarCollapsed;
    return Tooltip(
      message: collapsed ? item.label : '',
      child: InkWell(
        onTap: () {
          if (isDrawer) Navigator.of(context).pop();
          context.go(item.route);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withAlpha(46) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: isSelected ? Colors.white : Colors.white.withAlpha(166),
                size: 20,
              ),
              if (!collapsed) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: GoogleFonts.manrope(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withAlpha(191),
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarFooter({bool isDrawer = false}) {
    final collapsed = isDrawer ? false : _sidebarCollapsed;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withAlpha(38))),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white.withAlpha(51),
            child: Text(
              _chName.isNotEmpty ? _chName[0].toUpperCase() : 'C',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (!collapsed) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _chName,
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: _handleLogout,
              icon: Icon(
                Icons.logout_rounded,
                color: Colors.white.withAlpha(179),
                size: 18,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              tooltip: 'Logout',
            ),
          ],
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

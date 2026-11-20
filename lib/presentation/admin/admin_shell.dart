import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/app_routes.dart';
import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';

class AdminShell extends StatefulWidget {
  final Widget child;
  final int selectedIndex;

  const AdminShell({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  bool _sidebarCollapsed = false;
  String _adminName = 'Admin';

  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.dashboard_rounded,
      label: 'Dashboard',
      route: AppRoutes.adminDashboard,
    ),
    _NavItem(
      icon: Icons.hub_rounded,
      label: 'Clusters',
      route: AppRoutes.adminClusters,
    ),
    _NavItem(
      icon: Icons.manage_accounts_rounded,
      label: 'Cluster Heads',
      route: AppRoutes.adminClusterHeads,
    ),
    _NavItem(
      icon: Icons.badge_rounded,
      label: 'Field Agents',
      route: AppRoutes.adminFieldAgents,
    ),
    _NavItem(
      icon: Icons.home_work_rounded,
      label: 'Households',
      route: AppRoutes.adminHouseholds,
    ),
    _NavItem(
      icon: Icons.assignment_rounded,
      label: 'Surveys',
      route: AppRoutes.adminSurveys,
    ),
    _NavItem(
      icon: Icons.quiz_rounded,
      label: 'Survey Questions',
      route: AppRoutes.adminSurveyQuestions,
    ),
    _NavItem(
      icon: Icons.campaign_rounded,
      label: 'Bulletins',
      route: AppRoutes.adminBulletins,
    ),
    _NavItem(
      icon: Icons.help_outline_rounded,
      label: 'HH Questions',
      route: AppRoutes.adminHouseholdQuestions,
    ),
    _NavItem(
      icon: Icons.analytics_rounded,
      label: 'Reports',
      route: AppRoutes.adminReports,
    ),
    _NavItem(
      icon: Icons.people_rounded,
      label: 'User Management',
      route: AppRoutes.adminUserManagement,
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
      setState(() {
        _adminName = profile['full_name'] as String? ?? 'Admin';
      });
    }
  }

  Future<void> _handleLogout() async {
    await SupabaseService.instance.signOut();
    if (mounted) context.go(AppRoutes.signUpLoginScreen);
  }

  @override
  Widget build(BuildContext context) {
    final sidebarWidth = _sidebarCollapsed ? 64.0 : 240.0;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: sidebarWidth,
            child: _buildSidebar(sidebarWidth),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildSidebar(double width) {
    return Container(
      color: AppTheme.primary,
      child: Column(
        children: [
          _buildSidebarHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _navItems.length,
              itemBuilder: (context, i) => _buildNavTile(_navItems[i], i),
            ),
          ),
          _buildSidebarFooter(),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
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
              Icons.admin_panel_settings_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          if (!_sidebarCollapsed) ...[
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
                    'Admin Panel',
                    style: GoogleFonts.manrope(
                      color: Colors.white.withAlpha(179),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  Widget _buildNavTile(_NavItem item, int index) {
    final isSelected = widget.selectedIndex == index;
    return Tooltip(
      message: _sidebarCollapsed ? item.label : '',
      child: InkWell(
        onTap: () => context.go(item.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: EdgeInsets.symmetric(
            horizontal: _sidebarCollapsed ? 12 : 12,
            vertical: 10,
          ),
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
              if (!_sidebarCollapsed) ...[
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

  Widget _buildSidebarFooter() {
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
              _adminName.isNotEmpty ? _adminName[0].toUpperCase() : 'A',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (!_sidebarCollapsed) ...[
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _adminName,
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

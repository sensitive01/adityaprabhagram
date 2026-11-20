import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/sign_up_login_screen/sign_up_login_screen.dart';
import '../presentation/assigned_households_screen/assigned_households_screen.dart';
import '../presentation/household_dashboard_screen/household_dashboard_screen.dart';
import '../presentation/survey_screen/survey_screen.dart';
import '../presentation/admin/admin_dashboard_screen.dart';
import '../presentation/admin/admin_management_screen.dart';
import '../presentation/admin/admin_households_screen.dart';
import '../presentation/admin/admin_surveys_screen.dart';
import '../presentation/admin/admin_survey_questions_screen.dart';
import '../presentation/admin/admin_bulletins_screen.dart';
import '../presentation/admin/admin_household_questions_screen.dart';
import '../presentation/admin/admin_reports_screen.dart';
import '../presentation/admin/admin_user_management_screen.dart';
import '../presentation/cluster_head/cluster_head_dashboard_screen.dart';
import '../presentation/cluster_head/cluster_head_field_agents_screen.dart';
import '../presentation/cluster_head/cluster_head_households_screen.dart';
import '../presentation/cluster_head/cluster_head_surveys_screen.dart';
import '../presentation/cluster_head/cluster_head_questions_screen.dart';
import '../services/supabase_service.dart';

class AppRoutes {
  static const String initial = '/';
  static const String signUpLoginScreen = '/sign-up-login-screen';
  static const String assignedHouseholdsScreen = '/assigned-households';
  static const String householdDashboardScreen = '/household-dashboard';
  static const String surveyScreen = '/survey-screen';

  // Admin routes
  static const String adminDashboard = '/admin/dashboard';
  static const String adminClusters = '/admin/clusters';
  static const String adminClusterHeads = '/admin/cluster-heads';
  static const String adminFieldAgents = '/admin/field-agents';
  static const String adminHouseholds = '/admin/households';
  static const String adminSurveys = '/admin/surveys';
  static const String adminSurveyQuestions = '/admin/survey-questions';
  static const String adminBulletins = '/admin/bulletins';
  static const String adminHouseholdQuestions = '/admin/household-questions';
  static const String adminReports = '/admin/reports';
  static const String adminUserManagement = '/admin/users';

  // Cluster Head routes
  static const String clusterHeadDashboard = '/cluster-head/dashboard';
  static const String clusterHeadFieldAgents = '/cluster-head/field-agents';
  static const String clusterHeadHouseholds = '/cluster-head/households';
  static const String clusterHeadSurveys = '/cluster-head/surveys';
  static const String clusterHeadQuestions = '/cluster-head/questions';
}

/// Route guard: redirect unauthenticated users to login.
String? _routeGuard(GoRouterState state) {
  final isSignedIn = SupabaseService.instance.isSignedIn;
  final path = state.matchedLocation;

  // Always allow login screen
  if (path == AppRoutes.initial || path == AppRoutes.signUpLoginScreen) {
    return null;
  }

  // Not signed in → go to login
  if (!isSignedIn) {
    return AppRoutes.signUpLoginScreen;
  }

  return null; // Allow — role-specific checks happen in each screen's initState
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.initial,
  redirect: (context, state) => _routeGuard(state),
  routes: [
    GoRoute(
      path: AppRoutes.initial,
      pageBuilder: (context, state) => _fadePage(const SignUpLoginScreen()),
    ),
    GoRoute(
      path: AppRoutes.signUpLoginScreen,
      pageBuilder: (context, state) => _fadePage(const SignUpLoginScreen()),
    ),
    GoRoute(
      path: AppRoutes.assignedHouseholdsScreen,
      pageBuilder: (context, state) =>
          _slidePage(const AssignedHouseholdsScreen()),
    ),
    GoRoute(
      path: AppRoutes.householdDashboardScreen,
      pageBuilder: (context, state) =>
          _slidePage(const HouseholdDashboardScreen()),
    ),
    GoRoute(
      path: AppRoutes.surveyScreen,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return _slidePage(
          SurveyScreen(
            householdId: (extra?['householdId'] as String?) ?? '',
            householdName: (extra?['householdName'] as String?) ?? '',
            surveyId: extra?['surveyId'] as String?,
            surveyMode: (extra?['surveyMode'] as String?) ?? 'start',
            isHouseholdView: (extra?['isHouseholdView'] as bool?) ?? false,
          ),
        );
      },
    ),
    // Admin routes
    GoRoute(
      path: AppRoutes.adminDashboard,
      pageBuilder: (context, state) => _fadePage(const AdminDashboardScreen()),
    ),
    GoRoute(
      path: AppRoutes.adminClusters,
      pageBuilder: (context, state) =>
          _fadePage(const AdminManagementScreen(initialTab: 0)),
    ),
    GoRoute(
      path: AppRoutes.adminClusterHeads,
      pageBuilder: (context, state) =>
          _fadePage(const AdminManagementScreen(initialTab: 1)),
    ),
    GoRoute(
      path: AppRoutes.adminFieldAgents,
      pageBuilder: (context, state) =>
          _fadePage(const AdminManagementScreen(initialTab: 2)),
    ),
    GoRoute(
      path: AppRoutes.adminHouseholds,
      pageBuilder: (context, state) => _fadePage(const AdminHouseholdsScreen()),
    ),
    GoRoute(
      path: AppRoutes.adminSurveys,
      pageBuilder: (context, state) => _fadePage(const AdminSurveysScreen()),
    ),
    GoRoute(
      path: AppRoutes.adminSurveyQuestions,
      pageBuilder: (context, state) =>
          _fadePage(const AdminSurveyQuestionsScreen()),
    ),
    GoRoute(
      path: AppRoutes.adminBulletins,
      pageBuilder: (context, state) => _fadePage(const AdminBulletinsScreen()),
    ),
    GoRoute(
      path: AppRoutes.adminHouseholdQuestions,
      pageBuilder: (context, state) =>
          _fadePage(const AdminHouseholdQuestionsScreen()),
    ),
    GoRoute(
      path: AppRoutes.adminReports,
      pageBuilder: (context, state) => _fadePage(const AdminReportsScreen()),
    ),
    GoRoute(
      path: AppRoutes.adminUserManagement,
      pageBuilder: (context, state) =>
          _fadePage(const AdminUserManagementScreen()),
    ),
    // Cluster Head routes
    GoRoute(
      path: AppRoutes.clusterHeadDashboard,
      pageBuilder: (context, state) =>
          _fadePage(const ClusterHeadDashboardScreen()),
    ),
    GoRoute(
      path: AppRoutes.clusterHeadFieldAgents,
      pageBuilder: (context, state) =>
          _fadePage(const ClusterHeadFieldAgentsScreen()),
    ),
    GoRoute(
      path: AppRoutes.clusterHeadHouseholds,
      pageBuilder: (context, state) =>
          _fadePage(const ClusterHeadHouseholdsScreen()),
    ),
    GoRoute(
      path: AppRoutes.clusterHeadSurveys,
      pageBuilder: (context, state) =>
          _fadePage(const ClusterHeadSurveysScreen()),
    ),
    GoRoute(
      path: AppRoutes.clusterHeadQuestions,
      pageBuilder: (context, state) =>
          _fadePage(const ClusterHeadQuestionsScreen()),
    ),
  ],
);

CustomTransitionPage<void> _fadePage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 220),
  );
}

CustomTransitionPage<void> _slidePage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero)
            .animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    transitionDuration: const Duration(milliseconds: 250),
  );
}

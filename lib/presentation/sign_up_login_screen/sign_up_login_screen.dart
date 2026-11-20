import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../routes/app_routes.dart';
import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import './widgets/login_form_widget.dart';

class SignUpLoginScreen extends StatefulWidget {
  const SignUpLoginScreen({super.key});

  @override
  State<SignUpLoginScreen> createState() => _SignUpLoginScreenState();
}

class _SignUpLoginScreenState extends State<SignUpLoginScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;

  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );
    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));
    _logoController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Authenticate with Supabase
      final response = await SupabaseService.instance.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (response.user == null) {
        _showError('Login failed. Please check your credentials.');
        return;
      }

      // 2. Fetch the actual role from the database — this is authoritative
      final role = await SupabaseService.instance.fetchCurrentUserRole();

      if (!mounted) return;

      if (role == null) {
        _showError('Unable to determine account role. Please try again.');
        await SupabaseService.instance.signOut();
        return;
      }

      // 3. Route based on actual DB role
      if (role == 'FIELD_AGENT') {
        context.go(AppRoutes.assignedHouseholdsScreen);
      } else if (role == 'HOUSEHOLD') {
        context.go(AppRoutes.householdDashboardScreen);
      } else if (role == 'ADMIN') {
        context.go(AppRoutes.adminDashboard);
      } else if (role == 'CLUSTER_HEAD') {
        context.go(AppRoutes.clusterHeadDashboard);
      } else {
        _showError('Unknown account role. Please contact support.');
        await SupabaseService.instance.signOut();
      }
   
} on AuthException catch (e) {
  final errorText = e.message.toLowerCase();

  final isNetworkError =
      errorText.contains('socketexception') ||
      errorText.contains('failed host lookup') ||
      errorText.contains('clientexception') ||
      errorText.contains('connection refused') ||
      errorText.contains('network is unreachable');

  if (isNetworkError) {
    _showError(
      'No internet connection. Please connect to the internet to sign in.',
    );
  } else {
    _showError(e.message);
}
} catch (e) {
  final errorText = e.toString().toLowerCase();

  final isNetworkError =
      errorText.contains('socketexception') ||
      errorText.contains('failed host lookup') ||
      errorText.contains('clientexception') ||
      errorText.contains('connection refused') ||
      errorText.contains('network is unreachable');

  if (isNetworkError) {
    _showError(
      'No internet connection. Please connect to the internet to sign in.',
    );
  } else {
    _showError('Login failed. Please try again.');
  }
} finally {

      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: AppTheme.error,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 600;
            return isWide
                ? _buildWideLayout(Theme.of(context))
                : _buildNarrowLayout(Theme.of(context));
          },
        ),
      ),
    );
  }

  Widget _buildNarrowLayout(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          _buildLogoSection(theme),
          const SizedBox(height: 32),
          _buildLoginCard(theme),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildWideLayout(ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLogoSection(theme),
              const SizedBox(height: 40),
              _buildLoginCard(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcome Back',
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Sign in to your account to continue',
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          LoginFormWidget(
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
            obscurePassword: _obscurePassword,
            onTogglePassword: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            isLoading: _isLoading,
            onSubmit: _handleLogin,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection(ThemeData theme) {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Opacity(
          opacity: _logoOpacity.value,
          child: Transform.scale(scale: _logoScale.value, child: child),
        );
      },
      child: Column(
        children: [
          Image.asset(
            'assets/images/APGLogo-1786950630397.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
            semanticLabel:
                'Aditya Prabha Gram and Central Agricultural University logos',
          ),
          const SizedBox(height: 16),
          Text(
            'AdityaPrabhaGram',
            style: GoogleFonts.manrope(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Fostering Agricultural Harmony In Border Communities',
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class LoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final bool isLoading;
  final VoidCallback onSubmit;

  const LoginFormWidget({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email Address',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => onSubmit(),
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: onTogglePassword,
                  ),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              ),
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: isLoading ? null : onSubmit,
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: AppTheme.primary.withAlpha(153),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Sign In',
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

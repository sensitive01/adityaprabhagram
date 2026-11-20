import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../theme/app_theme.dart';

class DemoCredentialsWidget extends StatelessWidget {
  final List<Map<String, String>> credentials;
  final int selectedRole;
  final ValueChanged<int> onFill;

  const DemoCredentialsWidget({
    super.key,
    required this.credentials,
    required this.selectedRole,
    required this.onFill,
  });

  void _copyToClipboard(String value, String label) {
    Clipboard.setData(ClipboardData(text: value));
    Fluttertoast.showToast(
      msg: '$label copied',
      backgroundColor: AppTheme.primary,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withAlpha(102),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withAlpha(38)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AppTheme.primary,
              ),
              const SizedBox(width: 6),
              Text(
                'Demo Credentials',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...List.generate(credentials.length, (index) {
            final cred = credentials[index];
            final isSelected = index == selectedRole;
            return GestureDetector(
              onTap: () => onFill(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary.withAlpha(20)
                      : Colors.white.withAlpha(128),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primary.withAlpha(77)
                        : Colors.transparent,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            cred['role']!,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Tap to fill',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: AppTheme.primary.withAlpha(153),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _CredentialRow(
                      label: 'Email',
                      value: cred['email']!,
                      onCopy: () => _copyToClipboard(cred['email']!, 'Email'),
                    ),
                    const SizedBox(height: 4),
                    _CredentialRow(
                      label: 'Password',
                      value: cred['password']!,
                      onCopy: () =>
                          _copyToClipboard(cred['password']!, 'Password'),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CredentialRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onCopy;

  const _CredentialRow({
    required this.label,
    required this.value,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF6B7280),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A1A),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        InkWell(
          onTap: onCopy,
          borderRadius: BorderRadius.circular(4),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(Icons.copy_rounded, size: 14, color: AppTheme.primary),
          ),
        ),
      ],
    );
  }
}

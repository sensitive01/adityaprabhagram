import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class RoleSelectorWidget extends StatelessWidget {
  final List<String> roles;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const RoleSelectorWidget({
    super.key,
    required this.roles,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sign in as',
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: List.generate(roles.length, (index) {
              final isSelected = index == selectedIndex;
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppTheme.primary.withAlpha(64),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: InkWell(
                    onTap: () => onChanged(index),
                    borderRadius: BorderRadius.circular(9),
                    splashColor: AppTheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            index == 0
                                ? Icons.admin_panel_settings_outlined
                                : Icons.groups_outlined,
                            size: 16,
                            color: isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            roles[index],
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

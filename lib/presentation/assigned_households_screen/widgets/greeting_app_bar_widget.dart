import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class GreetingAppBarWidget extends StatelessWidget {
  final String agentName;
  final String avatarUrl;
  final String avatarSemanticLabel;
  final int notificationCount;
  final VoidCallback? onLogout;

  const GreetingAppBarWidget({
    super.key,
    required this.agentName,
    required this.avatarUrl,
    required this.avatarSemanticLabel,
    this.notificationCount = 0,
    this.onLogout,
  });

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _greeting,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  agentName,
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.badge_outlined,
                      color: AppTheme.primary,
                      size: 13,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Field Agent · Nashik District',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Icon(
                    Icons.notifications_outlined,
                    size: 22,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (notificationCount > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        notificationCount > 9
                            ? '9+'
                            : notificationCount.toString(),
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomImageWidget(
              imageUrl: avatarUrl,
              width: 42,
              height: 42,
              fit: BoxFit.cover,
              semanticLabel: avatarSemanticLabel,
            ),
          ),
          if (onLogout != null) ...[
            const SizedBox(width: 10),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: onLogout,
                borderRadius: BorderRadius.circular(12),
                child: Icon(
                  Icons.logout_rounded,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

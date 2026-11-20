import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/status_badge_widget.dart';
import '../assigned_households_screen.dart';

class HouseholdCardWidget extends StatefulWidget {
  final HouseholdModel household;
  final VoidCallback onTap;
  final Duration animationDelay;

  const HouseholdCardWidget({
    super.key,
    required this.household,
    required this.onTap,
    this.animationDelay = Duration.zero,
  });

  @override
  State<HouseholdCardWidget> createState() => _HouseholdCardWidgetState();
}

class _HouseholdCardWidgetState extends State<HouseholdCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(widget.animationDelay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final h = widget.household;
    final hasCorrectionReason =
        h.surveyStatus == SurveyStatus.correctionRequired &&
        h.rejectionReason != null;

    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: h.surveyStatus == SurveyStatus.correctionRequired
                ? Border.all(
                    color: AppTheme.statusCorrection.withAlpha(102),
                    width: 1.5,
                  )
                : Border.all(color: theme.colorScheme.outline.withAlpha(51)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            splashColor: AppTheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CustomImageWidget(
                          imageUrl: h.avatarUrl,
                          width: 44,
                          height: 44,
                          fit: BoxFit.cover,
                          semanticLabel: h.avatarSemanticLabel,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              h.name,
                              style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              h.headName,
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatusBadgeWidget(status: h.surveyStatus.label),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _MetaChip(
                        icon: Icons.location_on_outlined,
                        label: '${h.village}, ${h.district}',
                      ),
                      const SizedBox(width: 8),
                      _MetaChip(
                        icon: Icons.people_outline_rounded,
                        label: '${h.membersCount} members',
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _MetaChip(
                        icon: Icons.calendar_today_outlined,
                        label: 'Last: ${h.lastSurveyDate}',
                      ),
                      const SizedBox(width: 8),
                      _MetaChip(
                        icon: Icons.tag_rounded,
                        label: h.id,
                        isMonospace: true,
                      ),
                    ],
                  ),
                  if (hasCorrectionReason) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.statusCorrectionContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            size: 14,
                            color: AppTheme.statusCorrection,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              h.rejectionReason!,
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.statusCorrection,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 38,
                          child: FilledButton.icon(
                            onPressed: widget.onTap,
                            style: FilledButton.styleFrom(
                              backgroundColor: _actionBgColor(h.surveyStatus),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: Icon(_actionIcon(h.surveyStatus), size: 16),
                            label: Text(
                              _actionLabel(h.surveyStatus),
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(10),
                          child: Icon(
                            Icons.map_outlined,
                            size: 18,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _actionBgColor(SurveyStatus status) {
    switch (status) {
      case SurveyStatus.noSurvey:
        return AppTheme.primary;
      case SurveyStatus.draft:
        return AppTheme.primary;
      case SurveyStatus.correctionRequired:
        return AppTheme.statusCorrection;
      case SurveyStatus.approved:
        return AppTheme.statusApproved;
      default:
        return AppTheme.statusDraft;
    }
  }

  IconData _actionIcon(SurveyStatus status) {
    switch (status) {
      case SurveyStatus.noSurvey:
        return Icons.add_circle_outline_rounded;
      case SurveyStatus.draft:
        return Icons.play_arrow_rounded;
      case SurveyStatus.correctionRequired:
        return Icons.edit_rounded;
      case SurveyStatus.approved:
        return Icons.check_circle_outline_rounded;
      case SurveyStatus.submitted:
        return Icons.hourglass_top_rounded;
      case SurveyStatus.underReview:
        return Icons.rate_review_outlined;
    }
  }

  String _actionLabel(SurveyStatus status) {
    switch (status) {
      case SurveyStatus.noSurvey:
        return 'Start Survey';
      case SurveyStatus.draft:
        return 'Resume Survey';
      case SurveyStatus.correctionRequired:
        return 'Fix & Resubmit';
      case SurveyStatus.approved:
        return 'View Survey';
      case SurveyStatus.submitted:
        return 'Awaiting Review';
      case SurveyStatus.underReview:
        return 'Under Review';
    }
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isMonospace;

  const _MetaChip({
    required this.icon,
    required this.label,
    this.isMonospace = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 3),
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 11,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

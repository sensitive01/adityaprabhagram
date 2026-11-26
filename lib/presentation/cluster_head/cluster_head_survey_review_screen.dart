import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/status_badge_widget.dart';

/// Survey review detail screen for Cluster Head — approve or request correction
class ClusterHeadSurveyReviewScreen extends StatefulWidget {
  final Map<String, dynamic> survey;
  final VoidCallback onBack;
  final VoidCallback onUpdated;

  const ClusterHeadSurveyReviewScreen({
    super.key,
    required this.survey,
    required this.onBack,
    required this.onUpdated,
  });

  @override
  State<ClusterHeadSurveyReviewScreen> createState() =>
      _ClusterHeadSurveyReviewScreenState();
}

class _ClusterHeadSurveyReviewScreenState
    extends State<ClusterHeadSurveyReviewScreen> {
  bool _isSubmitting = false;
  final _correctionCtrl = TextEditingController();
  bool _showCorrectionField = false;

  @override
  void dispose() {
    _correctionCtrl.dispose();
    super.dispose();
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'draft':
        return 'Draft';
      case 'submitted':
        return 'Submitted';
      case 'under_review':
        return 'Under Review';
      case 'correction_required':
        return 'Correction Required';
      case 'approved':
        return 'Approved';
      default:
        return s;
    }
  }

  Future<void> _updateStatus(
    String newStatus, {
    String? rejectionReason,
  }) async {
    setState(() => _isSubmitting = true);
    try {
      final uid = SupabaseService.instance.currentUser?.id;
      final updateData = <String, dynamic>{
        'status': newStatus,
        'reviewed_by': uid,
        'reviewed_at': DateTime.now().toIso8601String(),
      };
      if (rejectionReason != null) {
        updateData['rejection_reason'] = rejectionReason;
      }
      if (newStatus == 'approved') {
        updateData['approved_at'] = DateTime.now().toIso8601String();
      }

      await SupabaseService.instance.client
          .from('surveys')
          .update(updateData)
          .eq('id', widget.survey['id'] as String);

      if (mounted) widget.onUpdated();
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.survey;
    final hh = s['households'] as Map<String, dynamic>?;
    final agent = s['user_profiles'] as Map<String, dynamic>?;
    final status = s['status'] as String? ?? 'draft';
    final responses = s['responses'] as Map<String, dynamic>?;
    final rejectionReason = s['rejection_reason'] as String?;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Column(
      children: [
        _buildTopBar(hh, status, isMobile),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 12 : 24),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInfoCard(hh, agent, status, rejectionReason),
                      const SizedBox(height: 16),
                      _buildActionCard(status),
                      const SizedBox(height: 16),
                      _buildResponsesCard(responses),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoCard(hh, agent, status, rejectionReason),
                            const SizedBox(height: 16),
                            _buildResponsesCard(responses),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(width: 300, child: _buildActionCard(status)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(Map<String, dynamic>? hh, String status, bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: isMobile ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        border: Border(bottom: BorderSide(color: const Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onBack,
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Back to Surveys',
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Survey Review — ${hh?['hh_id'] ?? '—'}',
                  style: GoogleFonts.manrope(
                    fontSize: isMobile ? 15 : 18,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  hh?['name'] as String? ?? '—',
                  style: GoogleFonts.manrope(
                    fontSize: isMobile ? 11 : 13,
                    color: const Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          StatusBadgeWidget(status: _statusLabel(status)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    Map<String, dynamic>? hh,
    Map<String, dynamic>? agent,
    String status,
    String? rejectionReason,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Survey Information',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _infoRow('HH_ID', hh?['hh_id'] ?? '—'),
          _infoRow('Household', hh?['name'] ?? '—'),
          _infoRow('Village', hh?['village'] ?? '—'),
          _infoRow('Field Agent', agent?['full_name'] ?? '—'),
          _infoRow('Status', _statusLabel(status)),
          if (rejectionReason != null && rejectionReason.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.warningContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Correction Reason',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.warning,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rejectionReason,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      color: AppTheme.warning,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResponsesCard(Map<String, dynamic>? responses) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Survey Responses',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (responses == null || responses.isEmpty)
            Text(
              'No responses recorded',
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: const Color(0xFF9CA3AF),
              ),
            )
          else
            ...responses.entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        e.key,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        '${e.value}',
                        style: GoogleFonts.manrope(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String status) {
    final canReview =
        status == 'submitted' ||
        status == 'under_review' ||
        status == 'correction_required';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review Actions',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          if (!canReview)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariantLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status == 'approved'
                    ? 'This survey has been approved.'
                    : 'This survey is in draft state and cannot be reviewed yet.',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: const Color(0xFF6B7280),
                ),
              ),
            )
          else ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isSubmitting
                    ? null
                    : () => _updateStatus('approved'),
                icon: const Icon(Icons.check_circle_rounded, size: 18),
                label: Text('Approve Survey', style: GoogleFonts.manrope()),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.success,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isSubmitting
                    ? null
                    : () => setState(
                        () => _showCorrectionField = !_showCorrectionField,
                      ),
                icon: const Icon(Icons.warning_rounded, size: 18),
                label: Text('Request Correction', style: GoogleFonts.manrope()),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.warning,
                  side: BorderSide(color: AppTheme.warning),
                ),
              ),
            ),
            if (_showCorrectionField) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _correctionCtrl,
                decoration: InputDecoration(
                  labelText: 'Correction instructions *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: 'Explain what needs to be corrected...',
                ),
                style: GoogleFonts.manrope(fontSize: 13),
                maxLines: 4,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          if (_correctionCtrl.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter correction instructions',
                                ),
                              ),
                            );
                            return;
                          }
                          _updateStatus(
                            'correction_required',
                            rejectionReason: _correctionCtrl.text.trim(),
                          );
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.warning,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Send for Correction',
                          style: GoogleFonts.manrope(),
                        ),
                ),
              ),
            ],
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isSubmitting
                    ? null
                    : () => _updateStatus('under_review'),
                icon: const Icon(Icons.rate_review_rounded, size: 18),
                label: Text('Mark Under Review', style: GoogleFonts.manrope()),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

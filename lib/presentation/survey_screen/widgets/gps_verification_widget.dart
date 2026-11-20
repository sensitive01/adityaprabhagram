import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class GpsVerificationWidget extends StatelessWidget {
  final bool isVerifying;
  final VoidCallback onVerify;

  const GpsVerificationWidget({
    super.key,
    required this.isVerifying,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.warningContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.warning.withAlpha(77)),
      ),
      child: Row(
        children: [
          isVerifying
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.warning,
                  ),
                )
              : const Icon(
                  Icons.gps_fixed_rounded,
                  size: 18,
                  color: AppTheme.warning,
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isVerifying
                      ? 'Verifying your location...'
                      : 'GPS Verification Required',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.warning,
                  ),
                ),
                if (!isVerifying)
                  Text(
                    'Verify you are at the household location before starting',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: AppTheme.warning.withAlpha(204),
                    ),
                  ),
              ],
            ),
          ),
          if (!isVerifying) ...[
            const SizedBox(width: 8),
            SizedBox(
              height: 32,
              child: FilledButton(
                onPressed: onVerify,
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.warning,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Verify',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

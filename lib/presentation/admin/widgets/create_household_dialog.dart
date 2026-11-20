import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/supabase_service.dart';
import '../../../theme/app_theme.dart';

/// Dialog for creating a new Household.
/// - Admin: can select any active cluster from the dropdown.
/// - Cluster Head: cluster is preselected and locked (cannot change).
class CreateHouseholdDialog extends StatefulWidget {
  /// List of active clusters to populate the dropdown.
  final List<Map<String, dynamic>> clusters;

  /// If non-null, the cluster is preselected and the dropdown is disabled.
  /// Used for Cluster Head role.
  final String? lockedClusterId;

  /// Called after successful creation so the parent can refresh its list.
  final VoidCallback onCreated;

  const CreateHouseholdDialog({
    super.key,
    required this.clusters,
    this.lockedClusterId,
    required this.onCreated,
  });

  @override
  State<CreateHouseholdDialog> createState() => _CreateHouseholdDialogState();
}

class _CreateHouseholdDialogState extends State<CreateHouseholdDialog> {
  final _formKey = GlobalKey<FormState>();
  final _hhIdCtrl = TextEditingController();
  String? _selectedClusterId;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Preselect the locked cluster (Cluster Head) or leave null (Admin).
    _selectedClusterId = widget.lockedClusterId;
  }

  @override
  void dispose() {
    _hhIdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final client = SupabaseService.instance.client;

      // Resolve the selected cluster record from the provided list.
      final clusterRecord = widget.clusters.firstWhere(
        (c) => c['id'] == _selectedClusterId,
        orElse: () => {},
      );

      // Validate that all required legacy fields are present.
      final clusterCode = clusterRecord['cluster_code'] as String?;
      final clusterName = clusterRecord['cluster_name'] as String?;
      final district = clusterRecord['district'] as String?;
      final state = clusterRecord['state'] as String?;

      if (clusterCode == null ||
          clusterCode.isEmpty ||
          clusterName == null ||
          clusterName.isEmpty ||
          district == null ||
          district.isEmpty) {
        setState(() {
          _error =
              'The selected cluster is missing required information (cluster_code, cluster_name, or district). Please contact your administrator.';
          _isLoading = false;
        });
        return;
      }

      final hhId = _hhIdCtrl.text.trim();

      // Check for duplicate HH_ID
      final existing = await client
          .from('households')
          .select('id')
          .eq('hh_id', hhId)
          .maybeSingle();

      if (existing != null) {
        setState(() {
          _error = 'HH_ID $hhId already exists. Please use a unique HH_ID.';
          _isLoading = false;
        });
        return;
      }

      // Auto-generate the deterministic primary key using the established convention.
      final generatedId = 'HH-${clusterCode.toUpperCase()}-$hhId';

      // Insert the new household with all required legacy fields populated.
      // household_user_id is intentionally omitted (stays NULL).
      // Respondent details will be entered later by the Field Agent.
      await client.from('households').insert({
        'id': generatedId,
        'hh_id': hhId,
        'cluster_id': _selectedClusterId,
        'cluster': clusterName,
        'district': district,
        'state': state,
        'created_by': SupabaseService.instance.currentUser?.id,
      });

      if (mounted) {
        Navigator.pop(context);
        widget.onCreated();
      }
    } catch (e) {
      final errStr = e.toString();
      // Handle duplicate primary-key error gracefully.
      if (errStr.contains('duplicate key') ||
          errStr.contains('unique constraint') ||
          errStr.contains('23505')) {
        setState(() {
          _error =
              'A household with this HH_ID and cluster combination already exists. Please use a different HH_ID.';
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = errStr;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 480,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Household',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _error!,
                      style: GoogleFonts.manrope(
                        color: AppTheme.error,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                // HH_ID field — numeric only
                TextFormField(
                  controller: _hhIdCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'HH_ID *',
                    hintText: 'e.g. 1905',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: GoogleFonts.manrope(fontSize: 14),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'HH_ID is required';
                    }
                    if (v.trim().contains(RegExp(r'[^0-9]'))) {
                      return 'HH_ID must contain digits only';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Assign to Cluster dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedClusterId,
                  decoration: InputDecoration(
                    labelText: 'Assign to Cluster *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: widget.clusters
                      .map(
                        (c) => DropdownMenuItem<String>(
                          value: c['id'] as String,
                          child: Text(
                            c['cluster_name'] as String,
                            style: GoogleFonts.manrope(fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                  // Locked for Cluster Head — they cannot change the cluster.
                  onChanged: widget.lockedClusterId != null
                      ? null
                      : (v) => setState(() => _selectedClusterId = v),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Cluster is required' : null,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      child: Text('Cancel', style: GoogleFonts.manrope()),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: _isLoading ? null : _submit,
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Create Household',
                              style: GoogleFonts.manrope(),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

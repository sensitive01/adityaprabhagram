import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/supabase_service.dart';
import '../../../theme/app_theme.dart';

/// Dialog for creating/editing Clusters, Cluster Heads, and Field Agents
class AdminCreateUserDialog extends StatefulWidget {
  final String type; // 'cluster' | 'cluster_head' | 'field_agent'
  final List<Map<String, dynamic>> clusters;
  final Map<String, dynamic>? existingData;
  final VoidCallback onCreated;

  const AdminCreateUserDialog({
    super.key,
    required this.type,
    required this.clusters,
    this.existingData,
    required this.onCreated,
  });

  @override
  State<AdminCreateUserDialog> createState() => _AdminCreateUserDialogState();
}

class _AdminCreateUserDialogState extends State<AdminCreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _error;

  // Cluster fields
  final _clusterNameCtrl = TextEditingController();
  final _clusterCodeCtrl = TextEditingController();
  final _districtCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();

  // User fields
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String? _selectedClusterId;

  bool get _isEdit => widget.existingData != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _prefillData();
  }

  void _prefillData() {
    final d = widget.existingData!;
    if (widget.type == 'cluster') {
      _clusterNameCtrl.text = d['cluster_name'] ?? '';
      _clusterCodeCtrl.text = d['cluster_code'] ?? '';
      _districtCtrl.text = d['district'] ?? '';
      _stateCtrl.text = d['state'] ?? '';
    } else {
      final profile = d['user_profiles'] as Map<String, dynamic>? ?? d;
      _fullNameCtrl.text = profile['full_name'] ?? '';
      _emailCtrl.text = profile['email'] ?? '';
      _phoneCtrl.text = profile['phone'] ?? '';
      _usernameCtrl.text = profile['username'] ?? '';
    }
  }

  @override
  void dispose() {
    _clusterNameCtrl.dispose();
    _clusterCodeCtrl.dispose();
    _districtCtrl.dispose();
    _stateCtrl.dispose();
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  String get _title {
    final action = _isEdit ? 'Edit' : 'Create';
    switch (widget.type) {
      case 'cluster':
        return '$action Cluster';
      case 'cluster_head':
        return '$action Cluster Head';
      case 'field_agent':
        return '$action Field Agent';
      default:
        return action;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final client = SupabaseService.instance.client;
      if (widget.type == 'cluster') {
        await _saveCluster(client);
      } else {
        await _saveUser(client);
      }
      if (mounted) {
        Navigator.pop(context);
        widget.onCreated();
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _saveCluster(dynamic client) async {
    final data = {
      'cluster_name': _clusterNameCtrl.text.trim(),
      'cluster_code': _clusterCodeCtrl.text.trim(),
      'district': _districtCtrl.text.trim(),
      'state': _stateCtrl.text.trim(),
    };
    if (_isEdit) {
      await client
          .from('clusters')
          .update(data)
          .eq('id', widget.existingData!['id'] as String);
    } else {
      await client.from('clusters').insert({...data, 'is_active': true});
    }
  }

  Future<void> _saveUser(dynamic client) async {
    if (_isEdit) {
      // Edit path: only update non-privileged profile fields (no Auth Admin API needed)
      final profile =
          widget.existingData!['user_profiles'] as Map<String, dynamic>? ??
          widget.existingData!;
      await client
          .from('user_profiles')
          .update({
            'full_name': _fullNameCtrl.text.trim(),
            'phone': _phoneCtrl.text.trim(),
          })
          .eq('id', profile['id'] as String);
    } else {
      // Create path: delegate ALL privileged Auth Admin operations to the Edge Function.
      // The service-role key is NEVER exposed to Flutter/client code.
      final role = widget.type == 'cluster_head'
          ? 'CLUSTER_HEAD'
          : 'FIELD_AGENT';

      final response = await client.functions.invoke(
        'create-field-agent',
        body: {
          'fullName': _fullNameCtrl.text.trim(),
          'email': _emailCtrl.text.trim(),
          'password': _passwordCtrl.text,
          'phone': _phoneCtrl.text.trim(),
          'username': _usernameCtrl.text.trim(),
          'clusterId': _selectedClusterId,
          'role': role,
        },
      );

      // functions.invoke throws on HTTP errors, but check the response body too
      final data = response.data;
      if (data is Map && data['error'] != null) {
        throw Exception(data['error'].toString());
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
                  _title,
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
                ..._buildFields(),
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
                              _isEdit ? 'Save Changes' : 'Create',
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

  List<Widget> _buildFields() {
    if (widget.type == 'cluster') return _clusterFields();
    return _userFields();
  }

  List<Widget> _clusterFields() => [
    _field('Cluster Name', _clusterNameCtrl, required: true),
    const SizedBox(height: 12),
    _field('Cluster Code', _clusterCodeCtrl, required: true),
    const SizedBox(height: 12),
    _field('District', _districtCtrl),
    const SizedBox(height: 12),
    _field('State', _stateCtrl),
  ];

  List<Widget> _userFields() => [
    _field('Full Name', _fullNameCtrl, required: true),
    const SizedBox(height: 12),
    if (!_isEdit) ...[
      _field(
        'Email',
        _emailCtrl,
        required: true,
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 12),
      _field('Password', _passwordCtrl, required: true, obscure: true),
      const SizedBox(height: 12),
      _field('Username', _usernameCtrl),
      const SizedBox(height: 12),
    ],
    _field('Phone', _phoneCtrl, keyboardType: TextInputType.phone),
    const SizedBox(height: 12),
    if (!_isEdit) _clusterDropdown(),
  ];

  Widget _clusterDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedClusterId,
      decoration: InputDecoration(
        labelText: 'Assign to Cluster',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
      onChanged: (v) => setState(() => _selectedClusterId = v),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    bool required = false,
    bool obscure = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      style: GoogleFonts.manrope(fontSize: 14),
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null
          : null,
    );
  }
}

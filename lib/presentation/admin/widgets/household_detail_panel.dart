import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/supabase_service.dart';
import '../../../theme/app_theme.dart';

class HouseholdDetailPanel extends StatefulWidget {
  final Map<String, dynamic> household;
  final List<Map<String, dynamic>> fieldAgents;
  final VoidCallback onClose;
  final VoidCallback onUpdated;

  const HouseholdDetailPanel({
    super.key,
    required this.household,
    required this.fieldAgents,
    required this.onClose,
    required this.onUpdated,
  });

  @override
  State<HouseholdDetailPanel> createState() => _HouseholdDetailPanelState();
}

class _HouseholdDetailPanelState extends State<HouseholdDetailPanel> {
  List<Map<String, dynamic>> _members = [];
  bool _loadingMembers = true;
  String? _selectedAgentId;

  @override
  void initState() {
    super.initState();
    _loadMembers();
    _selectedAgentId = widget.household['assigned_agent_id'] as String?;
  }

  Future<void> _loadMembers() async {
    try {
      final members = await SupabaseService.instance.client
          .from('household_members')
          .select()
          .eq('household_id', widget.household['id'] as String)
          .order('member_name');
      if (mounted) {
        setState(() {
          _members = List<Map<String, dynamic>>.from(members as List);
          _loadingMembers = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingMembers = false);
    }
  }

  Future<void> _assignAgent() async {
    if (_selectedAgentId == null) return;
    try {
      await SupabaseService.instance.client
          .from('households')
          .update({'assigned_agent_id': _selectedAgentId})
          .eq('id', widget.household['id'] as String);
      widget.onUpdated();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Agent assigned successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.household;
    return Container(
      width: 340,
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        border: Border(left: BorderSide(color: const Color(0xFFE2E8F0))),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: const Color(0xFFE2E8F0)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Household Details',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close_rounded, size: 20),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('HH_ID', h['hh_id'] ?? '—'),
                  _infoRow('Name', h['name'] ?? '—'),
                  _infoRow('Respondent', h['respondent_name'] ?? '—'),
                  _infoRow('Village', h['village'] ?? '—'),
                  _infoRow('Block', h['block'] ?? '—'),
                  _infoRow('District', h['district'] ?? '—'),
                  _infoRow('State', h['state'] ?? '—'),
                  _infoRow('Family Size', '${h['family_size'] ?? '—'}'),
                  _infoRow('Contact', h['contact_number'] ?? '—'),
                  const Divider(height: 24),
                  Text(
                    'Assign Field Agent',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedAgentId,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('Unassigned'),
                      ),
                      ...widget.fieldAgents.map(
                        (a) => DropdownMenuItem<String>(
                          value: a['id'] as String,
                          child: Text(
                            a['full_name'] as String,
                            style: GoogleFonts.manrope(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (v) => setState(() => _selectedAgentId = v),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _assignAgent,
                      child: Text(
                        'Save Assignment',
                        style: GoogleFonts.manrope(fontSize: 13),
                      ),
                    ),
                  ),
                  const Divider(height: 24),
                  Text(
                    'Members (${_members.length})',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_loadingMembers)
                    const Center(child: CircularProgressIndicator())
                  else if (_members.isEmpty)
                    Text(
                      'No members recorded',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: const Color(0xFF9CA3AF),
                      ),
                    )
                  else
                    ..._members.map((m) => _memberRow(m)),
                ],
              ),
            ),
          ),
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
            width: 100,
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

  Widget _memberRow(Map<String, dynamic> m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceVariantLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppTheme.primaryContainer,
            child: Text(
              (m['member_name'] as String? ?? '?')[0].toUpperCase(),
              style: GoogleFonts.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m['member_name'] ?? '—',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${m['age'] ?? '—'} yrs • ${m['gender'] ?? '—'}',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

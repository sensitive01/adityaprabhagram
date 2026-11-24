import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/data/location_master_data.dart';
import '../../../theme/app_theme.dart';

class RespondentDetailsSectionWidget extends StatefulWidget {
  final String householdId;
  final String initialHouseholdName;
  final Map<String, dynamic> initialAnswers;
  final ValueChanged<Map<String, dynamic>> onSave;
  final bool isReadOnly;
  final String currentAgentName;

  const RespondentDetailsSectionWidget({
    super.key,
    required this.householdId,
    required this.initialHouseholdName,
    required this.initialAnswers,
    required this.onSave,
    this.isReadOnly = false,
    this.currentAgentName = 'Field Agent',
  });

  @override
  State<RespondentDetailsSectionWidget> createState() =>
      RespondentDetailsSectionWidgetState();
}

class RespondentDetailsSectionWidgetState
    extends State<RespondentDetailsSectionWidget> {
  final _formKey = GlobalKey<FormState>();

  // A2: Salutation
  String? _salutation;
  final List<String> _salutations = [
    'Mr.',
    'Mrs.',
    'Ms.',
    'Dr.',
    'Shri',
    'Smt.',
  ];

  // A3: Respondent Name
  late TextEditingController _nameController;

  // A4: Relationship to Head
  String? _relationshipToHead;
  final List<String> _relationships = [
    'Head',
    'Spouse',
    'Son or daughter',
    'In laws',
    'Blood Relatives',
    'Guardian',
    'Others',
  ];
  late TextEditingController _otherRelationshipController;

  // A5: Location Hierarchy
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedBlock;
  String? _selectedVillage;
  bool _isOtherVillage = false;
  late TextEditingController _otherVillageController;
  late TextEditingController _gramPanchayatController;
  late TextEditingController _psPoController;
  late TextEditingController _lgdCodeController;

  // A6: Mobile Number
  late TextEditingController _mobileController;

  // A7: Aadhaar Number
  late TextEditingController _aadhaarController;
  bool _maskAadhaar = true;

  // A8: Survey Date
  DateTime _surveyDate = DateTime.now();

  // A9: Interview Language
  String? _preferredLanguage;
  final List<String> _languages = [
    'English',
    'Hindi',
    'Local language (specify)',
  ];
  late TextEditingController _localLanguageController;

  // A10: Enumerator Name
  late TextEditingController _enumeratorController;

  @override
  void initState() {
    super.initState();
    final ans = widget.initialAnswers;

    _salutation = ans['A2_salutation'] as String? ?? 'Mr.';
    _nameController = TextEditingController(
      text: (ans['A3_respondent_name'] as String? ??
              ans['A-01'] as String? ??
              ans['respondent_name'] as String? ??
              widget.initialHouseholdName)
          .toUpperCase(),
    );

    _relationshipToHead = ans['A4_relationship_to_head'] as String? ?? 'Head';
    _otherRelationshipController = TextEditingController(
      text: ans['A4_relationship_other'] as String? ?? '',
    );

    // Location
    _selectedState = ans['A5_state'] as String? ?? 'Manipur';
    _selectedDistrict = ans['A5_district'] as String? ?? 'Churachandpur';
    _selectedBlock = ans['A5_block'] as String? ?? 'Lamka';
    _selectedVillage = ans['A5_village'] as String? ?? 'Tuibong';
    _isOtherVillage = ans['A5_is_other_village'] as bool? ?? false;
    _otherVillageController = TextEditingController(
      text: ans['A5_other_village_name'] as String? ?? '',
    );
    _gramPanchayatController = TextEditingController(
      text: ans['A5_gram_panchayat'] as String? ?? '',
    );
    _psPoController = TextEditingController(
      text: ans['A5_police_station_post_office'] as String? ?? '',
    );
    _lgdCodeController = TextEditingController(
      text: ans['A5_lgd_code'] as String? ?? '',
    );

    _autoPopulateVillageMetadata(_selectedVillage);

    // Mobile & Aadhaar
    _mobileController = TextEditingController(
      text: ans['A6_mobile_number'] as String? ??
          ans['A-02'] as String? ??
          ans['contact_number'] as String? ??
          '',
    );
    _aadhaarController = TextEditingController(
      text: ans['A7_aadhaar_number'] as String? ?? ans['A-03'] as String? ?? '',
    );

    // Survey Date
    final dateStr = ans['A8_survey_date'] as String? ?? '';
    if (dateStr.isNotEmpty) {
      try {
        _surveyDate = DateTime.parse(dateStr);
      } catch (_) {
        _surveyDate = DateTime.now();
      }
    } else {
      _surveyDate = DateTime.now();
    }

    // Language
    _preferredLanguage = ans['A9_preferred_language'] as String? ?? 'English';
    _localLanguageController = TextEditingController(
      text: ans['A9_local_language_specify'] as String? ?? '',
    );

    // Enumerator
    _enumeratorController = TextEditingController(
      text: ans['A10_enumerator_name'] as String? ?? widget.currentAgentName,
    );
  }

  void _autoPopulateVillageMetadata(String? villageName) {
    if (villageName == null || villageName == 'Other / Not Listed') {
      return;
    }
    if (_selectedState != null &&
        _selectedDistrict != null &&
        _selectedBlock != null) {
      final record = LocationMasterData.findVillage(
        _selectedState!,
        _selectedDistrict!,
        _selectedBlock!,
        villageName,
      );
      if (record != null) {
        _gramPanchayatController.text = record.gramPanchayat;
        _psPoController.text = record.policeStationPostOffice;
        _lgdCodeController.text = record.lgdCode;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _otherRelationshipController.dispose();
    _otherVillageController.dispose();
    _gramPanchayatController.dispose();
    _psPoController.dispose();
    _lgdCodeController.dispose();
    _mobileController.dispose();
    _aadhaarController.dispose();
    _localLanguageController.dispose();
    _enumeratorController.dispose();
    super.dispose();
  }

  void _notifyParent() {
    final dateIso =
        "${_surveyDate.year.toString().padLeft(4, '0')}-${_surveyDate.month.toString().padLeft(2, '0')}-${_surveyDate.day.toString().padLeft(2, '0')}";

    final map = <String, dynamic>{
      'A1_household_id': widget.householdId,
      'A2_salutation': _salutation,
      'A3_respondent_name': _nameController.text.trim().toUpperCase(),
      'A4_relationship_to_head': _relationshipToHead,
      'A4_relationship_other': _relationshipToHead == 'Others'
          ? _otherRelationshipController.text.trim()
          : null,
      'A5_state': _selectedState,
      'A5_district': _selectedDistrict,
      'A5_block': _selectedBlock,
      'A5_village': _isOtherVillage
          ? _otherVillageController.text.trim()
          : _selectedVillage,
      'A5_is_other_village': _isOtherVillage,
      'A5_other_village_name': _otherVillageController.text.trim(),
      'A5_gram_panchayat': _gramPanchayatController.text.trim(),
      'A5_police_station_post_office': _psPoController.text.trim(),
      'A5_lgd_code': _lgdCodeController.text.trim(),
      'A6_mobile_number': _mobileController.text.trim(),
      'A7_aadhaar_number': _aadhaarController.text.trim(),
      'A8_survey_date': dateIso,
      'A9_preferred_language': _preferredLanguage,
      'A9_local_language_specify':
          _preferredLanguage == 'Local language (specify)'
              ? _localLanguageController.text.trim()
              : null,
      'A10_enumerator_name': _enumeratorController.text.trim(),

      // Backward compatibility keys for reporting and queries:
      'A-01': _nameController.text.trim().toUpperCase(),
      'respondent_name': _nameController.text.trim().toUpperCase(),
      'A-02': _mobileController.text.trim(),
      'contact_number': _mobileController.text.trim(),
      'A-03': _aadhaarController.text.trim(),
    };

    widget.onSave(map);
  }

  /// Validates the form and notifies parent with current data.
  /// Returns true if all validations pass.
  bool validateAndSave() {
    final isValid = _formKey.currentState?.validate() ?? true;
    _notifyParent();
    return isValid;
  }

  /// Unconditionally serializes current state and notifies parent.
  void saveData() {
    _notifyParent();
  }

  Future<void> _pickDate() async {
    if (widget.isReadOnly) return;
    final picked = await showDatePicker(
      context: context,
      initialDate: _surveyDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.primary,
                  onPrimary: Colors.white,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _surveyDate = picked;
      });
      _notifyParent();
    }
  }

  String _formatDateDisplay(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}";
  }

  String _getMaskedAadhaar(String raw) {
    if (raw.length != 12) return raw;
    return "XXXX-XXXX-${raw.substring(8)}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Header Card
          _buildHeaderCard(theme),
          const SizedBox(height: 16),

          // A1 & A2 & A3: Household ID, Salutation & Respondent Name
          _buildRespondentCard(theme),
          const SizedBox(height: 16),

          // A4: Relationship to Head
          _buildRelationshipCard(theme),
          const SizedBox(height: 16),

          // A5: Location Hierarchy
          _buildLocationCard(theme),
          const SizedBox(height: 16),

          // A6 & A7: Mobile & Aadhaar
          _buildIdentityCard(theme),
          const SizedBox(height: 16),

          // A8, A9, A10: Survey Date, Language & Enumerator
          _buildSurveyAuditCard(theme),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withAlpha(50)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.badge_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SECTION A: RESPONDENT DETAILS',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Verify respondent identification and administrative location coding.',
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRespondentCard(ThemeData theme) {
    return _cardContainer(
      theme: theme,
      title: 'A1–A3: Respondent Identification',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A1: Household ID (Read-only)
          Text(
            'A1. Household ID (Retained)',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.outline.withAlpha(50),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_outline_rounded, size: 16, color: Colors.grey),
                const SizedBox(width: 10),
                Text(
                  widget.householdId,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  'System Sequence ID',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // A2: Salutation
          Text(
            'A2. Salutation *',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _salutation,
            decoration: _inputDecoration(theme, 'Select Salutation'),
            items: _salutations.map((s) {
              return DropdownMenuItem(value: s, child: Text(s));
            }).toList(),
            onChanged: widget.isReadOnly
                ? null
                : (val) {
                    setState(() => _salutation = val);
                    _notifyParent();
                  },
          ),
          const SizedBox(height: 16),

          // A3: Respondent Name (CAPS ONLY)
          Text(
            'A3. Respondent Name (CAPS ONLY) *',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _nameController,
            readOnly: widget.isReadOnly,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              _UpperCaseTextFormatter(),
            ],
            style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: _inputDecoration(theme, 'ENTER FULL NAME IN CAPITAL LETTERS'),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Respondent name is required';
              }
              return null;
            },
            onChanged: (_) => _notifyParent(),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipCard(ThemeData theme) {
    return _cardContainer(
      theme: theme,
      title: 'A4: Relationship to Household Head',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Respondent relationship to household head *',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _relationshipToHead,
            decoration: _inputDecoration(theme, 'Select Relationship'),
            items: _relationships.map((r) {
              return DropdownMenuItem(value: r, child: Text(r));
            }).toList(),
            onChanged: widget.isReadOnly
                ? null
                : (val) {
                    setState(() => _relationshipToHead = val);
                    _notifyParent();
                  },
          ),
          if (_relationshipToHead == 'Others') ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _otherRelationshipController,
              readOnly: widget.isReadOnly,
              decoration: _inputDecoration(theme, 'Specify relationship'),
              onChanged: (_) => _notifyParent(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationCard(ThemeData theme) {
    final states = LocationMasterData.getStates();
    final districts = _selectedState != null
        ? LocationMasterData.getDistricts(_selectedState!)
        : <String>[];
    final blocks = (_selectedState != null && _selectedDistrict != null)
        ? LocationMasterData.getBlocks(_selectedState!, _selectedDistrict!)
        : <String>[];
    final villages = (_selectedState != null &&
            _selectedDistrict != null &&
            _selectedBlock != null)
        ? LocationMasterData.getVillages(
            _selectedState!,
            _selectedDistrict!,
            _selectedBlock!,
          )
        : <VillageRecord>[];

    return _cardContainer(
      theme: theme,
      title: 'A5: Location Hierarchy (Master Lookup)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cascading selection auto-populates LGD codes and administrative units.',
            style: GoogleFonts.manrope(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 14),

          // State
          _label('State *', theme),
          DropdownButtonFormField<String>(
            value: states.contains(_selectedState) ? _selectedState : null,
            decoration: _inputDecoration(theme, 'Select State'),
            items: states.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
            onChanged: widget.isReadOnly
                ? null
                : (val) {
                    setState(() {
                      _selectedState = val;
                      final dList = LocationMasterData.getDistricts(val ?? '');
                      _selectedDistrict = dList.isNotEmpty ? dList.first : null;
                      final bList = (_selectedDistrict != null)
                          ? LocationMasterData.getBlocks(val ?? '', _selectedDistrict!)
                          : <String>[];
                      _selectedBlock = bList.isNotEmpty ? bList.first : null;
                      _selectedVillage = null;
                      _isOtherVillage = false;
                      _gramPanchayatController.clear();
                      _psPoController.clear();
                      _lgdCodeController.clear();
                    });
                    _notifyParent();
                  },
          ),
          const SizedBox(height: 12),

          // District
          _label('District *', theme),
          DropdownButtonFormField<String>(
            value: districts.contains(_selectedDistrict) ? _selectedDistrict : null,
            decoration: _inputDecoration(theme, 'Select District'),
            items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
            onChanged: widget.isReadOnly
                ? null
                : (val) {
                    setState(() {
                      _selectedDistrict = val;
                      final bList = (_selectedState != null && val != null)
                          ? LocationMasterData.getBlocks(_selectedState!, val)
                          : <String>[];
                      _selectedBlock = bList.isNotEmpty ? bList.first : null;
                      _selectedVillage = null;
                      _isOtherVillage = false;
                      _gramPanchayatController.clear();
                      _psPoController.clear();
                      _lgdCodeController.clear();
                    });
                    _notifyParent();
                  },
          ),
          const SizedBox(height: 12),

          // Block
          _label('Block *', theme),
          DropdownButtonFormField<String>(
            value: blocks.contains(_selectedBlock) ? _selectedBlock : null,
            decoration: _inputDecoration(theme, 'Select Block'),
            items: blocks.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
            onChanged: widget.isReadOnly
                ? null
                : (val) {
                    setState(() {
                      _selectedBlock = val;
                      _selectedVillage = null;
                      _isOtherVillage = false;
                      _gramPanchayatController.clear();
                      _psPoController.clear();
                      _lgdCodeController.clear();
                    });
                    _notifyParent();
                  },
          ),
          const SizedBox(height: 12),

          // Village
          _label('Village *', theme),
          DropdownButtonFormField<String>(
            value: _isOtherVillage
                ? 'Other / Not Listed'
                : (villages.any((v) => v.villageName == _selectedVillage)
                    ? _selectedVillage
                    : null),
            decoration: _inputDecoration(theme, 'Select Village from Master'),
            items: [
              ...villages.map((v) => DropdownMenuItem(
                    value: v.villageName,
                    child: Text(v.villageName),
                  )),
              const DropdownMenuItem(
                value: 'Other / Not Listed',
                child: Text('Other / Not Listed (Manual entry)'),
              ),
            ],
            onChanged: widget.isReadOnly
                ? null
                : (val) {
                    setState(() {
                      if (val == 'Other / Not Listed') {
                        _isOtherVillage = true;
                        _selectedVillage = 'Other / Not Listed';
                        _gramPanchayatController.clear();
                        _psPoController.clear();
                        _lgdCodeController.clear();
                      } else {
                        _isOtherVillage = false;
                        _selectedVillage = val;
                        _autoPopulateVillageMetadata(val);
                      }
                    });
                    _notifyParent();
                  },
          ),

          if (_isOtherVillage) ...[
            const SizedBox(height: 10),
            TextFormField(
              controller: _otherVillageController,
              readOnly: widget.isReadOnly,
              decoration: _inputDecoration(theme, 'Enter Village Name (Not listed in master)'),
              onChanged: (_) => _notifyParent(),
            ),
          ],

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 10),

          // Auto-populated metadata
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Gram Panchayat', theme),
                    TextFormField(
                      controller: _gramPanchayatController,
                      readOnly: widget.isReadOnly,
                      decoration: _inputDecoration(theme, 'Auto-populated GP'),
                      onChanged: (_) => _notifyParent(),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('LGD Code', theme),
                    TextFormField(
                      controller: _lgdCodeController,
                      readOnly: widget.isReadOnly,
                      decoration: _inputDecoration(theme, 'LGD Code'),
                      onChanged: (_) => _notifyParent(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _label('Police Station / Post Office', theme),
          TextFormField(
            controller: _psPoController,
            readOnly: widget.isReadOnly,
            decoration: _inputDecoration(theme, 'PS / Post Office details'),
            onChanged: (_) => _notifyParent(),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityCard(ThemeData theme) {
    return _cardContainer(
      theme: theme,
      title: 'A6–A7: Contact & Identity',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A6: Mobile
          _label('A6. Mobile Number (10 digits, begins with 6/7/8/9)', theme),
          TextFormField(
            controller: _mobileController,
            readOnly: widget.isReadOnly,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _inputDecoration(theme, 'Enter 10-digit mobile number')
                .copyWith(counterText: ''),
            validator: (v) {
              if (v != null && v.isNotEmpty) {
                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v)) {
                  return 'Must be 10 digits starting with 6, 7, 8, or 9';
                }
              }
              return null;
            },
            onChanged: (_) => _notifyParent(),
          ),
          const SizedBox(height: 16),

          // A7: Aadhaar
          Row(
            children: [
              _label('A7. Aadhaar Number (12 digits, Optional)', theme),
              const Spacer(),
              if (_aadhaarController.text.isNotEmpty)
                GestureDetector(
                  onTap: () => setState(() => _maskAadhaar = !_maskAadhaar),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _maskAadhaar
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 16,
                        color: AppTheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _maskAadhaar ? 'Unmask' : 'Mask',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _aadhaarController,
            readOnly: widget.isReadOnly,
            keyboardType: TextInputType.number,
            maxLength: 12,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: _inputDecoration(theme, 'Enter 12-digit Aadhaar number')
                .copyWith(counterText: ''),
            validator: (v) {
              if (v != null && v.isNotEmpty && v.length != 12) {
                return 'Aadhaar must be exactly 12 digits';
              }
              return null;
            },
            onChanged: (_) => _notifyParent(),
          ),
          if (_maskAadhaar && _aadhaarController.text.length == 12) ...[
            const SizedBox(height: 4),
            Text(
              'Masked Preview: ${_getMaskedAadhaar(_aadhaarController.text)}',
              style: GoogleFonts.manrope(
                fontSize: 11,
                color: Colors.green.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSurveyAuditCard(ThemeData theme) {
    return _cardContainer(
      theme: theme,
      title: 'A8–A10: Survey Execution & Audit',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // A8: Survey Date
          _label('A8. Survey Date *', theme),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.colorScheme.outline.withAlpha(80)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, size: 18, color: AppTheme.primary),
                  const SizedBox(width: 10),
                  Text(
                    _formatDateDisplay(_surveyDate),
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  if (!widget.isReadOnly)
                    Text(
                      'Change Date',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // A9: Preferred Interview Language
          _label('A9. Preferred Interview Language *', theme),
          DropdownButtonFormField<String>(
            value: _preferredLanguage,
            decoration: _inputDecoration(theme, 'Select Language'),
            items: _languages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
            onChanged: widget.isReadOnly
                ? null
                : (val) {
                    setState(() => _preferredLanguage = val);
                    _notifyParent();
                  },
          ),
          if (_preferredLanguage == 'Local language (specify)') ...[
            const SizedBox(height: 10),
            TextFormField(
              controller: _localLanguageController,
              readOnly: widget.isReadOnly,
              decoration: _inputDecoration(theme, 'Specify local language (e.g. Meiteilon, Paite)'),
              onChanged: (_) => _notifyParent(),
            ),
          ],
          const SizedBox(height: 16),

          // A10: Enumerator Name
          _label('A10. Enumerator Name *', theme),
          TextFormField(
            controller: _enumeratorController,
            readOnly: widget.isReadOnly,
            decoration: _inputDecoration(theme, 'Enumerator full name'),
            onChanged: (_) => _notifyParent(),
          ),
        ],
      ),
    );
  }

  Widget _label(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _cardContainer({
    required ThemeData theme,
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: theme.colorScheme.outline.withAlpha(40)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.manrope(fontSize: 12, color: theme.colorScheme.onSurfaceVariant),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.colorScheme.outline.withAlpha(80)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.colorScheme.outline.withAlpha(80)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
      ),
    );
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

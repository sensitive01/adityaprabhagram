import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

/// Data model representing a single household member record for Section B8.
class HouseholdMemberRecord {
  final String memberId;
  String memberName;
  int age;
  String gender; // Male | Female | Transgender
  String relationToHead;

  // Education
  String educationLevel;
  String presentEducationStatus; // Pursuing | Not pursuing
  bool isDropout;
  String? ageAtDropout; // <15 | 15–20 | 20–25 | 25 and above
  List<String> dropoutReasons;
  String? dropoutReasonOther;
  bool? willingToContinue;
  List<String> supportNeeded;
  String? supportNeededOther;

  // Primary Occupation
  String primaryOccupation;
  List<String> farmingActivities; // Agriculture, Horticulture, Livestock, Fishery
  List<String> notWorkingReasons; // Age, Health, Searching job

  // Migration
  String migrationStatus; // Current migrant | Returned migrant | Migrates periodically | Not migrated / living in village
  String? placeOfMigration;
  String? destinationText;
  String? migrationReason;
  String? durationAway;
  String? returnFrequency;
  bool? contributesIncome;
  String? annualContribution;

  // Secondary Skills
  List<String> secondarySkills;
  String? skillFrequency;
  List<String> skillMonths;
  String? skillProficiency; // Basic | Moderate | Advanced | Master or traditional expert
  List<String> commercialSupportNeeded;

  HouseholdMemberRecord({
    required this.memberId,
    this.memberName = '',
    this.age = 0,
    this.gender = 'Male',
    this.relationToHead = 'Head',
    this.educationLevel = 'No formal education',
    this.presentEducationStatus = 'Not pursuing',
    this.isDropout = false,
    this.ageAtDropout,
    List<String>? dropoutReasons,
    this.dropoutReasonOther,
    this.willingToContinue,
    List<String>? supportNeeded,
    this.supportNeededOther,
    this.primaryOccupation = 'Farming',
    List<String>? farmingActivities,
    List<String>? notWorkingReasons,
    this.migrationStatus = 'Not migrated / living in village',
    this.placeOfMigration,
    this.destinationText,
    this.migrationReason,
    this.durationAway,
    this.returnFrequency,
    this.contributesIncome,
    this.annualContribution,
    List<String>? secondarySkills,
    this.skillFrequency,
    List<String>? skillMonths,
    this.skillProficiency,
    List<String>? commercialSupportNeeded,
  })  : dropoutReasons = dropoutReasons ?? [],
        supportNeeded = supportNeeded ?? [],
        farmingActivities = farmingActivities ?? [],
        notWorkingReasons = notWorkingReasons ?? [],
        secondarySkills = secondarySkills ?? [],
        skillMonths = skillMonths ?? [],
        commercialSupportNeeded = commercialSupportNeeded ?? [];

  Map<String, dynamic> toJson() => {
        'member_id': memberId,
        'member_name': memberName,
        'age': age,
        'gender': gender,
        'relation_to_head': relationToHead,
        'education_level': educationLevel,
        'present_education_status': presentEducationStatus,
        'is_dropout': isDropout,
        'age_at_dropout': ageAtDropout,
        'dropout_reasons': dropoutReasons,
        'dropout_reason_other': dropoutReasonOther,
        'willing_to_continue': willingToContinue,
        'support_needed': supportNeeded,
        'support_needed_other': supportNeededOther,
        'primary_occupation': primaryOccupation,
        'farming_activities': farmingActivities,
        'not_working_reasons': notWorkingReasons,
        'migration_status': migrationStatus,
        'place_of_migration': placeOfMigration,
        'destination_text': destinationText,
        'migration_reason': migrationReason,
        'duration_away': durationAway,
        'return_frequency': returnFrequency,
        'contributes_income': contributesIncome,
        'annual_contribution': annualContribution,
        'secondary_skills': secondarySkills,
        'skill_frequency': skillFrequency,
        'skill_months': skillMonths,
        'skill_proficiency': skillProficiency,
        'commercial_support_needed': commercialSupportNeeded,
      };

  factory HouseholdMemberRecord.fromJson(Map<String, dynamic> json) {
    return HouseholdMemberRecord(
      memberId: json['member_id'] as String? ?? '01',
      memberName: json['member_name'] as String? ?? '',
      age: json['age'] is int
          ? json['age'] as int
          : int.tryParse(json['age']?.toString() ?? '0') ?? 0,
      gender: json['gender'] as String? ?? 'Male',
      relationToHead: json['relation_to_head'] as String? ?? 'Head',
      educationLevel: json['education_level'] as String? ?? 'No formal education',
      presentEducationStatus: json['present_education_status'] as String? ?? 'Not pursuing',
      isDropout: json['is_dropout'] as bool? ?? false,
      ageAtDropout: json['age_at_dropout'] as String?,
      dropoutReasons: (json['dropout_reasons'] as List?)?.cast<String>() ?? [],
      dropoutReasonOther: json['dropout_reason_other'] as String?,
      willingToContinue: json['willing_to_continue'] as bool?,
      supportNeeded: (json['support_needed'] as List?)?.cast<String>() ?? [],
      supportNeededOther: json['support_needed_other'] as String?,
      primaryOccupation: json['primary_occupation'] as String? ?? 'Farming',
      farmingActivities: (json['farming_activities'] as List?)?.cast<String>() ?? [],
      notWorkingReasons: (json['not_working_reasons'] as List?)?.cast<String>() ?? [],
      migrationStatus: json['migration_status'] as String? ?? 'Not migrated / living in village',
      placeOfMigration: json['place_of_migration'] as String?,
      destinationText: json['destination_text'] as String?,
      migrationReason: json['migration_reason'] as String?,
      durationAway: json['duration_away'] as String?,
      returnFrequency: json['return_frequency'] as String?,
      contributesIncome: json['contributes_income'] as bool?,
      annualContribution: json['annual_contribution'] as String?,
      secondarySkills: (json['secondary_skills'] as List?)?.cast<String>() ?? [],
      skillFrequency: json['skill_frequency'] as String?,
      skillMonths: (json['skill_months'] as List?)?.cast<String>() ?? [],
      skillProficiency: json['skill_proficiency'] as String?,
      commercialSupportNeeded: (json['commercial_support_needed'] as List?)?.cast<String>() ?? [],
    );
  }
}

class HouseholdProfileSectionWidget extends StatefulWidget {
  final String householdId;
  final Map<String, dynamic> initialAnswers;
  final ValueChanged<Map<String, dynamic>> onSave;
  final bool isReadOnly;

  const HouseholdProfileSectionWidget({
    super.key,
    required this.householdId,
    required this.initialAnswers,
    required this.onSave,
    this.isReadOnly = false,
  });

  @override
  State<HouseholdProfileSectionWidget> createState() =>
      HouseholdProfileSectionWidgetState();
}

class HouseholdProfileSectionWidgetState
    extends State<HouseholdProfileSectionWidget> {
  final _formKey = GlobalKey<FormState>();

  // B1: Household Type
  String? _householdType;
  final List<String> _householdTypes = [
    'Nuclear',
    'Joint',
    'Single-person',
    'Other',
  ];

  // B2: Household Head Status
  String? _headStatus;
  final List<String> _headStatuses = [
    'Male-headed',
    'Female-headed',
    'Jointly headed',
  ];

  // B3: Type of House
  String? _houseType;
  final List<String> _houseTypes = [
    'Kutcha',
    'Semi-pucca',
    'Pucca',
  ];

  // B4: Religion
  String? _religion;
  final List<String> _religions = [
    'Hindu',
    'Christian',
    'Buddhist',
    'Muslim',
    'Other religion (specify)',
    'Does not follow any religion',
    'Prefer not to answer',
  ];
  late TextEditingController _religionOtherController;

  // B5: Social Category
  String? _socialCategory;
  final List<String> _socialCategories = [
    'ST',
    'SC',
    'OBC',
    'General',
    'Other (specify)',
    'Prefer not to answer',
  ];
  late TextEditingController _socialCategoryOtherController;

  // B6: Tribe / Ethnic Group
  late TextEditingController _tribeController;

  // B7: Family Size Breakdown
  late TextEditingController _adultMaleController;
  late TextEditingController _adultFemaleController;
  late TextEditingController _childMaleController;
  late TextEditingController _childFemaleController;

  // B8: Repeatable Member Records
  List<HouseholdMemberRecord> _members = [];

  @override
  void initState() {
    super.initState();
    final ans = widget.initialAnswers;

    _householdType = ans['B1_household_type'] as String? ??
        ans['B-03'] as String? ??
        'Nuclear';
    _headStatus = ans['B2_head_status'] as String? ?? 'Male-headed';
    _houseType = ans['B3_house_type'] as String? ??
        ans['B-04'] as String? ??
        'Semi-pucca';

    _religion = ans['B4_religion'] as String? ?? 'Hindu';
    _religionOtherController = TextEditingController(
      text: ans['B4_religion_other'] as String? ?? '',
    );

    _socialCategory = ans['B5_social_category'] as String? ?? 'ST';
    _socialCategoryOtherController = TextEditingController(
      text: ans['B5_social_category_other'] as String? ?? '',
    );

    _tribeController = TextEditingController(
      text: ans['B6_tribe'] as String? ?? ans['B-02'] as String? ?? '',
    );

    _adultMaleController = TextEditingController(
      text: (ans['B7_adult_male'] ?? ans['adult_male'] ?? '1').toString(),
    );
    _adultFemaleController = TextEditingController(
      text: (ans['B7_adult_female'] ?? ans['adult_female'] ?? '1').toString(),
    );
    _childMaleController = TextEditingController(
      text: (ans['B7_child_male'] ?? ans['child_male'] ?? '0').toString(),
    );
    _childFemaleController = TextEditingController(
      text: (ans['B7_child_female'] ?? ans['child_female'] ?? '0').toString(),
    );

    // Load members
    final rawMembers = ans['B8_members'] ?? ans['household_members'];
    if (rawMembers is List && rawMembers.isNotEmpty) {
      _members = rawMembers
          .map((m) => HouseholdMemberRecord.fromJson(
              m is Map ? Map<String, dynamic>.from(m) : {}))
          .toList();
    } else {
      // Default: generate 1 head member with household name if available
      final hhName = ans['A3_respondent_name'] as String? ??
          ans['A-01'] as String? ??
          '';
      _members = [
        HouseholdMemberRecord(
          memberId: '${widget.householdId}-01',
          memberName: hhName,
          age: 35,
          gender: 'Male',
          relationToHead: 'Head',
        ),
      ];
    }
  }

  @override
  void dispose() {
    _religionOtherController.dispose();
    _socialCategoryOtherController.dispose();
    _tribeController.dispose();
    _adultMaleController.dispose();
    _adultFemaleController.dispose();
    _childMaleController.dispose();
    _childFemaleController.dispose();
    super.dispose();
  }

  int get _calculatedFamilySize {
    final am = int.tryParse(_adultMaleController.text.trim()) ?? 0;
    final af = int.tryParse(_adultFemaleController.text.trim()) ?? 0;
    final cm = int.tryParse(_childMaleController.text.trim()) ?? 0;
    final cf = int.tryParse(_childFemaleController.text.trim()) ?? 0;
    return am + af + cm + cf;
  }

  void _notifyParent() {
    final totalSize = _calculatedFamilySize;

    final map = <String, dynamic>{
      'B1_household_type': _householdType,
      'B2_head_status': _headStatus,
      'B3_house_type': _houseType,
      'B4_religion': _religion,
      'B4_religion_other': _religion == 'Other religion (specify)'
          ? _religionOtherController.text.trim()
          : null,
      'B5_social_category': _socialCategory,
      'B5_social_category_other': _socialCategory == 'Other (specify)'
          ? _socialCategoryOtherController.text.trim()
          : null,
      'B6_tribe': _tribeController.text.trim(),
      'B7_family_size': totalSize,
      'B7_adult_male': int.tryParse(_adultMaleController.text.trim()) ?? 0,
      'B7_adult_female': int.tryParse(_adultFemaleController.text.trim()) ?? 0,
      'B7_child_male': int.tryParse(_childMaleController.text.trim()) ?? 0,
      'B7_child_female': int.tryParse(_childFemaleController.text.trim()) ?? 0,
      'B8_members': _members.map((m) => m.toJson()).toList(),

      // Backward compatibility keys
      'B-01': totalSize.toString(),
      'B-02': _tribeController.text.trim(),
      'B-03': _householdType,
      'B-04': _houseType,
      'household_members': _members.map((m) => m.toJson()).toList(),
    };

    // Also populate legacy member keys if members exist
    for (int i = 0; i < _members.length; i++) {
      final m = _members[i];
      final prefix = 'B1_M${i + 1}';
      map['${prefix}_NAME'] = m.memberName;
      map['${prefix}_AGE'] = m.age.toString();
      map['${prefix}_GENDER'] = m.gender;
      map['${prefix}_RELATIONSHIP'] = m.relationToHead;
      map['${prefix}_EDUCATION'] = m.educationLevel;
      map['${prefix}_OCCUPATION'] = m.primaryOccupation;
      map['${prefix}_LIVING_STATUS'] =
          m.migrationStatus == 'Not migrated / living in village' ? 'yes' : 'no';
    }

    widget.onSave(map);
  }

  bool validateAndSave() {
    final isValid = _formKey.currentState?.validate() ?? true;
    _notifyParent();
    return isValid;
  }

  void saveData() {
    _notifyParent();
  }

  void _addMember() {
    if (widget.isReadOnly) return;
    final nextNum = (_members.length + 1).toString().padLeft(2, '0');
    final newMember = HouseholdMemberRecord(
      memberId: '${widget.householdId}-$nextNum',
      memberName: '',
      age: 25,
      gender: 'Male',
      relationToHead: 'Son or daughter',
    );

    _showMemberDialog(newMember, isNew: true);
  }

  void _editMember(int index) {
    if (widget.isReadOnly) return;
    _showMemberDialog(_members[index], isNew: false, index: index);
  }

  void _deleteMember(int index) {
    if (widget.isReadOnly) return;
    setState(() {
      _members.removeAt(index);
    });
    _notifyParent();
  }

  void _showMemberDialog(HouseholdMemberRecord member,
      {required bool isNew, int? index}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _MemberFormDialog(
        member: member,
        householdId: widget.householdId,
        onSave: (savedMember) {
          setState(() {
            if (isNew) {
              _members.add(savedMember);
            } else if (index != null && index < _members.length) {
              _members[index] = savedMember;
            }
          });
          _notifyParent();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHouseholdProfileCard(theme),
          const SizedBox(height: 16),
          _buildFamilySizeCard(theme),
          const SizedBox(height: 16),
          _buildMembersCard(theme),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _cardContainer({
    required ThemeData theme,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          child,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.manrope(fontSize: 13, color: Colors.grey.shade500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerLowest,
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

  Widget _buildHouseholdProfileCard(ThemeData theme) {
    return _cardContainer(
      theme: theme,
      title: 'B1–B6: Household Structure & Demographics',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // B1: Household Type
          _label('B1. Household Type *', theme),
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: _householdType,
            decoration: _inputDecoration(theme, 'Select Household Type'),
            items: _householdTypes.map((t) {
              return DropdownMenuItem(value: t, child: Text(t, overflow: TextOverflow.ellipsis));
            }).toList(),
            onChanged: widget.isReadOnly
                ? null
                : (val) {
                    setState(() => _householdType = val);
                    _notifyParent();
                  },
          ),
          const SizedBox(height: 14),

          // B2: Household Head Status
          _label('B2. Household Head Status *', theme),
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: _headStatus,
            decoration: _inputDecoration(theme, 'Select Head Status'),
            items: _headStatuses.map((s) {
              return DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis));
            }).toList(),
            onChanged: widget.isReadOnly
                ? null
                : (val) {
                    setState(() => _headStatus = val);
                    _notifyParent();
                  },
          ),
          const SizedBox(height: 14),

          // B3: Type of House
          _label('B3. Type of House *', theme),
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: _houseType,
            decoration: _inputDecoration(theme, 'Select Type of House'),
            items: _houseTypes.map((h) {
              return DropdownMenuItem(value: h, child: Text(h, overflow: TextOverflow.ellipsis));
            }).toList(),
            onChanged: widget.isReadOnly
                ? null
                : (val) {
                    setState(() => _houseType = val);
                    _notifyParent();
                  },
          ),
          const SizedBox(height: 14),

          // B4: Religion of Household
          _label('B4. Religion of Household *', theme),
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: _religion,
            decoration: _inputDecoration(theme, 'Select Religion'),
            items: _religions.map((r) {
              return DropdownMenuItem(value: r, child: Text(r, overflow: TextOverflow.ellipsis));
            }).toList(),
            onChanged: widget.isReadOnly
                ? null
                : (val) {
                    setState(() => _religion = val);
                    _notifyParent();
                  },
          ),
          if (_religion == 'Other religion (specify)') ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _religionOtherController,
              readOnly: widget.isReadOnly,
              decoration: _inputDecoration(theme, 'Specify religion'),
              onChanged: (_) => _notifyParent(),
            ),
          ],
          const SizedBox(height: 14),

          // B5: Social Category
          _label('B5. Social Category *', theme),
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: _socialCategory,
            decoration: _inputDecoration(theme, 'Select Social Category'),
            items: _socialCategories.map((c) {
              return DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis));
            }).toList(),
            onChanged: widget.isReadOnly
                ? null
                : (val) {
                    setState(() => _socialCategory = val);
                    _notifyParent();
                  },
          ),
          if (_socialCategory == 'Other (specify)') ...[
            const SizedBox(height: 8),
            TextFormField(
              controller: _socialCategoryOtherController,
              readOnly: widget.isReadOnly,
              decoration: _inputDecoration(theme, 'Specify category'),
              onChanged: (_) => _notifyParent(),
            ),
          ],
          const SizedBox(height: 14),

          // B6: Tribe / Ethnic Group
          _label('B6. Tribe / Ethnic Group (e.g., Adi, Monpa, Tagin, Galo)', theme),
          TextFormField(
            controller: _tribeController,
            readOnly: widget.isReadOnly,
            textCapitalization: TextCapitalization.words,
            decoration: _inputDecoration(theme, 'Enter Tribe / Community name'),
            onChanged: (_) => _notifyParent(),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilySizeCard(ThemeData theme) {
    final total = _calculatedFamilySize;

    return _cardContainer(
      theme: theme,
      title: 'B7: Family Size Breakdown (Linked to Member Records)',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.people_alt_outlined, color: AppTheme.primary, size: 20),
                const SizedBox(width: 10),
                Text(
                  'Total Family Size: $total members',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_members.length} records added',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _members.length == total ? Colors.green.shade700 : Colors.orange.shade800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Adult Male & Female
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Adults: Male', theme),
                    TextFormField(
                      controller: _adultMaleController,
                      readOnly: widget.isReadOnly,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: _inputDecoration(theme, '0'),
                      onChanged: (_) {
                        setState(() {});
                        _notifyParent();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Adults: Female', theme),
                    TextFormField(
                      controller: _adultFemaleController,
                      readOnly: widget.isReadOnly,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: _inputDecoration(theme, '0'),
                      onChanged: (_) {
                        setState(() {});
                        _notifyParent();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Children Male & Female
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Children: Male', theme),
                    TextFormField(
                      controller: _childMaleController,
                      readOnly: widget.isReadOnly,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: _inputDecoration(theme, '0'),
                      onChanged: (_) {
                        setState(() {});
                        _notifyParent();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Children: Female', theme),
                    TextFormField(
                      controller: _childFemaleController,
                      readOnly: widget.isReadOnly,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: _inputDecoration(theme, '0'),
                      onChanged: (_) {
                        setState(() {});
                        _notifyParent();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMembersCard(ThemeData theme) {
    return _cardContainer(
      theme: theme,
      title: 'B8: Member-Level Repeatable Records',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Individual records for every household member',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (!widget.isReadOnly)
                FilledButton.icon(
                  onPressed: _addMember,
                  icon: const Icon(Icons.person_add_alt_1_outlined, size: 16),
                  label: const Text('Add Member'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    textStyle: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          if (_members.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Icon(Icons.group_outlined, size: 40, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    Text(
                      'No members recorded yet.\nClick "Add Member" to record household members.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _members.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final m = _members[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withAlpha(50),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppTheme.primary.withAlpha(30),
                        child: Text(
                          (index + 1).toString(),
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    m.memberName.isNotEmpty
                                        ? m.memberName
                                        : 'Member ${index + 1}',
                                    style: GoogleFonts.manrope(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    m.memberId,
                                    style: GoogleFonts.manrope(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                _badge('${m.age} yrs', Colors.grey.shade700, Colors.grey.shade100),
                                _badge(m.gender, Colors.teal.shade800, Colors.teal.shade50),
                                _badge(m.relationToHead, Colors.purple.shade800, Colors.purple.shade50),
                                _badge(m.educationLevel, Colors.indigo.shade800, Colors.indigo.shade50),
                                _badge(m.primaryOccupation, Colors.amber.shade900, Colors.amber.shade50),
                                if (m.migrationStatus != 'Not migrated / living in village')
                                  _badge('Migrant', Colors.red.shade800, Colors.red.shade50),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (!widget.isReadOnly) ...[
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                          onPressed: () => _editMember(index),
                          tooltip: 'Edit Member',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          onPressed: () => _deleteMember(index),
                          tooltip: 'Delete Member',
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Member Add / Edit Modal Dialog
// ─────────────────────────────────────────────────────────────────────────────

class _MemberFormDialog extends StatefulWidget {
  final HouseholdMemberRecord member;
  final String householdId;
  final ValueChanged<HouseholdMemberRecord> onSave;

  const _MemberFormDialog({
    required this.member,
    required this.householdId,
    required this.onSave,
  });

  @override
  State<_MemberFormDialog> createState() => _MemberFormDialogState();
}

class _MemberFormDialogState extends State<_MemberFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late String _gender;
  late String _relation;

  // Education
  late String _educationLevel;
  late String _presentEducationStatus;
  late bool _isDropout;
  String? _ageAtDropout;
  late List<String> _dropoutReasons;
  late TextEditingController _dropoutReasonOtherController;
  bool? _willingToContinue;
  late List<String> _supportNeeded;
  late TextEditingController _supportOtherController;

  // Primary Occupation
  late String _primaryOccupation;
  late List<String> _farmingActivities;
  late List<String> _notWorkingReasons;

  // Migration
  late String _migrationStatus;
  String? _placeOfMigration;
  late TextEditingController _destinationController;
  String? _migrationReason;
  String? _durationAway;
  String? _returnFrequency;
  bool? _contributesIncome;
  late TextEditingController _annualContributionController;

  // Secondary Skills
  late List<String> _secondarySkills;
  String? _skillFrequency;
  late List<String> _skillMonths;
  String? _skillProficiency;
  late List<String> _commercialSupport;

  final List<String> _genders = ['Male', 'Female', 'Transgender'];
  final List<String> _relations = [
    'Head',
    'Spouse',
    'Son or daughter',
    'Parent',
    'Sibling',
    'In laws',
    'Blood Relatives',
    'Guardian',
    'Others',
  ];
  final List<String> _educationLevels = [
    'No formal education',
    'Read and write',
    'Primary school (1-5)',
    'Secondary school (6-10)',
    'Higher secondary (11-12)',
    'ITI or vocational',
    'Diploma',
    'Graduate',
    'Postgraduate',
    'PhD',
    'Other',
  ];
  final List<String> _dropoutAgeBands = [
    '<15',
    '15–20',
    '20–25',
    '25 and above',
  ];
  final List<String> _allDropoutReasons = [
    'Not interested',
    'Family financial difficulty',
    'No suitable school nearby',
    'Transportation',
    'Health',
    'Family migration',
    'Marriage',
    'Poor academic performance',
    'Other',
  ];
  final List<String> _allSupportOptions = [
    'Admission support',
    'Transport',
    'Hostel',
    'Other specify',
  ];
  final List<String> _allOccupations = [
    'Farming',
    'Wage labour',
    'Business',
    'Government service',
    'Self-employment',
    'Pension / retired',
    'Unemployed',
    'Not working',
    'Housewife / Homemaker',
  ];
  final List<String> _allFarmingActivities = [
    'Agriculture',
    'Horticulture',
    'Livestock',
    'Fishery',
  ];
  final List<String> _allNotWorkingReasons = [
    'Age',
    'Health',
    'Searching job',
  ];
  final List<String> _allMigrationStatuses = [
    'Not migrated / living in village',
    'Current migrant',
    'Returned migrant',
    'Migrates periodically',
  ];
  final List<String> _allMigrationPlaces = [
    'Nearby city/district or state capital',
    'Within country',
    'Outside country',
  ];
  final List<String> _allMigrationReasons = [
    'Employment',
    'Higher income',
    'Business',
    'Education',
    'Health',
    'Family reasons',
    'Marriage',
    'Lack of local livelihood',
    'Other',
  ];
  final List<String> _allDurations = [
    '<1 month',
    '1–3 months',
    '3–6 months',
    '6–12 months',
    '>12 months',
    'Does not return regularly',
  ];
  final List<String> _allFrequencies = [
    'Monthly',
    'Seasonally',
    'Annually',
    'Irregular',
    'Never during period',
    'Other',
  ];
  final List<String> _allSkills = [
    'Beekeeping',
    'Mushroom',
    'Poultry',
    'Piggery',
    'Goatery',
    'Dairy',
    'Fishery',
    'Nursery',
    'Food processing',
    'Baking',
    'Weaving',
    'Handicraft',
    'Bamboo/cane',
    'Carpentry/woodwork',
    'Masonry',
    'NTFP/MAP collection',
    'Tourism/homestay',
    'Electrician',
    'Others',
    'None / Not Known',
  ];
  final List<String> _allSkillFrequencies = [
    'Regular and daily',
    'Regular but seasonal',
    'Occasionally',
    'Rarely',
    'Only when required',
  ];
  final List<String> _allSkillMonths = [
    'Jan–Mar',
    'Apr–Jun',
    'Jul–Sep',
    'Oct–Dec',
  ];
  final List<String> _allProficiencies = [
    'Basic',
    'Moderate',
    'Advanced',
    'Master or traditional expert',
  ];
  final List<String> _allCommercialSupports = [
    'Training/upskilling',
    'Equipment',
    'Raw material',
    'Workspace',
    'Working capital',
    'Packaging',
    'Branding',
    'Certification',
    'Market linkage',
    'Digital marketing',
    'Business planning',
    'Credit/loan',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    final m = widget.member;
    _nameController = TextEditingController(text: m.memberName);
    _ageController = TextEditingController(text: m.age > 0 ? m.age.toString() : '');
    _gender = m.gender;
    _relation = m.relationToHead;

    _educationLevel = m.educationLevel;
    _presentEducationStatus = m.presentEducationStatus;
    _isDropout = m.isDropout;
    _ageAtDropout = m.ageAtDropout;
    _dropoutReasons = List.from(m.dropoutReasons);
    _dropoutReasonOtherController =
        TextEditingController(text: m.dropoutReasonOther ?? '');
    _willingToContinue = m.willingToContinue;
    _supportNeeded = List.from(m.supportNeeded);
    _supportOtherController =
        TextEditingController(text: m.supportNeededOther ?? '');

    _primaryOccupation = m.primaryOccupation;
    _farmingActivities = List.from(m.farmingActivities);
    _notWorkingReasons = List.from(m.notWorkingReasons);

    _migrationStatus = m.migrationStatus;
    _placeOfMigration = m.placeOfMigration;
    _destinationController = TextEditingController(text: m.destinationText ?? '');
    _migrationReason = m.migrationReason;
    _durationAway = m.durationAway;
    _returnFrequency = m.returnFrequency;
    _contributesIncome = m.contributesIncome;
    _annualContributionController =
        TextEditingController(text: m.annualContribution ?? '');

    _secondarySkills = List.from(m.secondarySkills);
    _skillFrequency = m.skillFrequency;
    _skillMonths = List.from(m.skillMonths);
    _skillProficiency = m.skillProficiency;
    _commercialSupport = List.from(m.commercialSupportNeeded);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _dropoutReasonOtherController.dispose();
    _supportOtherController.dispose();
    _destinationController.dispose();
    _annualContributionController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    if (!_formKey.currentState!.validate()) return;

    final parsedAge = int.tryParse(_ageController.text.trim()) ?? 0;
    final updated = HouseholdMemberRecord(
      memberId: widget.member.memberId,
      memberName: _nameController.text.trim().toUpperCase(),
      age: parsedAge,
      gender: _gender,
      relationToHead: _relation,
      educationLevel: _educationLevel,
      presentEducationStatus: _presentEducationStatus,
      isDropout: _isDropout,
      ageAtDropout: _isDropout ? _ageAtDropout : null,
      dropoutReasons: _isDropout ? _dropoutReasons : [],
      dropoutReasonOther: _isDropout ? _dropoutReasonOtherController.text.trim() : null,
      willingToContinue: (_isDropout && parsedAge >= 10 && parsedAge <= 25) ? _willingToContinue : null,
      supportNeeded: (_isDropout && _willingToContinue == true) ? _supportNeeded : [],
      supportNeededOther: (_isDropout && _willingToContinue == true) ? _supportOtherController.text.trim() : null,
      primaryOccupation: _primaryOccupation,
      farmingActivities: _primaryOccupation == 'Farming' ? _farmingActivities : [],
      notWorkingReasons: _primaryOccupation == 'Not working' ? _notWorkingReasons : [],
      migrationStatus: _migrationStatus,
      placeOfMigration: _isMigrant ? _placeOfMigration : null,
      destinationText: _isMigrant ? _destinationController.text.trim() : null,
      migrationReason: _isMigrant ? _migrationReason : null,
      durationAway: _isMigrant ? _durationAway : null,
      returnFrequency: _isMigrant ? _returnFrequency : null,
      contributesIncome: _isMigrant ? _contributesIncome : null,
      annualContribution: (_isMigrant && _contributesIncome == true) ? _annualContributionController.text.trim() : null,
      secondarySkills: _secondarySkills,
      skillFrequency: _hasSkills ? _skillFrequency : null,
      skillMonths: _hasSkills ? _skillMonths : [],
      skillProficiency: _hasSkills ? _skillProficiency : null,
      commercialSupportNeeded: _hasSkills ? _commercialSupport : [],
    );

    widget.onSave(updated);
    Navigator.of(context).pop();
  }

  bool get _isPursuing => _presentEducationStatus == 'Pursuing';
  bool get _isMigrant => _migrationStatus != 'Not migrated / living in village';
  bool get _hasSkills =>
      _secondarySkills.isNotEmpty && !_secondarySkills.contains('None / Not Known');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_outline, color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Household Member Details (${widget.member.memberId})',
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionHeader('1. Basic Demographics'),
                      const SizedBox(height: 12),

                      // Name
                      _label('Full Name (CAPS ONLY) *', theme),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: _dialogInputDecoration('ENTER FULL NAME'),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Member name is required';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Age & Gender
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Age *', theme),
                                TextFormField(
                                  controller: _ageController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: _dialogInputDecoration('Age in years'),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return 'Age is required';
                                    return null;
                                  },
                                  onChanged: (_) => setState(() {}),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Gender *', theme),
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  initialValue: _gender,
                                  decoration: _dialogInputDecoration('Gender'),
                                  items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g, overflow: TextOverflow.ellipsis))).toList(),
                                  onChanged: (val) => setState(() => _gender = val!),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Relation to Head
                      _label('Relationship to Household Head *', theme),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _relation,
                        decoration: _dialogInputDecoration('Select Relationship'),
                        items: _relations.map((r) => DropdownMenuItem(value: r, child: Text(r, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) => setState(() => _relation = val!),
                      ),
                      const SizedBox(height: 20),

                      _sectionHeader('2. Education & Status'),
                      const SizedBox(height: 12),

                      _label('Highest Education Level *', theme),
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue: _educationLevel,
                        decoration: _dialogInputDecoration('Select Level'),
                        items: _educationLevels.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) => setState(() => _educationLevel = val!),
                      ),
                      const SizedBox(height: 12),

                      _label('Present Status of Education *', theme),
                      Row(
                        children: [
                          _choiceChip('Pursuing', _presentEducationStatus == 'Pursuing', () {
                            setState(() => _presentEducationStatus = 'Pursuing');
                          }),
                          const SizedBox(width: 12),
                          _choiceChip('Not pursuing', _presentEducationStatus == 'Not pursuing', () {
                            setState(() => _presentEducationStatus = 'Not pursuing');
                          }),
                        ],
                      ),

                      if (_isPursuing) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Member is currently pursuing education. Remaining employment, dropout & migration questions are skipped.',
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 16),
                        _label('School / College Dropout or Not Attended? *', theme),
                        Row(
                          children: [
                            _choiceChip('Yes', _isDropout, () => setState(() => _isDropout = true)),
                            const SizedBox(width: 12),
                            _choiceChip('No', !_isDropout, () => setState(() => _isDropout = false)),
                          ],
                        ),

                        if (_isDropout) ...[
                          const SizedBox(height: 12),
                          _label('Age at Dropout', theme),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            initialValue: _ageAtDropout,
                            decoration: _dialogInputDecoration('Select Age Band'),
                            items: _dropoutAgeBands.map((b) => DropdownMenuItem(value: b, child: Text(b, overflow: TextOverflow.ellipsis))).toList(),
                            onChanged: (val) => setState(() => _ageAtDropout = val),
                          ),
                          const SizedBox(height: 12),

                          _label('Main Reason for Dropping (Select up to 2)', theme),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _allDropoutReasons.map((reason) {
                              final selected = _dropoutReasons.contains(reason);
                              return FilterChip(
                                label: Text(reason),
                                selected: selected,
                                onSelected: (sel) {
                                  setState(() {
                                    if (sel) {
                                      if (_dropoutReasons.length < 2) {
                                        _dropoutReasons.add(reason);
                                      }
                                    } else {
                                      _dropoutReasons.remove(reason);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          if (_dropoutReasons.contains('Other')) ...[
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _dropoutReasonOtherController,
                              decoration: _dialogInputDecoration('Specify dropout reason'),
                            ),
                          ],

                          // Willing to continue if age 10-25
                          if ((int.tryParse(_ageController.text.trim()) ?? 0) >= 10 &&
                              (int.tryParse(_ageController.text.trim()) ?? 0) <= 25) ...[
                            const SizedBox(height: 12),
                            _label('Willing to continue education if support is given?', theme),
                            Row(
                              children: [
                                _choiceChip('Yes', _willingToContinue == true,
                                    () => setState(() => _willingToContinue = true)),
                                const SizedBox(width: 12),
                                _choiceChip('No', _willingToContinue == false,
                                    () => setState(() => _willingToContinue = false)),
                              ],
                            ),
                            if (_willingToContinue == true) ...[
                              const SizedBox(height: 8),
                              _label('Type of Support Desired', theme),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _allSupportOptions.map((opt) {
                                  final sel = _supportNeeded.contains(opt);
                                  return FilterChip(
                                    label: Text(opt),
                                    selected: sel,
                                    onSelected: (val) {
                                      setState(() {
                                        if (val) {
                                          _supportNeeded.add(opt);
                                        } else {
                                          _supportNeeded.remove(opt);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              if (_supportNeeded.contains('Other specify')) ...[
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _supportOtherController,
                                  decoration: _dialogInputDecoration('Specify support needed'),
                                ),
                              ],
                            ],
                          ],
                        ],

                        const SizedBox(height: 20),
                        _sectionHeader('3. Primary Occupation'),
                        const SizedBox(height: 12),

                        _label('Current / Primary Occupation *', theme),
                        DropdownButtonFormField<String>(
                          initialValue: _primaryOccupation,
                          decoration: _dialogInputDecoration('Select Occupation'),
                          items: _allOccupations.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                          onChanged: (val) => setState(() => _primaryOccupation = val!),
                        ),

                        if (_primaryOccupation == 'Farming') ...[
                          const SizedBox(height: 10),
                          _label('Farming Activities Practiced (Select all that apply)', theme),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _allFarmingActivities.map((act) {
                              final sel = _farmingActivities.contains(act);
                              return FilterChip(
                                label: Text(act),
                                selected: sel,
                                onSelected: (val) {
                                  setState(() {
                                    if (val) {
                                      _farmingActivities.add(act);
                                    } else {
                                      _farmingActivities.remove(act);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],

                        if (_primaryOccupation == 'Not working') ...[
                          const SizedBox(height: 10),
                          _label('Reason Not Working (Select all that apply)', theme),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _allNotWorkingReasons.map((r) {
                              final sel = _notWorkingReasons.contains(r);
                              return FilterChip(
                                label: Text(r),
                                selected: sel,
                                onSelected: (val) {
                                  setState(() {
                                    if (val) {
                                      _notWorkingReasons.add(r);
                                    } else {
                                      _notWorkingReasons.remove(r);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],

                        const SizedBox(height: 20),
                        _sectionHeader('4. Migration Profile'),
                        const SizedBox(height: 12),

                        _label('Migration Status *', theme),
                        DropdownButtonFormField<String>(
                          initialValue: _migrationStatus,
                          decoration: _dialogInputDecoration('Select Status'),
                          items: _allMigrationStatuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                          onChanged: (val) => setState(() => _migrationStatus = val!),
                        ),

                        if (_isMigrant) ...[
                          const SizedBox(height: 12),
                          _label('Place of Migration', theme),
                          DropdownButtonFormField<String>(
                            initialValue: _placeOfMigration,
                            decoration: _dialogInputDecoration('Select Place'),
                            items: _allMigrationPlaces.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                            onChanged: (val) => setState(() => _placeOfMigration = val),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _destinationController,
                            decoration: _dialogInputDecoration('Destination City / State / Country'),
                          ),
                          const SizedBox(height: 12),

                          _label('Main Reason for Migration', theme),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            initialValue: _migrationReason,
                            decoration: _dialogInputDecoration('Select Reason'),
                            items: _allMigrationReasons.map((r) => DropdownMenuItem(value: r, child: Text(r, overflow: TextOverflow.ellipsis))).toList(),
                            onChanged: (val) => setState(() => _migrationReason = val),
                          ),
                          const SizedBox(height: 12),

                          _label('Typical Duration Away', theme),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            initialValue: _durationAway,
                            decoration: _dialogInputDecoration('Select Duration Away'),
                            items: _allDurations.map((d) => DropdownMenuItem(value: d, child: Text(d, overflow: TextOverflow.ellipsis))).toList(),
                            onChanged: (val) => setState(() => _durationAway = val),
                          ),
                          const SizedBox(height: 12),

                          _label('Return Frequency', theme),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            initialValue: _returnFrequency,
                            decoration: _dialogInputDecoration('Select Return Frequency'),
                            items: _allFrequencies.map((f) => DropdownMenuItem(value: f, child: Text(f, overflow: TextOverflow.ellipsis))).toList(),
                            onChanged: (val) => setState(() => _returnFrequency = val),
                          ),
                          const SizedBox(height: 12),

                          _label('Contributes to Household Income?', theme),
                          Row(
                            children: [
                              _choiceChip('Yes', _contributesIncome == true,
                                  () => setState(() => _contributesIncome = true)),
                              const SizedBox(width: 12),
                              _choiceChip('No', _contributesIncome == false,
                                  () => setState(() => _contributesIncome = false)),
                            ],
                          ),
                          if (_contributesIncome == true) ...[
                            const SizedBox(height: 8),
                            _label('Approximate Annual Contribution (₹)', theme),
                            TextFormField(
                              controller: _annualContributionController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: _dialogInputDecoration('₹ Amount per year'),
                            ),
                          ],
                        ],

                        const SizedBox(height: 20),
                        _sectionHeader('5. Secondary Occupation & Skills'),
                        const SizedBox(height: 12),

                        _label('Secondary Occupations / Skills Known (Multi-select)', theme),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _allSkills.map((sk) {
                            final sel = _secondarySkills.contains(sk);
                            return FilterChip(
                              label: Text(sk),
                              selected: sel,
                              onSelected: (val) {
                                setState(() {
                                  if (sk == 'None / Not Known') {
                                    _secondarySkills.clear();
                                    if (val) _secondarySkills.add('None / Not Known');
                                  } else {
                                    _secondarySkills.remove('None / Not Known');
                                    if (val) {
                                      _secondarySkills.add(sk);
                                    } else {
                                      _secondarySkills.remove(sk);
                                    }
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),

                        if (_hasSkills) ...[
                          const SizedBox(height: 14),
                          _label('Frequency of Secondary Occupation', theme),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            initialValue: _skillFrequency,
                            decoration: _dialogInputDecoration('Select Frequency'),
                            items: _allSkillFrequencies.map((f) => DropdownMenuItem(value: f, child: Text(f, overflow: TextOverflow.ellipsis))).toList(),
                            onChanged: (val) => setState(() => _skillFrequency = val),
                          ),
                          const SizedBox(height: 12),

                          _label('Months / Season of Involvement', theme),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _allSkillMonths.map((m) {
                              final sel = _skillMonths.contains(m);
                              return FilterChip(
                                label: Text(m),
                                selected: sel,
                                onSelected: (val) {
                                  setState(() {
                                    if (val) {
                                      _skillMonths.add(m);
                                    } else {
                                      _skillMonths.remove(m);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 12),

                          _label('Skill Proficiency Level', theme),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            initialValue: _skillProficiency,
                            decoration: _dialogInputDecoration('Select Proficiency'),
                            items: _allProficiencies.map((p) => DropdownMenuItem(value: p, child: Text(p, overflow: TextOverflow.ellipsis))).toList(),
                            onChanged: (val) => setState(() => _skillProficiency = val),
                          ),
                          const SizedBox(height: 12),

                          _label('Support Needed to Commercialise Skill', theme),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _allCommercialSupports.map((cs) {
                              final sel = _commercialSupport.contains(cs);
                              return FilterChip(
                                label: Text(cs),
                                selected: sel,
                                onSelected: (val) {
                                  setState(() {
                                    if (val) {
                                      _commercialSupport.add(cs);
                                    } else {
                                      _commercialSupport.remove(cs);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Footer actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(color: theme.colorScheme.outline.withAlpha(50)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _onSavePressed,
                    style: FilledButton.styleFrom(backgroundColor: AppTheme.primary),
                    child: const Text('Save Member'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppTheme.primary,
        ),
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

  Widget _choiceChip(String text, bool selected, VoidCallback onTap) {
    return FilterChip(
      label: Text(
        text,
        style: GoogleFonts.manrope(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? AppTheme.primary : Colors.black87,
        ),
      ),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppTheme.primaryContainer,
      backgroundColor: Colors.grey.shade100,
      checkmarkColor: AppTheme.primary,
      side: BorderSide(
        color: selected ? AppTheme.primary : Colors.grey.shade300,
        width: selected ? 1.4 : 1.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  InputDecoration _dialogInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.manrope(fontSize: 12, color: Colors.grey.shade400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      isDense: true,
    );
  }
}

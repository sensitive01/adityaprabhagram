import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../../theme/app_theme.dart';

// ─── Data model ──────────────────────────────────────────────────────────────

class _EnterpriseItem {
  /// Stable client-generated UUID — generated once, reused on every reopen.
  final String id;
  final String enterpriseCode;
  String enterpriseName; // mutable for "other"
  String currentlyPracticing; // "yes" | "no" | ""
  String trainingReceived; // "yes" | "no" | ""
  String skillLevel; // "low" | "medium" | "high" | ""
  String needTraining; // "yes" | "no" | ""
  String priorityLevel; // "high" | "medium" | "low" | ""
  List<String> preferredTrainingAreas; // list of area codes
  String otherSpecify; // free text for "other" enterprise name
  String otherTrainingAreaText; // free text for "other" preferred training area

  _EnterpriseItem({
    required this.id,
    required this.enterpriseCode,
    required this.enterpriseName,
    this.currentlyPracticing = '',
    this.trainingReceived = '',
    this.skillLevel = '',
    this.needTraining = '',
    this.priorityLevel = '',
    List<String>? preferredTrainingAreas,
    this.otherSpecify = '',
    this.otherTrainingAreaText = '',
  }) : preferredTrainingAreas = preferredTrainingAreas ?? [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'enterprise_code': enterpriseCode,
    'enterprise_name': enterpriseName,
    'currently_practicing': currentlyPracticing,
    'training_received': trainingReceived,
    'skill_level': skillLevel,
    'need_training': needTraining,
    'priority_level': priorityLevel,
    'preferred_training_areas': preferredTrainingAreas,
    'other_specify': otherSpecify,
    'other_training_area_text': otherTrainingAreaText,
  };

  factory _EnterpriseItem.fromJson(Map<String, dynamic> json) {
    final persistedId = (json['id'] as String?)?.trim() ?? '';
    final areas = json['preferred_training_areas'];
    List<String> areaList = [];
    if (areas is List) {
      areaList = areas
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return _EnterpriseItem(
      id: persistedId.isNotEmpty ? persistedId : const Uuid().v4(),
      enterpriseCode: (json['enterprise_code'] as String?) ?? '',
      enterpriseName: (json['enterprise_name'] as String?) ?? '',
      currentlyPracticing: (json['currently_practicing'] as String?) ?? '',
      trainingReceived: (json['training_received'] as String?) ?? '',
      skillLevel: (json['skill_level'] as String?) ?? '',
      needTraining: (json['need_training'] as String?) ?? '',
      priorityLevel: (json['priority_level'] as String?) ?? '',
      preferredTrainingAreas: areaList,
      otherSpecify: (json['other_specify'] as String?) ?? '',
      otherTrainingAreaText:
          (json['other_training_area_text'] as String?) ?? '',
    );
  }
}

// ─── Fixed enterprise definitions ────────────────────────────────────────────

const List<Map<String, dynamic>> _kFixedEnterprises = [
  {
    'code': 'crop_production',
    'name': 'Crop Production',
    'training_areas': [
      {'code': 'improved_seeds', 'label': 'Improved seeds'},
      {'code': 'ipm', 'label': 'IPM'},
      {'code': 'inm', 'label': 'INM'},
      {'code': 'water_management', 'label': 'Water management'},
    ],
  },
  {
    'code': 'horticulture',
    'name': 'Horticulture',
    'training_areas': [
      {'code': 'nursery', 'label': 'Nursery'},
      {'code': 'pruning', 'label': 'Pruning'},
      {'code': 'pest_management', 'label': 'Pest management'},
    ],
  },
  {
    'code': 'livestock',
    'name': 'Livestock (Dairy/Meat)',
    'training_areas': [
      {'code': 'breed_mgmt', 'label': 'Breed mgmt'},
      {'code': 'feeding', 'label': 'Feeding'},
      {'code': 'health_care', 'label': 'Health care'},
    ],
  },
  {
    'code': 'piggery',
    'name': 'Piggery',
    'training_areas': [
      {'code': 'breed', 'label': 'Breed'},
      {'code': 'feed', 'label': 'Feed'},
      {'code': 'disease_control', 'label': 'Disease control'},
    ],
  },
  {
    'code': 'poultry',
    'name': 'Poultry',
    'training_areas': [
      {'code': 'backyard', 'label': 'Backyard'},
      {'code': 'vaccination', 'label': 'Vaccination'},
      {'code': 'housing', 'label': 'Housing'},
    ],
  },
  {
    'code': 'fishery',
    'name': 'Fishery',
    'training_areas': [
      {'code': 'pond_mgmt', 'label': 'Pond mgmt'},
      {'code': 'feeding_fish', 'label': 'Feeding'},
      {'code': 'stocking', 'label': 'Stocking'},
    ],
  },
  {
    'code': 'beekeeping',
    'name': 'Beekeeping',
    'training_areas': [
      {'code': 'hive_mgmt', 'label': 'Hive mgmt'},
      {'code': 'honey_extraction', 'label': 'Honey extraction'},
    ],
  },
  {
    'code': 'mushroom',
    'name': 'Mushroom',
    'training_areas': [
      {'code': 'spawn', 'label': 'Spawn'},
      {'code': 'cultivation', 'label': 'Cultivation'},
      {'code': 'marketing_mushroom', 'label': 'Marketing'},
    ],
  },
  {
    'code': 'food_processing',
    'name': 'Food Processing',
    'training_areas': [
      {'code': 'value_addition', 'label': 'Value addition'},
      {'code': 'packaging', 'label': 'Packaging'},
    ],
  },
  {
    'code': 'marketing_business',
    'name': 'Marketing & Business',
    'training_areas': [
      {'code': 'pricing', 'label': 'Pricing'},
      {'code': 'branding', 'label': 'Branding'},
      {'code': 'digital_sales', 'label': 'Digital sales'},
    ],
  },
  {
    'code': 'other',
    'name': 'Others (specify)',
    'training_areas': <Map<String, dynamic>>[],
  },
];

// ─── Widget ───────────────────────────────────────────────────────────────────

/// P2 — Enterprise-wise Training Needs Assessment.
///
/// Shows 11 fixed enterprise accordion cards. One expanded at a time.
/// Stores the complete matrix under "P2-TRAINING-NEEDS" via [onAnswer].
class P2TrainingNeedsSectionWidget extends StatefulWidget {
  /// Current value of `_answers['P2-TRAINING-NEEDS']`.
  final dynamic answer;

  /// Called whenever any enterprise item changes.
  final ValueChanged<dynamic> onAnswer;

  final bool isReadOnly;

  const P2TrainingNeedsSectionWidget({
    super.key,
    required this.answer,
    required this.onAnswer,
    this.isReadOnly = false,
  });

  @override
  State<P2TrainingNeedsSectionWidget> createState() =>
      _P2TrainingNeedsSectionWidgetState();
}

class _P2TrainingNeedsSectionWidgetState
    extends State<P2TrainingNeedsSectionWidget> {
  late List<_EnterpriseItem> _items;
  int? _expandedIndex; // null = all collapsed

  // Text controllers for free-text fields
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _items = _buildInitialItems();
    _initControllers();
  }

  @override
  void didUpdateWidget(P2TrainingNeedsSectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.answer != widget.answer) {
      final newItems = _buildInitialItems();
      for (int i = 0; i < _items.length; i++) {
        final newItem = newItems[i];
        _items[i].currentlyPracticing = newItem.currentlyPracticing;
        _items[i].trainingReceived = newItem.trainingReceived;
        _items[i].skillLevel = newItem.skillLevel;
        _items[i].needTraining = newItem.needTraining;
        _items[i].priorityLevel = newItem.priorityLevel;
        _items[i].preferredTrainingAreas = newItem.preferredTrainingAreas;
        _items[i].otherSpecify = newItem.otherSpecify;
        _items[i].otherTrainingAreaText = newItem.otherTrainingAreaText;
        if (_items[i].enterpriseCode == 'other') {
          _items[i].enterpriseName = newItem.enterpriseName;
        }
        _syncControllers(_items[i]);
      }
    }
  }

  /// Builds the initial list of enterprise items, merging saved data if available.
  List<_EnterpriseItem> _buildInitialItems() {
    final Map<String, _EnterpriseItem> savedByCode = {};
    final raw = widget.answer;
    if (raw != null) {
      List<dynamic>? list;
      if (raw is List) {
        list = raw;
      } else if (raw is String && raw.isNotEmpty) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is List) list = decoded;
        } catch (_) {}
      }
      if (list != null) {
        for (final item in list) {
          if (item is Map<String, dynamic>) {
            final parsed = _EnterpriseItem.fromJson(item);
            if (parsed.enterpriseCode.isNotEmpty) {
              savedByCode[parsed.enterpriseCode] = parsed;
            }
          }
        }
      }
    }

    return _kFixedEnterprises.map((def) {
      final code = def['code'] as String;
      final defaultName = def['name'] as String;
      if (savedByCode.containsKey(code)) {
        return savedByCode[code]!;
      }
      // New item — generate a stable UUID now
      return _EnterpriseItem(
        id: const Uuid().v4(),
        enterpriseCode: code,
        enterpriseName: defaultName,
      );
    }).toList();
  }

  void _initControllers() {
    for (final item in _items) {
      _syncControllers(item);
    }
  }

  void _syncControllers(_EnterpriseItem item) {
    final otherAreaKey = '${item.enterpriseCode}_other_area';
    _controllers.putIfAbsent(otherAreaKey, () => TextEditingController());
    if (_controllers[otherAreaKey]!.text != item.otherTrainingAreaText) {
      _controllers[otherAreaKey]!.text = item.otherTrainingAreaText;
    }
    if (item.enterpriseCode == 'other') {
      final nameKey = '${item.enterpriseCode}_enterprise_name';
      _controllers.putIfAbsent(nameKey, () => TextEditingController());
      final displayName = item.enterpriseName == 'Others (specify)'
          ? ''
          : item.enterpriseName;
      if (_controllers[nameKey]!.text != displayName) {
        _controllers[nameKey]!.text = displayName;
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _notifyChange() {
    widget.onAnswer(_items.map((e) => e.toJson()).toList());
  }

  void _updateItem(int index, void Function(_EnterpriseItem) updater) {
    setState(() {
      updater(_items[index]);
    });
    _notifyChange();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'P2. Enterprise-wise Training Needs Assessment',
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A2B4A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'For each enterprise, please provide the following information.',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        // Enterprise cards
        ...List.generate(_items.length, (i) => _buildEnterpriseCard(i)),
      ],
    );
  }

  Widget _buildEnterpriseCard(int index) {
    final item = _items[index];
    final isExpanded = _expandedIndex == index;
    final def = _kFixedEnterprises[index];
    final trainingAreas = (def['training_areas'] as List)
        .cast<Map<String, dynamic>>();
    final isOther = item.enterpriseCode == 'other';

    // Display name
    final displayName =
        isOther &&
            item.enterpriseName.isNotEmpty &&
            item.enterpriseName != 'Others (specify)'
        ? item.enterpriseName
        : def['name'] as String;

    // Number badge color
    final badgeColors = [
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFFFF9800),
      const Color(0xFF9C27B0),
      const Color(0xFFE91E63),
      const Color(0xFF00BCD4),
      const Color(0xFF795548),
      const Color(0xFF607D8B),
      const Color(0xFFFF5722),
      const Color(0xFF3F51B5),
      const Color(0xFF9E9E9E),
    ];
    final badgeColor = badgeColors[index % badgeColors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isExpanded ? AppTheme.primary : const Color(0xFFE2E8F0),
          width: isExpanded ? 1.5 : 1,
        ),
        boxShadow: isExpanded
            ? [
                BoxShadow(
                  color: AppTheme.primary.withAlpha(25),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          // Header row (tap to expand/collapse)
          InkWell(
            onTap: () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      displayName,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A2B4A),
                      ),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF6B7280),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          // Expanded content
          if (isExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Other" enterprise name field
                  if (isOther) ...[
                    _buildLabel('Enterprise name (specify)'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller:
                          _controllers['${item.enterpriseCode}_enterprise_name']!,
                      hint: 'Enter enterprise name',
                      onChanged: (v) {
                        _updateItem(index, (it) {
                          it.enterpriseName = v.trim().isEmpty
                              ? 'Others (specify)'
                              : v.trim();
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                  ],
                  // Currently practicing
                  _buildLabel('Currently practicing this enterprise?'),
                  const SizedBox(height: 8),
                  _buildYesNoRow(
                    value: item.currentlyPracticing,
                    onChanged: (v) =>
                        _updateItem(index, (it) => it.currentlyPracticing = v),
                  ),
                  const SizedBox(height: 14),
                  // Training received
                  _buildLabel('Have you received any training?'),
                  const SizedBox(height: 8),
                  _buildYesNoRow(
                    value: item.trainingReceived,
                    onChanged: (v) =>
                        _updateItem(index, (it) => it.trainingReceived = v),
                  ),
                  const SizedBox(height: 14),
                  // Skill level
                  _buildLabel('Your skill level'),
                  const SizedBox(height: 8),
                  _buildThreeOptionRow(
                    options: const ['Low', 'Medium', 'High'],
                    values: const ['low', 'medium', 'high'],
                    selected: item.skillLevel,
                    onChanged: (v) =>
                        _updateItem(index, (it) => it.skillLevel = v),
                  ),
                  const SizedBox(height: 14),
                  // Need training
                  _buildLabel('Do you need training?'),
                  const SizedBox(height: 8),
                  _buildYesNoRow(
                    value: item.needTraining,
                    onChanged: (v) =>
                        _updateItem(index, (it) => it.needTraining = v),
                  ),
                  const SizedBox(height: 14),
                  // Priority level
                  _buildLabel('Priority level'),
                  const SizedBox(height: 8),
                  _buildThreeOptionRow(
                    options: const ['High', 'Medium', 'Low'],
                    values: const ['high', 'medium', 'low'],
                    selected: item.priorityLevel,
                    onChanged: (v) =>
                        _updateItem(index, (it) => it.priorityLevel = v),
                  ),
                  const SizedBox(height: 14),
                  // Preferred training areas
                  _buildLabel(
                    'Preferred training area (select all that apply)',
                  ),
                  const SizedBox(height: 8),
                  if (isOther) ...[
                    // Free text for "other" enterprise
                    _buildTextField(
                      controller:
                          _controllers['${item.enterpriseCode}_other_area']!,
                      hint: 'Enter preferred training area(s)',
                      onChanged: (v) {
                        _updateItem(
                          index,
                          (it) => it.otherTrainingAreaText = v,
                        );
                      },
                    ),
                  ] else ...[
                    // Multi-select checkboxes
                    ...trainingAreas.map((area) {
                      final areaCode = area['code'] as String;
                      final areaLabel = area['label'] as String;
                      final isChecked = item.preferredTrainingAreas.contains(
                        areaCode,
                      );
                      return _buildCheckboxRow(
                        label: areaLabel,
                        checked: isChecked,
                        onChanged: widget.isReadOnly
                            ? null
                            : (checked) {
                                _updateItem(index, (it) {
                                  if (checked == true) {
                                    if (!it.preferredTrainingAreas.contains(
                                      areaCode,
                                    )) {
                                      it.preferredTrainingAreas = [
                                        ...it.preferredTrainingAreas,
                                        areaCode,
                                      ];
                                    }
                                  } else {
                                    it.preferredTrainingAreas = it
                                        .preferredTrainingAreas
                                        .where((c) => c != areaCode)
                                        .toList();
                                  }
                                });
                              },
                      );
                    }),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF374151),
      ),
    );
  }

  Widget _buildYesNoRow({
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      children: [
        _buildRadioOption(
          label: 'Yes',
          selected: value == 'yes',
          onTap: widget.isReadOnly ? null : () => onChanged('yes'),
        ),
        const SizedBox(width: 16),
        _buildRadioOption(
          label: 'No',
          selected: value == 'no',
          onTap: widget.isReadOnly ? null : () => onChanged('no'),
        ),
      ],
    );
  }

  Widget _buildThreeOptionRow({
    required List<String> options,
    required List<String> values,
    required String selected,
    required ValueChanged<String> onChanged,
  }) {
    return Row(
      children: List.generate(options.length, (i) {
        return Padding(
          padding: EdgeInsets.only(right: i < options.length - 1 ? 16 : 0),
          child: _buildRadioOption(
            label: options[i],
            selected: selected == values[i],
            onTap: widget.isReadOnly ? null : () => onChanged(values[i]),
          ),
        );
      }),
    );
  }

  Widget _buildRadioOption({
    required String label,
    required bool selected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppTheme.primary : const Color(0xFFD1D5DB),
                width: 2,
              ),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.primary,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: selected ? AppTheme.primary : const Color(0xFF374151),
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxRow({
    required String label,
    required bool checked,
    ValueChanged<bool?>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        onTap: onChanged == null ? null : () => onChanged(!checked),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: checked ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: checked ? AppTheme.primary : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: checked
                  ? const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      readOnly: widget.isReadOnly,
      onChanged: onChanged,
      style: GoogleFonts.manrope(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.manrope(
          fontSize: 13,
          color: const Color(0xFF9CA3AF),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppTheme.primary),
        ),
        isDense: true,
      ),
    );
  }
}

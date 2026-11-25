import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../../services/supabase_service.dart';
import '../../../services/local_database_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../theme/app_theme.dart';

// Key for top-level survey draft persistence
const String kSectionDAgricultureKey = 'D-AGRICULTURAL-INFORMATION';
const String kSectionDCroppingPatternKey = 'D-CROPPING-PATTERN';
const String kSectionDCropsKey = 'D-CROPS-REPEATABLE';

const Color _neutralDark = Color(0xFF1E293B);

// ─────────────────────────────────────────────────────────────────────────────
// Options constants for D1 - D12
// ─────────────────────────────────────────────────────────────────────────────
const List<String> _kD2FarmingPractices = [
  'Mono-cropping',
  'Mixed cropping',
  'Intercropping',
  'Terrace cultivation',
  'Shifting cultivation',
  'Crop-based',
  'Livestock-based',
  'Crop-livestock',
  'Crop-fish',
  'Crop-livestock-fish',
  'Horticulture-livestock',
  'Agroforestry-based',
  'NTFP-MAP-based',
  'Mixed livelihood system',
  'Other',
];

const List<String> _kD3DominantFarmingSystems = [
  'Crop-based farming',
  'Livestock-based farming',
  'Crop–livestock integrated farming',
  'Crop–fish integrated farming',
  'Crop–livestock–fish integrated farming',
  'Horticulture–livestock farming',
  'Agroforestry-based farming',
  'NTFP/forest-based livelihood',
  'Mixed/subsistence farming',
  'Shifting cultivation',
  'Other (specify)',
];

const List<String> _kD4SeedSources = [
  'Own-saved seeds',
  'Local farmers/neighbours',
  'Local market',
  'Private seed dealers/companies',
  'Government department/agency',
  'KVK',
  'SAU/University',
  'FPO/cooperative',
  'Other (specify)',
];

const List<String> _kD5SeedReplacementFrequencies = [
  'Every season',
  'Every year',
  'Once in 2–3 years',
  'More than 3 years',
  'Rarely',
  'Never',
];

const List<String> _kD7VarietyCharacteristics = [
  'High yield',
  'Drought tolerance',
  'Pest resistance',
  'Disease resistance',
  'Short duration',
  'Taste/quality',
  'Good storage quality',
  'Market preference',
  'Cold tolerance',
  'Resistance to lodging',
  'Other (specify)',
];

const List<String> _kD9ChangeReasons = [
  'Market demand',
  'Climate change/rainfall variability',
  'Crop failure',
  'Pest and disease incidence',
  'Wildlife damage',
  'Labour shortage',
  'Water availability',
  'Declining soil fertility/land degradation',
  'Government schemes/support',
  'Availability of improved seeds',
  'Better profitability from alternative crops',
  'Other (specify)',
];

const List<String> _kD10Categories = [
  'Agriculture crops',
  'Fruits and vegetables',
  'Medicinal and aromatic plants',
  'NTFP',
  'Others (spices, flowers, etc.)',
];

const List<String> _kCropCategories = [
  'Agriculture crop',
  'Vegetable',
  'Fruit',
  'Medicinal and aromatic plant',
  'Spices',
  'Flower',
  'NTFP',
  'Roots and tubers',
  'Other',
];

const List<String> _kSeasons = [
  'Kharif',
  'Rabi',
  'Zaid',
  'Perennial / Year-round',
];

const List<String> _kVarieties = [
  'Local',
  'Improved',
  'Hybrid',
  'Other',
];

const List<String> _kYieldUnits = [
  'kg',
  'quintal',
  'tonne',
];

const List<String> _kCultivationPurposes = [
  'Household consumption',
  'Sale / income generation',
  'Both consumption and sale',
  'Feed / fodder',
  'Seed production',
  'Cultural / traditional use',
  'Other',
];

// ─────────────────────────────────────────────────────────────────────────────
// Repeatable Crop Detail Model (D11 & D12)
// ─────────────────────────────────────────────────────────────────────────────
class CropRecord {
  String id;
  String cropName;
  String category;
  List<String> seasons;
  String variety;
  String? varietyOther;
  double? areaAcres;
  double? productionYield;
  String yieldUnit;
  double? quantityConsumed;
  double? quantitySold;
  double? averageSellingPrice;
  List<String> purposes;
  String? purposeOther;

  CropRecord({
    String? id,
    this.cropName = '',
    this.category = 'Agriculture crop',
    List<String>? seasons,
    this.variety = 'Local',
    this.varietyOther,
    this.areaAcres,
    this.productionYield,
    this.yieldUnit = 'quintal',
    this.quantityConsumed,
    this.quantitySold,
    this.averageSellingPrice,
    List<String>? purposes,
    this.purposeOther,
  })  : id = id ?? const Uuid().v4(),
        seasons = seasons ?? ['Kharif'],
        purposes = purposes ?? ['Both consumption and sale'];

  factory CropRecord.fromJson(Map<String, dynamic> json) {
    return CropRecord(
      id: json['id'] as String?,
      cropName: json['crop_name'] as String? ?? '',
      category: json['category'] as String? ?? 'Agriculture crop',
      seasons: (json['seasons'] as List?)?.map((e) => e.toString()).toList() ?? ['Kharif'],
      variety: json['variety'] as String? ?? 'Local',
      varietyOther: json['variety_other'] as String?,
      areaAcres: (json['area_acres'] as num?)?.toDouble(),
      productionYield: (json['production_yield'] as num?)?.toDouble(),
      yieldUnit: json['yield_unit'] as String? ?? 'quintal',
      quantityConsumed: (json['quantity_consumed'] as num?)?.toDouble(),
      quantitySold: (json['quantity_sold'] as num?)?.toDouble(),
      averageSellingPrice: (json['average_selling_price'] as num?)?.toDouble(),
      purposes: (json['purposes'] as List?)?.map((e) => e.toString()).toList() ?? ['Both consumption and sale'],
      purposeOther: json['purpose_other'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'crop_name': cropName,
      'category': category,
      'seasons': seasons,
      'variety': variety,
      if (varietyOther != null && varietyOther!.isNotEmpty) 'variety_other': varietyOther,
      'area_acres': areaAcres,
      'production_yield': productionYield,
      'yield_unit': yieldUnit,
      'quantity_consumed': quantityConsumed,
      'quantity_sold': quantitySold,
      'average_selling_price': averageSellingPrice,
      'purposes': purposes,
      if (purposeOther != null && purposeOther!.isNotEmpty) 'purpose_other': purposeOther,
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main Agricultural Information Section Widget
// ─────────────────────────────────────────────────────────────────────────────
class AgriculturalInformationSectionWidget extends StatefulWidget {
  final String householdId;
  final String surveyId;
  final Map<String, dynamic> initialAnswers;
  final bool isReadOnly;
  final ValueChanged<Map<String, dynamic>>? onDataChanged;

  const AgriculturalInformationSectionWidget({
    super.key,
    required this.householdId,
    required this.surveyId,
    required this.initialAnswers,
    this.isReadOnly = false,
    this.onDataChanged,
  });

  @override
  State<AgriculturalInformationSectionWidget> createState() =>
      AgriculturalInformationSectionWidgetState();
}

class AgriculturalInformationSectionWidgetState
    extends State<AgriculturalInformationSectionWidget> {
  int _currentPage = 0; // 0: Practices & Seeds (D1-D9), 1: Cropping Matrix & Crop Details (D10-D12)

  // ── D1 - D9 Controllers & State ──────────────────────────────────────────
  final TextEditingController _farmingExperienceCtrl = TextEditingController();
  final Set<String> _selectedFarmingPractices = {};
  final TextEditingController _farmingPracticesOtherCtrl = TextEditingController();

  String? _dominantFarmingSystem;
  final TextEditingController _dominantFarmingSystemOtherCtrl = TextEditingController();

  final Set<String> _selectedSeedSources = {};
  final TextEditingController _seedSourceOtherCtrl = TextEditingController();

  String? _seedReplacementFrequency;

  bool? _usedImprovedVarieties; // D6: Yes / No

  final Set<String> _preferredVarietyCharacteristics = {};
  final TextEditingController _varietyCharacteristicsOtherCtrl = TextEditingController();

  bool? _changedCroppingPattern; // D8: Yes / No

  final Set<String> _reasonsForChange = {};
  final TextEditingController _reasonsForChangeOtherCtrl = TextEditingController();

  // ── D10 Cropping Matrix Controllers ──────────────────────────────────────
  // Map of category -> season -> controller
  final Map<String, Map<String, TextEditingController>> _d10MatrixControllers = {};

  // ── D11 & D12 Repeatable Crops List ──────────────────────────────────────
  final List<CropRecord> _cropRecords = [];

  @override
  void initState() {
    super.initState();
    _initD10Controllers();
    _loadInitialData();
  }

  void _initD10Controllers() {
    for (final cat in _kD10Categories) {
      _d10MatrixControllers[cat] = {
        'kharif': TextEditingController(),
        'rabi': TextEditingController(),
        'zaid': TextEditingController(),
        'perennial': TextEditingController(),
      };
    }
  }

  void _loadInitialData() {
    // 1. Try to load from combined JSON key
    final raw = widget.initialAnswers[kSectionDAgricultureKey];
    Map<String, dynamic> data = {};
    if (raw is Map) {
      data = Map<String, dynamic>.from(raw);
    } else if (raw is String && raw.isNotEmpty) {
      try {
        data = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      } catch (_) {}
    }

    // Fall back to top-level individual keys
    if (data.isEmpty) {
      data = widget.initialAnswers;
    }

    // D1
    final exp = data['D1_farming_experience'] ?? data['farming_experience'] ?? data['D-01'];
    if (exp != null) _farmingExperienceCtrl.text = exp.toString();

    // D2
    final d2List = data['D2_farming_practices'] ?? data['farming_practices'];
    if (d2List is List) {
      _selectedFarmingPractices.addAll(d2List.map((e) => e.toString()));
    }
    _farmingPracticesOtherCtrl.text = data['D2_farming_practices_other']?.toString() ?? '';

    // D3
    _dominantFarmingSystem = data['D3_dominant_farming_system']?.toString() ?? data['dominant_farming_system']?.toString();
    _dominantFarmingSystemOtherCtrl.text = data['D3_dominant_farming_system_other']?.toString() ?? '';

    // D4
    final d4List = data['D4_seed_sources'] ?? data['seed_sources'];
    if (d4List is List) {
      _selectedSeedSources.addAll(d4List.map((e) => e.toString()));
    }
    _seedSourceOtherCtrl.text = data['D4_seed_sources_other']?.toString() ?? '';

    // D5
    _seedReplacementFrequency = data['D5_seed_replacement_frequency']?.toString();

    // D6
    final d6Val = data['D6_used_improved_varieties'];
    if (d6Val != null) {
      _usedImprovedVarieties = d6Val == true || d6Val == 'Yes' || d6Val == 'true';
    }

    // D7
    final d7List = data['D7_preferred_variety_characteristics'];
    if (d7List is List) {
      _preferredVarietyCharacteristics.addAll(d7List.map((e) => e.toString()));
    }
    _varietyCharacteristicsOtherCtrl.text = data['D7_preferred_variety_characteristics_other']?.toString() ?? '';

    // D8
    final d8Val = data['D8_changed_cropping_pattern'];
    if (d8Val != null) {
      _changedCroppingPattern = d8Val == true || d8Val == 'Yes' || d8Val == 'true';
    }

    // D9
    final d9List = data['D9_reasons_for_change'];
    if (d9List is List) {
      _reasonsForChange.addAll(d9List.map((e) => e.toString()));
    }
    _reasonsForChangeOtherCtrl.text = data['D9_reasons_for_change_other']?.toString() ?? '';

    // D10 Cropping Matrix
    final d10Map = data['D10_season_wise_pattern'] ?? widget.initialAnswers[kSectionDCroppingPatternKey];
    if (d10Map is Map) {
      d10Map.forEach((catKey, seasonData) {
        if (_d10MatrixControllers.containsKey(catKey) && seasonData is Map) {
          _d10MatrixControllers[catKey]!['kharif']?.text = seasonData['kharif']?.toString() ?? '';
          _d10MatrixControllers[catKey]!['rabi']?.text = seasonData['rabi']?.toString() ?? '';
          _d10MatrixControllers[catKey]!['zaid']?.text = seasonData['zaid']?.toString() ?? '';
          _d10MatrixControllers[catKey]!['perennial']?.text = seasonData['perennial']?.toString() ?? '';
        }
      });
    }

    // D11 & D12 Repeatable Crops
    final rawCrops = data['D11_crops_repeatable'] ?? widget.initialAnswers[kSectionDCropsKey];
    if (rawCrops is List && rawCrops.isNotEmpty) {
      _cropRecords.clear();
      for (final item in rawCrops) {
        if (item is Map<String, dynamic>) {
          _cropRecords.add(CropRecord.fromJson(item));
        } else if (item is Map) {
          _cropRecords.add(CropRecord.fromJson(Map<String, dynamic>.from(item)));
        }
      }
    }

    // Provide default initial crop record if empty
    if (_cropRecords.isEmpty) {
      _cropRecords.add(CropRecord(
        cropName: '',
        category: 'Agriculture crop',
        seasons: ['Kharif'],
        variety: 'Local',
        areaAcres: null,
        productionYield: null,
        yieldUnit: 'quintal',
        purposes: ['Both consumption and sale'],
      ));
    }
  }

  @override
  void dispose() {
    _farmingExperienceCtrl.dispose();
    _farmingPracticesOtherCtrl.dispose();
    _dominantFarmingSystemOtherCtrl.dispose();
    _seedSourceOtherCtrl.dispose();
    _varietyCharacteristicsOtherCtrl.dispose();
    _reasonsForChangeOtherCtrl.dispose();

    for (final seasonsMap in _d10MatrixControllers.values) {
      for (final ctrl in seasonsMap.values) {
        ctrl.dispose();
      }
    }
    super.dispose();
  }

  void goToPage(int page) {
    if (page >= 0 && page <= 1) {
      setState(() => _currentPage = page);
    }
  }

  bool validateCurrentPage() {
    if (_currentPage == 0) {
      // Experience in farming is mandatory or optional
      if (_farmingExperienceCtrl.text.trim().isEmpty) {
        _showToast('Please enter D1: Experience in farming (number of years)');
        return false;
      }
    }
    return true;
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.red.shade700,
      textColor: Colors.white,
    );
  }

  void saveData() {
    // 1. Pack D10 seasonal matrix
    final d10Data = <String, Map<String, String>>{};
    _d10MatrixControllers.forEach((cat, seasonsMap) {
      d10Data[cat] = {
        'kharif': seasonsMap['kharif']?.text.trim() ?? '',
        'rabi': seasonsMap['rabi']?.text.trim() ?? '',
        'zaid': seasonsMap['zaid']?.text.trim() ?? '',
        'perennial': seasonsMap['perennial']?.text.trim() ?? '',
      };
    });

    // 2. Pack repeatable crop records
    final cropsList = _cropRecords
        .where((c) => c.cropName.trim().isNotEmpty || c.areaAcres != null)
        .map((c) => c.toJson())
        .toList();

    // 3. Complete Section D payload
    final sectionDMap = <String, dynamic>{
      'D1_farming_experience': int.tryParse(_farmingExperienceCtrl.text.trim()),
      'D2_farming_practices': _selectedFarmingPractices.toList(),
      'D2_farming_practices_other': _farmingPracticesOtherCtrl.text.trim(),
      'D3_dominant_farming_system': _dominantFarmingSystem,
      'D3_dominant_farming_system_other': _dominantFarmingSystemOtherCtrl.text.trim(),
      'D4_seed_sources': _selectedSeedSources.toList(),
      'D4_seed_sources_other': _seedSourceOtherCtrl.text.trim(),
      'D5_seed_replacement_frequency': _seedReplacementFrequency,
      'D6_used_improved_varieties': _usedImprovedVarieties == true ? 'Yes' : (_usedImprovedVarieties == false ? 'No' : null),
      'D7_preferred_variety_characteristics': _preferredVarietyCharacteristics.toList(),
      'D7_preferred_variety_characteristics_other': _varietyCharacteristicsOtherCtrl.text.trim(),
      'D8_changed_cropping_pattern': _changedCroppingPattern == true ? 'Yes' : (_changedCroppingPattern == false ? 'No' : null),
      'D9_reasons_for_change': _reasonsForChange.toList(),
      'D9_reasons_for_change_other': _reasonsForChangeOtherCtrl.text.trim(),
      'D10_season_wise_pattern': d10Data,
      'D11_crops_repeatable': cropsList,
    };

    widget.initialAnswers[kSectionDAgricultureKey] = sectionDMap;
    widget.initialAnswers[kSectionDCroppingPatternKey] = d10Data;
    widget.initialAnswers[kSectionDCropsKey] = cropsList;

    // Flatten convenience keys for draft syncing
    sectionDMap.forEach((k, v) {
      widget.initialAnswers[k] = v;
    });

    widget.onDataChanged?.call(widget.initialAnswers);

    // Save crops and cropping_pattern into local database
    _saveToDatabase(d10Data, cropsList);
  }

  Future<void> _saveToDatabase(
    Map<String, Map<String, String>> d10Data,
    List<Map<String, dynamic>> cropsList,
  ) async {
    final isOnline = ConnectivityService.instance.isOnline;
    final user = SupabaseService.instance.currentUser;
    final createdBy = user?.id;

    try {
      // 1. Save Cropping Pattern rows
      for (final cat in d10Data.keys) {
        final seasons = d10Data[cat]!;
        final rowPayload = {
          'id': '${widget.surveyId}_$cat',
          'survey_id': widget.surveyId,
          'household_id': widget.householdId,
          'category': cat,
          'pattern_data_json': jsonEncode(seasons),
          'kharif': seasons['kharif'],
          'rabi': seasons['rabi'],
          'zaid': seasons['zaid'],
          'perennial': seasons['perennial'],
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };

        await LocalDatabaseService.instance.upsertCroppingPattern(rowPayload);
      }

      // 2. Save Repeatable Crop Records
      for (int i = 0; i < cropsList.length; i++) {
        final crop = cropsList[i];
        final rank = i + 1;
        final cropId = crop['id']?.toString() ?? const Uuid().v4();

        final localPayload = {
          'id': cropId,
          'survey_id': widget.surveyId,
          'household_id': widget.householdId,
          'category': crop['category']?.toString() ?? 'Agriculture crop',
          'crop_rank': rank,
          'crop_data_json': jsonEncode(crop),
          'crop_name': crop['crop_name']?.toString(),
          'area_acres': crop['area_acres'],
          'yield_kg': crop['production_yield'],
          'variety': crop['variety']?.toString(),
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };

        await LocalDatabaseService.instance.upsertCrop(localPayload);

        if (isOnline) {
          try {
            await SupabaseService.instance.client.from('crops').upsert({
              'id': cropId,
              'household_id': widget.householdId,
              'survey_id': widget.surveyId,
              'crop_name': crop['crop_name']?.toString(),
              'category': crop['category']?.toString(),
              'variety': crop['variety']?.toString(),
              'area_acres': crop['area_acres'],
              'yield_kg': crop['production_yield'],
              'season': (crop['seasons'] as List?)?.join(', '),
              if (createdBy != null) 'created_by': createdBy,
              'updated_at': DateTime.now().toIso8601String(),
            });
          } catch (_) {
            // Local sync handles retry
          }
        }
      }
    } catch (e) {
      debugPrint('[Section D] Local save error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildStepNavigation(theme),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _currentPage == 0
              ? _buildPracticesPage(theme)
              : _buildCroppingMatrixPage(theme),
        ),
      ],
    );
  }

  // ── Step Navigation ────────────────────────────────────────────────────────
  Widget _buildStepNavigation(ThemeData theme) {
    final steps = [
      {'title': '1. Practices & Seeds (D1–D9)', 'icon': Icons.agriculture_outlined},
      {'title': '2. Cropping Pattern (D10–D12)', 'icon': Icons.grid_on_outlined},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(steps.length, (idx) {
          final isSelected = _currentPage == idx;
          final isCompleted = _currentPage > idx;
          final step = steps[idx];

          return Expanded(
            child: InkWell(
              onTap: () {
                if (validateCurrentPage()) {
                  setState(() => _currentPage = idx);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primary.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isCompleted ? Icons.check_circle : (step['icon'] as IconData),
                      size: 20,
                      color: isSelected
                          ? AppTheme.primary
                          : (isCompleted ? Colors.green.shade700 : Colors.grey.shade600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step['title'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppTheme.primary
                            : (isCompleted ? Colors.grey.shade800 : Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PAGE 1: Practices & Seeds (D1 – D9)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildPracticesPage(ThemeData theme) {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // D1. Experience in farming
        _card(
          title: 'D1. Farming Experience *',
          icon: Icons.history,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Experience in farming (Number of years) *', theme),
              TextFormField(
                controller: _farmingExperienceCtrl,
                readOnly: widget.isReadOnly,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDecoration(theme, 'e.g. 15 years'),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // D2. Type of farming / cropping practices followed
        _card(
          title: 'D2. Cropping & Farming Practices',
          icon: Icons.grass,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Type of farming / cropping practices followed (Select all that apply)', theme),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _kD2FarmingPractices.map((practice) {
                  final sel = _selectedFarmingPractices.contains(practice);
                  return FilterChip(
                    label: Text(
                      practice,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w600,
                        color: sel ? const Color(0xFF1B4332) : const Color(0xFF1E293B),
                      ),
                    ),
                    selected: sel,
                    selectedColor: const Color(0xFFD8F3DC),
                    backgroundColor: Colors.white,
                    checkmarkColor: const Color(0xFF1B4332),
                    side: BorderSide(
                      color: sel ? const Color(0xFF2D6A4F) : Colors.grey.shade300,
                      width: sel ? 1.5 : 1.0,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: widget.isReadOnly
                        ? null
                        : (val) {
                            setState(() {
                              if (val) {
                                _selectedFarmingPractices.add(practice);
                              } else {
                                _selectedFarmingPractices.remove(practice);
                              }
                            });
                          },
                  );
                }).toList(),
              ),
              if (_selectedFarmingPractices.contains('Other')) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _farmingPracticesOtherCtrl,
                  readOnly: widget.isReadOnly,
                  decoration: _inputDecoration(theme, 'Specify other farming practice'),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 14),

        // D3. Dominant Farming System
        _card(
          title: 'D3. Dominant Farming System',
          icon: Icons.hub_outlined,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Dominant farming system of your household (Single-select)', theme),
              ..._kD3DominantFarmingSystems.map((sys) {
                final isSel = _dominantFarmingSystem == sys;
                return InkWell(
                  onTap: widget.isReadOnly ? null : () => setState(() => _dominantFarmingSystem = sys),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSel ? AppTheme.primary : Colors.grey.shade500,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            sys,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                              color: isSel ? AppTheme.primary : _neutralDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              if (_dominantFarmingSystem == 'Other (specify)') ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dominantFarmingSystemOtherCtrl,
                  readOnly: widget.isReadOnly,
                  decoration: _inputDecoration(theme, 'Specify dominant farming system'),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 14),

        // D4. Major Source of seeds used
        _card(
          title: 'D4. Seed Sources',
          icon: Icons.grain,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('What are the major sources of seeds used? (Select all that apply)', theme),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _kD4SeedSources.map((source) {
                  final sel = _selectedSeedSources.contains(source);
                  return FilterChip(
                    label: Text(
                      source,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w600,
                        color: sel ? const Color(0xFF1B4332) : const Color(0xFF1E293B),
                      ),
                    ),
                    selected: sel,
                    selectedColor: const Color(0xFFD8F3DC),
                    backgroundColor: Colors.white,
                    checkmarkColor: const Color(0xFF1B4332),
                    side: BorderSide(
                      color: sel ? const Color(0xFF2D6A4F) : Colors.grey.shade300,
                      width: sel ? 1.5 : 1.0,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: widget.isReadOnly
                        ? null
                        : (val) {
                            setState(() {
                              if (val) {
                                _selectedSeedSources.add(source);
                              } else {
                                _selectedSeedSources.remove(source);
                              }
                            });
                          },
                  );
                }).toList(),
              ),
              if (_selectedSeedSources.contains('Other (specify)')) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _seedSourceOtherCtrl,
                  readOnly: widget.isReadOnly,
                  decoration: _inputDecoration(theme, 'Specify other seed source'),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 14),

        // D5. Frequency of seed replacement
        _card(
          title: 'D5. Seed Replacement Frequency',
          icon: Icons.published_with_changes,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('How frequently do you replace your seeds with new seeds? (Single-select)', theme),
              ..._kD5SeedReplacementFrequencies.map((freq) {
                final isSel = _seedReplacementFrequency == freq;
                return InkWell(
                  onTap: widget.isReadOnly ? null : () => setState(() => _seedReplacementFrequency = freq),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSel ? AppTheme.primary : Colors.grey.shade500,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            freq,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                              color: isSel ? AppTheme.primary : _neutralDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // D6. Improved Varieties Used Earlier
        _card(
          title: 'D6. Improved Varieties',
          icon: Icons.verified_outlined,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Have you used improved varieties of crops earlier?', theme),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildYesNoButton(
                      label: 'Yes',
                      icon: Icons.check_circle_rounded,
                      isSelected: _usedImprovedVarieties == true,
                      selectedColor: AppTheme.primary,
                      selectedBg: AppTheme.primary,
                      onTap: () => setState(() => _usedImprovedVarieties = true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildYesNoButton(
                      label: 'No',
                      icon: Icons.cancel_rounded,
                      isSelected: _usedImprovedVarieties == false,
                      selectedColor: const Color(0xFF475569),
                      selectedBg: const Color(0xFF475569),
                      onTap: () => setState(() => _usedImprovedVarieties = false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // D7. Preferred Characteristics
        _card(
          title: 'D7. Variety Preferences',
          icon: Icons.tune,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('What characteristics do you prefer while selecting crop varieties? (Select all that apply)', theme),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _kD7VarietyCharacteristics.map((trait) {
                  final sel = _preferredVarietyCharacteristics.contains(trait);
                  return FilterChip(
                    label: Text(
                      trait,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w600,
                        color: sel ? const Color(0xFF1B4332) : const Color(0xFF1E293B),
                      ),
                    ),
                    selected: sel,
                    selectedColor: const Color(0xFFD8F3DC),
                    backgroundColor: Colors.white,
                    checkmarkColor: const Color(0xFF1B4332),
                    side: BorderSide(
                      color: sel ? const Color(0xFF2D6A4F) : Colors.grey.shade300,
                      width: sel ? 1.5 : 1.0,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: widget.isReadOnly
                        ? null
                        : (val) {
                            setState(() {
                              if (val) {
                                _preferredVarietyCharacteristics.add(trait);
                              } else {
                                _preferredVarietyCharacteristics.remove(trait);
                              }
                            });
                          },
                  );
                }).toList(),
              ),
              if (_preferredVarietyCharacteristics.contains('Other (specify)')) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _varietyCharacteristicsOtherCtrl,
                  readOnly: widget.isReadOnly,
                  decoration: _inputDecoration(theme, 'Specify other preferred trait'),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 14),

        // D8 & D9. Cropping Pattern Changes
        _card(
          title: 'D8 & D9. Cropping Pattern Changes (Last 5 Years)',
          icon: Icons.change_circle_outlined,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('D8. Have you changed your cropping pattern during the last five years? *', theme),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildYesNoButton(
                      label: 'Yes',
                      icon: Icons.check_circle_rounded,
                      isSelected: _changedCroppingPattern == true,
                      selectedColor: AppTheme.primary,
                      selectedBg: AppTheme.primary,
                      onTap: () => setState(() => _changedCroppingPattern = true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildYesNoButton(
                      label: 'No',
                      icon: Icons.cancel_rounded,
                      isSelected: _changedCroppingPattern == false,
                      selectedColor: const Color(0xFF475569),
                      selectedBg: const Color(0xFF475569),
                      onTap: () => setState(() => _changedCroppingPattern = false),
                    ),
                  ),
                ],
              ),

              if (_changedCroppingPattern == true) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 10),
                _label('D9. Reasons for change in cropping pattern (Select all that apply):', theme),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _kD9ChangeReasons.map((reason) {
                    final sel = _reasonsForChange.contains(reason);
                    return FilterChip(
                      label: Text(
                        reason,
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w600,
                          color: sel ? const Color(0xFF1B4332) : const Color(0xFF1E293B),
                        ),
                      ),
                      selected: sel,
                      selectedColor: const Color(0xFFD8F3DC),
                      backgroundColor: Colors.white,
                      checkmarkColor: const Color(0xFF1B4332),
                      side: BorderSide(
                        color: sel ? const Color(0xFF2D6A4F) : Colors.grey.shade300,
                        width: sel ? 1.5 : 1.0,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      onSelected: widget.isReadOnly
                          ? null
                          : (val) {
                              setState(() {
                                if (val) {
                                  _reasonsForChange.add(reason);
                                } else {
                                  _reasonsForChange.remove(reason);
                                }
                              });
                            },
                    );
                  }).toList(),
                ),
                if (_reasonsForChange.contains('Other (specify)')) ...[
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _reasonsForChangeOtherCtrl,
                    readOnly: widget.isReadOnly,
                    decoration: _inputDecoration(theme, 'Specify other reason for change'),
                  ),
                ],
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PAGE 2: Cropping Matrix (D10) & Repeatable Crop Details (D11–D12)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildCroppingMatrixPage(ThemeData theme) {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // D10. Season-wise Cropping Pattern Table
        _card(
          title: 'D10. Season-Wise Cropping Pattern',
          icon: Icons.table_chart_outlined,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter name of crops grown across seasons (Kharif, Rabi, Zaid, and Perennial/Year-round). For multiple crops within a cell, separate them with "+".',
                style: GoogleFonts.manrope(fontSize: 13, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 14),
              ..._kD10Categories.map((cat) {
                final seasons = _d10MatrixControllers[cat]!;
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cat,
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _subLabel('Kharif (Jun-Oct)'),
                                TextFormField(
                                  controller: seasons['kharif'],
                                  readOnly: widget.isReadOnly,
                                  decoration: _inputDecoration(theme, 'e.g. Paddy + Maize'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _subLabel('Rabi (Oct-Mar)'),
                                TextFormField(
                                  controller: seasons['rabi'],
                                  readOnly: widget.isReadOnly,
                                  decoration: _inputDecoration(theme, 'e.g. Mustard'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _subLabel('Zaid (Mar-Jun)'),
                                TextFormField(
                                  controller: seasons['zaid'],
                                  readOnly: widget.isReadOnly,
                                  decoration: _inputDecoration(theme, 'e.g. Moong'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _subLabel('Perennial / Year-round'),
                                TextFormField(
                                  controller: seasons['perennial'],
                                  readOnly: widget.isReadOnly,
                                  decoration: _inputDecoration(theme, 'e.g. Arecanut'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // D11 & D12. Crop-Wise Details (Repeatable Records)
        _card(
          title: 'D11 & D12. Repeatable Crop Details',
          icon: Icons.format_list_bulleted_add,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Record yield, variety, sales, and purpose for each cultivated crop:',
                      style: GoogleFonts.manrope(fontSize: 13, color: Colors.grey.shade700),
                    ),
                  ),
                  if (!widget.isReadOnly)
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _cropRecords.add(CropRecord(
                            cropName: '',
                            category: 'Agriculture crop',
                            seasons: ['Kharif'],
                            variety: 'Local',
                            purposes: ['Both consumption and sale'],
                          ));
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: Text('Add Crop', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              ...List.generate(_cropRecords.length, (idx) {
                return _buildCropCard(idx, _cropRecords[idx], theme);
              }),
            ],
          ),
        ),
      ],
    );
  }

  // ── Crop Record Item Card ──────────────────────────────────────────────────
  Widget _buildCropCard(int index, CropRecord crop, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Crop # and delete button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Crop #${index + 1}',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    crop.cropName.isNotEmpty ? crop.cropName : 'New Crop Record',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _neutralDark,
                    ),
                  ),
                ],
              ),
              if (!widget.isReadOnly && _cropRecords.length > 1)
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade600, size: 20),
                  onPressed: () {
                    setState(() {
                      _cropRecords.removeAt(index);
                    });
                  },
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Crop Name & Category
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Crop Name *', theme),
                    TextFormField(
                      initialValue: crop.cropName,
                      readOnly: widget.isReadOnly,
                      decoration: _inputDecoration(theme, 'e.g. Rice / Paddy'),
                      onChanged: (val) => setState(() => crop.cropName = val.trim()),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Crop Category', theme),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _kCropCategories.contains(crop.category) ? crop.category : _kCropCategories.first,
                      decoration: _inputDecoration(theme, 'Select Category'),
                      items: _kCropCategories
                          .map((c) => DropdownMenuItem(
                                value: c,
                                child: Text(
                                  c,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.manrope(fontSize: 13),
                                ),
                              ))
                          .toList(),
                      onChanged: widget.isReadOnly ? null : (val) => setState(() => crop.category = val ?? crop.category),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Season (Multi-select) & Variety
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Season(s) grown in:', theme),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _kSeasons.map((s) {
                  final isSel = crop.seasons.contains(s);
                  return FilterChip(
                    label: Text(
                      s,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w600,
                        color: isSel ? const Color(0xFF1B4332) : const Color(0xFF1E293B),
                      ),
                    ),
                    selected: isSel,
                    selectedColor: const Color(0xFFD8F3DC),
                    backgroundColor: Colors.white,
                    checkmarkColor: const Color(0xFF1B4332),
                    side: BorderSide(color: isSel ? const Color(0xFF2D6A4F) : Colors.grey.shade300, width: isSel ? 1.5 : 1.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onSelected: widget.isReadOnly
                        ? null
                        : (val) {
                            setState(() {
                              if (val) {
                                crop.seasons.add(s);
                              } else if (crop.seasons.length > 1) {
                                crop.seasons.remove(s);
                              }
                            });
                          },
                  );
                }).toList(),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Variety & Area
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Variety', theme),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _kVarieties.contains(crop.variety) ? crop.variety : _kVarieties.first,
                      decoration: _inputDecoration(theme, 'Select Variety'),
                      items: _kVarieties
                          .map((v) => DropdownMenuItem(
                                value: v,
                                child: Text(
                                  v,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.manrope(fontSize: 13),
                                ),
                              ))
                          .toList(),
                      onChanged: widget.isReadOnly ? null : (val) => setState(() => crop.variety = val ?? crop.variety),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Area Cultivated (Acres)', theme),
                    TextFormField(
                      initialValue: crop.areaAcres?.toString(),
                      readOnly: widget.isReadOnly,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: _inputDecoration(theme, 'e.g. 1.5'),
                      onChanged: (val) => crop.areaAcres = double.tryParse(val.trim()),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Production & Unit
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Production / Yield', theme),
                    TextFormField(
                      initialValue: crop.productionYield?.toString(),
                      readOnly: widget.isReadOnly,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: _inputDecoration(theme, 'e.g. 25'),
                      onChanged: (val) => crop.productionYield = double.tryParse(val.trim()),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Unit', theme),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: _kYieldUnits.contains(crop.yieldUnit) ? crop.yieldUnit : _kYieldUnits.first,
                      decoration: _inputDecoration(theme, 'Unit'),
                      items: _kYieldUnits
                          .map((u) => DropdownMenuItem(
                                value: u,
                                child: Text(
                                  u,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.manrope(fontSize: 13),
                                ),
                              ))
                          .toList(),
                      onChanged: widget.isReadOnly ? null : (val) => setState(() => crop.yieldUnit = val ?? crop.yieldUnit),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Consumed vs Sold
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Household Consumed (${crop.yieldUnit})', theme),
                    TextFormField(
                      initialValue: crop.quantityConsumed?.toString(),
                      readOnly: widget.isReadOnly,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: _inputDecoration(theme, 'e.g. 10'),
                      onChanged: (val) => crop.quantityConsumed = double.tryParse(val.trim()),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Quantity Sold (${crop.yieldUnit})', theme),
                    TextFormField(
                      initialValue: crop.quantitySold?.toString(),
                      readOnly: widget.isReadOnly,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: _inputDecoration(theme, 'e.g. 15'),
                      onChanged: (val) => setState(() => crop.quantitySold = double.tryParse(val.trim())),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Average Selling Price (Conditional on Sold > 0)
          if ((crop.quantitySold ?? 0) > 0) ...[
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('Average Selling Price (₹ per ${crop.yieldUnit}) *', theme),
                TextFormField(
                  initialValue: crop.averageSellingPrice?.toString(),
                  readOnly: widget.isReadOnly,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: _inputDecoration(theme, 'e.g. 2200'),
                  onChanged: (val) => crop.averageSellingPrice = double.tryParse(val.trim()),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),

          // D12. Purpose of Cultivation
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('D12. Purpose of Cultivation (Select all that apply):', theme),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _kCultivationPurposes.map((p) {
                  final isSel = crop.purposes.contains(p);
                  return FilterChip(
                    label: Text(
                      p,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w600,
                        color: isSel ? const Color(0xFF1B4332) : const Color(0xFF1E293B),
                      ),
                    ),
                    selected: isSel,
                    selectedColor: const Color(0xFFD8F3DC),
                    backgroundColor: Colors.white,
                    checkmarkColor: const Color(0xFF1B4332),
                    side: BorderSide(color: isSel ? const Color(0xFF2D6A4F) : Colors.grey.shade300, width: isSel ? 1.5 : 1.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onSelected: widget.isReadOnly
                        ? null
                        : (val) {
                            setState(() {
                              if (val) {
                                crop.purposes.add(p);
                              } else if (crop.purposes.length > 1) {
                                crop.purposes.remove(p);
                              }
                            });
                          },
                  );
                }).toList(),
              ),
              if (crop.purposes.contains('Other')) ...[
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: crop.purposeOther,
                  readOnly: widget.isReadOnly,
                  decoration: _inputDecoration(theme, 'Specify other purpose'),
                  onChanged: (val) => crop.purposeOther = val.trim(),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ── Reusable Helpers ───────────────────────────────────────────────────────
  Widget _card({
    required String title,
    required IconData icon,
    required ThemeData theme,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
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
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _neutralDark,
        ),
      ),
    );
  }

  Widget _subLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildYesNoButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color selectedColor,
    required Color selectedBg,
    required VoidCallback onTap,
  }) {
    final effectiveBg = isSelected ? selectedColor : Colors.white;
    final effectiveFg = isSelected ? Colors.white : const Color(0xFF1E293B);
    final effectiveBorder = isSelected ? selectedColor : Colors.grey.shade300;
    final effectiveIconColor = isSelected ? Colors.white : Colors.grey.shade700;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.isReadOnly ? null : onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: effectiveBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: effectiveBorder,
              width: isSelected ? 1.8 : 1.2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: selectedColor.withValues(alpha: 0.32),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    )
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: effectiveIconColor,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: effectiveFg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.manrope(fontSize: 13, color: Colors.grey.shade400),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
      ),
    );
  }
}

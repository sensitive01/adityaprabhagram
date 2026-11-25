import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '../../../services/local_database_service.dart';
import '../../../theme/app_theme.dart';

const Color _neutralDark = Color(0xFF1E293B);

// ─────────────────────────────────────────────────────────────────────────────
// Response Keys used in survey responses map
// ─────────────────────────────────────────────────────────────────────────────
const String kSectionCLandWaterKey = 'C-LAND-WATER';
const String kSectionCAssetsKey = 'C-ASSETS';
const String kSectionCLivestockKey = 'C10-LIVESTOCK';

// ─────────────────────────────────────────────────────────────────────────────
// Asset Item Model
// ─────────────────────────────────────────────────────────────────────────────
class AssetItem {
  String id;
  String name;
  String category; // 'Agricultural' or 'Household'
  bool isCustom;
  String status; // 'Owned', 'Hired / Rented', 'Both owned and hired', 'Not available'
  int? quantityOwned;
  int? quantityHired;
  double? hiringCharge;
  String hiringRateUnit; // 'Per hour', 'Per day'
  String hiringSource;
  String hiringSourceOther;

  AssetItem({
    required this.id,
    required this.name,
    required this.category,
    this.isCustom = false,
    this.status = 'Not available',
    this.quantityOwned,
    this.quantityHired,
    this.hiringCharge,
    this.hiringRateUnit = 'Per day',
    this.hiringSource = 'Private agency or individual',
    this.hiringSourceOther = '',
  });

  bool get isOwned => status == 'Owned' || status == 'Both owned and hired';
  bool get isHired => status == 'Hired / Rented' || status == 'Both owned and hired';
  bool get isNotAvailable => status == 'Not available';

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'isCustom': isCustom,
    'status': status,
    'quantityOwned': quantityOwned,
    'quantityHired': quantityHired,
    'hiringCharge': hiringCharge,
    'hiringRateUnit': hiringRateUnit,
    'hiringSource': hiringSource,
    'hiringSourceOther': hiringSourceOther,
  };

  factory AssetItem.fromJson(Map<String, dynamic> json) => AssetItem(
    id: json['id'] as String? ?? const Uuid().v4(),
    name: json['name'] as String? ?? '',
    category: json['category'] as String? ?? 'Agricultural',
    isCustom: json['isCustom'] as bool? ?? false,
    status: json['status'] as String? ?? 'Not available',
    quantityOwned: json['quantityOwned'] as int?,
    quantityHired: json['quantityHired'] as int?,
    hiringCharge: (json['hiringCharge'] != null)
        ? double.tryParse(json['hiringCharge'].toString())
        : null,
    hiringRateUnit: json['hiringRateUnit'] as String? ?? 'Per day',
    hiringSource: json['hiringSource'] as String? ?? 'Private agency or individual',
    hiringSourceOther: json['hiringSourceOther'] as String? ?? '',
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Livestock Item Model
// ─────────────────────────────────────────────────────────────────────────────
class LivestockItem {
  String id;
  String name;
  bool isCustom;
  bool isPractised; // true = 'Owned / Rearing', false = 'Not practised'
  int? count;
  String breed;
  String purpose; // 'Household consumption', 'Sale', 'Both', 'Breeding', 'Other'
  String purposeOther;
  bool hasHiredFacilities;
  int? quantityHiredFacilities;
  double? hiringChargeFacilities;
  String hiringRateUnitFacilities; // '₹ per day', '₹ per month', '₹ per production cycle'
  String hiringSourceFacilities;
  String hiringSourceFacilitiesOther;

  // Production details
  String productType; // e.g. Milk, Eggs, Meat, Honey, Fish
  double? quantityProduced;
  double? quantityConsumedHome;
  double? quantitySold;
  double? averageSellingPrice;

  LivestockItem({
    required this.id,
    required this.name,
    this.isCustom = false,
    this.isPractised = false,
    this.count,
    this.breed = '',
    this.purpose = 'Both',
    this.purposeOther = '',
    this.hasHiredFacilities = false,
    this.quantityHiredFacilities,
    this.hiringChargeFacilities,
    this.hiringRateUnitFacilities = '₹ per day',
    this.hiringSourceFacilities = 'Individual farmer',
    this.hiringSourceFacilitiesOther = '',
    required this.productType,
    this.quantityProduced,
    this.quantityConsumedHome,
    this.quantitySold,
    this.averageSellingPrice,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isCustom': isCustom,
    'isPractised': isPractised,
    'count': count,
    'breed': breed,
    'purpose': purpose,
    'purposeOther': purposeOther,
    'hasHiredFacilities': hasHiredFacilities,
    'quantityHiredFacilities': quantityHiredFacilities,
    'hiringChargeFacilities': hiringChargeFacilities,
    'hiringRateUnitFacilities': hiringRateUnitFacilities,
    'hiringSourceFacilities': hiringSourceFacilities,
    'hiringSourceFacilitiesOther': hiringSourceFacilitiesOther,
    'productType': productType,
    'quantityProduced': quantityProduced,
    'quantityConsumedHome': quantityConsumedHome,
    'quantitySold': quantitySold,
    'averageSellingPrice': averageSellingPrice,
  };

  factory LivestockItem.fromJson(Map<String, dynamic> json) => LivestockItem(
    id: json['id'] as String? ?? const Uuid().v4(),
    name: json['name'] as String? ?? '',
    isCustom: json['isCustom'] as bool? ?? false,
    isPractised: json['isPractised'] as bool? ?? false,
    count: json['count'] as int?,
    breed: json['breed'] as String? ?? '',
    purpose: json['purpose'] as String? ?? 'Both',
    purposeOther: json['purposeOther'] as String? ?? '',
    hasHiredFacilities: json['hasHiredFacilities'] as bool? ?? false,
    quantityHiredFacilities: json['quantityHiredFacilities'] as int?,
    hiringChargeFacilities: (json['hiringChargeFacilities'] != null)
        ? double.tryParse(json['hiringChargeFacilities'].toString())
        : null,
    hiringRateUnitFacilities: json['hiringRateUnitFacilities'] as String? ?? '₹ per day',
    hiringSourceFacilities: json['hiringSourceFacilities'] as String? ?? 'Individual farmer',
    hiringSourceFacilitiesOther: json['hiringSourceFacilitiesOther'] as String? ?? '',
    productType: json['productType'] as String? ?? 'Product',
    quantityProduced: (json['quantityProduced'] != null)
        ? double.tryParse(json['quantityProduced'].toString())
        : null,
    quantityConsumedHome: (json['quantityConsumedHome'] != null)
        ? double.tryParse(json['quantityConsumedHome'].toString())
        : null,
    quantitySold: (json['quantitySold'] != null)
        ? double.tryParse(json['quantitySold'].toString())
        : null,
    averageSellingPrice: (json['averageSellingPrice'] != null)
        ? double.tryParse(json['averageSellingPrice'].toString())
        : null,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Default List Constants
// ─────────────────────────────────────────────────────────────────────────────
final List<Map<String, String>> _kDefaultAssets = [
  {'name': 'Tractor with implements', 'category': 'Agricultural'},
  {'name': 'Power tiller', 'category': 'Agricultural'},
  {'name': 'Power weeder', 'category': 'Agricultural'},
  {'name': 'Sprayer / Power sprayer', 'category': 'Agricultural'},
  {'name': 'Reaper / Harvester', 'category': 'Agricultural'},
  {'name': 'Rice / Dal mill', 'category': 'Agricultural'},
  {'name': 'Pump set / Water pump', 'category': 'Agricultural'},
  {'name': 'Chaff cutter / Feed grinder', 'category': 'Agricultural'},
  {'name': 'Smartphones', 'category': 'Household'},
  {'name': 'Television', 'category': 'Household'},
  {'name': 'Refrigerator', 'category': 'Household'},
  {'name': 'Computer / Laptop', 'category': 'Household'},
  {'name': 'Two-wheeler', 'category': 'Household'},
  {'name': 'Car / Pickup truck', 'category': 'Household'},
  {'name': 'Generator', 'category': 'Household'},
];

final List<Map<String, String>> _kDefaultLivestock = [
  {'name': 'Cattle (indigenous/crossbred)', 'product': 'Milk (litres/day)'},
  {'name': 'Mithun', 'product': 'Milk & Meat'},
  {'name': 'Yak', 'product': 'Milk (litres/day)'},
  {'name': 'Buffalo', 'product': 'Milk (litres/day)'},
  {'name': 'Goat', 'product': 'Meat (kg/year)'},
  {'name': 'Sheep', 'product': 'Wool & Meat'},
  {'name': 'Pig', 'product': 'Meat (kg/year)'},
  {'name': 'Poultry', 'product': 'Eggs (nos./year)'},
  {'name': 'Duck', 'product': 'Eggs (nos./year)'},
  {'name': 'Fish farming (Trout/Carp/Tilapia/Other)', 'product': 'Fish (kg/year)'},
  {'name': 'Beekeeping', 'product': 'Honey (kg/year)'},
];

const List<String> _kFallowReasons = [
  'Water shortage',
  'Labour shortage',
  'Difficult terrain',
  'Wildlife damage',
  'Landslide or erosion',
  'Soil degradation',
  'Low profitability',
  'Distance from house',
  'Lack of capital',
  'Lack of seed/input',
  'Migration',
  'Land dispute/documentation',
  'Others (specify)',
];

const List<String> _kTerrainTypes = [
  'Plain / valley',
  'Foothill / sloping',
  'Undulating',
  'Terrace',
  'Wetland / lowland',
  'Upland',
  'Jhum / shifting',
  'Orchard',
  'Homestead',
  'Other',
];

const List<String> _kIrrigationSources = [
  'Rainfed',
  'Bamboo-piped gravity-fed',
  'Spring and small stream',
  'Jalkund or farm pond',
  'Tube well / borewell',
  'Other (specify)',
];

const List<String> _kWaterAvailabilityOptions = [
  'Year-round',
  'Seasonal',
  'Frequently interrupted',
  'Available only in rainy months',
];

const List<String> _kWaterConstraints = [
  'Low discharge',
  'Seasonal drying',
  'Source is distant',
  'Water conflict',
  'Other (specify)',
];

const List<String> _kHiringSourcesAsset = [
  'Government institution',
  'Custom Hiring Centre',
  'FPO or Cooperative',
  'Private agency or individual',
  'Neighbour or farmer',
  'Other (specify)',
];

const List<String> _kHiringSourcesLivestock = [
  'Government institution / Department',
  'FPO or Cooperative',
  'Private agency',
  'Individual farmer',
  'Other (specify)',
];

// ─────────────────────────────────────────────────────────────────────────────
// Main Section C Widget
// ─────────────────────────────────────────────────────────────────────────────
class HouseholdAssetsSectionWidget extends StatefulWidget {
  final String householdId;
  final String? surveyId;
  final Map<String, dynamic> initialAnswers;
  final bool isReadOnly;
  final ValueChanged<Map<String, dynamic>>? onDataChanged;
  final int initialPage;

  const HouseholdAssetsSectionWidget({
    super.key,
    required this.householdId,
    this.surveyId,
    required this.initialAnswers,
    this.isReadOnly = false,
    this.onDataChanged,
    this.initialPage = 0,
  });

  @override
  State<HouseholdAssetsSectionWidget> createState() =>
      HouseholdAssetsSectionWidgetState();
}

class HouseholdAssetsSectionWidgetState
    extends State<HouseholdAssetsSectionWidget> {
  int _currentPage = 0;

  // ── Page 1: Land Controllers & State ──────────────────────────────────────
  bool? _hasLand; // C1: Yes / No
  final _totalLandOwnedCtrl = TextEditingController(); // C2
  final _cultivatedLandCtrl = TextEditingController(); // C3
  final _fallowLandCtrl = TextEditingController(); // C4
  final Set<String> _selectedFallowReasons = {}; // C5
  final _fallowReasonOtherCtrl = TextEditingController();
  final _leasedOutAreaCtrl = TextEditingController(); // C6 area
  final _leasedOutReceiptCtrl = TextEditingController(); // C6 receipt ₹

  // C6b: Land tenure origin
  bool _tenurePurchase = false;
  final _tenurePurchaseAreaCtrl = TextEditingController();
  bool _tenureInherited = false;
  final _tenureInheritedAreaCtrl = TextEditingController();
  bool _tenureCustomary = false;
  final _tenureCustomaryAreaCtrl = TextEditingController();

  final _leasedInAreaCtrl = TextEditingController(); // C7 area
  final _leasedInPaymentCtrl = TextEditingController(); // C7 payment ₹

  // C10: Terrain-wise areas
  final Map<String, TextEditingController> _terrainControllers = {};
  final _terrainOtherNameCtrl = TextEditingController();
  final _terrainOtherAreaCtrl = TextEditingController();

  // ── Page 2: Water Controllers & State ─────────────────────────────────────
  final Set<String> _selectedIrrigationSources = {}; // C11
  final _irrigationOtherCtrl = TextEditingController();
  String? _waterAvailability; // C12
  final Set<String> _selectedWaterConstraints = {}; // C13
  final _waterConstraintOtherCtrl = TextEditingController();

  // ── Page 3: Assets State ──────────────────────────────────────────────────
  final List<AssetItem> _assets = [];

  // ── Page 4: Livestock State ───────────────────────────────────────────────
  final List<LivestockItem> _livestock = [];

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _initTerrainControllers();
    _loadInitialData();
  }

  void _initTerrainControllers() {
    for (final t in _kTerrainTypes) {
      if (t != 'Other') {
        _terrainControllers[t] = TextEditingController();
      }
    }
  }

  void _loadInitialData() {
    // 1. Load Land & Water from initialAnswers['C-LAND-WATER'] or individual keys
    final landWaterData =
        widget.initialAnswers[kSectionCLandWaterKey] as Map<String, dynamic>? ??
            {};

    final c1Val = landWaterData['C1_land_availability'] ??
        widget.initialAnswers['C1_land_availability'];
    if (c1Val != null) {
      _hasLand = c1Val == true || c1Val == 'Yes' || c1Val == 'true';
    }

    _totalLandOwnedCtrl.text = (landWaterData['C2_total_land_owned'] ??
            widget.initialAnswers['C2_total_land_owned'] ??
            '')
        .toString();
    _cultivatedLandCtrl.text = (landWaterData['C3_cultivated_land'] ??
            widget.initialAnswers['C3_cultivated_land'] ??
            '')
        .toString();
    _fallowLandCtrl.text = (landWaterData['C4_fallow_land'] ??
            widget.initialAnswers['C4_fallow_land'] ??
            '')
        .toString();

    final fallowReasons = (landWaterData['C5_fallow_reasons'] ??
        widget.initialAnswers['C5_fallow_reasons']);
    if (fallowReasons is List) {
      _selectedFallowReasons.addAll(fallowReasons.map((e) => e.toString()));
    }
    _fallowReasonOtherCtrl.text = (landWaterData['C5_fallow_other'] ??
            widget.initialAnswers['C5_fallow_other'] ??
            '')
        .toString();

    _leasedOutAreaCtrl.text = (landWaterData['C6_leased_out_area'] ??
            widget.initialAnswers['C6_leased_out_area'] ??
            '')
        .toString();
    _leasedOutReceiptCtrl.text = (landWaterData['C6_leased_out_receipt'] ??
            widget.initialAnswers['C6_leased_out_receipt'] ??
            '')
        .toString();

    final tenureData = landWaterData['C6_tenure_origin'] as Map<String, dynamic>?;
    if (tenureData != null) {
      _tenurePurchase = tenureData['purchase'] == true;
      _tenurePurchaseAreaCtrl.text =
          (tenureData['purchase_area'] ?? '').toString();
      _tenureInherited = tenureData['inherited'] == true;
      _tenureInheritedAreaCtrl.text =
          (tenureData['inherited_area'] ?? '').toString();
      _tenureCustomary = tenureData['customary'] == true;
      _tenureCustomaryAreaCtrl.text =
          (tenureData['customary_area'] ?? '').toString();
    }

    _leasedInAreaCtrl.text = (landWaterData['C7_leased_in_area'] ??
            widget.initialAnswers['C7_leased_in_area'] ??
            '')
        .toString();
    _leasedInPaymentCtrl.text = (landWaterData['C7_leased_in_payment'] ??
            widget.initialAnswers['C7_leased_in_payment'] ??
            '')
        .toString();

    final terrainData =
        landWaterData['C10_terrain_breakdown'] as Map<String, dynamic>?;
    if (terrainData != null) {
      terrainData.forEach((k, v) {
        if (_terrainControllers.containsKey(k)) {
          _terrainControllers[k]!.text = v.toString();
        } else if (k == 'Other') {
          _terrainOtherAreaCtrl.text = v.toString();
        }
      });
      _terrainOtherNameCtrl.text =
          (terrainData['Other_specify'] ?? '').toString();
    }

    // Water data
    final irriSources = (landWaterData['C11_irrigation_sources'] ??
        widget.initialAnswers['C11_irrigation_sources']);
    if (irriSources is List) {
      _selectedIrrigationSources.addAll(irriSources.map((e) => e.toString()));
    }
    _irrigationOtherCtrl.text = (landWaterData['C11_irrigation_other'] ??
            widget.initialAnswers['C11_irrigation_other'] ??
            '')
        .toString();

    _waterAvailability = (landWaterData['C12_water_availability'] ??
            widget.initialAnswers['C12_water_availability'])
        ?.toString();

    final waterConstraints = (landWaterData['C13_water_constraints'] ??
        widget.initialAnswers['C13_water_constraints']);
    if (waterConstraints is List) {
      _selectedWaterConstraints.addAll(waterConstraints.map((e) => e.toString()));
    }
    _waterConstraintOtherCtrl.text = (landWaterData['C13_water_constraint_other'] ??
            widget.initialAnswers['C13_water_constraint_other'] ??
            '')
        .toString();

    // 2. Load Assets
    final rawAssets = widget.initialAnswers[kSectionCAssetsKey];
    if (rawAssets is List && rawAssets.isNotEmpty) {
      for (final a in rawAssets) {
        if (a is Map<String, dynamic>) {
          _assets.add(AssetItem.fromJson(a));
        }
      }
    } else {
      // Default initial assets
      for (final def in _kDefaultAssets) {
        _assets.add(AssetItem(
          id: const Uuid().v4(),
          name: def['name']!,
          category: def['category']!,
        ));
      }
    }

    // 3. Load Livestock
    final rawLivestock = widget.initialAnswers[kSectionCLivestockKey];
    if (rawLivestock is List && rawLivestock.isNotEmpty) {
      for (final l in rawLivestock) {
        if (l is Map<String, dynamic>) {
          _livestock.add(LivestockItem.fromJson(l));
        }
      }
    } else {
      // Default initial livestock
      for (final def in _kDefaultLivestock) {
        _livestock.add(LivestockItem(
          id: const Uuid().v4(),
          name: def['name']!,
          productType: def['product']!,
        ));
      }
    }
  }

  @override
  void dispose() {
    _totalLandOwnedCtrl.dispose();
    _cultivatedLandCtrl.dispose();
    _fallowLandCtrl.dispose();
    _fallowReasonOtherCtrl.dispose();
    _leasedOutAreaCtrl.dispose();
    _leasedOutReceiptCtrl.dispose();
    _tenurePurchaseAreaCtrl.dispose();
    _tenureInheritedAreaCtrl.dispose();
    _tenureCustomaryAreaCtrl.dispose();
    _leasedInAreaCtrl.dispose();
    _leasedInPaymentCtrl.dispose();
    for (final c in _terrainControllers.values) {
      c.dispose();
    }
    _terrainOtherNameCtrl.dispose();
    _terrainOtherAreaCtrl.dispose();
    _irrigationOtherCtrl.dispose();
    _waterConstraintOtherCtrl.dispose();
    super.dispose();
  }

  void goToPage(int page) {
    if (page >= 0 && page <= 3) {
      setState(() => _currentPage = page);
    }
  }

  bool validateCurrentPage() {
    if (_currentPage == 0) {
      if (_hasLand == null) {
        _showToast('Please specify C1: Land Availability');
        return false;
      }
    }
    return true;
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red.shade700),
    );
  }

  void saveData() {
    // 1. Pack Land & Water JSON
    final terrainMap = <String, dynamic>{};
    _terrainControllers.forEach((k, v) {
      if (v.text.trim().isNotEmpty) {
        terrainMap[k] = double.tryParse(v.text.trim()) ?? v.text.trim();
      }
    });
    if (_terrainOtherAreaCtrl.text.trim().isNotEmpty) {
      terrainMap['Other'] = double.tryParse(_terrainOtherAreaCtrl.text.trim()) ??
          _terrainOtherAreaCtrl.text.trim();
      terrainMap['Other_specify'] = _terrainOtherNameCtrl.text.trim();
    }

    final landWaterMap = <String, dynamic>{
      'C1_land_availability': _hasLand == true ? 'Yes' : 'No',
      'C2_total_land_owned': double.tryParse(_totalLandOwnedCtrl.text.trim()),
      'C3_cultivated_land': double.tryParse(_cultivatedLandCtrl.text.trim()),
      'C4_fallow_land': double.tryParse(_fallowLandCtrl.text.trim()),
      'C5_fallow_reasons': ((double.tryParse(_fallowLandCtrl.text.trim()) ?? 0) > 0)
          ? _selectedFallowReasons.toList()
          : <String>[],
      'C5_fallow_other': ((double.tryParse(_fallowLandCtrl.text.trim()) ?? 0) > 0)
          ? _fallowReasonOtherCtrl.text.trim()
          : '',
      'C6_leased_out_area': double.tryParse(_leasedOutAreaCtrl.text.trim()),
      'C6_leased_out_receipt': double.tryParse(_leasedOutReceiptCtrl.text.trim()),
      'C6_tenure_origin': {
        'purchase': _tenurePurchase,
        'purchase_area': double.tryParse(_tenurePurchaseAreaCtrl.text.trim()),
        'inherited': _tenureInherited,
        'inherited_area': double.tryParse(_tenureInheritedAreaCtrl.text.trim()),
        'customary': _tenureCustomary,
        'customary_area': double.tryParse(_tenureCustomaryAreaCtrl.text.trim()),
      },
      'C7_leased_in_area': double.tryParse(_leasedInAreaCtrl.text.trim()),
      'C7_leased_in_payment': double.tryParse(_leasedInPaymentCtrl.text.trim()),
      'C10_terrain_breakdown': terrainMap,
      'C11_irrigation_sources': _selectedIrrigationSources.toList(),
      'C11_irrigation_other': _irrigationOtherCtrl.text.trim(),
      'C12_water_availability': _waterAvailability,
      'C13_water_constraints': _selectedWaterConstraints.toList(),
      'C13_water_constraint_other': _waterConstraintOtherCtrl.text.trim(),
    };

    // 2. Pack Assets
    final assetsJsonList = _assets.map((a) => a.toJson()).toList();

    // 3. Pack Livestock
    final livestockJsonList = _livestock.map((l) => l.toJson()).toList();

    // 4. Update initialAnswers and notify
    widget.initialAnswers[kSectionCLandWaterKey] = landWaterMap;
    widget.initialAnswers[kSectionCAssetsKey] = assetsJsonList;
    widget.initialAnswers[kSectionCLivestockKey] = livestockJsonList;

    // Also populate top-level convenience keys
    landWaterMap.forEach((k, v) {
      widget.initialAnswers[k] = v;
    });

    widget.onDataChanged?.call(widget.initialAnswers);

    // 5. Persist to SQLite local_household_assets & local_livestock
    _persistLocalData();
  }

  Future<void> _persistLocalData() async {
    final surveyId = widget.surveyId;
    if (surveyId == null || surveyId.isEmpty) return;

    try {
      if (LocalDatabaseService.instance.isAvailable) {
        for (final asset in _assets) {
          if (!asset.isNotAvailable) {
            await LocalDatabaseService.instance.upsertHouseholdAsset({
              'id': asset.id,
              'survey_id': surveyId,
              'household_id': widget.householdId,
              'asset_type': asset.name,
              'asset_data_json': jsonEncode(asset.toJson()),
            });
          }
        }
        for (final animal in _livestock) {
          if (animal.isPractised) {
            await LocalDatabaseService.instance.upsertLivestock({
              'id': animal.id,
              'survey_id': surveyId,
              'household_id': widget.householdId,
              'animal_type': animal.name,
              'livestock_data_json': jsonEncode(animal.toJson()),
            });
          }
        }
      }
    } catch (e) {
      debugPrint('[SectionC] Failed to persist local assets/livestock: $e');
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
          child: _buildCurrentPage(theme),
        ),
      ],
    );
  }

  // ── Step Progress Indicator ────────────────────────────────────────────────
  Widget _buildStepNavigation(ThemeData theme) {
    final steps = [
      {'title': '1. Land', 'icon': Icons.landscape_outlined},
      {'title': '2. Water', 'icon': Icons.water_drop_outlined},
      {'title': '3. Assets', 'icon': Icons.construction_outlined},
      {'title': '4. Livestock', 'icon': Icons.pets_outlined},
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
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppTheme.primary
                            : (isCompleted
                                ? Colors.grey.shade800
                                : Colors.grey.shade600),
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

  Widget _buildCurrentPage(ThemeData theme) {
    switch (_currentPage) {
      case 0:
        return _buildLandPage(theme);
      case 1:
        return _buildWaterPage(theme);
      case 2:
        return _buildAssetsPage(theme);
      case 3:
        return _buildLivestockPage(theme);
      default:
        return const SizedBox.shrink();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PAGE 1: Land Details (C1 – C10)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildLandPage(ThemeData theme) {
    final ownedAcres = double.tryParse(_totalLandOwnedCtrl.text.trim()) ?? 0.0;
    final leasedInAcres = double.tryParse(_leasedInAreaCtrl.text.trim()) ?? 0.0;
    final leasedOutAcres = double.tryParse(_leasedOutAreaCtrl.text.trim()) ?? 0.0;
    final operatedAcres = (ownedAcres + leasedInAcres - leasedOutAcres).clamp(0.0, 999999.0);

    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _card(
          title: 'C1. Land Availability *',
          icon: Icons.landscape,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Does your household own, cultivate, or possess any agricultural or homestead land?',
                style: GoogleFonts.manrope(fontSize: 14, color: _neutralDark),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildYesNoButton(
                      label: 'Yes',
                      icon: Icons.check_circle_rounded,
                      isSelected: _hasLand == true,
                      selectedColor: AppTheme.primary,
                      selectedBg: AppTheme.primary,
                      onTap: () => setState(() => _hasLand = true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildYesNoButton(
                      label: 'No',
                      icon: Icons.cancel_rounded,
                      isSelected: _hasLand == false,
                      selectedColor: const Color(0xFF475569),
                      selectedBg: const Color(0xFF475569),
                      onTap: () => setState(() => _hasLand = false),
                    ),
                  ),
                ],
              ),
              if (_hasLand == false) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber.shade800, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'No land reported. Questions C2 to C10 are skipped. You may proceed to Page 2 (Water) or subsequent sections.',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: Colors.amber.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),

        if (_hasLand == true) ...[
          const SizedBox(height: 14),
          _card(
            title: 'Land Holding & Use (C2 – C5)',
            icon: Icons.pie_chart_outline,
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('C2. Total land owned / possessed by household (acres) *', theme),
                TextFormField(
                  controller: _totalLandOwnedCtrl,
                  readOnly: widget.isReadOnly,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: _inputDecoration(theme, 'e.g. 2.5'),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 14),

                _label('C3. Total land currently cultivated / under use (acres) *', theme),
                TextFormField(
                  controller: _cultivatedLandCtrl,
                  readOnly: widget.isReadOnly,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: _inputDecoration(theme, 'e.g. 2.0'),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 14),

                _label('C4. Total fallow / uncultivated land (acres)', theme),
                TextFormField(
                  controller: _fallowLandCtrl,
                  readOnly: widget.isReadOnly,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: _inputDecoration(theme, 'e.g. 0.5 (or 0 if none)'),
                  onChanged: (val) {
                    final acres = double.tryParse(val.trim()) ?? 0;
                    if (acres <= 0) {
                      _selectedFallowReasons.clear();
                      _fallowReasonOtherCtrl.clear();
                    }
                    setState(() {});
                  },
                ),
                if ((double.tryParse(_fallowLandCtrl.text.trim()) ?? 0) > 0) ...[
                  const SizedBox(height: 14),
                  _label('C5. Reason for fallow / uncultivated land (Select all that apply)', theme),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _kFallowReasons.map((reason) {
                      final sel = _selectedFallowReasons.contains(reason);
                      return FilterChip(
                        label: Text(
                          reason,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: sel ? FontWeight.w700 : FontWeight.w600,
                            color: sel ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                        labelStyle: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: sel ? FontWeight.w700 : FontWeight.w600,
                          color: sel ? Colors.white : const Color(0xFF1E293B),
                        ),
                        selected: sel,
                        selectedColor: AppTheme.primary,
                        backgroundColor: const Color(0xFFF1F5F9),
                        checkmarkColor: Colors.white,
                        side: BorderSide(
                          color: sel ? AppTheme.primary : const Color(0xFFCBD5E1),
                          width: sel ? 1.5 : 1.0,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        onSelected: widget.isReadOnly
                            ? null
                            : (val) {
                                setState(() {
                                  if (val) {
                                    _selectedFallowReasons.add(reason);
                                  } else {
                                    _selectedFallowReasons.remove(reason);
                                  }
                                });
                              },
                      );
                    }).toList(),
                  ),
                  if (_selectedFallowReasons.contains('Others (specify)')) ...[
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _fallowReasonOtherCtrl,
                      readOnly: widget.isReadOnly,
                      decoration: _inputDecoration(theme, 'Specify reason for fallow land'),
                    ),
                  ],
                ],
              ],
            ),
          ),

          const SizedBox(height: 14),
          _card(
            title: 'Lease & Tenure Origin (C6 – C7)',
            icon: Icons.real_estate_agent_outlined,
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _subHeader('C6. Leased-out land (if any)'),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Area (acres)', theme),
                          TextFormField(
                            controller: _leasedOutAreaCtrl,
                            readOnly: widget.isReadOnly,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: _inputDecoration(theme, 'Acres'),
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
                          _label('Annual Receipt (₹)', theme),
                          TextFormField(
                            controller: _leasedOutReceiptCtrl,
                            readOnly: widget.isReadOnly,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: _inputDecoration(theme, '₹ / year'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 28),

                _subHeader('C6b. Land Tenure Origin (Select all that apply)'),
                const SizedBox(height: 8),
                _tenureRow('Purchased', _tenurePurchase, _tenurePurchaseAreaCtrl, (v) {
                  setState(() => _tenurePurchase = v);
                }, theme),
                const SizedBox(height: 8),
                _tenureRow('Inherited', _tenureInherited, _tenureInheritedAreaCtrl, (v) {
                  setState(() => _tenureInherited = v);
                }, theme),
                const SizedBox(height: 8),
                _tenureRow('Customary / Community tenure', _tenureCustomary, _tenureCustomaryAreaCtrl, (v) {
                  setState(() => _tenureCustomary = v);
                }, theme),
                const Divider(height: 28),

                _subHeader('C7. Leased-in land (if any)'),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Area (acres)', theme),
                          TextFormField(
                            controller: _leasedInAreaCtrl,
                            readOnly: widget.isReadOnly,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: _inputDecoration(theme, 'Acres'),
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
                          _label('Annual Payment (₹)', theme),
                          TextFormField(
                            controller: _leasedInPaymentCtrl,
                            readOnly: widget.isReadOnly,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: _inputDecoration(theme, '₹ / year'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),
          _card(
            title: 'C10. Land Type / Terrain-wise Area',
            icon: Icons.terrain_outlined,
            theme: theme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter the area (acres) corresponding to each terrain type. Total operated area: ${operatedAcres.toStringAsFixed(2)} acres.',
                  style: GoogleFonts.manrope(fontSize: 13, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 12),
                ..._kTerrainTypes.where((t) => t != 'Other').map((terrain) {
                  final ctrl = _terrainControllers[terrain]!;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            terrain,
                            style: GoogleFonts.manrope(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _neutralDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: ctrl,
                            readOnly: widget.isReadOnly,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: _inputDecoration(theme, '0.0 acres'),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _terrainOtherNameCtrl,
                        readOnly: widget.isReadOnly,
                        decoration: _inputDecoration(theme, 'Other terrain (specify)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _terrainOtherAreaCtrl,
                        readOnly: widget.isReadOnly,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: _inputDecoration(theme, '0.0 acres'),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _tenureRow(
    String label,
    bool isYes,
    TextEditingController areaCtrl,
    ValueChanged<bool> onChanged,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isYes ? AppTheme.primary.withValues(alpha: 0.04) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isYes ? AppTheme.primary.withValues(alpha: 0.3) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: isYes ? FontWeight.w700 : FontWeight.w500,
                color: isYes ? AppTheme.primary : _neutralDark,
              ),
            ),
          ),
          Switch(
            value: isYes,
            activeThumbColor: AppTheme.primary,
            onChanged: widget.isReadOnly ? null : onChanged,
          ),
          if (isYes) ...[
            const SizedBox(width: 8),
            SizedBox(
              width: 90,
              child: TextFormField(
                controller: areaCtrl,
                readOnly: widget.isReadOnly,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: _inputDecoration(theme, 'Acres'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PAGE 2: Water & Irrigation (C11 – C13)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildWaterPage(ThemeData theme) {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _card(
          title: 'C11. Source of Irrigation *',
          icon: Icons.water_drop_outlined,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select all sources of irrigation available to your household farm parcels:',
                style: GoogleFonts.manrope(fontSize: 13, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _kIrrigationSources.map((source) {
                  final sel = _selectedIrrigationSources.contains(source);
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
                                _selectedIrrigationSources.add(source);
                              } else {
                                _selectedIrrigationSources.remove(source);
                              }
                            });
                          },
                  );
                }).toList(),
              ),
              if (_selectedIrrigationSources.contains('Other (specify)')) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _irrigationOtherCtrl,
                  readOnly: widget.isReadOnly,
                  decoration: _inputDecoration(theme, 'Specify other irrigation source'),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 14),
        _card(
          title: 'C12. Frequency of Water Availability *',
          icon: Icons.access_time_outlined,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How reliably is water available throughout the year?',
                style: GoogleFonts.manrope(fontSize: 13, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),
              ..._kWaterAvailabilityOptions.map((opt) {
                final isSel = _waterAvailability == opt;
                return InkWell(
                  onTap: widget.isReadOnly
                      ? null
                      : () => setState(() => _waterAvailability = opt),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                            opt,
                            style: GoogleFonts.manrope(
                              fontSize: 14,
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
        _card(
          title: 'C13. Main Water-related Constraints',
          icon: Icons.warning_amber_outlined,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select any critical water-related constraints faced by the household:',
                style: GoogleFonts.manrope(fontSize: 13, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _kWaterConstraints.map((constraint) {
                  final sel = _selectedWaterConstraints.contains(constraint);
                  return FilterChip(
                    label: Text(
                      constraint,
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
                                _selectedWaterConstraints.add(constraint);
                              } else {
                                _selectedWaterConstraints.remove(constraint);
                              }
                            });
                          },
                  );
                }).toList(),
              ),
              if (_selectedWaterConstraints.contains('Other (specify)')) ...[
                const SizedBox(height: 10),
                TextFormField(
                  controller: _waterConstraintOtherCtrl,
                  readOnly: widget.isReadOnly,
                  decoration: _inputDecoration(theme, 'Specify other water constraint'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PAGE 3: Agricultural Tools and Household Assets (C14)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildAssetsPage(ThemeData theme) {
    final agriAssets = _assets.where((a) => a.category == 'Agricultural').toList();
    final houseAssets = _assets.where((a) => a.category == 'Household').toList();

    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _card(
          title: 'C14. Agricultural Tools & Household Assets',
          icon: Icons.construction_outlined,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Which of the following agricultural tools, machinery and household assets are available with your household?',
                style: GoogleFonts.manrope(fontSize: 13, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              _subHeader('Agricultural Tools & Machinery'),
              const SizedBox(height: 8),
              ...agriAssets.map((asset) => _buildAssetTile(asset, theme)),
              const Divider(height: 28),
              _subHeader('Household Assets'),
              const SizedBox(height: 8),
              ...houseAssets.map((asset) => _buildAssetTile(asset, theme)),
              const SizedBox(height: 16),
              if (!widget.isReadOnly)
                OutlinedButton.icon(
                  onPressed: _showAddAssetDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text('Add Custom Tool / Asset', style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssetTile(AssetItem asset, ThemeData theme) {
    final isExpanded = !asset.isNotAvailable;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isExpanded ? Colors.white : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isExpanded ? AppTheme.primary.withValues(alpha: 0.35) : Colors.grey.shade300,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    asset.name,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isExpanded ? AppTheme.primary : _neutralDark,
                    ),
                  ),
                ),
                if (asset.isCustom && !widget.isReadOnly)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    onPressed: () => setState(() => _assets.remove(asset)),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // 4 Segmented options: Owned, Hired / Rented, Both owned and hired, Not available
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                'Owned',
                'Hired / Rented',
                'Both owned and hired',
                'Not available',
              ].map((opt) {
                final isSel = asset.status == opt;
                return ChoiceChip(
                  label: Text(
                    opt,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                      color: isSel ? AppTheme.primary : Colors.grey.shade800,
                    ),
                  ),
                  selected: isSel,
                  selectedColor: AppTheme.primaryContainer,
                  backgroundColor: Colors.grey.shade100,
                  side: BorderSide(
                    color: isSel ? AppTheme.primary : Colors.grey.shade300,
                    width: isSel ? 1.4 : 1.0,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  onSelected: widget.isReadOnly
                      ? null
                      : (val) {
                          if (val) {
                            setState(() => asset.status = opt);
                          }
                        },
                );
              }).toList(),
            ),

            if (asset.isOwned) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Quantity Owned (Units) *', theme),
                        TextFormField(
                          initialValue: asset.quantityOwned?.toString(),
                          readOnly: widget.isReadOnly,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: _inputDecoration(theme, 'e.g. 1'),
                          onChanged: (val) => asset.quantityOwned = int.tryParse(val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],

            if (asset.isHired) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _subHeader('Hiring / Rental Details'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Quantity Hired', theme),
                              TextFormField(
                                initialValue: asset.quantityHired?.toString(),
                                readOnly: widget.isReadOnly,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                decoration: _inputDecoration(theme, 'Count'),
                                onChanged: (val) => asset.quantityHired = int.tryParse(val),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Hiring Charge (₹)', theme),
                              TextFormField(
                                initialValue: asset.hiringCharge?.toString(),
                                readOnly: widget.isReadOnly,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: _inputDecoration(theme, '₹ Rate'),
                                onChanged: (val) => asset.hiringCharge = double.tryParse(val),
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
                              _label('Rate Unit', theme),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                initialValue: asset.hiringRateUnit,
                                decoration: _inputDecoration(theme, 'Unit'),
                                items: ['Per hour', 'Per day'].map((u) {
                                  return DropdownMenuItem(
                                    value: u,
                                    child: Text(u, overflow: TextOverflow.ellipsis),
                                  );
                                }).toList(),
                                onChanged: widget.isReadOnly
                                    ? null
                                    : (val) => setState(() => asset.hiringRateUnit = val!),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Source of Hiring', theme),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                initialValue: _kHiringSourcesAsset.contains(asset.hiringSource)
                                    ? asset.hiringSource
                                    : 'Other (specify)',
                                decoration: _inputDecoration(theme, 'Source'),
                                items: _kHiringSourcesAsset.map((s) {
                                  return DropdownMenuItem(
                                    value: s,
                                    child: Text(s, overflow: TextOverflow.ellipsis),
                                  );
                                }).toList(),
                                onChanged: widget.isReadOnly
                                    ? null
                                    : (val) => setState(() => asset.hiringSource = val!),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (asset.hiringSource == 'Other (specify)') ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: asset.hiringSourceOther,
                        readOnly: widget.isReadOnly,
                        decoration: _inputDecoration(theme, 'Specify hiring source'),
                        onChanged: (val) => asset.hiringSourceOther = val,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddAssetDialog() {
    final nameCtrl = TextEditingController();
    String category = 'Agricultural';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          title: Text('Add Custom Tool / Asset', style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: _inputDecoration(Theme.of(context), 'Asset Name (e.g. Combine)'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: category,
                decoration: _inputDecoration(Theme.of(context), 'Category'),
                items: ['Agricultural', 'Household'].map((c) {
                  return DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis));
                }).toList(),
                onChanged: (val) => setDlgState(() => category = val!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    _assets.add(AssetItem(
                      id: const Uuid().v4(),
                      name: name,
                      category: category,
                      isCustom: true,
                    ));
                  });
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PAGE 4: Owned Livestock & Allied Enterprises (C15)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildLivestockPage(ThemeData theme) {
    return Column(
      key: const ValueKey(3),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _card(
          title: 'C15. Owned Livestock & Allied Enterprises',
          icon: Icons.pets_outlined,
          theme: theme,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Which of the following livestock and allied enterprises are practised by your household?',
                style: GoogleFonts.manrope(fontSize: 13, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 16),
              ..._livestock.map((item) => _buildLivestockTile(item, theme)),
              const SizedBox(height: 16),
              if (!widget.isReadOnly)
                OutlinedButton.icon(
                  onPressed: _showAddLivestockDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text('Add Other Enterprise / Species', style: GoogleFonts.manrope(fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLivestockTile(LivestockItem item, ThemeData theme) {
    final isPractised = item.isPractised;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isPractised ? Colors.white : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isPractised ? AppTheme.primary.withValues(alpha: 0.35) : Colors.grey.shade300,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isPractised ? AppTheme.primary : _neutralDark,
                    ),
                  ),
                ),
                if (item.isCustom && !widget.isReadOnly)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    onPressed: () => setState(() => _livestock.remove(item)),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                _choiceChip('Owned / Rearing', item.isPractised, () {
                  setState(() => item.isPractised = true);
                }),
                const SizedBox(width: 8),
                _choiceChip('Not practised', !item.isPractised, () {
                  setState(() => item.isPractised = false);
                }),
              ],
            ),

            if (isPractised) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Count / Units *', theme),
                        TextFormField(
                          initialValue: item.count?.toString(),
                          readOnly: widget.isReadOnly,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: _inputDecoration(theme, 'e.g. 5'),
                          onChanged: (val) => item.count = int.tryParse(val),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Breed / Species', theme),
                        TextFormField(
                          initialValue: item.breed,
                          readOnly: widget.isReadOnly,
                          decoration: _inputDecoration(theme, 'e.g. Crossbred / Desi'),
                          onChanged: (val) => item.breed = val,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _label('Purpose of Enterprise', theme),
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: item.purpose,
                decoration: _inputDecoration(theme, 'Purpose'),
                items: [
                  'Household consumption',
                  'Sale',
                  'Both',
                  'Breeding',
                  'Other',
                ].map((p) {
                  return DropdownMenuItem(value: p, child: Text(p, overflow: TextOverflow.ellipsis));
                }).toList(),
                onChanged: widget.isReadOnly
                    ? null
                    : (val) => setState(() => item.purpose = val!),
              ),
              if (item.purpose == 'Other') ...[
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: item.purposeOther,
                  readOnly: widget.isReadOnly,
                  decoration: _inputDecoration(theme, 'Specify purpose'),
                  onChanged: (val) => item.purposeOther = val,
                ),
              ],

              const SizedBox(height: 14),
              // Production details (species-specific)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _subHeader('Annual Production Details — ${item.productType}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Qty Produced', theme),
                              TextFormField(
                                initialValue: item.quantityProduced?.toString(),
                                readOnly: widget.isReadOnly,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: _inputDecoration(theme, 'Produced'),
                                onChanged: (val) => item.quantityProduced = double.tryParse(val),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Home Consumed', theme),
                              TextFormField(
                                initialValue: item.quantityConsumedHome?.toString(),
                                readOnly: widget.isReadOnly,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: _inputDecoration(theme, 'Consumed'),
                                onChanged: (val) => item.quantityConsumedHome = double.tryParse(val),
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
                              _label('Qty Sold', theme),
                              TextFormField(
                                initialValue: item.quantitySold?.toString(),
                                readOnly: widget.isReadOnly,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: _inputDecoration(theme, 'Sold'),
                                onChanged: (val) => item.quantitySold = double.tryParse(val),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Avg Price (₹/unit)', theme),
                              TextFormField(
                                initialValue: item.averageSellingPrice?.toString(),
                                readOnly: widget.isReadOnly,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: _inputDecoration(theme, '₹ / unit'),
                                onChanged: (val) => item.averageSellingPrice = double.tryParse(val),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              // Hired equipment toggle
              Row(
                children: [
                  Checkbox(
                    value: item.hasHiredFacilities,
                    activeColor: AppTheme.primary,
                    onChanged: widget.isReadOnly
                        ? null
                        : (val) => setState(() => item.hasHiredFacilities = val ?? false),
                  ),
                  Expanded(
                    child: Text(
                      'Facilities or equipment are hired / rented for this enterprise',
                      style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              if (item.hasHiredFacilities) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Quantity Hired', theme),
                                TextFormField(
                                  initialValue: item.quantityHiredFacilities?.toString(),
                                  readOnly: widget.isReadOnly,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: _inputDecoration(theme, 'Units'),
                                  onChanged: (val) => item.quantityHiredFacilities = int.tryParse(val),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Hiring Charge', theme),
                                TextFormField(
                                  initialValue: item.hiringChargeFacilities?.toString(),
                                  readOnly: widget.isReadOnly,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: _inputDecoration(theme, '₹ Amount'),
                                  onChanged: (val) => item.hiringChargeFacilities = double.tryParse(val),
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
                                _label('Rate Unit', theme),
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  initialValue: item.hiringRateUnitFacilities,
                                  decoration: _inputDecoration(theme, 'Rate Unit'),
                                  items: ['₹ per day', '₹ per month', '₹ per production cycle'].map((u) {
                                    return DropdownMenuItem(value: u, child: Text(u, overflow: TextOverflow.ellipsis));
                                  }).toList(),
                                  onChanged: widget.isReadOnly
                                      ? null
                                      : (val) => setState(() => item.hiringRateUnitFacilities = val!),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('Hiring Source', theme),
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  initialValue: _kHiringSourcesLivestock.contains(item.hiringSourceFacilities)
                                      ? item.hiringSourceFacilities
                                      : 'Other (specify)',
                                  decoration: _inputDecoration(theme, 'Hiring Source'),
                                  items: _kHiringSourcesLivestock.map((s) {
                                    return DropdownMenuItem(value: s, child: Text(s, overflow: TextOverflow.ellipsis));
                                  }).toList(),
                                  onChanged: widget.isReadOnly
                                      ? null
                                      : (val) => setState(() => item.hiringSourceFacilities = val!),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (item.hiringSourceFacilities == 'Other (specify)') ...[
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: item.hiringSourceFacilitiesOther,
                          readOnly: widget.isReadOnly,
                          decoration: _inputDecoration(theme, 'Specify hiring source'),
                          onChanged: (val) => item.hiringSourceFacilitiesOther = val,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  void _showAddLivestockDialog() {
    final nameCtrl = TextEditingController();
    final productCtrl = TextEditingController(text: 'Meat / Milk / Units');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Other Enterprise / Species', style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameCtrl,
              decoration: _inputDecoration(Theme.of(context), 'Species Name (e.g. Turkey)'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: productCtrl,
              decoration: _inputDecoration(Theme.of(context), 'Product Output (e.g. Meat kg/year)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isNotEmpty) {
                setState(() {
                  _livestock.add(LivestockItem(
                    id: const Uuid().v4(),
                    name: name,
                    productType: productCtrl.text.trim(),
                    isCustom: true,
                    isPractised: true,
                  ));
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // UI Helpers
  // ─────────────────────────────────────────────────────────────────────────
  Widget _card({
    required String title,
    required IconData icon,
    required ThemeData theme,
    required Widget child,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppTheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _neutralDark,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
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
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _neutralDark,
        ),
      ),
    );
  }

  Widget _subHeader(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppTheme.primary,
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

  Widget _choiceChip(String label, bool isSelected, VoidCallback onSelected) {
    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          color: isSelected ? const Color(0xFF1B4332) : const Color(0xFF1E293B),
        ),
      ),
      selected: isSelected,
      selectedColor: const Color(0xFFD8F3DC),
      backgroundColor: Colors.white,
      checkmarkColor: const Color(0xFF1B4332),
      side: BorderSide(
        color: isSelected ? const Color(0xFF2D6A4F) : Colors.grey.shade300,
        width: isSelected ? 1.5 : 1.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onSelected: widget.isReadOnly ? null : (_) => onSelected(),
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/status_badge_widget.dart';
import './admin_shell.dart';
import './widgets/admin_data_table.dart';

class AdminSurveysScreen extends StatefulWidget {
  const AdminSurveysScreen({super.key});

  @override
  State<AdminSurveysScreen> createState() => _AdminSurveysScreenState();
}

class _AdminSurveysScreenState extends State<AdminSurveysScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _surveys = [];
  Map<String, dynamic>? _selectedSurvey;
  String _filterStatus = 'All';
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentPage = 0;
  static const int _pageSize = 20;
  Map<String, Map<String, dynamic>> _questionMeta = {};

  // Caches for specialized section data keyed by survey_id
  final Map<String, List<Map<String, dynamic>>> _lSeasonalityCache = {};
  final Map<String, List<Map<String, dynamic>>> _householdAssetsCache = {};
  final Map<String, List<Map<String, dynamic>>> _livestockCache = {};
  final Map<String, List<Map<String, dynamic>>> _croppingPatternCache = {};
  final Map<String, List<Map<String, dynamic>>> _cropsCache = {};
  final Map<String, List<Map<String, dynamic>>> _pestsDiseaseCache = {};

  final _statuses = [
    'All',
    'draft',
    'submitted',
    'under_review',
    'correction_required',
    'approved',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        SupabaseService.instance.client
            .from('surveys')
            .select(
              '*, households(hh_id, name, village), user_profiles!agent_id(full_name)',
            )
            .order('created_at', ascending: false),
        SupabaseService.instance.client
            .from('survey_questions')
            .select(
              'id, question_text, display_order, question_type, section_id, survey_sections(section_code, section_title)',
            )
            .eq('is_active', true),
      ]);
      if (mounted) {
        final meta = <String, Map<String, dynamic>>{};
        for (final row in (results[1] as List)) {
          final id = row['id'] as String?;
          final text = row['question_text'] as String?;
          if (id != null && text != null) {
            final sectionData = row['survey_sections'] as Map<String, dynamic>?;
            meta[id] = {
              'question_text': text,
              'display_order': row['display_order'] as int? ?? 0,
              'section_code': sectionData?['section_code'] as String? ?? '',
              'section_title': sectionData?['section_title'] as String? ?? '',
              'question_type': row['question_type'] as String? ?? '',
            };
          }
        }
        setState(() {
          _surveys = List<Map<String, dynamic>>.from(results[0] as List);
          _questionMeta = meta;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load surveys: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadLSeasonality(String surveyId) async {
    if (_lSeasonalityCache.containsKey(surveyId)) return;
    try {
      final rows = await SupabaseService.instance.client
          .from('employment_seasonality')
          .select(
            'activity, jan_available, feb_available, mar_available, apr_available, '
            'may_available, jun_available, jul_available, aug_available, sep_available, '
            'oct_available, nov_available, dec_available, remarks',
          )
          .eq('survey_id', surveyId)
          .order('created_at', ascending: true);
      if (mounted) {
        setState(() {
          _lSeasonalityCache[surveyId] = List<Map<String, dynamic>>.from(
            rows as List,
          );
        });
      }
    } catch (e) {
      debugPrint(
        'Admin: failed to load employment_seasonality for $surveyId: $e',
      );
    }
  }

  Future<void> _loadHouseholdAssets(String surveyId) async {
    if (_householdAssetsCache.containsKey(surveyId)) return;
    try {
      final rows = await SupabaseService.instance.client
          .from('household_assets')
          .select(
            'asset_type, asset_name, ownership_status, quantity, is_hired, hire_cost, hire_cost_unit, hiring_source, remarks',
          )
          .eq('survey_id', surveyId)
          .order('created_at', ascending: true);
      if (mounted) {
        setState(() {
          _householdAssetsCache[surveyId] = List<Map<String, dynamic>>.from(
            rows as List,
          );
        });
      }
    } catch (e) {
      debugPrint('Admin: failed to load household_assets for $surveyId: $e');
    }
  }

  Future<void> _loadLivestock(String surveyId) async {
    if (_livestockCache.containsKey(surveyId)) return;
    try {
      final rows = await SupabaseService.instance.client
          .from('livestock')
          .select(
            'animal_type, enterprise_type, breed, count, purpose, feed_source, market_value, annual_income, remarks',
          )
          .eq('survey_id', surveyId)
          .order('created_at', ascending: true);
      if (mounted) {
        setState(() {
          _livestockCache[surveyId] = List<Map<String, dynamic>>.from(
            rows as List,
          );
        });
      }
    } catch (e) {
      debugPrint('Admin: failed to load livestock for $surveyId: $e');
    }
  }

  Future<void> _loadCroppingPattern(String surveyId) async {
    if (_croppingPatternCache.containsKey(surveyId)) return;
    try {
      final rows = await SupabaseService.instance.client
          .from('cropping_pattern')
          .select('category, kharif, rabi, zaid')
          .eq('survey_id', surveyId)
          .order('created_at', ascending: true);
      if (mounted) {
        setState(() {
          _croppingPatternCache[surveyId] = List<Map<String, dynamic>>.from(
            rows as List,
          );
        });
      }
    } catch (e) {
      debugPrint('Admin: failed to load cropping_pattern for $surveyId: $e');
    }
  }

  Future<void> _loadCrops(String surveyId) async {
    if (_cropsCache.containsKey(surveyId)) return;
    try {
      final rows = await SupabaseService.instance.client
          .from('crops')
          .select(
            'category, crop_rank, crop_name, area_acres, yield_kg, variety, season',
          )
          .eq('survey_id', surveyId)
          .order('category', ascending: true);
      if (mounted) {
        setState(() {
          _cropsCache[surveyId] = List<Map<String, dynamic>>.from(rows as List);
        });
      }
    } catch (e) {
      debugPrint('Admin: failed to load crops for $surveyId: $e');
    }
  }

  Future<void> _loadPestsDiseases(String surveyId) async {
    if (_pestsDiseaseCache.containsKey(surveyId)) return;
    try {
      final rows = await SupabaseService.instance.client
          .from('pests_diseases')
          .select(
            'incident_type, crop_name, pest_disease_name, crop_stage, infestation_level, attack_frequency, symptoms, severity, disease_type, control_method, animal_type, treatment_given',
          )
          .eq('survey_id', surveyId)
          .order('created_at', ascending: true);
      if (mounted) {
        setState(() {
          _pestsDiseaseCache[surveyId] = List<Map<String, dynamic>>.from(
            rows as List,
          );
        });
      }
    } catch (e) {
      debugPrint('Admin: failed to load pests_diseases for $surveyId: $e');
    }
  }

  Future<void> _loadAllSpecializedData(String surveyId) async {
    await Future.wait([
      _loadLSeasonality(surveyId),
      _loadHouseholdAssets(surveyId),
      _loadLivestock(surveyId),
      _loadCroppingPattern(surveyId),
      _loadCrops(surveyId),
      _loadPestsDiseases(surveyId),
    ]);
  }

  List<Map<String, dynamic>> get _filtered {
    return _surveys.where((s) {
      if (_filterStatus != 'All' && s['status'] != _filterStatus) return false;
      if (_searchQuery.isNotEmpty) {
        final hh = s['households'] as Map<String, dynamic>?;
        final hhId = (hh?['hh_id'] as String? ?? '').toLowerCase();
        final name = (hh?['name'] as String? ?? '').toLowerCase();
        if (!hhId.contains(_searchQuery) && !name.contains(_searchQuery)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  List<Map<String, dynamic>> get _paginated {
    final f = _filtered;
    final start = _currentPage * _pageSize;
    if (start >= f.length) return [];
    return f.sublist(start, (start + _pageSize).clamp(0, f.length));
  }

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedIndex: 5,
      child: Row(
        children: [
          Expanded(child: _buildMainContent()),
          if (_selectedSurvey != null) _buildDetailPanel(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildTopBar(),
        _buildFilterBar(),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                  child: Text(
                    _error!,
                    style: GoogleFonts.manrope(color: AppTheme.error),
                  ),
                )
              : _buildTable(),
        ),
        _buildPagination(),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        border: Border(bottom: BorderSide(color: const Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Surveys',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${_filtered.length} surveys',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 240,
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() {
                _searchQuery = v.toLowerCase();
                _currentPage = 0;
              }),
              decoration: InputDecoration(
                hintText: 'Search by HH_ID, name...',
                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      color: AppTheme.surfaceVariantLight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _statuses.map((s) {
            final isSelected = _filterStatus == s;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  _statusLabel(s),
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => setState(() {
                  _filterStatus = s;
                  _currentPage = 0;
                }),
                selectedColor: AppTheme.primaryContainer,
                checkmarkColor: AppTheme.primary,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'All':
        return 'All';
      case 'draft':
        return 'Draft';
      case 'submitted':
        return 'Submitted';
      case 'under_review':
        return 'Under Review';
      case 'correction_required':
        return 'Correction';
      case 'approved':
        return 'Approved';
      default:
        return s;
    }
  }

  Widget _buildTable() {
    final rows = _paginated;
    if (rows.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.assignment_outlined,
        title: 'No surveys found',
        subtitle: 'There are no surveys matching your current filters.',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: AdminDataTable(
        columns: const [
          'HH_ID',
          'Household',
          'Village',
          'Field Agent',
          'Status',
          'Submitted At',
          'Actions',
        ],
        rows: rows.map((s) {
          final hh = s['households'] as Map<String, dynamic>?;
          final agent = s['user_profiles'] as Map<String, dynamic>?;
          final submittedAt = s['submitted_at'] as String?;
          final dt = submittedAt != null
              ? DateTime.tryParse(submittedAt)
              : null;
          final dateStr = dt != null ? '${dt.day}/${dt.month}/${dt.year}' : '—';
          return [
            hh?['hh_id'] ?? '—',
            hh?['name'] ?? '—',
            hh?['village'] ?? '—',
            agent?['full_name'] ?? '—',
            StatusBadgeWidget(
              status: _statusLabel(s['status'] as String? ?? 'draft'),
            ),
            dateStr,
            IconButton(
              onPressed: () {
                setState(() => _selectedSurvey = s);
                final sid = s['id'] as String?;
                if (sid != null) _loadAllSpecializedData(sid);
              },
              icon: const Icon(Icons.visibility_rounded, size: 16),
              tooltip: 'View',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
          ];
        }).toList(),
        onRowTap: (i) {
          setState(() => _selectedSurvey = rows[i]);
          final sid = rows[i]['id'] as String?;
          if (sid != null) _loadAllSpecializedData(sid);
        },
      ),
    );
  }

  Widget _buildDetailPanel() {
    final s = _selectedSurvey!;
    final hh = s['households'] as Map<String, dynamic>?;
    final rejectionReason = s['rejection_reason'] as String?;
    return Container(
      width: 360,
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
                    'Survey Details',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _selectedSurvey = null),
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
                  _infoRow('HH_ID', hh?['hh_id'] ?? '—'),
                  _infoRow('Household', hh?['name'] ?? '—'),
                  _infoRow(
                    'Status',
                    _statusLabel(s['status'] as String? ?? 'draft'),
                  ),
                  if (rejectionReason != null &&
                      rejectionReason.isNotEmpty) ...[
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
                  const Divider(height: 24),
                  Text(
                    'Survey Responses',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildResponsesSection(s),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsesSection(Map<String, dynamic> s) {
    final responses = s['responses'] as Map<String, dynamic>?;
    final surveyId = s['id'] as String?;

    if (responses == null || responses.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No responses recorded',
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          ..._buildAllSpecializedWidgets(surveyId, responses),
        ],
      );
    }

    final uuidPattern = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );

    final List<Map<String, dynamic>> validEntries = [];
    for (final entry in responses.entries) {
      final key = entry.key;
      if (!uuidPattern.hasMatch(key)) continue;
      final meta = _questionMeta[key];
      if (meta == null) continue;
      validEntries.add({
        'id': key,
        'value': entry.value,
        'question_text': meta['question_text'] as String,
        'display_order': meta['display_order'] as int,
        'section_code': meta['section_code'] as String,
        'section_title': meta['section_title'] as String,
      });
    }

    if (validEntries.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No responses recorded',
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          ..._buildAllSpecializedWidgets(surveyId, responses),
        ],
      );
    }

    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (final entry in validEntries) {
      final code = entry['section_code'] as String;
      grouped.putIfAbsent(code, () => []).add(entry);
    }

    final sortedSectionCodes = grouped.keys.toList()..sort();

    final List<Widget> sectionWidgets = [];
    for (final sectionCode in sortedSectionCodes) {
      final questions = grouped[sectionCode]!;
      questions.sort(
        (a, b) =>
            (a['display_order'] as int).compareTo(b['display_order'] as int),
      );

      final sectionTitle = questions.first['section_title'] as String;
      final displayTitle = sectionTitle.isNotEmpty
          ? sectionTitle
          : (sectionCode.isNotEmpty ? '$sectionCode.' : 'Other');

      sectionWidgets.add(
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayTitle,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF374151),
                ),
              ),
              const Divider(height: 8, thickness: 1),
            ],
          ),
        ),
      );

      for (final q in questions) {
        sectionWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    q['question_text'] as String,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    _formatResponseValue(q['value']),
                    style: GoogleFonts.manrope(fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      if (sectionCode == 'K') {
        double kTotal = 0;
        for (final q in questions) {
          final qMeta = _questionMeta[q['id'] as String?];
          final qType = qMeta?['question_type'] as String? ?? '';
          if (qType == 'number') {
            final raw = q['value'];
            if (raw != null) {
              final parsed = double.tryParse(raw.toString());
              if (parsed != null) kTotal += parsed;
            }
          }
        }
        final totalDisplay = kTotal == kTotal.truncateToDouble()
            ? '₹${kTotal.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'
            : '₹${kTotal.toStringAsFixed(2)}';

        sectionWidgets.add(const Divider(height: 12, thickness: 1));
        sectionWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Total Annual Household Income (Rs.)',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    totalDisplay,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...sectionWidgets,
        ..._buildAllSpecializedWidgets(surveyId, responses),
      ],
    );
  }

  // ─── Master builder for all specialized sections ──────────────────────────
  List<Widget> _buildAllSpecializedWidgets(
    String? surveyId,
    Map<String, dynamic>? responses,
  ) {
    return [
      ..._buildHouseholdAssetsWidget(surveyId),
      ..._buildLivestockWidget(surveyId),
      ..._buildCroppingPatternWidget(surveyId),
      ..._buildCropsWidget(surveyId),
      ..._buildPestsDiseaseWidget(surveyId),
      ..._buildItkWidget(responses),
      ..._buildLSeasonalityWidget(surveyId),
      ..._buildSchemeMatrixWidget(responses),
      ..._buildP2TrainingNeedsWidget(responses),
    ];
  }

  // ─── Helper: section header ───────────────────────────────────────────────
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF374151),
            ),
          ),
          const Divider(height: 8, thickness: 1),
        ],
      ),
    );
  }

  // ─── Helper: compact key-value row ───────────────────────────────────────
  Widget _kvRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: const Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? '—' : value,
              style: GoogleFonts.manrope(fontSize: 13),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helper: compact table header row ────────────────────────────────────
  Widget _tableHeaderRow(List<String> cols) {
    return Container(
      color: const Color(0xFFF3F4F6),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        children: cols
            .map(
              (c) => Expanded(
                child: Text(
                  c,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF374151),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ─── Helper: compact table data row ──────────────────────────────────────
  Widget _tableDataRow(List<String> cells, {Color? bg}) {
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      child: Row(
        children: cells
            .map(
              (c) => Expanded(
                child: Text(
                  c.isEmpty ? '—' : c,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: const Color(0xFF374151),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ─── Response value formatter ─────────────────────────────────────────────
  /// Converts raw survey response values to human-readable strings.
  /// - List → comma-separated items
  /// - Map with "selections" key → comma-separated selections,
  ///   with "Other: `specifyText`" appended when specifyText is non-empty
  /// - Everything else → plain toString()
  String _formatResponseValue(dynamic value) {
    if (value == null) return '—';

    // Handle JSON-decoded List
    if (value is List) {
      if (value.isEmpty) return '—';
      return value.map((e) => e?.toString() ?? '').join(', ');
    }

    // Handle JSON-decoded Map with a "selections" key
    if (value is Map) {
      final selections = value['selections'];
      final specifyText = (value['specifyText'] as String? ?? '').trim();
      if (selections != null) {
        final selStr = selections is List
            ? selections.map((e) => e?.toString() ?? '').join(', ')
            : selections.toString();
        if (specifyText.isNotEmpty) {
          return '$selStr\nOther: $specifyText';
        }
        return selStr.isEmpty ? '—' : selStr;
      }
      // Generic map — fall through to toString
    }

    // Plain string: try to parse as JSON first (handles stored-as-string cases)
    if (value is String) {
      final trimmed = value.trim();
      if ((trimmed.startsWith('[') || trimmed.startsWith('{'))) {
        try {
          final decoded = jsonDecode(trimmed);
          return _formatResponseValue(decoded);
        } catch (_) {
          // Not valid JSON — return as-is
        }
      }
      return trimmed.isEmpty ? '—' : trimmed;
    }

    return value.toString();
  }

  // ─── C — Asset Matrix ─────────────────────────────────────────────────────
  List<Widget> _buildHouseholdAssetsWidget(String? surveyId) {
    if (surveyId == null) return [];
    final rows = _householdAssetsCache[surveyId];
    if (rows == null || rows.isEmpty) return [];

    final widgets = <Widget>[_sectionHeader('C — Asset Matrix')];

    widgets.add(
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            _tableHeaderRow(['Asset', 'Owned', 'Qty', 'Hired', 'Hire Cost']),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            ...rows.asMap().entries.map((e) {
              final row = e.value;
              final assetName =
                  (row['asset_name'] as String?)?.isNotEmpty == true
                  ? row['asset_name'] as String
                  : (row['asset_type'] as String?) ?? '—';
              final owned = (row['ownership_status'] as String?) ?? '—';
              final qty = row['quantity'] != null ? '${row['quantity']}' : '—';
              final isHired = row['is_hired'];
              final hiredStr = isHired == true || isHired.toString() == 'true'
                  ? 'Yes'
                  : 'No';
              final hireCost = row['hire_cost'] != null
                  ? '₹${row['hire_cost']} ${(row['hire_cost_unit'] as String?) ?? ''}'
                        .trim()
                  : '—';
              return Column(
                children: [
                  _tableDataRow([
                    assetName,
                    owned,
                    qty,
                    hiredStr,
                    hireCost,
                  ], bg: e.key.isEven ? null : const Color(0xFFF9FAFB)),
                  if (e.key < rows.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE2E8F0),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );

    return widgets;
  }

  // ─── C — Livestock ────────────────────────────────────────────────────────
  List<Widget> _buildLivestockWidget(String? surveyId) {
    if (surveyId == null) return [];
    final rows = _livestockCache[surveyId];
    if (rows == null || rows.isEmpty) return [];

    final widgets = <Widget>[_sectionHeader('C — Livestock')];

    widgets.add(
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            _tableHeaderRow([
              'Animal / Enterprise',
              'Breed',
              'Count',
              'Purpose',
              'Annual Income',
            ]),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            ...rows.asMap().entries.map((e) {
              final row = e.value;
              final animalType =
                  (row['enterprise_type'] as String?)?.isNotEmpty == true
                  ? row['enterprise_type'] as String
                  : (row['animal_type'] as String?) ?? '—';
              final breed = (row['breed'] as String?) ?? '—';
              final count = row['count'] != null ? '${row['count']}' : '—';
              final purpose = (row['purpose'] as String?) ?? '—';
              final income = row['annual_income'] != null
                  ? '₹${row['annual_income']}'
                  : '—';
              return Column(
                children: [
                  _tableDataRow([
                    animalType,
                    breed,
                    count,
                    purpose,
                    income,
                  ], bg: e.key.isEven ? null : const Color(0xFFF9FAFB)),
                  if (e.key < rows.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE2E8F0),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );

    return widgets;
  }

  // ─── D-09 — Cropping Pattern ──────────────────────────────────────────────
  List<Widget> _buildCroppingPatternWidget(String? surveyId) {
    if (surveyId == null) return [];
    final rows = _croppingPatternCache[surveyId];
    if (rows == null || rows.isEmpty) return [];

    final widgets = <Widget>[_sectionHeader('D-09 — Cropping Pattern')];

    widgets.add(
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            _tableHeaderRow(['Category', 'Kharif', 'Rabi', 'Zaid']),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            ...rows.asMap().entries.map((e) {
              final row = e.value;
              return Column(
                children: [
                  _tableDataRow([
                    (row['category'] as String?) ?? '—',
                    (row['kharif'] as String?) ?? '—',
                    (row['rabi'] as String?) ?? '—',
                    (row['zaid'] as String?) ?? '—',
                  ], bg: e.key.isEven ? null : const Color(0xFFF9FAFB)),
                  if (e.key < rows.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE2E8F0),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );

    return widgets;
  }

  // ─── D-10 — Crop Details ──────────────────────────────────────────────────
  List<Widget> _buildCropsWidget(String? surveyId) {
    if (surveyId == null) return [];
    final rows = _cropsCache[surveyId];
    if (rows == null || rows.isEmpty) return [];

    final widgets = <Widget>[_sectionHeader('D-10 — Crop Details')];

    widgets.add(
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            _tableHeaderRow([
              'Category',
              'Crop',
              'Area (ac)',
              'Yield (kg)',
              'Variety',
            ]),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            ...rows.asMap().entries.map((e) {
              final row = e.value;
              return Column(
                children: [
                  _tableDataRow([
                    (row['category'] as String?) ?? '—',
                    (row['crop_name'] as String?) ?? '—',
                    row['area_acres'] != null ? '${row['area_acres']}' : '—',
                    row['yield_kg'] != null ? '${row['yield_kg']}' : '—',
                    (row['variety'] as String?) ?? '—',
                  ], bg: e.key.isEven ? null : const Color(0xFFF9FAFB)),
                  if (e.key < rows.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE2E8F0),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );

    return widgets;
  }

  // ─── F — Pest / Disease ───────────────────────────────────────────────────
  List<Widget> _buildPestsDiseaseWidget(String? surveyId) {
    if (surveyId == null) return [];
    final rows = _pestsDiseaseCache[surveyId];
    if (rows == null || rows.isEmpty) return [];

    final widgets = <Widget>[_sectionHeader('F — Pest / Disease')];

    for (int i = 0; i < rows.length; i++) {
      final row = rows[i];
      final type = (row['incident_type'] as String?) ?? '';
      final isPest = type == 'pest';
      widgets.add(
        Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(6),
            color: isPest ? const Color(0xFFFFF7ED) : const Color(0xFFF0FDF4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isPest
                          ? const Color(0xFFFED7AA)
                          : const Color(0xFFBBF7D0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isPest ? 'Pest' : 'Disease',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isPest
                            ? const Color(0xFF9A3412)
                            : const Color(0xFF166534),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      (row['pest_disease_name'] as String?) ?? '—',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              _kvRow('Crop', (row['crop_name'] as String?) ?? ''),
              if ((row['crop_stage'] as String?)?.isNotEmpty == true)
                _kvRow('Crop Stage', row['crop_stage'] as String),
              if (isPest) ...[
                if ((row['infestation_level'] as String?)?.isNotEmpty == true)
                  _kvRow(
                    'Infestation Level',
                    row['infestation_level'] as String,
                  ),
                if ((row['attack_frequency'] as String?)?.isNotEmpty == true)
                  _kvRow('Attack Frequency', row['attack_frequency'] as String),
                if ((row['symptoms'] as String?)?.isNotEmpty == true)
                  _kvRow('Symptoms', row['symptoms'] as String),
              ] else ...[
                if ((row['severity'] as String?)?.isNotEmpty == true)
                  _kvRow('Severity', row['severity'] as String),
                if ((row['disease_type'] as String?)?.isNotEmpty == true)
                  _kvRow('Disease Type', row['disease_type'] as String),
                if ((row['control_method'] as String?)?.isNotEmpty == true)
                  _kvRow('Control Method', row['control_method'] as String),
              ],
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  // ─── I-07 — ITK (from surveys.responses) ─────────────────────────────────
  static const String _kI07QuestionId = '93aefa43-08d1-499b-a2e6-b0ee251d6d8f';

  List<Widget> _buildItkWidget(Map<String, dynamic>? responses) {
    if (responses == null) return [];
    final raw = responses[_kI07QuestionId];
    if (raw == null) return [];

    List<dynamic> items = [];
    if (raw is List) {
      items = raw;
    } else if (raw is String && raw.trim().startsWith('[')) {
      try {
        final decoded = (raw).trim();
        // Simple JSON-like parse — use dart:convert
        items = _parseJsonList(decoded);
      } catch (_) {
        return [];
      }
    }

    if (items.isEmpty) return [];

    final widgets = <Widget>[
      _sectionHeader('I-07 — ITK (Indigenous Technical Knowledge)'),
    ];

    widgets.add(
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            _tableHeaderRow([
              'S.No.',
              'ITK Practice',
              'Purpose / Use',
              'Materials Used',
            ]),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            ...items.asMap().entries.map((e) {
              final item = e.value is Map ? e.value as Map : {};
              return Column(
                children: [
                  _tableDataRow([
                    '${e.key + 1}',
                    (item['itk_practice'] as String?) ?? '—',
                    (item['purpose_use'] as String?) ?? '—',
                    (item['materials_used'] as String?) ?? '—',
                  ], bg: e.key.isEven ? null : const Color(0xFFF9FAFB)),
                  if (e.key < items.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE2E8F0),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );

    return widgets;
  }

  // ─── L — Seasonality / Employment Calendar ────────────────────────────────
  List<Widget> _buildLSeasonalityWidget(String? surveyId) {
    if (surveyId == null) return [];
    final rows = _lSeasonalityCache[surveyId];
    if (rows == null || rows.isEmpty) return [];

    const monthLabels = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const monthCols = [
      'jan_available',
      'feb_available',
      'mar_available',
      'apr_available',
      'may_available',
      'jun_available',
      'jul_available',
      'aug_available',
      'sep_available',
      'oct_available',
      'nov_available',
      'dec_available',
    ];

    final widgets = <Widget>[
      _sectionHeader('L — Seasonality / Employment Calendar'),
    ];

    for (final row in rows) {
      final activity = (row['activity'] as String?) ?? '';
      final tickedMonths = <String>[];
      for (int i = 0; i < monthCols.length; i++) {
        final v = row[monthCols[i]];
        if (v == true || v.toString() == 'true') {
          tickedMonths.add(monthLabels[i]);
        }
      }
      final remarks = (row['remarks'] as String?) ?? '';
      final monthsStr = tickedMonths.isEmpty ? '—' : tickedMonths.join(', ');

      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  activity,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(monthsStr, style: GoogleFonts.manrope(fontSize: 13)),
                    if (remarks.isNotEmpty)
                      Text(
                        'Remarks: $remarks',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          color: const Color(0xFF9CA3AF),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  // ─── O — Scheme / Service Matrix ─────────────────────────────────────────
  static const String _kOSchemeMatrixKey = 'O-SCHEME-MATRIX';
  static const String _kO01QuestionId = 'cf094f24-5672-42be-8de1-9752cc08d93c';
  static const String _kO02QuestionId = 'd4f5d4b5-505d-4046-aacc-4ef39210da52';

  List<Widget> _buildSchemeMatrixWidget(Map<String, dynamic>? responses) {
    if (responses == null) return [];

    final o01Answer = responses[_kO01QuestionId];
    final o02Answer = responses[_kO02QuestionId];
    final matrixRaw = responses[_kOSchemeMatrixKey];

    // Only render if at least one O-section value is present
    if (o01Answer == null && o02Answer == null && matrixRaw == null) return [];

    List<dynamic> matrixItems = [];
    if (matrixRaw is List) {
      matrixItems = matrixRaw;
    } else if (matrixRaw is String && matrixRaw.trim().startsWith('[')) {
      try {
        matrixItems = _parseJsonList(matrixRaw.trim());
      } catch (_) {}
    }

    final widgets = <Widget>[
      _sectionHeader('O — Access to Schemes & Services'),
    ];

    if (o01Answer != null) {
      widgets.add(_kvRow('Awareness of Govt. schemes', '$o01Answer'));
    }
    if (o02Answer != null) {
      final displayVal = o02Answer.toString().toLowerCase() == 'yes'
          ? 'Yes'
          : o02Answer.toString().toLowerCase() == 'no'
          ? 'No'
          : '$o02Answer';
      widgets.add(_kvRow('Have you availed any scheme?', displayVal));
    }

    if (matrixItems.isNotEmpty) {
      widgets.add(const SizedBox(height: 8));
      widgets.add(
        Text(
          'Scheme / Service Details',
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
      );
      widgets.add(const SizedBox(height: 4));
      widgets.add(
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              _tableHeaderRow([
                'Scheme / Service',
                'Status',
                'Utility / Reason',
              ]),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
              ...matrixItems.asMap().entries.map((e) {
                final item = e.value is Map ? e.value as Map : {};
                final schemeCode = (item['scheme_code'] as String?) ?? '';
                final schemeName =
                    (item['scheme_name'] as String?)?.isNotEmpty == true
                    ? item['scheme_name'] as String
                    : _schemeDisplayName(schemeCode);
                final status = (item['status'] as String?) ?? '';
                final statusDisplay = status == 'availed'
                    ? 'Availed'
                    : status == 'not_availed'
                    ? 'Not Availed'
                    : '—';
                final utilityOrReason = status == 'availed'
                    ? (item['utility'] as String?) ?? ''
                    : (item['reason'] as String?) ?? '';

                return Column(
                  children: [
                    _tableDataRow([
                      schemeName,
                      statusDisplay,
                      utilityOrReason,
                    ], bg: e.key.isEven ? null : const Color(0xFFF9FAFB)),
                    if (e.key < matrixItems.length - 1)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFE2E8F0),
                      ),
                  ],
                );
              }),
            ],
          ),
        ),
      );
    }

    return widgets;
  }

  String _schemeDisplayName(String code) {
    const names = {
      'ration_card': 'Ration card',
      'kisan_credit_card': 'Kisan Credit Card',
      'mgnrega_job_card': 'MGNREGA Job Card',
      'pm_kisan_samman_nidhi': 'PM-Kisan Samman Nidhi',
      'shg_membership': 'SHG membership',
      'fpo_membership': 'FPO membership',
      'health_insurance_pmjay': 'Health insurance (Ayushman Bharat - PM-JAY)',
      'namo_drone_didi': 'Namo Drone Didi scheme',
      'other': 'Other',
    };
    return names[code] ?? code;
  }

  // ─── P2 — Enterprise-wise Training Needs Assessment ───────────────────────
  static const String _kP2TrainingNeedsKey = 'P2-TRAINING-NEEDS';

  List<Widget> _buildP2TrainingNeedsWidget(Map<String, dynamic>? responses) {
    if (responses == null) return [];
    final raw = responses[_kP2TrainingNeedsKey];
    if (raw == null) return [];

    List<dynamic> items = [];
    if (raw is List) {
      items = raw;
    } else if (raw is String && raw.trim().startsWith('[')) {
      try {
        items = _parseJsonList(raw.trim());
      } catch (_) {}
    }

    if (items.isEmpty) return [];

    final widgets = <Widget>[
      _sectionHeader('P2 — Enterprise-wise Training Needs Assessment'),
    ];

    // Table header
    widgets.add(const SizedBox(height: 8));
    widgets.add(
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              child: Row(
                children: [
                  _p2HeaderCell('#', flex: 1),
                  _p2HeaderCell('Enterprise', flex: 4),
                  _p2HeaderCell('Currently\nPracticing', flex: 2),
                  _p2HeaderCell('Training\nReceived', flex: 2),
                  _p2HeaderCell('Skill\nLevel', flex: 2),
                  _p2HeaderCell('Need\nTraining', flex: 2),
                  _p2HeaderCell('Priority\nLevel', flex: 2),
                  _p2HeaderCell('Preferred Training Area', flex: 5),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            // Data rows
            ...items.asMap().entries.map((e) {
              final idx = e.key;
              final item = e.value is Map ? e.value as Map : {};
              final enterpriseCode = (item['enterprise_code'] as String?) ?? '';
              final enterpriseName =
                  (item['enterprise_name'] as String?)?.isNotEmpty == true
                  ? item['enterprise_name'] as String
                  : _p2EnterpriseDisplayName(enterpriseCode);
              final otherSpecify = (item['other_specify'] as String?) ?? '';
              final displayName =
                  enterpriseCode == 'other' && otherSpecify.isNotEmpty
                  ? '$enterpriseName ($otherSpecify)'
                  : enterpriseName;

              final currentlyPracticing = _p2YesNo(
                item['currently_practicing'],
              );
              final trainingReceived = _p2YesNo(item['training_received']);
              final skillLevel = _p2Capitalize(item['skill_level']);
              final needTraining = _p2YesNo(item['need_training']);
              final priorityLevel = _p2Capitalize(item['priority_level']);

              // Preferred training areas
              final areasRaw = item['preferred_training_areas'];
              List<String> areas = [];
              if (areasRaw is List) {
                areas = areasRaw
                    .map(
                      (a) => _p2TrainingAreaLabel(
                        enterpriseCode,
                        a?.toString() ?? '',
                      ),
                    )
                    .where((a) => a.isNotEmpty)
                    .toList();
              }
              final otherAreaText =
                  (item['other_training_area_text'] as String?) ?? '';
              if (enterpriseCode == 'other' && otherAreaText.isNotEmpty) {
                areas = [otherAreaText];
              }
              final areasDisplay = areas.isNotEmpty ? areas.join(', ') : '—';

              final bg = idx.isEven ? null : const Color(0xFFF9FAFB);

              return Column(
                children: [
                  Container(
                    color: bg,
                    child: Row(
                      children: [
                        _p2DataCell('${idx + 1}', flex: 1),
                        _p2DataCell(displayName, flex: 4, bold: true),
                        _p2DataCell(currentlyPracticing, flex: 2),
                        _p2DataCell(trainingReceived, flex: 2),
                        _p2DataCell(skillLevel, flex: 2),
                        _p2DataCell(needTraining, flex: 2),
                        _p2DataCell(priorityLevel, flex: 2),
                        _p2DataCell(areasDisplay, flex: 5),
                      ],
                    ),
                  ),
                  if (idx < items.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE2E8F0),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );

    // If "other" enterprise has specify text, show it separately
    final otherItem = items.firstWhere(
      (i) => i is Map && (i['enterprise_code'] as String?) == 'other',
      orElse: () => null,
    );
    if (otherItem != null && otherItem is Map) {
      final specifyName = (otherItem['other_specify'] as String?) ?? '';
      final specifyArea =
          (otherItem['other_training_area_text'] as String?) ?? '';
      if (specifyName.isNotEmpty || specifyArea.isNotEmpty) {
        widgets.add(const SizedBox(height: 8));
        widgets.add(
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              border: Border.all(color: const Color(0xFFFDE68A)),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🟡 Others (if specified)',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF92400E),
                  ),
                ),
                const SizedBox(height: 6),
                if (specifyName.isNotEmpty)
                  _kvRow('Enterprise name', specifyName),
                if (specifyArea.isNotEmpty)
                  _kvRow('Preferred training area', specifyArea),
              ],
            ),
          ),
        );
      }
    }

    return widgets;
  }

  Widget _p2HeaderCell(String text, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF374151),
          ),
        ),
      ),
    );
  }

  Widget _p2DataCell(String text, {required int flex, bool bold = false}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
        child: Text(
          text.isEmpty ? '—' : text,
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
            color: const Color(0xFF374151),
          ),
        ),
      ),
    );
  }

  String _p2YesNo(dynamic val) {
    if (val == null) return '—';
    final s = val.toString().toLowerCase().trim();
    if (s == 'yes') return 'Yes';
    if (s == 'no') return 'No';
    return s.isEmpty ? '—' : val.toString();
  }

  String _p2Capitalize(dynamic val) {
    if (val == null) return '—';
    final s = val.toString().trim();
    if (s.isEmpty) return '—';
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  String _p2EnterpriseDisplayName(String code) {
    const names = {
      'crop_production': 'Crop Production',
      'horticulture': 'Horticulture',
      'livestock': 'Livestock (Dairy/Meat)',
      'piggery': 'Piggery',
      'poultry': 'Poultry',
      'fishery': 'Fishery',
      'beekeeping': 'Beekeeping',
      'mushroom': 'Mushroom',
      'food_processing': 'Food Processing',
      'marketing_business': 'Marketing & Business',
      'other': 'Others',
    };
    return names[code] ?? code;
  }

  String _p2TrainingAreaLabel(String enterpriseCode, String areaCode) {
    const areaLabels = <String, Map<String, String>>{
      'crop_production': {
        'improved_seeds': 'Improved seeds',
        'ipm': 'IPM',
        'inm': 'INM',
        'water_management': 'Water management',
      },
      'horticulture': {
        'nursery': 'Nursery',
        'pruning': 'Pruning',
        'pest_management': 'Pest management',
      },
      'livestock': {
        'breed_mgmt': 'Breed mgmt',
        'feeding': 'Feeding',
        'health_care': 'Health care',
      },
      'piggery': {
        'breed': 'Breed',
        'feed': 'Feed',
        'disease_control': 'Disease control',
      },
      'poultry': {
        'backyard': 'Backyard',
        'vaccination': 'Vaccination',
        'housing': 'Housing',
      },
      'fishery': {
        'pond_mgmt': 'Pond mgmt',
        'feeding': 'Feeding',
        'stocking': 'Stocking',
      },
      'beekeeping': {
        'hive_mgmt': 'Hive mgmt',
        'honey_extraction': 'Honey extraction',
      },
      'mushroom': {
        'spawn': 'Spawn',
        'cultivation': 'Cultivation',
        'marketing': 'Marketing',
      },
      'food_processing': {
        'value_addition': 'Value addition',
        'packaging': 'Packaging',
      },
      'marketing_business': {
        'pricing': 'Pricing',
        'branding': 'Branding',
        'digital_sales': 'Digital sales',
      },
    };
    return areaLabels[enterpriseCode]?[areaCode] ?? areaCode;
  }

  // ─── JSON list parser ─────────────────────────────────────────────────────
  List<dynamic> _parseJsonList(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded;
      return [];
    } catch (_) {
      return [];
    }
  }

  Widget _buildPagination() {
    final total = _filtered.length;
    final totalPages = (total / _pageSize).ceil();
    if (totalPages <= 1) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        border: Border(top: BorderSide(color: const Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 0
                ? () => setState(() => _currentPage--)
                : null,
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          Text(
            'Page ${_currentPage + 1} of $totalPages',
            style: GoogleFonts.manrope(fontSize: 13),
          ),
          IconButton(
            onPressed: _currentPage < totalPages - 1
                ? () => setState(() => _currentPage++)
                : null,
            icon: const Icon(Icons.chevron_right_rounded),
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
}

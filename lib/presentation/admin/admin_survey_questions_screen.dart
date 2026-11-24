import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import './admin_shell.dart';
import './widgets/admin_confirm_dialog.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AdminSurveyQuestionsScreen — Full CRUD Manager
// Phase 1: Template / Section / Question / Option management
// ─────────────────────────────────────────────────────────────────────────────

class AdminSurveyQuestionsScreen extends StatefulWidget {
  const AdminSurveyQuestionsScreen({super.key});

  @override
  State<AdminSurveyQuestionsScreen> createState() =>
      _AdminSurveyQuestionsScreenState();
}

class _AdminSurveyQuestionsScreenState
    extends State<AdminSurveyQuestionsScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _templates = [];
  List<Map<String, dynamic>> _sections = [];
  List<Map<String, dynamic>> _questions = [];
  String? _selectedTemplateId;
  String? _selectedSectionId;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  // ── Data loading ──────────────────────────────────────────────────────────

  Future<void> _loadTemplates() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await SupabaseService.instance.client
          .from('survey_templates')
          .select()
          .order('created_at', ascending: false);
      if (!mounted) return;
      setState(() {
        _templates = List<Map<String, dynamic>>.from(data as List);
        _isLoading = false;
        if (_templates.isNotEmpty) {
          _selectedTemplateId = _templates.first['id'] as String;
          _loadSections(_selectedTemplateId!);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load templates: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSections(String templateId) async {
    try {
      final data = await SupabaseService.instance.client
          .from('survey_sections')
          .select()
          .eq('template_id', templateId)
          .order('display_order');
      if (!mounted) return;
      setState(() {
        _sections = List<Map<String, dynamic>>.from(data as List);
        if (_sections.isNotEmpty) {
          _selectedSectionId = _sections.first['id'] as String;
          _loadQuestions(_selectedSectionId!);
        } else {
          _selectedSectionId = null;
          _questions = [];
        }
      });
    } catch (_) {}
  }

  Future<void> _loadQuestions(String sectionId) async {
    try {
      final data = await SupabaseService.instance.client
          .from('survey_questions')
          .select('*, survey_question_options(*)')
          .eq('section_id', sectionId)
          .order('display_order');
      if (!mounted) return;
      setState(() {
        _questions = List<Map<String, dynamic>>.from(data as List);
        // Sort options by display_order within each question
        for (final q in _questions) {
          final opts = q['survey_question_options'] as List?;
          if (opts != null) {
            opts.sort(
              (a, b) => ((a['display_order'] as int?) ?? 0).compareTo(
                (b['display_order'] as int?) ?? 0,
              ),
            );
          }
        }
      });
    } catch (_) {}
  }

  // ── Check if a question has existing survey_answers ───────────────────────

  Future<bool> _questionHasAnswers(String questionId) async {
    try {
      final result = await SupabaseService.instance.client
          .from('survey_answers')
          .select('id')
          .eq('question_id', questionId)
          .limit(1);
      return (result as List).isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _optionHasAnswers(String optionValue, String questionId) async {
    try {
      // answer_options is a TEXT[] column; check if any answer references this option value
      final result = await SupabaseService.instance.client
          .from('survey_answers')
          .select('id')
          .eq('question_id', questionId)
          .contains('answer_options', [optionValue])
          .limit(1);
      return (result as List).isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // ── Template CRUD ─────────────────────────────────────────────────────────

  void _showCreateTemplateDialog() {
    showDialog(
      context: context,
      builder: (_) => _TemplateDialog(onSaved: () => _loadTemplates()),
    );
  }

  void _showEditTemplateDialog(Map<String, dynamic> t) {
    showDialog(
      context: context,
      builder: (_) =>
          _TemplateDialog(existing: t, onSaved: () => _loadTemplates()),
    );
  }

  Future<void> _toggleTemplateActive(Map<String, dynamic> t) async {
    final isActive = t['is_active'] as bool? ?? true;
    final confirmed = await AdminConfirmDialog.show(
      context,
      title: isActive ? 'Deactivate Template' : 'Activate Template',
      message: isActive
          ? 'Deactivating this template will hide it from new surveys. Existing survey data is unaffected.'
          : 'Activate this template?',
    );
    if (confirmed != true) return;
    try {
      await SupabaseService.instance.client
          .from('survey_templates')
          .update({'is_active': !isActive})
          .eq('id', t['id'] as String);
      _loadTemplates();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  // ── Section CRUD ──────────────────────────────────────────────────────────

  void _showCreateSectionDialog() {
    if (_selectedTemplateId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a template first')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => _SectionDialog(
        templateId: _selectedTemplateId!,
        displayOrder: _sections.length + 1,
        onSaved: () => _loadSections(_selectedTemplateId!),
      ),
    );
  }

  void _showEditSectionDialog(Map<String, dynamic> s) {
    showDialog(
      context: context,
      builder: (_) => _SectionDialog(
        templateId: _selectedTemplateId!,
        existing: s,
        displayOrder: s['display_order'] as int? ?? 1,
        onSaved: () => _loadSections(_selectedTemplateId!),
      ),
    );
  }

  Future<void> _toggleSectionActive(Map<String, dynamic> s) async {
    final isActive = s['is_active'] as bool? ?? true;
    final confirmed = await AdminConfirmDialog.show(
      context,
      title: isActive ? 'Deactivate Section' : 'Activate Section',
      message: isActive
          ? 'Deactivating this section will hide all its questions from new surveys.'
          : 'Activate this section?',
    );
    if (confirmed != true) return;
    try {
      await SupabaseService.instance.client
          .from('survey_sections')
          .update({'is_active': !isActive})
          .eq('id', s['id'] as String);
      if (_selectedTemplateId != null) _loadSections(_selectedTemplateId!);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  Future<void> _reorderSection(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;
    final sections = List<Map<String, dynamic>>.from(_sections);
    final item = sections.removeAt(oldIndex);
    sections.insert(newIndex, item);
    setState(() => _sections = sections);
    try {
      for (int i = 0; i < sections.length; i++) {
        await SupabaseService.instance.client
            .from('survey_sections')
            .update({'display_order': i + 1})
            .eq('id', sections[i]['id'] as String);
      }
    } catch (_) {
      if (_selectedTemplateId != null) _loadSections(_selectedTemplateId!);
    }
  }

  // ── Question CRUD ─────────────────────────────────────────────────────────

  void _showAddQuestionDialog() {
    if (_selectedSectionId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a section first')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => _QuestionDialog(
        sectionId: _selectedSectionId!,
        displayOrder: _questions.length + 1,
        onSaved: () => _loadQuestions(_selectedSectionId!),
      ),
    );
  }

  void _showEditQuestionDialog(Map<String, dynamic> q) async {
    final hasAnswers = await _questionHasAnswers(q['id'] as String);
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => _QuestionDialog(
        sectionId: _selectedSectionId!,
        existing: q,
        displayOrder: q['display_order'] as int? ?? 1,
        hasExistingAnswers: hasAnswers,
        onSaved: () => _loadQuestions(_selectedSectionId!),
      ),
    );
  }

  Future<void> _toggleQuestionActive(Map<String, dynamic> q) async {
    final isActive = q['is_active'] as bool? ?? true;
    final confirmed = await AdminConfirmDialog.show(
      context,
      title: isActive ? 'Deactivate Question' : 'Activate Question',
      message: isActive
          ? 'Deactivating this question will exclude it from new surveys. Existing answers are preserved.'
          : 'Activate this question?',
    );
    if (confirmed != true) return;
    try {
      await SupabaseService.instance.client
          .from('survey_questions')
          .update({'is_active': !isActive})
          .eq('id', q['id'] as String);
      if (_selectedSectionId != null) _loadQuestions(_selectedSectionId!);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  Future<void> _reorderQuestion(int oldIndex, int newIndex) async {
    if (oldIndex == newIndex) return;
    final questions = List<Map<String, dynamic>>.from(_questions);
    final item = questions.removeAt(oldIndex);
    questions.insert(newIndex, item);
    setState(() => _questions = questions);
    try {
      for (int i = 0; i < questions.length; i++) {
        await SupabaseService.instance.client
            .from('survey_questions')
            .update({'display_order': i + 1})
            .eq('id', questions[i]['id'] as String);
      }
    } catch (_) {
      if (_selectedSectionId != null) _loadQuestions(_selectedSectionId!);
    }
  }

  // ── Option management ─────────────────────────────────────────────────────

  void _showManageOptionsDialog(Map<String, dynamic> q) {
    showDialog(
      context: context,
      builder: (_) => _OptionsManagerDialog(
        question: q,
        onChanged: () => _loadQuestions(_selectedSectionId!),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AdminShell(
      selectedIndex: 6,
      child: Column(
        children: [
          _buildTopBar(),
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
                : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        border: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Survey Questions',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Manage templates, sections, questions & options',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _TopBarButton(
            icon: Icons.add_rounded,
            label: 'Template',
            onPressed: _showCreateTemplateDialog,
          ),
          const SizedBox(width: 4),
          _TopBarButton(
            icon: Icons.playlist_add_rounded,
            label: 'Section',
            onPressed: _showCreateSectionDialog,
          ),
          const SizedBox(width: 4),
          _TopBarButton(
            icon: Icons.help_outline_rounded,
            label: 'Question',
            onPressed: _showAddQuestionDialog,
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: _loadTemplates,
            icon: const Icon(Icons.refresh_rounded, size: 20),
            tooltip: 'Refresh',
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth < 600
            ? _buildNarrowLayout()
            : _buildWideLayout();
      },
    );
  }

  // ── Wide layout ───────────────────────────────────────────────────────────

  Widget _buildWideLayout() {
    return Row(
      children: [
        _buildSidebar(),
        Expanded(child: _buildQuestionsList()),
      ],
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Templates header
          _SidebarSectionHeader(
            label: 'Templates',
            onAdd: _showCreateTemplateDialog,
          ),
          ..._templates.map((t) => _templateTile(t)),
          const Divider(height: 1),
          // Sections header
          _SidebarSectionHeader(
            label: 'Sections',
            onAdd: _showCreateSectionDialog,
          ),
          Expanded(
            child: _sections.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No sections',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: _sections.length,
                    onReorder: _reorderSection,
                    itemBuilder: (_, i) => _sectionTile(_sections[i], i),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Narrow layout ─────────────────────────────────────────────────────────

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        _buildNarrowSelectors(),
        Expanded(child: _buildQuestionsList()),
      ],
    );
  }

  Widget _buildNarrowSelectors() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NarrowDropdownRow(
            icon: Icons.description_rounded,
            label: 'Template',
            items: _templates,
            value: _selectedTemplateId,
            displayKey: 'name',
            onChanged: (val) {
              setState(() => _selectedTemplateId = val);
              _loadSections(val!);
            },
          ),
          const SizedBox(height: 8),
          _NarrowDropdownRow(
            icon: Icons.layers_rounded,
            label: 'Section',
            items: _sections,
            value: _selectedSectionId,
            displayKey: 'section_title',
            trailing: _sections.isNotEmpty ? '${_questions.length} Q' : null,
            onChanged: (val) {
              setState(() => _selectedSectionId = val);
              _loadQuestions(val!);
            },
          ),
        ],
      ),
    );
  }

  // ── Tiles ─────────────────────────────────────────────────────────────────

  Widget _templateTile(Map<String, dynamic> t) {
    final isSelected = _selectedTemplateId == t['id'];
    final isActive = t['is_active'] as bool? ?? true;
    return InkWell(
      key: ValueKey(t['id']),
      onTap: () {
        setState(() => _selectedTemplateId = t['id'] as String);
        _loadSections(t['id'] as String);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.description_rounded,
              size: 15,
              color: isSelected ? AppTheme.primary : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t['name'] as String? ?? 'Template',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? AppTheme.primary
                          : const Color(0xFF374151),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isActive)
                    Text(
                      'Inactive',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        color: AppTheme.statusDraft,
                      ),
                    ),
                ],
              ),
            ),
            // Edit button
            _MiniIconButton(
              icon: Icons.edit_rounded,
              tooltip: 'Edit template',
              onTap: () => _showEditTemplateDialog(t),
            ),
            // Toggle active
            _MiniIconButton(
              icon: isActive
                  ? Icons.toggle_on_rounded
                  : Icons.toggle_off_rounded,
              tooltip: isActive ? 'Deactivate' : 'Activate',
              color: isActive ? AppTheme.success : const Color(0xFF9CA3AF),
              onTap: () => _toggleTemplateActive(t),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTile(Map<String, dynamic> s, int index) {
    final isSelected = _selectedSectionId == s['id'];
    final isActive = s['is_active'] as bool? ?? true;
    return InkWell(
      key: ValueKey(s['id']),
      onTap: () {
        setState(() => _selectedSectionId = s['id'] as String);
        _loadQuestions(s['id'] as String);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.drag_handle_rounded,
              size: 14,
              color: Color(0xFFCBD5E0),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s['section_title'] as String? ?? 'Section',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? AppTheme.primary
                          : const Color(0xFF374151),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isActive)
                    Text(
                      'Inactive',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        color: AppTheme.statusDraft,
                      ),
                    ),
                ],
              ),
            ),
            _MiniIconButton(
              icon: Icons.edit_rounded,
              tooltip: 'Edit section',
              onTap: () => _showEditSectionDialog(s),
            ),
            _MiniIconButton(
              icon: isActive
                  ? Icons.toggle_on_rounded
                  : Icons.toggle_off_rounded,
              tooltip: isActive ? 'Deactivate' : 'Activate',
              color: isActive ? AppTheme.success : const Color(0xFF9CA3AF),
              onTap: () => _toggleSectionActive(s),
            ),
          ],
        ),
      ),
    );
  }

  // ── Questions list ────────────────────────────────────────────────────────

  Widget _buildQuestionsList() {
    if (_selectedSectionId == null) {
      return const EmptyStateWidget(
        icon: Icons.layers_outlined,
        title: 'No Section Selected',
        subtitle: 'Select or create a section to manage questions',
      );
    }
    if (_questions.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.quiz_outlined,
        title: 'No Questions',
        subtitle: 'No questions in this section yet',
        ctaLabel: 'Add Question',
        onCta: _showAddQuestionDialog,
      );
    }
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _questions.length,
      onReorder: _reorderQuestion,
      itemBuilder: (_, i) => _buildQuestionCard(_questions[i], i),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> q, int index) {
    final isActive = q['is_active'] as bool? ?? true;
    final qType = q['question_type'] as String? ?? 'text';
    final options = (q['survey_question_options'] as List? ?? [])
        .cast<Map<String, dynamic>>();
    final hasOptions = qType == 'single_choice' || qType == 'multiple_choice';

    return Container(
      key: ValueKey(q['id']),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isActive
              ? const Color(0xFFE2E8F0)
              : const Color(0xFFE2E8F0).withAlpha(128),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 0),
            child: Row(
              children: [
                const Icon(
                  Icons.drag_handle_rounded,
                  size: 16,
                  color: Color(0xFFCBD5E0),
                ),
                const SizedBox(width: 6),
                _Badge(
                  label: 'Q${index + 1}',
                  bg: AppTheme.primaryContainer,
                  fg: AppTheme.primary,
                ),
                const SizedBox(width: 6),
                _Badge(
                  label: _typeLabel(qType),
                  bg: AppTheme.surfaceVariantLight,
                  fg: const Color(0xFF6B7280),
                ),
                if (q['required'] == true) ...[
                  const SizedBox(width: 4),
                  _Badge(
                    label: 'Req',
                    bg: AppTheme.errorContainer,
                    fg: AppTheme.error,
                  ),
                ],
                const Spacer(),
                _Badge(
                  label: isActive ? 'Active' : 'Inactive',
                  bg: isActive
                      ? const Color(0xFFDCFCE7)
                      : AppTheme.statusDraftContainer,
                  fg: isActive ? AppTheme.success : AppTheme.statusDraft,
                ),
                const SizedBox(width: 4),
                // Edit
                _MiniIconButton(
                  icon: Icons.edit_rounded,
                  tooltip: 'Edit question',
                  onTap: () => _showEditQuestionDialog(q),
                ),
                // Toggle active
                _MiniIconButton(
                  icon: isActive
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  tooltip: isActive ? 'Deactivate' : 'Activate',
                  color: isActive ? AppTheme.error : AppTheme.success,
                  onTap: () => _toggleQuestionActive(q),
                ),
              ],
            ),
          ),
          // ── Question text ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Text(
              q['question_text'] as String? ?? '',
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ),
          // ── Help text ────────────────────────────────────────────────────
          if ((q['help_text'] as String?)?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
              child: Text(
                q['help_text'] as String,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ),
          // ── Options ──────────────────────────────────────────────────────
          if (hasOptions) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: options.isEmpty
                  ? Text(
                      'No options yet',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        color: const Color(0xFF9CA3AF),
                      ),
                    )
                  : Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: options.map((o) {
                        final optActive = o['is_active'] as bool? ?? true;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: optActive
                                ? AppTheme.surfaceVariantLight
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                            border: optActive
                                ? null
                                : Border.all(color: const Color(0xFFCBD5E0)),
                          ),
                          child: Text(
                            '${o['option_text'] ?? ''}${optActive ? '' : ' (inactive)'}',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: optActive
                                  ? const Color(0xFF374151)
                                  : const Color(0xFF9CA3AF),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
              child: TextButton.icon(
                onPressed: () => _showManageOptionsDialog(q),
                icon: const Icon(Icons.tune_rounded, size: 14),
                label: Text(
                  'Manage Options',
                  style: GoogleFonts.manrope(fontSize: 12),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  String _typeLabel(String type) {
    const labels = {
      'text': 'Text',
      'number': 'Number',
      'yes_no': 'Yes/No',
      'single_choice': 'Single Choice',
      'multiple_choice': 'Multi Choice',
      'date': 'Date',
      'photo': 'Photo',
      'gps': 'GPS',
    };
    return labels[type] ?? type;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Small reusable widgets
// ─────────────────────────────────────────────────────────────────────────────

class _TopBarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _TopBarButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 15),
      label: Text(label, style: GoogleFonts.manrope(fontSize: 12)),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

class _SidebarSectionHeader extends StatelessWidget {
  final String label;
  final VoidCallback onAdd;
  const _SidebarSectionHeader({required this.label, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF4A5568),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(4),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.add_rounded,
                size: 16,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;
  const _MiniIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(icon, size: 16, color: color ?? const Color(0xFF6B7280)),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const _Badge({required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _NarrowDropdownRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Map<String, dynamic>> items;
  final String? value;
  final String displayKey;
  final String? trailing;
  final ValueChanged<String?> onChanged;
  const _NarrowDropdownRow({
    required this.icon,
    required this.label,
    required this.items,
    required this.value,
    required this.displayKey,
    required this.onChanged,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF6B7280)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4A5568),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              Text(
                trailing!,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        items.isEmpty
            ? Text(
                'None',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: const Color(0xFF9CA3AF),
                ),
              )
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      color: const Color(0xFF1A1A1A),
                    ),
                    items: items.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['id'] as String,
                        child: Text(
                          item[displayKey] as String? ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.manrope(fontSize: 13),
                        ),
                      );
                    }).toList(),
                    onChanged: onChanged,
                  ),
                ),
              ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Template Dialog (Create / Edit)
// ─────────────────────────────────────────────────────────────────────────────

class _TemplateDialog extends StatefulWidget {
  final Map<String, dynamic>? existing;
  final VoidCallback onSaved;
  const _TemplateDialog({this.existing, required this.onSaved});

  @override
  State<_TemplateDialog> createState() => _TemplateDialogState();
}

class _TemplateDialogState extends State<_TemplateDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _versionCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(
      text: widget.existing?['name'] as String? ?? '',
    );
    _descCtrl = TextEditingController(
      text: widget.existing?['description'] as String? ?? '',
    );
    _versionCtrl = TextEditingController(
      text: widget.existing?['version'] as String? ?? '1',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _versionCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final payload = {
        'name': _nameCtrl.text.trim(),
        'description': _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
        'version': _versionCtrl.text.trim().isEmpty
            ? '1'
            : _versionCtrl.text.trim(),
      };
      if (widget.existing != null) {
        await SupabaseService.instance.client
            .from('survey_templates')
            .update(payload)
            .eq('id', widget.existing!['id'] as String);
      } else {
        await SupabaseService.instance.client.from('survey_templates').insert({
          ...payload,
          'is_active': true,
        });
      }
      if (mounted) {
        Navigator.pop(context);
        widget.onSaved();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 440,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Edit Template' : 'Create Template',
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: _inputDec('Template Name *'),
                  style: GoogleFonts.manrope(fontSize: 14),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _versionCtrl,
                  decoration: _inputDec('Version'),
                  style: GoogleFonts.manrope(fontSize: 14),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descCtrl,
                  decoration: _inputDec('Description (optional)'),
                  style: GoogleFonts.manrope(fontSize: 14),
                  maxLines: 2,
                ),
                const SizedBox(height: 20),
                _DialogActions(
                  isLoading: _isLoading,
                  onCancel: () => Navigator.pop(context),
                  onSave: _submit,
                  saveLabel: isEdit ? 'Save' : 'Create',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Dialog (Create / Edit)
// ─────────────────────────────────────────────────────────────────────────────

class _SectionDialog extends StatefulWidget {
  final String templateId;
  final Map<String, dynamic>? existing;
  final int displayOrder;
  final VoidCallback onSaved;
  const _SectionDialog({
    required this.templateId,
    this.existing,
    required this.displayOrder,
    required this.onSaved,
  });

  @override
  State<_SectionDialog> createState() => _SectionDialogState();
}

class _SectionDialogState extends State<_SectionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _codeCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(
      text: widget.existing?['section_title'] as String? ?? '',
    );
    _codeCtrl = TextEditingController(
      text: widget.existing?['section_code'] as String? ?? '',
    );
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final payload = {
        'section_title': _titleCtrl.text.trim(),
        'section_code': _codeCtrl.text.trim().isEmpty
            ? null
            : _codeCtrl.text.trim(),
      };
      if (widget.existing != null) {
        await SupabaseService.instance.client
            .from('survey_sections')
            .update(payload)
            .eq('id', widget.existing!['id'] as String);
      } else {
        await SupabaseService.instance.client.from('survey_sections').insert({
          ...payload,
          'template_id': widget.templateId,
          'display_order': widget.displayOrder,
          'is_active': true,
        });
      }
      if (mounted) {
        Navigator.pop(context);
        widget.onSaved();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 440,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Edit Section' : 'Create Section',
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: _inputDec('Section Title *'),
                  style: GoogleFonts.manrope(fontSize: 14),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _codeCtrl,
                  decoration: _inputDec('Section Code (optional, e.g. A, B1)'),
                  style: GoogleFonts.manrope(fontSize: 14),
                ),
                const SizedBox(height: 20),
                _DialogActions(
                  isLoading: _isLoading,
                  onCancel: () => Navigator.pop(context),
                  onSave: _submit,
                  saveLabel: isEdit ? 'Save' : 'Create',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Question Dialog (Add / Edit)
// ─────────────────────────────────────────────────────────────────────────────

class _QuestionDialog extends StatefulWidget {
  final String sectionId;
  final Map<String, dynamic>? existing;
  final int displayOrder;
  final bool hasExistingAnswers;
  final VoidCallback onSaved;
  const _QuestionDialog({
    required this.sectionId,
    this.existing,
    required this.displayOrder,
    this.hasExistingAnswers = false,
    required this.onSaved,
  });

  @override
  State<_QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<_QuestionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _helpCtrl;
  late String _type;
  late bool _required;
  bool _isLoading = false;

  static const _types = [
    'text',
    'number',
    'yes_no',
    'single_choice',
    'multiple_choice',
    'date',
    'photo',
    'gps',
  ];

  static const _typeLabels = {
    'text': 'Text',
    'number': 'Number',
    'yes_no': 'Yes / No',
    'single_choice': 'Single Choice',
    'multiple_choice': 'Multiple Choice',
    'date': 'Date',
    'photo': 'Photo',
    'gps': 'GPS',
  };

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(
      text: widget.existing?['question_text'] as String? ?? '',
    );
    _codeCtrl = TextEditingController(
      text: widget.existing?['question_code'] as String? ?? '',
    );
    _helpCtrl = TextEditingController(
      text: widget.existing?['help_text'] as String? ?? '',
    );
    _type = widget.existing?['question_type'] as String? ?? 'text';
    _required = widget.existing?['required'] as bool? ?? false;
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _codeCtrl.dispose();
    _helpCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final payload = {
        'question_text': _textCtrl.text.trim(),
        'question_code': _codeCtrl.text.trim().isEmpty
            ? null
            : _codeCtrl.text.trim(),
        'help_text': _helpCtrl.text.trim().isEmpty
            ? null
            : _helpCtrl.text.trim(),
        'question_type': _type,
        'required': _required,
      };
      if (widget.existing != null) {
        await SupabaseService.instance.client
            .from('survey_questions')
            .update(payload)
            .eq('id', widget.existing!['id'] as String);
      } else {
        await SupabaseService.instance.client.from('survey_questions').insert({
          ...payload,
          'section_id': widget.sectionId,
          'display_order': widget.displayOrder,
          'is_active': true,
        });
      }
      if (mounted) {
        Navigator.pop(context);
        widget.onSaved();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    final typeChangeLocked = isEdit && widget.hasExistingAnswers;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEdit ? 'Edit Question' : 'Add Question',
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (typeChangeLocked) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFED7AA)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lock_outline_rounded,
                          size: 14,
                          color: Color(0xFFD97706),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'This question has existing survey answers. Question type cannot be changed. Deactivate and create a new question instead.',
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: const Color(0xFF92400E),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                TextFormField(
                  controller: _textCtrl,
                  decoration: _inputDec('Question Text *'),
                  style: GoogleFonts.manrope(fontSize: 14),
                  maxLines: 3,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _codeCtrl,
                  decoration: _inputDec(
                    'Question Code (optional, e.g. Q-CROP-01)',
                  ),
                  style: GoogleFonts.manrope(fontSize: 14),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _helpCtrl,
                  decoration: _inputDec('Help Text (optional)'),
                  style: GoogleFonts.manrope(fontSize: 14),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                // Question type — locked if has existing answers
                typeChangeLocked
                    ? InputDecorator(
                        decoration: _inputDec('Question Type (locked)'),
                        child: Text(
                          _typeLabels[_type] ?? _type,
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: const Color(0xFF6B7280),
                          ),
                        ),
                      )
                    : DropdownButtonFormField<String>(
                        initialValue: _type,
                        decoration: _inputDec('Question Type'),
                        items: _types
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text(
                                  _typeLabels[t] ?? t,
                                  style: GoogleFonts.manrope(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _type = v ?? 'text'),
                      ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  value: _required,
                  onChanged: (v) => setState(() => _required = v ?? false),
                  title: Text(
                    'Required',
                    style: GoogleFonts.manrope(fontSize: 14),
                  ),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 16),
                _DialogActions(
                  isLoading: _isLoading,
                  onCancel: () => Navigator.pop(context),
                  onSave: _submit,
                  saveLabel: isEdit ? 'Save' : 'Add',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Options Manager Dialog
// ─────────────────────────────────────────────────────────────────────────────

class _OptionsManagerDialog extends StatefulWidget {
  final Map<String, dynamic> question;
  final VoidCallback onChanged;
  const _OptionsManagerDialog({
    required this.question,
    required this.onChanged,
  });

  @override
  State<_OptionsManagerDialog> createState() => _OptionsManagerDialogState();
}

class _OptionsManagerDialogState extends State<_OptionsManagerDialog> {
  List<Map<String, dynamic>> _options = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    setState(() => _isLoading = true);
    try {
      final data = await SupabaseService.instance.client
          .from('survey_question_options')
          .select()
          .eq('question_id', widget.question['id'] as String)
          .order('display_order');
      if (!mounted) return;
      setState(() {
        _options = List<Map<String, dynamic>>.from(data as List);
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addOption() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => _OptionEditDialog(),
    );
    if (result == null) return;
    try {
      await SupabaseService.instance.client
          .from('survey_question_options')
          .insert({
            'question_id': widget.question['id'] as String,
            'option_text': result['text']!,
            'option_value': result['value']!,
            'display_order': _options.length + 1,
            'is_active': true,
          });
      _loadOptions();
      widget.onChanged();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  Future<void> _editOption(Map<String, dynamic> opt) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => _OptionEditDialog(existing: opt),
    );
    if (result == null) return;
    try {
      await SupabaseService.instance.client
          .from('survey_question_options')
          .update({
            'option_text': result['text']!,
            'option_value': result['value']!,
          })
          .eq('id', opt['id'] as String);
      _loadOptions();
      widget.onChanged();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed: $e')));
      }
    }
  }

  Future<void> _removeOrDeactivateOption(Map<String, dynamic> opt) async {
    // Check if this option value has been used in any survey_answers
    bool hasAnswers = false;
    try {
      final optValue = opt['option_value'] as String? ?? '';
      final qId = widget.question['id'] as String;
      final result = await SupabaseService.instance.client
          .from('survey_answers')
          .select('id')
          .eq('question_id', qId)
          .contains('answer_options', [optValue])
          .limit(1);
      hasAnswers = (result as List).isNotEmpty;
    } catch (_) {}

    if (hasAnswers) {
      // Must deactivate instead of delete
      final confirmed = await AdminConfirmDialog.show(
        context,
        title: 'Deactivate Option',
        message:
            'This option has been used in existing survey answers and cannot be deleted. It will be deactivated instead so historical answers remain intact.',
      );
      if (confirmed != true) return;
      try {
        await SupabaseService.instance.client
            .from('survey_question_options')
            .update({'is_active': false})
            .eq('id', opt['id'] as String);
        _loadOptions();
        widget.onChanged();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed: $e')));
        }
      }
    } else {
      final confirmed = await AdminConfirmDialog.show(
        context,
        title: 'Remove Option',
        message:
            'Remove "${opt['option_text']}"? This option has no existing answers and will be permanently deleted.',
      );
      if (confirmed != true) return;
      try {
        await SupabaseService.instance.client
            .from('survey_question_options')
            .delete()
            .eq('id', opt['id'] as String);
        _loadOptions();
        widget.onChanged();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed: $e')));
        }
      }
    }
  }

  Future<void> _reorderOptions(int oldIndex, int newIndex) async {
    final opts = List<Map<String, dynamic>>.from(_options);
    final item = opts.removeAt(oldIndex);
    opts.insert(newIndex, item);
    setState(() => _options = opts);
    try {
      for (int i = 0; i < opts.length; i++) {
        await SupabaseService.instance.client
            .from('survey_question_options')
            .update({'display_order': i + 1})
            .eq('id', opts[i]['id'] as String);
      }
      widget.onChanged();
    } catch (_) {
      _loadOptions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 480,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Manage Options',
                          style: GoogleFonts.manrope(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          widget.question['question_text'] as String? ?? '',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: const Color(0xFF6B7280),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _addOption,
                    icon: const Icon(Icons.add_rounded, size: 15),
                    label: Text(
                      'Add',
                      style: GoogleFonts.manrope(fontSize: 13),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_options.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No options yet. Add the first one.',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 360),
                  child: ReorderableListView.builder(
                    shrinkWrap: true,
                    itemCount: _options.length,
                    onReorder: _reorderOptions,
                    itemBuilder: (_, i) {
                      final opt = _options[i];
                      final isActive = opt['is_active'] as bool? ?? true;
                      return ListTile(
                        key: ValueKey(opt['id']),
                        dense: true,
                        leading: const Icon(
                          Icons.drag_handle_rounded,
                          size: 18,
                          color: Color(0xFFCBD5E0),
                        ),
                        title: Text(
                          opt['option_text'] as String? ?? '',
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: isActive
                                ? const Color(0xFF1A1A1A)
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                        subtitle: Text(
                          'Value: ${opt['option_value'] ?? ''}${isActive ? '' : ' • Inactive'}',
                          style: GoogleFonts.manrope(
                            fontSize: 11,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _MiniIconButton(
                              icon: Icons.edit_rounded,
                              tooltip: 'Edit option',
                              onTap: () => _editOption(opt),
                            ),
                            _MiniIconButton(
                              icon: isActive
                                  ? Icons.remove_circle_outline_rounded
                                  : Icons.delete_outline_rounded,
                              tooltip: isActive
                                  ? 'Remove / Deactivate'
                                  : 'Delete',
                              color: AppTheme.error,
                              onTap: () => _removeOrDeactivateOption(opt),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close', style: GoogleFonts.manrope()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Option Edit Dialog
// ─────────────────────────────────────────────────────────────────────────────

class _OptionEditDialog extends StatefulWidget {
  final Map<String, dynamic>? existing;
  const _OptionEditDialog({this.existing});

  @override
  State<_OptionEditDialog> createState() => _OptionEditDialogState();
}

class _OptionEditDialogState extends State<_OptionEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _textCtrl;
  late final TextEditingController _valueCtrl;

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(
      text: widget.existing?['option_text'] as String? ?? '',
    );
    _valueCtrl = TextEditingController(
      text: widget.existing?['option_value'] as String? ?? '',
    );
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _valueCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // Auto-fill value from text if empty
    final value = _valueCtrl.text.trim().isEmpty
        ? _textCtrl.text.trim().toLowerCase().replaceAll(' ', '_')
        : _valueCtrl.text.trim();
    Navigator.pop(context, {'text': _textCtrl.text.trim(), 'value': value});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 380,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.existing != null ? 'Edit Option' : 'Add Option',
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _textCtrl,
                  decoration: _inputDec('Option Text *'),
                  style: GoogleFonts.manrope(fontSize: 14),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _valueCtrl,
                  decoration: _inputDec(
                    'Option Value (leave blank to auto-generate)',
                  ),
                  style: GoogleFonts.manrope(fontSize: 14),
                ),
                const SizedBox(height: 20),
                _DialogActions(
                  isLoading: false,
                  onCancel: () => Navigator.pop(context),
                  onSave: _submit,
                  saveLabel: widget.existing != null ? 'Save' : 'Add',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────────────────

InputDecoration _inputDec(String label) {
  return InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );
}

class _DialogActions extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final String saveLabel;
  const _DialogActions({
    required this.isLoading,
    required this.onCancel,
    required this.onSave,
    required this.saveLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: onCancel,
          child: Text('Cancel', style: GoogleFonts.manrope()),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: isLoading ? null : onSave,
          child: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(saveLabel, style: GoogleFonts.manrope()),
        ),
      ],
    );
  }
}

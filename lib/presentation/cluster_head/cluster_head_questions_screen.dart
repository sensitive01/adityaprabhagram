import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import './cluster_head_shell.dart';

class ClusterHeadQuestionsScreen extends StatefulWidget {
  const ClusterHeadQuestionsScreen({super.key});

  @override
  State<ClusterHeadQuestionsScreen> createState() =>
      _ClusterHeadQuestionsScreenState();
}

class _ClusterHeadQuestionsScreenState
    extends State<ClusterHeadQuestionsScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _questions = [];
  Map<String, dynamic>? _selectedQuestion;
  bool _showUnanswered = true;
  final _answerCtrl = TextEditingController();
  bool _isAnswering = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _answerCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final uid = SupabaseService.instance.currentUser?.id;
      if (uid == null) throw Exception('Not authenticated');

      final chRecord = await SupabaseService.instance.client
          .from('cluster_heads')
          .select('cluster_id')
          .eq('user_id', uid)
          .eq('is_active', true)
          .maybeSingle();

      if (chRecord == null) throw Exception('No cluster assignment');

      final clusterId = chRecord['cluster_id'] as String;
      final agentAssignments = await SupabaseService.instance.client
          .from('field_agent_cluster_assignments')
          .select('agent_id')
          .eq('cluster_id', clusterId)
          .eq('is_active', true);

      final agentIds = (agentAssignments as List)
          .map((a) => a['agent_id'] as String)
          .toList();

      if (agentIds.isEmpty) {
        if (mounted) {
          setState(() {
            _questions = [];
            _isLoading = false;
          });
        }
        return;
      }

      final hhData = await SupabaseService.instance.client
          .from('households')
          .select('id')
          .inFilter('assigned_agent_id', agentIds);
      final householdIds = (hhData as List)
          .map((h) => h['id'] as String)
          .toList();

      if (householdIds.isEmpty) {
        if (mounted) {
          setState(() {
            _questions = [];
            _isLoading = false;
          });
        }
        return;
      }

      final data = await SupabaseService.instance.client
          .from('household_questions')
          .select(
            '*, households(hh_id, name, village), question_answers(*, user_profiles!answered_by(full_name))',
          )
          .inFilter('household_id', householdIds)
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _questions = List<Map<String, dynamic>>.from(data as List);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load questions: $e';
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> get _filtered => _questions
      .where((q) => (q['is_answered'] as bool? ?? false) != _showUnanswered)
      .toList();

  Future<void> _submitAnswer() async {
    if (_selectedQuestion == null || _answerCtrl.text.trim().isEmpty) return;
    setState(() => _isAnswering = true);
    try {
      final uid = SupabaseService.instance.currentUser?.id;
      await SupabaseService.instance.client.from('question_answers').insert({
        'question_id': _selectedQuestion!['id'] as String,
        'answered_by': uid,
        'answer_text': _answerCtrl.text.trim(),
      });
      await SupabaseService.instance.client
          .from('household_questions')
          .update({'is_answered': true})
          .eq('id', _selectedQuestion!['id'] as String);
      _answerCtrl.clear();
      await _loadData();
      if (mounted) {
        setState(() {
          _selectedQuestion = null;
          _isAnswering = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isAnswering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClusterHeadShell(
      selectedIndex: 4,
      child: Row(
        children: [
          Expanded(child: _buildMainContent()),
          if (_selectedQuestion != null) _buildDetailPanel(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
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
              : _buildList(),
        ),
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
                'Household Questions',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Questions from households in your cluster',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  color: const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const Spacer(),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: true,
                label: Text('Unanswered'),
                icon: Icon(Icons.help_outline_rounded, size: 16),
              ),
              ButtonSegment(
                value: false,
                label: Text('Answered'),
                icon: Icon(Icons.check_circle_outline_rounded, size: 16),
              ),
            ],
            selected: {_showUnanswered},
            onSelectionChanged: (s) => setState(() {
              _showUnanswered = s.first;
              _selectedQuestion = null;
            }),
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(
                GoogleFonts.manrope(fontSize: 13),
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

  Widget _buildList() {
    final items = _filtered;
    if (items.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.help_outline_rounded,
        title: _showUnanswered
            ? 'No unanswered questions'
            : 'No answered questions',
        subtitle: _showUnanswered
            ? 'All questions have been answered'
            : 'No questions have been answered yet',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final q = items[i];
        final isSelected = _selectedQuestion?['id'] == q['id'];
        final hh = q['households'] as Map<String, dynamic>?;
        final isAnswered = q['is_answered'] as bool? ?? false;
        return InkWell(
          onTap: () => setState(() => _selectedQuestion = q),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.infoContainer.withAlpha(77)
                  : AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppTheme.info.withAlpha(102)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.infoContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        hh?['hh_id'] as String? ?? '—',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.info,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        hh?['name'] as String? ?? '—',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isAnswered
                            ? AppTheme.successContainer
                            : AppTheme.warningContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isAnswered ? 'Answered' : 'Open',
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isAnswered
                              ? AppTheme.success
                              : AppTheme.warning,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  q['question_text'] as String? ?? '',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    color: const Color(0xFF374151),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailPanel() {
    final q = _selectedQuestion!;
    final hh = q['households'] as Map<String, dynamic>?;
    final answers = q['question_answers'] as List? ?? [];
    final isAnswered = q['is_answered'] as bool? ?? false;
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
                    'Question Details',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _selectedQuestion = null),
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
                  Text(
                    'From: ${hh?['name'] ?? '—'} (${hh?['hh_id'] ?? '—'})',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Village: ${hh?['village'] ?? '—'}',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceVariantLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      q['question_text'] as String? ?? '',
                      style: GoogleFonts.manrope(fontSize: 14),
                    ),
                  ),
                  if (answers.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Answers (${answers.length})',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...answers.map((a) {
                      final answeredBy =
                          a['user_profiles'] as Map<String, dynamic>?;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.successContainer.withAlpha(128),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a['answer_text'] as String? ?? '',
                              style: GoogleFonts.manrope(fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '— ${answeredBy?['full_name'] ?? 'Cluster Head'}',
                              style: GoogleFonts.manrope(
                                fontSize: 11,
                                color: AppTheme.success,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                  if (!isAnswered) ...[
                    const Divider(height: 24),
                    Text(
                      'Your Answer',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _answerCtrl,
                      decoration: InputDecoration(
                        hintText: 'Type your answer...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: GoogleFonts.manrope(fontSize: 14),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isAnswering ? null : _submitAnswer,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.info,
                        ),
                        child: _isAnswering
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Submit Answer',
                                style: GoogleFonts.manrope(),
                              ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/supabase_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state_widget.dart';
import './admin_shell.dart';
import './widgets/admin_confirm_dialog.dart';

class AdminBulletinsScreen extends StatefulWidget {
  const AdminBulletinsScreen({super.key});

  @override
  State<AdminBulletinsScreen> createState() => _AdminBulletinsScreenState();
}

class _AdminBulletinsScreenState extends State<AdminBulletinsScreen> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _bulletins = [];
  bool _showPublished = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await SupabaseService.instance.client
          .from('bulletins')
          .select('*, user_profiles!published_by(full_name)')
          .order('created_at', ascending: false);
      if (mounted) {
        setState(() {
          _bulletins = List<Map<String, dynamic>>.from(data as List);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load bulletins: $e';
          _isLoading = false;
        });
      }
    }
  }

  List<Map<String, dynamic>> get _filtered => _bulletins
      .where((b) => (b['is_active'] as bool? ?? false) == _showPublished)
      .toList();

  Future<void> _togglePublish(Map<String, dynamic> b) async {
    final isActive = b['is_active'] as bool? ?? false;
    final confirmed = await AdminConfirmDialog.show(
      context,
      title: isActive ? 'Unpublish Bulletin' : 'Publish Bulletin',
      message:
          'Are you sure you want to ${isActive ? 'unpublish' : 'publish'} "${b['title']}"?',
    );
    if (confirmed != true) return;
    try {
      await SupabaseService.instance.client
          .from('bulletins')
          .update({
            'is_active': !isActive,
            if (!isActive) 'published_at': DateTime.now().toIso8601String(),
          })
          .eq('id', b['id'] as String);
      _loadData();
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
    return AdminShell(
      selectedIndex: 7,
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
                'Bulletins / Information',
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Manage agricultural advisories and announcements',
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
                label: Text('Published'),
                icon: Icon(Icons.public_rounded, size: 16),
              ),
              ButtonSegment(
                value: false,
                label: Text('Drafts'),
                icon: Icon(Icons.drafts_rounded, size: 16),
              ),
            ],
            selected: {_showPublished},
            onSelectionChanged: (s) => setState(() => _showPublished = s.first),
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(
                GoogleFonts.manrope(fontSize: 13),
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: _showCreateDialog,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(
              'New Bulletin',
              style: GoogleFonts.manrope(fontSize: 13),
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

  Widget _buildContent() {
    final items = _filtered;
    if (items.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.article_outlined,
        title: _showPublished ? 'No published bulletins' : 'No draft bulletins',
        subtitle: _showPublished
            ? 'Published bulletins will appear here'
            : 'Draft bulletins will appear here',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      itemBuilder: (context, i) => _buildBulletinCard(items[i]),
    );
  }

  Widget _buildBulletinCard(Map<String, dynamic> b) {
    final isActive = b['is_active'] as bool? ?? false;
    final author = b['user_profiles'] as Map<String, dynamic>?;
    final publishedAt = b['published_at'] as String?;
    final dt = publishedAt != null ? DateTime.tryParse(publishedAt) : null;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  b['title'] as String? ?? 'Untitled',
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppTheme.successContainer
                      : AppTheme.statusDraftContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isActive ? 'Published' : 'Draft',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? AppTheme.success : AppTheme.statusDraft,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _togglePublish(b),
                icon: Icon(
                  isActive ? Icons.unpublished_rounded : Icons.publish_rounded,
                  size: 18,
                  color: isActive ? AppTheme.error : AppTheme.success,
                ),
                tooltip: isActive ? 'Unpublish' : 'Publish',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              IconButton(
                onPressed: () => _showEditDialog(b),
                icon: const Icon(Icons.edit_rounded, size: 18),
                tooltip: 'Edit',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            b['body'] as String? ?? '',
            style: GoogleFonts.manrope(
              fontSize: 13,
              color: const Color(0xFF4A5568),
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.person_rounded,
                size: 14,
                color: const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Text(
                author?['full_name'] as String? ?? 'Admin',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              if (dt != null) ...[
                const SizedBox(width: 12),
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: const Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 4),
                Text(
                  '${dt.day}/${dt.month}/${dt.year}',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (_) => _BulletinDialog(onSaved: _loadData),
    );
  }

  void _showEditDialog(Map<String, dynamic> b) {
    showDialog(
      context: context,
      builder: (_) => _BulletinDialog(existing: b, onSaved: _loadData),
    );
  }
}

class _BulletinDialog extends StatefulWidget {
  final Map<String, dynamic>? existing;
  final VoidCallback onSaved;
  const _BulletinDialog({this.existing, required this.onSaved});

  @override
  State<_BulletinDialog> createState() => _BulletinDialogState();
}

class _BulletinDialogState extends State<_BulletinDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _titleCtrl.text = widget.existing!['title'] as String? ?? '';
      _bodyCtrl.text = widget.existing!['body'] as String? ?? '';
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final uid = SupabaseService.instance.currentUser?.id;
      final data = {
        'title': _titleCtrl.text.trim(),
        'body': _bodyCtrl.text.trim(),
        'published_by': uid,
      };
      if (widget.existing != null) {
        await SupabaseService.instance.client
            .from('bulletins')
            .update(data)
            .eq('id', widget.existing!['id'] as String);
      } else {
        await SupabaseService.instance.client.from('bulletins').insert({
          ...data,
          'is_active': false,
        });
      }
      if (mounted) {
        Navigator.pop(context);
        widget.onSaved();
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 520,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.existing != null ? 'Edit Bulletin' : 'New Bulletin',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleCtrl,
                  decoration: InputDecoration(
                    labelText: 'Title *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: GoogleFonts.manrope(fontSize: 14),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bodyCtrl,
                  decoration: InputDecoration(
                    labelText: 'Content *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  style: GoogleFonts.manrope(fontSize: 14),
                  maxLines: 6,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
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
                          : Text('Save', style: GoogleFonts.manrope()),
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
}

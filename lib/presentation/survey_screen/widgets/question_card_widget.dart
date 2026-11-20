import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../survey_screen.dart';

class QuestionCardWidget extends StatefulWidget {
  final SurveyQuestion question;
  final dynamic answer;
  final ValueChanged<dynamic> onAnswer;

  const QuestionCardWidget({
    super.key,
    required this.question,
    required this.answer,
    required this.onAnswer,
  });

  @override
  State<QuestionCardWidget> createState() => _QuestionCardWidgetState();
}

class _QuestionCardWidgetState extends State<QuestionCardWidget> {
  late TextEditingController _textController;
  late TextEditingController _specifyController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.answer is String ? widget.answer as String : '',
    );
    _specifyController = TextEditingController();
  }

  @override
  void didUpdateWidget(QuestionCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _textController.text = widget.answer is String
          ? widget.answer as String
          : '';
      _specifyController.clear();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _specifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = widget.question;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _TypeChip(type: q.type),
              const Spacer(),
              if (q.isRequired)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.errorContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Required',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.error,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Optional',
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            q.questionText,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
          if (q.hint != null) ...[
            const SizedBox(height: 6),
            Text(
              q.hint!,
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 20),
          _buildAnswerInput(context, q),
        ],
      ),
    );
  }

  Widget _buildAnswerInput(BuildContext context, SurveyQuestion q) {
    switch (q.type) {
      case QuestionType.text:
        return _TextInput(
          controller: _textController,
          onChanged: widget.onAnswer,
          hint: 'Type your answer here',
          maxLines: 3,
        );
      case QuestionType.number:
        return _TextInput(
          controller: _textController,
          onChanged: widget.onAnswer,
          hint: 'Enter a number',
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
          ],
        );
      case QuestionType.yesNo:
        return _YesNoInput(
          value: widget.answer as String?,
          onChanged: widget.onAnswer,
        );
      case QuestionType.singleChoice:
        return _SingleChoiceInput(
          options: q.options ?? [],
          selected: widget.answer as String?,
          onChanged: widget.onAnswer,
        );
      case QuestionType.multipleChoice:
        // Detect "top 3" constraint from hint (e.g. Q-G-03: "Tick top 3")
        int? maxSel;
        final hint = q.hint?.toLowerCase() ?? '';
        if (hint.contains('top 3') ||
            hint.contains('select up to 3') ||
            hint.contains('select top 3')) {
          maxSel = 3;
        }
        // Generic: any multipleChoice question whose options include an entry
        // that starts with "other" (case-insensitive) gets the specify textbox.
        final bool needsSpecify = (q.options ?? []).any(
          (opt) => opt.trim().toLowerCase().startsWith('other'),
        );

        // For needsSpecify questions, answer is stored as Map {'selections': [...], 'specifyText': '...'}
        // For all other multipleChoice questions, answer is stored as List<String>
        List<String> selectedList;
        String savedSpecifyText = '';
        if (needsSpecify) {
          if (widget.answer is Map) {
            final ansMap = widget.answer as Map;
            selectedList =
                (ansMap['selections'] as List?)?.cast<String>() ?? [];
            savedSpecifyText = (ansMap['specifyText'] as String?) ?? '';
          } else if (widget.answer is List) {
            // Migrate legacy list-only answer
            selectedList = (widget.answer as List).cast<String>();
          } else {
            selectedList = [];
          }
          // Sync specifyController text if it differs from saved (e.g. on resume)
          if (_specifyController.text != savedSpecifyText) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _specifyController.text != savedSpecifyText) {
                _specifyController.text = savedSpecifyText;
              }
            });
          }
        } else {
          selectedList = (widget.answer as List?)?.cast<String>() ?? [];
        }

        final otherSelected =
            needsSpecify &&
            selectedList.any(
              (s) =>
                  s.toLowerCase().contains('other') ||
                  s.toLowerCase() == 'others',
            );

        if (needsSpecify) {
          // If "Others" was just unchecked, clear the specify controller and save empty specifyText
          if (!otherSelected && _specifyController.text.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _specifyController.clear();
                widget.onAnswer({
                  'selections': selectedList,
                  'specifyText': '',
                });
              }
            });
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MultipleChoiceInput(
                options: q.options ?? [],
                selected: selectedList,
                onChanged: (newSelections) {
                  // When selections change, preserve current specifyText unless Others was unchecked
                  final newList = (newSelections).cast<String>();
                  final stillHasOther = newList.any(
                    (s) =>
                        s.toLowerCase().contains('other') ||
                        s.toLowerCase() == 'others',
                  );
                  final specifyText = stillHasOther
                      ? _specifyController.text
                      : '';
                  if (!stillHasOther) _specifyController.clear();
                  widget.onAnswer({
                    'selections': newList,
                    'specifyText': specifyText,
                  });
                },
                maxSelections: maxSel,
              ),
              if (otherSelected) ...[
                const SizedBox(height: 12),
                Text(
                  'Please specify',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                _TextInput(
                  controller: _specifyController,
                  onChanged: (text) {
                    widget.onAnswer({
                      'selections': selectedList,
                      'specifyText': text,
                    });
                  },
                  hint: 'Please specify...',
                  maxLines: 2,
                ),
              ],
            ],
          );
        }

        return _MultipleChoiceInput(
          options: q.options ?? [],
          selected: selectedList,
          onChanged: widget.onAnswer,
          maxSelections: maxSel,
        );
      case QuestionType.date:
        return _DateInput(
          value: widget.answer as String?,
          onChanged: widget.onAnswer,
        );
      case QuestionType.photo:
        return _PhotoInput(
          value: widget.answer as String?,
          onChanged: widget.onAnswer,
        );
      case QuestionType.gps:
        return _GpsInput(
          value: widget.answer as Map<String, double>?,
          onChanged: widget.onAnswer,
        );
    }
  }
}

// --- TYPE CHIP ---

class _TypeChip extends StatelessWidget {
  final QuestionType type;
  const _TypeChip({required this.type});

  String get _label {
    switch (type) {
      case QuestionType.text:
        return 'Text';
      case QuestionType.number:
        return 'Number';
      case QuestionType.yesNo:
        return 'Yes / No';
      case QuestionType.singleChoice:
        return 'Single Choice';
      case QuestionType.multipleChoice:
        return 'Multiple Choice';
      case QuestionType.date:
        return 'Date';
      case QuestionType.photo:
        return 'Photo';
      case QuestionType.gps:
        return 'GPS Location';
    }
  }

  IconData get _icon {
    switch (type) {
      case QuestionType.text:
        return Icons.text_fields_rounded;
      case QuestionType.number:
        return Icons.pin_rounded;
      case QuestionType.yesNo:
        return Icons.toggle_on_rounded;
      case QuestionType.singleChoice:
        return Icons.radio_button_checked_rounded;
      case QuestionType.multipleChoice:
        return Icons.check_box_rounded;
      case QuestionType.date:
        return Icons.calendar_today_rounded;
      case QuestionType.photo:
        return Icons.photo_camera_rounded;
      case QuestionType.gps:
        return Icons.gps_fixed_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: AppTheme.primary),
          const SizedBox(width: 4),
          Text(
            _label,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// --- TEXT INPUT ---

class _TextInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const _TextInput({
    required this.controller,
    required this.onChanged,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: GoogleFonts.manrope(
        fontSize: 14,
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withAlpha(102),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    );
  }
}

// --- YES/NO INPUT ---

class _YesNoInput extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;

  const _YesNoInput({this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ChoiceButton(
            label: 'Yes',
            icon: Icons.check_circle_rounded,
            isSelected: value == 'Yes',
            selectedColor: AppTheme.success,
            selectedBg: AppTheme.successContainer,
            onTap: () => onChanged('Yes'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ChoiceButton(
            label: 'No',
            icon: Icons.cancel_rounded,
            isSelected: value == 'No',
            selectedColor: AppTheme.error,
            selectedBg: AppTheme.errorContainer,
            onTap: () => onChanged('No'),
          ),
        ),
      ],
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color selectedColor;
  final Color selectedBg;
  final VoidCallback onTap;

  const _ChoiceButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.selectedColor,
    required this.selectedBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedBg
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? selectedColor.withAlpha(102)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? selectedColor
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? selectedColor
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- SINGLE CHOICE INPUT ---

class _SingleChoiceInput extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onChanged;

  const _SingleChoiceInput({
    required this.options,
    this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: options.map((option) {
        final isSelected = option == selected;
        return InkWell(
          onTap: () => onChanged(option),
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primary.withAlpha(102)
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primary
                          : theme.colorScheme.outline,
                      width: isSelected ? 5 : 2,
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppTheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// --- MULTIPLE CHOICE INPUT ---

class _MultipleChoiceInput extends StatelessWidget {
  final List<String> options;
  final List<String> selected;
  final ValueChanged<List<String>> onChanged;

  /// When non-null, prevents selecting more than this many options.
  final int? maxSelections;

  const _MultipleChoiceInput({
    required this.options,
    required this.selected,
    required this.onChanged,
    this.maxSelections,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (maxSelections != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Select up to $maxSelections',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.primary,
              ),
            ),
          ),
        ...options.map((option) {
          final isSelected = selected.contains(option);
          final atMax =
              maxSelections != null &&
              selected.length >= maxSelections! &&
              !isSelected;
          return InkWell(
            onTap: atMax
                ? () {
                    // Show a brief visual cue — do not add the item
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'You can select at most $maxSelections options',
                          style: GoogleFonts.manrope(fontSize: 13),
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: AppTheme.warning,
                      ),
                    );
                  }
                : () {
                    final updated = List<String>.from(selected);
                    if (isSelected) {
                      updated.remove(option);
                    } else {
                      updated.add(option);
                    }
                    onChanged(updated);
                  },
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryContainer
                    : atMax
                    ? theme.colorScheme.surfaceContainerHighest.withAlpha(128)
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primary.withAlpha(102)
                      : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isSelected ? AppTheme.primary : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primary
                            : atMax
                            ? theme.colorScheme.outline.withAlpha(128)
                            : theme.colorScheme.outline,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 12,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? AppTheme.primary
                            : atMax
                            ? theme.colorScheme.onSurface.withAlpha(128)
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// --- DATE INPUT ---

class _DateInput extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;

  const _DateInput({this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(
                  context,
                ).colorScheme.copyWith(primary: AppTheme.primary),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          final formatted =
              '${picked.day.toString().padLeft(2, '0')} ${_monthName(picked.month)} ${picked.year}';
          onChanged(formatted);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value != null
                ? AppTheme.primary.withAlpha(102)
                : theme.colorScheme.outline.withAlpha(102),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: value != null
                  ? AppTheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 10),
            Text(
              value ?? 'Select a date',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: value != null ? FontWeight.w500 : FontWeight.w400,
                color: value != null
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
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
    return months[month];
  }
}

// --- PHOTO INPUT ---

class _PhotoInput extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;

  const _PhotoInput({this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        onChanged('photo_captured_${DateTime.now().millisecondsSinceEpoch}');
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 120,
        decoration: BoxDecoration(
          color: value != null
              ? AppTheme.primaryContainer.withAlpha(128)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value != null
                ? AppTheme.primary.withAlpha(102)
                : theme.colorScheme.outline.withAlpha(77),
            width: 1.5,
          ),
        ),
        child: value != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 32,
                    color: AppTheme.success,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Photo captured',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.success,
                    ),
                  ),
                  Text(
                    'Tap to retake',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 32,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to capture photo',
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// --- GPS INPUT ---

class _GpsInput extends StatefulWidget {
  final Map<String, double>? value;
  final ValueChanged<Map<String, double>> onChanged;

  const _GpsInput({this.value, required this.onChanged});

  @override
  State<_GpsInput> createState() => _GpsInputState();
}

class _GpsInputState extends State<_GpsInput> {
  bool _isCapturing = false;

  Future<void> _captureGps() async {
    setState(() => _isCapturing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isCapturing = false);
    widget.onChanged({'lat': 20.0059, 'lng': 73.7898, 'accuracy': 4.2});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = widget.value != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasValue
            ? AppTheme.primaryContainer.withAlpha(102)
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasValue
              ? AppTheme.primary.withAlpha(77)
              : theme.colorScheme.outline.withAlpha(77),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasValue) ...[
            Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: AppTheme.success,
                ),
                const SizedBox(width: 8),
                Text(
                  'Location Captured',
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.success,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '±${widget.value!['accuracy']!.toStringAsFixed(1)}m',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.success,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Lat: ${widget.value!['lat']!.toStringAsFixed(6)}',
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'Lng: ${widget.value!['lng']!.toStringAsFixed(6)}',
              style: GoogleFonts.manrope(
                fontSize: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
          ],
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton.icon(
              onPressed: _isCapturing ? null : _captureGps,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primary,
                side: const BorderSide(color: AppTheme.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: _isCapturing
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primary,
                      ),
                    )
                  : const Icon(Icons.my_location_rounded, size: 16),
              label: Text(
                _isCapturing
                    ? 'Capturing...'
                    : hasValue
                    ? 'Recapture GPS'
                    : 'Capture GPS Location',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

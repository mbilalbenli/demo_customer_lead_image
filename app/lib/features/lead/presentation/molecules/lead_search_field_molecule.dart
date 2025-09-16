import 'package:flutter/material.dart';
import '../../../../core/widgets/atoms/app_text_field_atom.dart';
import '../../../../core/widgets/atoms/app_icon_button_atom.dart';

/// A feature-specific molecule for lead search functionality
/// Following atomic design principles - composed from atoms
class LeadSearchFieldMolecule extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onFilter;
  final String? hintText;
  final bool showFilterButton;
  final bool autofocus;

  const LeadSearchFieldMolecule({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onFilter,
    this.hintText,
    this.showFilterButton = true,
    this.autofocus = false,
  });

  @override
  State<LeadSearchFieldMolecule> createState() => _LeadSearchFieldMoleculeState();
}

class _LeadSearchFieldMoleculeState extends State<LeadSearchFieldMolecule> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
    widget.onChanged?.call(_controller.text);
  }

  void _handleClear() {
    _controller.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = Theme.of(context).platform == TargetPlatform.iOS
        ? 'Search Leads'
        : 'Search leads...';

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppSearchFieldAtom(
              controller: _controller,
              hintText: widget.hintText ?? l10n,
              onSubmitted: widget.onSubmitted,
              autofocus: widget.autofocus,
              onClear: _hasText ? _handleClear : null,
            ),
          ),
          if (widget.showFilterButton)
            Container(
              height: 40,
              width: 1,
              color: colorScheme.outline.withValues(alpha: 0.2),
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
          if (widget.showFilterButton)
            AppIconButtonAtom(
              icon: Icons.tune,
              onPressed: widget.onFilter,
              tooltip: 'Filter leads',
              color: colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }
}

/// A quick search bar for leads
class LeadQuickSearchMolecule extends StatelessWidget {
  final List<String> suggestions;
  final ValueChanged<String>? onSuggestionSelected;
  final VoidCallback? onViewAll;

  const LeadQuickSearchMolecule({
    super.key,
    required this.suggestions,
    this.onSuggestionSelected,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Search',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    'View All',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((suggestion) {
              return ActionChip(
                label: Text(
                  suggestion,
                  style: TextStyle(fontSize: 12),
                ),
                onPressed: () => onSuggestionSelected?.call(suggestion),
                backgroundColor: colorScheme.primaryContainer,
                side: BorderSide.none,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
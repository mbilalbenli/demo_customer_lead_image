import 'package:flutter/material.dart';
import '../../../../core/widgets/atoms/app_text_field_atom.dart';

class LeadSearchBarMolecule extends StatelessWidget {
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onFilter;
  final bool isSearching;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const LeadSearchBarMolecule({
    super.key,
    required this.query,
    required this.onChanged,
    this.onClear,
    this.onFilter,
    this.isSearching = false,
    this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: AppTextFieldAtom(
              controller: controller,
              focusNode: focusNode,
              hintText: 'Search leads...',
              onChanged: onChanged,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              prefixIcon: isSearching
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.primary,
                      ),
                    )
                  : const Icon(Icons.search),
              suffixIcon: query.isNotEmpty
                  ? IconButton(
                      onPressed: onClear,
                      icon: const Icon(Icons.clear),
                      tooltip: 'Clear search',
                    )
                  : null,
            ),
          ),
          if (onFilter != null) ...[
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: onFilter,
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filter results',
              ),
            ),
          ],
        ],
      ),
    );
  }
}
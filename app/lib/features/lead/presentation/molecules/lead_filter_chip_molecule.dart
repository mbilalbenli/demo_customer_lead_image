import 'package:flutter/material.dart';
import '../../../../core/widgets/atoms/app_badge_atom.dart';
import '../../domain/entities/lead_entity.dart';

/// A feature-specific molecule for lead filtering chips
/// Following atomic design principles - composed from atoms
class LeadFilterChipMolecule extends StatelessWidget {
  final FilterType filterType;
  final String label;
  final bool selected;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onRemove;
  final int? count;
  final Color? selectedColor;
  final IconData? icon;

  const LeadFilterChipMolecule({
    super.key,
    required this.filterType,
    required this.label,
    required this.selected,
    this.onChanged,
    this.onRemove,
    this.count,
    this.selectedColor,
    this.icon,
  });

  /// Factory for status filter
  factory LeadFilterChipMolecule.status({
    Key? key,
    required LeadStatus status,
    required bool selected,
    ValueChanged<bool>? onChanged,
    int? count,
  }) {
    return LeadFilterChipMolecule(
      key: key,
      filterType: FilterType.status,
      label: _getStatusLabel(status),
      selected: selected,
      onChanged: onChanged,
      count: count,
      icon: _getStatusIcon(status),
    );
  }

  /// Factory for image count filter
  factory LeadFilterChipMolecule.imageCount({
    Key? key,
    required String label,
    required bool selected,
    ValueChanged<bool>? onChanged,
    int? count,
    required bool hasImages,
  }) {
    return LeadFilterChipMolecule(
      key: key,
      filterType: FilterType.imageCount,
      label: label,
      selected: selected,
      onChanged: onChanged,
      count: count,
      icon: hasImages ? Icons.photo_library : Icons.hide_image,
    );
  }

  /// Factory for date range filter
  factory LeadFilterChipMolecule.dateRange({
    Key? key,
    required String label,
    required bool selected,
    ValueChanged<bool>? onChanged,
    int? count,
  }) {
    return LeadFilterChipMolecule(
      key: key,
      filterType: FilterType.dateRange,
      label: label,
      selected: selected,
      onChanged: onChanged,
      count: count,
      icon: Icons.date_range,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveSelectedColor = selectedColor ?? colorScheme.primary;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
            ),
            const SizedBox(width: 4),
          ],
          Text(label),
          if (count != null) ...[
            const SizedBox(width: 4),
            AppBadgeAtom.number(
              count: count!,
              backgroundColor: selected
                  ? colorScheme.surface
                  : colorScheme.primaryContainer,
              textColor: selected
                  ? effectiveSelectedColor
                  : colorScheme.onPrimaryContainer,
              fontSize: 10,
            ),
          ],
        ],
      ),
      selected: selected,
      onSelected: onChanged,
      selectedColor: effectiveSelectedColor.withValues(alpha: 0.2),
      checkmarkColor: effectiveSelectedColor,
      showCheckmark: filterType != FilterType.imageCount,
    );
  }

  static String _getStatusLabel(LeadStatus status) {
    switch (status) {
      case LeadStatus.newLead:
        return 'New';
      case LeadStatus.contacted:
        return 'Contacted';
      case LeadStatus.qualified:
        return 'Qualified';
      case LeadStatus.proposal:
        return 'Proposal';
      case LeadStatus.negotiation:
        return 'Negotiation';
      case LeadStatus.closed:
        return 'Closed';
      case LeadStatus.lost:
        return 'Lost';
    }
  }

  static IconData _getStatusIcon(LeadStatus status) {
    switch (status) {
      case LeadStatus.newLead:
        return Icons.verified;
      case LeadStatus.contacted:
        return Icons.pause_circle;
      case LeadStatus.qualified:
        return Icons.star;
      case LeadStatus.proposal:
        return Icons.description;
      case LeadStatus.negotiation:
        return Icons.handshake;
      case LeadStatus.closed:
        return Icons.check_circle;
      case LeadStatus.lost:
        return Icons.cancel;
    }
  }
}

enum FilterType {
  status,
  imageCount,
  dateRange,
  custom,
}

/// A collection of filter chips for leads
class LeadFilterBarMolecule extends StatelessWidget {
  final List<LeadFilterChipMolecule> filters;
  final VoidCallback? onClearAll;
  final bool showClearButton;
  final EdgeInsets? padding;
  final double spacing;
  final double runSpacing;

  const LeadFilterBarMolecule({
    super.key,
    required this.filters,
    this.onClearAll,
    this.showClearButton = true,
    this.padding,
    this.spacing = 8,
    this.runSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final hasActiveFilters = filters.any((filter) => filter.selected);

    return Container(
      padding: padding ?? const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showClearButton && hasActiveFilters)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Filters',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton.icon(
                  onPressed: onClearAll,
                  icon: Icon(Icons.clear_all, size: 16),
                  label: Text(
                    'Clear All',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: filters,
          ),
        ],
      ),
    );
  }
}

/// A filter summary showing active filters count
class LeadFilterSummaryMolecule extends StatelessWidget {
  final int activeFilterCount;
  final VoidCallback? onTap;
  final bool expanded;

  const LeadFilterSummaryMolecule({
    super.key,
    required this.activeFilterCount,
    this.onTap,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: activeFilterCount > 0
              ? colorScheme.primaryContainer.withValues(alpha: 0.3)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: activeFilterCount > 0
                ? colorScheme.primary.withValues(alpha: 0.3)
                : colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list,
              size: 18,
              color: activeFilterCount > 0
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              activeFilterCount > 0
                  ? '$activeFilterCount Filters'
                  : 'Filters',
              style: TextStyle(
                color: activeFilterCount > 0
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: activeFilterCount > 0
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
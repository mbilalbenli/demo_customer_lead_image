import 'package:flutter/material.dart';
import '../atoms/lead_initial_atom.dart';
import '../atoms/lead_status_chip_atom.dart';
import '../atoms/lead_info_text_atom.dart';
import '../atoms/lead_image_count_badge_atom.dart';
import '../../../../core/widgets/atoms/app_divider_atom.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/lead_entity.dart';

/// A feature-specific molecule for displaying lead information in a card
/// Composed from lead atoms and shows image count
/// Following atomic design principles - composed from atoms
class LeadCardMolecule extends StatelessWidget {
  final String leadName;
  final String? company;
  final String? email;
  final String? phone;
  final LeadStatus status;
  final int imageCount;
  final VoidCallback? onTap;
  final VoidCallback? onImagesTap;
  final bool showImageCount;
  final bool selected;
  final bool compact;

  const LeadCardMolecule({
    super.key,
    required this.leadName,
    this.company,
    this.email,
    this.phone,
    required this.status,
    required this.imageCount,
    this.onTap,
    this.onImagesTap,
    this.showImageCount = true,
    this.selected = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (compact) {
      return _buildCompactCard(context, theme, colorScheme);
    } else {
      return _buildStandardCard(context, theme, colorScheme);
    }
  }

  Widget _buildStandardCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Card(
      elevation: selected ? 4 : 1,
      color: selected
          ? colorScheme.primaryContainer.withValues(alpha: 0.3)
          : colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  LeadInitialAtom(
                    name: leadName,
                    size: 48,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          leadName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (company != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            company!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  LeadStatusChipAtom(
                    status: status,
                    showIcon: false,
                  ),
                ],
              ),

              // Contact Information
              if (email != null || phone != null) ...[
                const SizedBox(height: 12),
                AppDividerAtom.subtle(),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (email != null)
                      Expanded(
                        child: LeadInfoTextHorizontalAtom(
                          label: 'Email',
                          value: email!,
                          icon: Icons.email_outlined,
                        ),
                      ),
                    if (email != null && phone != null)
                      const SizedBox(width: 16),
                    if (phone != null)
                      Expanded(
                        child: LeadInfoTextHorizontalAtom(
                          label: 'Phone',
                          value: phone!,
                          icon: Icons.phone_outlined,
                        ),
                      ),
                  ],
                ),
              ],

              // Image Count Section
              if (showImageCount) ...[
                const SizedBox(height: 12),
                AppDividerAtom.subtle(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      (AppLocalizations.of(context)?.images ?? 'Images'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    LeadImageCountBadgeAtom(
                      currentCount: imageCount,
                      onTap: onImagesTap,
                      style: BadgeStyle.compact,
                    ),
                    const Icon(Icons.chevron_right, size: 20),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Card(
      elevation: selected ? 2 : 0,
      color: selected
          ? colorScheme.primaryContainer.withValues(alpha: 0.2)
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              LeadInitialAtom.small(
                name: leadName,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      leadName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (company != null)
                      Text(
                        company!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (showImageCount)
                LeadImageCountChipAtom(
                  count: imageCount,
                  onTap: onImagesTap,
                ),
              const SizedBox(width: 8),
              LeadStatusDotAtom(
                status: status,
                showTooltip: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A variant of lead card optimized for grid layout
class LeadGridCardMolecule extends StatelessWidget {
  final String leadName;
  final String? company;
  final LeadStatus status;
  final int imageCount;
  final VoidCallback? onTap;
  final VoidCallback? onImagesTap;
  final bool selected;

  const LeadGridCardMolecule({
    super.key,
    required this.leadName,
    this.company,
    required this.status,
    required this.imageCount,
    this.onTap,
    this.onImagesTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: selected ? 4 : 1,
      color: selected
          ? colorScheme.primaryContainer.withValues(alpha: 0.3)
          : colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LeadInitialAtom.large(
                name: leadName,
              ),
              const SizedBox(height: 12),
              Text(
                leadName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (company != null) ...[
                const SizedBox(height: 4),
                Text(
                  company!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              LeadStatusChipAtom(
                status: status,
                fontSize: 11,
              ),
              const SizedBox(height: 8),
              LeadImageCountBadgeAtom(
                currentCount: imageCount,
                onTap: onImagesTap,
                style: BadgeStyle.minimal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

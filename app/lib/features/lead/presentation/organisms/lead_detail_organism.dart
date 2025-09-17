import 'package:flutter/material.dart';
import '../../../../core/widgets/molecules/app_limit_indicator_molecule.dart';
import '../../../../l10n/app_localizations.dart';
import '../molecules/lead_info_card_molecule.dart';
import '../molecules/lead_action_bar_molecule.dart';
import '../atoms/lead_status_badge_atom.dart';
import '../atoms/image_count_badge_atom.dart';
import '../../domain/entities/lead_entity.dart';

class LeadDetailOrganism extends StatelessWidget {
  final LeadEntity lead;
  final int maxImageCount;
  final bool isLoading;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onViewImages;
  final VoidCallback onAddImage;

  const LeadDetailOrganism({
    super.key,
    required this.lead,
    required this.maxImageCount,
    required this.isLoading,
    required this.onEdit,
    required this.onDelete,
    required this.onViewImages,
    required this.onAddImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Status and Image Count
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lead.customerName.value,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        LeadStatusBadgeAtom(status: lead.status),
                        const SizedBox(width: 12),
                        ImageCountBadgeAtom.compact(
                          count: lead.imageCount,
                          maxCount: maxImageCount,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.person_outline,
                size: 48,
                color: colorScheme.primary,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Images section with limit indicator and actions
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.photo_library,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${l10n?.images ?? 'Images'} (${lead.imageCount}/$maxImageCount)',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: l10n?.addImage ?? 'Add Image',
                        onPressed: lead.imageCount < maxImageCount ? onAddImage : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppLimitIndicatorMolecule.images(
                    current: lead.imageCount,
                    max: maxImageCount,
                    style: LimitIndicatorStyle.progress,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: lead.imageCount > 0 ? onViewImages : null,
                          icon: const Icon(Icons.visibility),
                          label: Text(l10n?.viewImageGallery ?? 'View All Images'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: lead.imageCount < maxImageCount ? onAddImage : null,
                          icon: const Icon(Icons.add_a_photo),
                          label: Text(l10n?.addImage ?? 'Add Image'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Lead Information
          LeadInfoCardMolecule(lead: lead),

          const SizedBox(height: 16),

          // Lead Actions
          LeadActionBarMolecule(
            lead: lead,
            onEdit: onEdit,
            onDelete: onDelete,
            isLoading: isLoading,
          ),

          const SizedBox(height: 24),

          // Timeline/History Section (placeholder)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Activity History',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTimelineItem(
                    context,
                    'Lead created',
                    lead.createdAt,
                    Icons.person_add,
                  ),
                  _buildTimelineItem(
                    context,
                    'Last updated',
                    lead.updatedAt ?? lead.createdAt,
                    Icons.edit,
                  ),
                  if (lead.imageCount > 0)
                    _buildTimelineItem(
                      context,
                      '${lead.imageCount} images uploaded',
                      lead.updatedAt ?? lead.createdAt,
                      Icons.photo_camera,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String title,
    DateTime dateTime,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatDateTime(dateTime),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

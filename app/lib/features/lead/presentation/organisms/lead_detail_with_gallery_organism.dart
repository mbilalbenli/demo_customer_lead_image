import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/lead_entity.dart';
import '../../../lead_image/presentation/providers/image_providers.dart';
import '../atoms/lead_status_badge_atom.dart';
import '../molecules/lead_contact_info_molecule.dart';
import '../molecules/lead_image_gallery_molecule.dart';

class LeadDetailWithGalleryOrganism extends ConsumerWidget {
  final LeadEntity lead;
  final String leadId;
  final int maxImageCount;
  final bool isLoading;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onManagePhotos;

  const LeadDetailWithGalleryOrganism({
    super.key,
    required this.lead,
    required this.leadId,
    required this.maxImageCount,
    this.isLoading = false,
    required this.onEdit,
    required this.onDelete,
    required this.onManagePhotos,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading) {
      return this._buildLoadingSkeleton(context);
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lead Header Card
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Lead Avatar
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          lead.customerName.value.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Lead Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lead.customerName.value,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            LeadStatusBadgeAtom(status: lead.status),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Contact Info
                  LeadContactInfoMolecule(
                    email: lead.email.value,
                    phone: lead.phone.value,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Images Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Photos',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Builder(builder: (context) {
                    final galleryState = ref.watch(imageGalleryViewModelProvider(leadId));
                    final current = galleryState.currentCount;
                    return Text(
                      '$current/$maxImageCount',
                      style: Theme.of(context).textTheme.bodySmall,
                    );
                  }),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Add Photo',
                    onPressed: onManagePhotos,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Image Gallery
              LeadImageGalleryMolecule(
                leadId: leadId,
                maxImages: maxImageCount,
                onAddPhotos: onManagePhotos,
                isLoading: isLoading,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Additional Info Section
          if (lead.description != null && lead.description!.isNotEmpty) ...[
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lead.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }
}

extension on LeadDetailWithGalleryOrganism {
  Widget _buildLoadingSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color block([double alpha = 0.15]) => colorScheme.outlineVariant.withValues(alpha: alpha);

    Widget line({double width = 120, double height = 14, double radius = 6}) =>
        Container(width: width, height: height, decoration: BoxDecoration(color: block(), borderRadius: BorderRadius.circular(radius)));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card skeleton
          Card(
            elevation: 0,
            color: colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(color: block(), shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            line(width: 160, height: 20, radius: 8),
                            const SizedBox(height: 8),
                            line(width: 90, height: 14, radius: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Contact info skeleton
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        line(width: 140, height: 16),
                        const SizedBox(height: 12),
                        line(width: 220),
                        const SizedBox(height: 12),
                        line(width: 180),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Photos section skeleton
          Row(
            children: [
              line(width: 80, height: 20, radius: 8),
              const SizedBox(width: 8),
              line(width: 44, height: 14, radius: 8),
              const Spacer(),
              Container(width: 36, height: 36, decoration: BoxDecoration(color: block(), shape: BoxShape.circle)),
            ],
          ),
          const SizedBox(height: 12),

          LayoutBuilder(
            builder: (context, constraints) {
              const horizontalPadding = 12.0;
              const verticalPadding = 12.0;
              const hSpacing = 8.0;
              const vSpacing = 12.0;

              final availableWidth = constraints.maxWidth - (horizontalPadding * 2) - (hSpacing * 2);
              final tileWidth = (availableWidth / 3).floorToDouble();
              final tileHeight = tileWidth;

              final tiles = List.generate(6, (i) =>
                SizedBox(
                  width: tileWidth,
                  height: tileHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: block(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              );

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Wrap(
                  spacing: hSpacing,
                  runSpacing: vSpacing,
                  children: tiles,
                ),
              );
            },
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

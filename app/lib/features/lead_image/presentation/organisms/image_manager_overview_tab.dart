import 'package:flutter/material.dart';
import '../../data/models/managed_image_model.dart';
import '../molecules/slot_availability_bar_molecule.dart';
import '../molecules/image_limit_card_molecule.dart';
import '../atoms/limit_warning_atom.dart';
import '../../../../core/widgets/molecules/app_empty_state_molecule.dart';

class ImageManagerOverviewTab extends StatelessWidget {
  final List<ManagedImage> images;
  final int maxImages;
  final VoidCallback? onAddImage;
  final VoidCallback? onManageImages;

  const ImageManagerOverviewTab({
    super.key,
    required this.images,
    required this.maxImages,
    this.onAddImage,
    this.onManageImages,
  });

  @override
  Widget build(BuildContext context) {
    final isAtLimit = images.length >= maxImages;
    final isNearLimit = images.length >= maxImages - 2;

    if (images.isEmpty) {
      return Center(
        child: AppEmptyStateMolecule(
          icon: Icons.photo_library_outlined,
          title: 'No Images Yet',
          message: 'Add your first image to get started',
          actionText: 'Add Image',
          onAction: onAddImage,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Slot availability bar
          SlotAvailabilityBarMolecule(
            filledSlots: images.length,
            totalSlots: maxImages,
            onAddImage: isAtLimit ? null : onAddImage,
            onManageImages: onManageImages,
            showActions: true,
            alwaysShowWarning: isNearLimit || isAtLimit,
          ),

          const SizedBox(height: 16),

          // Visual slot grid
          _buildVisualSlotGrid(context),

          if (isNearLimit || isAtLimit) ...[
            const SizedBox(height: 16),
            AnimatedLimitWarningAtom(
              currentCount: images.length,
              maxCount: maxImages,
            ),
          ],

          const SizedBox(height: 16),

          // Image limit card
          ImageLimitCardMolecule(
            currentCount: images.length,
            maxCount: maxImages,
            onManageImages: onManageImages,
            onAddImage: isAtLimit ? null : onAddImage,
            style: CardStyle.detailed,
          ),
        ],
      ),
    );
  }

  Widget _buildVisualSlotGrid(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Image Slots',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: maxImages,
            itemBuilder: (context, index) {
              final isFilled = index < images.length;
              final isLastFilled = index == images.length - 1;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isFilled
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isLastFilled
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.2),
                    width: isLastFilled ? 2 : 1,
                  ),
                  boxShadow: isLastFilled
                      ? [
                          BoxShadow(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: isFilled
                      ? Icon(
                          Icons.check,
                          size: 16,
                          color: colorScheme.onPrimary,
                        )
                      : Text(
                          '${index + 1}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
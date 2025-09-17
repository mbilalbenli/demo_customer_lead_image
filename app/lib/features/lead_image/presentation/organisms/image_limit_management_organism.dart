import 'package:flutter/material.dart';
import '../molecules/image_limit_card_molecule.dart';
import '../molecules/slot_availability_bar_molecule.dart';
import '../molecules/image_grid_item_molecule.dart';
import '../atoms/slot_indicator_atom.dart';
import '../atoms/limit_warning_atom.dart';
import '../atoms/add_image_button_atom.dart';
import '../../../../core/widgets/molecules/app_empty_state_molecule.dart';

/// An organism for simple image limit management
/// Shows count, visual indicators, and delete functionality
/// Following atomic design principles - composed from molecules and atoms
class ImageLimitManagementOrganism extends StatefulWidget {
  final List<ManagedImage> images;
  final int maxImages;
  final bool isLoading;
  final ValueChanged<String>? onImageSelect;
  final ValueChanged<String>? onImageDelete;
  final VoidCallback? onAddImage;
  final VoidCallback? onManageStorage;

  const ImageLimitManagementOrganism({
    super.key,
    required this.images,
    this.maxImages = 10,
    this.isLoading = false,
    this.onImageSelect,
    this.onImageDelete,
    this.onAddImage,
    this.onManageStorage,
  });

  @override
  State<ImageLimitManagementOrganism> createState() =>
      _ImageLimitManagementOrganismState();
}

class _ImageLimitManagementOrganismState
    extends State<ImageLimitManagementOrganism>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedImageId;
  bool _showReplacementMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final storageUsed = widget.images.fold<int>(
      0,
      (sum, image) => sum + image.sizeInBytes,
    );

    return Column(
      children: [
        // Header with comprehensive stats
        _buildHeader(context, storageUsed),

        // Tab bar for different views
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Manage'),
              Tab(text: 'Storage'),
            ],
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
          ),
        ),

        // Tab views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(context),
              _buildManageTab(context),
              _buildStorageTab(context, storageUsed),
            ],
          ),
        ),

        // Bottom action bar
        _buildBottomActionBar(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, int storageUsed) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = widget.images.length >= widget.maxImages;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withValues(alpha: 0.1),
            colorScheme.surface,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Image Limit Manager',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAtLimit
                        ? 'Maximum capacity reached'
                        : '${widget.maxImages - widget.images.length} of ${widget.maxImages} slots available',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isAtLimit
                          ? colorScheme.error
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isAtLimit
                      ? colorScheme.errorContainer
                      : colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    Text(
                      '${widget.images.length}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isAtLimit
                            ? colorScheme.onErrorContainer
                            : colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      '/ ${widget.maxImages}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isAtLimit
                            ? colorScheme.onErrorContainer
                            : colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SlotIndicatorAtom.bar(
            filled: widget.images.length,
            total: widget.maxImages,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildQuickStat(
                context,
                Icons.photo,
                'Images',
                '${widget.images.length}',
                colorScheme.primary,
              ),
              _buildQuickStat(
                context,
                Icons.add_photo_alternate,
                'Available',
                '${widget.maxImages - widget.images.length}',
                isAtLimit ? colorScheme.error : colorScheme.primary,
              ),
              _buildQuickStat(
                context,
                Icons.storage,
                'Storage',
                _formatFileSize(storageUsed),
                colorScheme.secondary,
              ),
              _buildQuickStat(
                context,
                Icons.speed,
                'Usage',
                '${(widget.images.length / widget.maxImages * 100).round()}%',
                _getUsageColor(context, widget.images.length / widget.maxImages),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    final isAtLimit = widget.images.length >= widget.maxImages;
    final isNearLimit = widget.images.length >= widget.maxImages - 2;

    if (widget.images.isEmpty) {
      return Center(
        child: AppEmptyStateMolecule(
          icon: Icons.photo_library_outlined,
          title: 'No Images Yet',
          message: 'Add your first image to get started',
          actionText: 'Add Image',
          onAction: widget.onAddImage,
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
            filledSlots: widget.images.length,
            totalSlots: widget.maxImages,
            onAddImage: isAtLimit ? null : widget.onAddImage,
            onManageImages: () => _tabController.animateTo(1),
            showActions: true,
            alwaysShowWarning: isNearLimit || isAtLimit,
          ),

          const SizedBox(height: 16),

          // Visual slot grid
          _buildVisualSlotGrid(context),

          if (isNearLimit || isAtLimit) ...[
            const SizedBox(height: 16),
            AnimatedLimitWarningAtom(
              currentCount: widget.images.length,
              maxCount: widget.maxImages,
            ),
          ],

          const SizedBox(height: 16),

          // Image limit card
          ImageLimitCardMolecule(
            currentCount: widget.images.length,
            maxCount: widget.maxImages,
            onManageImages: () => _tabController.animateTo(1),
            onAddImage: isAtLimit ? null : widget.onAddImage,
            style: CardStyle.detailed,
          ),
        ],
      ),
    );
  }

  Widget _buildManageTab(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (widget.images.isEmpty) {
      return const Center(
        child: AppEmptyStateMolecule(
          icon: Icons.photo_library_outlined,
          title: 'No Images to Manage',
          message: 'Add images to manage them here',
        ),
      );
    }

    return Column(
      children: [
        // Management toolbar
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Row(
            children: [
              if (_showReplacementMode) ...[
                IconButton(
                  onPressed: () => setState(() {
                    _showReplacementMode = false;
                    _selectedImageId = null;
                  }),
                  icon: const Icon(Icons.close),
                ),
                Text(
                  'Select image to replace',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ] else ...[
                const Spacer(),
                Text(
                  '${widget.images.length} images',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),

        // Image grid for management
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final image = widget.images[index];
              final isSelected = _selectedImageId == image.id;

              return GestureDetector(
                onTap: () {
                  if (_showReplacementMode) {
                    setState(() => _selectedImageId = image.id);
                  } else {
                    widget.onImageSelect?.call(image.id);
                  }
                },
                child: Stack(
                  children: [
                    ImageGridItemMolecule(
                      base64Image: image.base64Data,
                      imageUrl: image.url,
                      index: index,
                      isSelected: isSelected,
                      onTap: () {
                        if (_showReplacementMode) {
                          setState(() => _selectedImageId = image.id);
                        } else {
                          widget.onImageSelect?.call(image.id);
                        }
                      },
                      onDelete: !_showReplacementMode
                          ? () => widget.onImageDelete?.call(image.id)
                          : null,
                      showDeleteButton: !_showReplacementMode,
                      showIndex: true,
                    ),
                    if (_showReplacementMode && isSelected)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.swap_horiz,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),

        // Replacement action bar
        if (_showReplacementMode && _selectedImageId != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              border: Border(
                top: BorderSide(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Replace selected image with new one',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Delete the selected image
                    if (_selectedImageId != null) {
                      widget.onImageDelete?.call(_selectedImageId!);
                    }
                    setState(() {
                      _showReplacementMode = false;
                      _selectedImageId = null;
                    });
                  },
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Choose New'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStorageTab(BuildContext context, int storageUsed) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final averageSize = widget.images.isEmpty
        ? 0
        : storageUsed ~/ widget.images.length;
    final estimatedMaxStorage = widget.maxImages * averageSize;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Storage overview card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.storage,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Storage Overview',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildStorageRow(
                    context,
                    'Current Usage',
                    _formatFileSize(storageUsed),
                    colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  _buildStorageRow(
                    context,
                    'Average per Image',
                    _formatFileSize(averageSize),
                    colorScheme.secondary,
                  ),
                  const SizedBox(height: 8),
                  _buildStorageRow(
                    context,
                    'Est. Max Storage',
                    _formatFileSize(estimatedMaxStorage),
                    colorScheme.tertiary,
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: widget.images.length / widget.maxImages,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getUsageColor(
                        context,
                        widget.images.length / widget.maxImages,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Image size breakdown
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Image Size Breakdown',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...widget.images.map((image) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              '${widget.images.indexOf(image) + 1}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                image.fileName,
                                style: theme.textTheme.bodyMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                _formatFileSize(image.sizeInBytes),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (image.isMain)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'MAIN',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = widget.images.length >= widget.maxImages;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: AddImageButtonAtom(
              onAdd: isAtLimit ? null : widget.onAddImage,
              onReplace: null,
              currentCount: widget.images.length,
              maxCount: widget.maxImages,
              variant: ButtonVariant.filled,
            ),
          ),
          if (widget.onManageStorage != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: widget.onManageStorage,
              icon: const Icon(Icons.settings),
              tooltip: 'Storage Settings',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVisualSlotGrid(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Visual Slot Status',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: widget.maxImages,
              itemBuilder: (context, index) {
                final isFilled = index < widget.images.length;
                final isLast = index == widget.maxImages - 1;
                final isSecondLast = index == widget.maxImages - 2;

                Color slotColor;
                if (isFilled) {
                  if (isLast) {
                    slotColor = colorScheme.error;
                  } else if (isSecondLast) {
                    slotColor = colorScheme.tertiary;
                  } else {
                    slotColor = colorScheme.primary;
                  }
                } else {
                  slotColor = colorScheme.surfaceContainerHighest;
                }

                return Container(
                  decoration: BoxDecoration(
                    color: slotColor,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isFilled
                          ? slotColor.withValues(alpha: 0.3)
                          : colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isFilled
                            ? Colors.white.withValues(alpha: 0.9)
                            : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStorageRow(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getUsageColor(BuildContext context, double usage) {
    final colorScheme = Theme.of(context).colorScheme;
    if (usage >= 1.0) return colorScheme.error;
    if (usage >= 0.8) return colorScheme.tertiary;
    return colorScheme.primary;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Data model for managed images
class ManagedImage {
  final String id;
  final String? base64Data;
  final String? url;
  final String fileName;
  final int sizeInBytes;
  final DateTime uploadedAt;
  final bool isMain;

  const ManagedImage({
    required this.id,
    this.base64Data,
    this.url,
    required this.fileName,
    required this.sizeInBytes,
    required this.uploadedAt,
    this.isMain = false,
  });
}
import 'package:flutter/material.dart';
import '../../data/models/managed_image_model.dart';
import 'image_manager_header_organism.dart';
import 'image_manager_overview_tab.dart';
import 'image_manager_manage_tab.dart';
import 'image_manager_storage_tab.dart';

export '../../data/models/managed_image_model.dart';

/// Refactored organism for image limit management
/// Now under 750 lines by extracting components
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
        ImageManagerHeaderOrganism(
          images: widget.images,
          maxImages: widget.maxImages,
          storageUsed: storageUsed,
        ),

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
              ImageManagerOverviewTab(
                images: widget.images,
                maxImages: widget.maxImages,
                onAddImage: widget.onAddImage,
                onManageImages: () => _tabController.animateTo(1),
              ),
              ImageManagerManageTab(
                images: widget.images,
                onImageSelect: widget.onImageSelect,
                onImageDelete: widget.onImageDelete,
                onAddImage: widget.onAddImage,
              ),
              ImageManagerStorageTab(
                images: widget.images,
                storageUsed: storageUsed,
                onManageStorage: widget.onManageStorage,
              ),
            ],
          ),
        ),

        // Bottom action bar
        _buildBottomActionBar(context),
      ],
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: widget.onManageStorage,
                icon: const Icon(Icons.settings),
                label: const Text('Settings'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton.icon(
                onPressed: isAtLimit ? null : widget.onAddImage,
                icon: const Icon(Icons.add_photo_alternate),
                label: Text(
                  isAtLimit ? 'Limit Reached' : 'Add Image',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
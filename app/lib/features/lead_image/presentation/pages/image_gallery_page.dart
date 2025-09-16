import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/base/base_page.dart';
import '../providers/image_providers.dart';
import '../states/image_gallery_state.dart';
import '../../domain/entities/lead_image_entity.dart';

class ImageGalleryPage extends BasePage<ImageGalleryState> {
  final String leadId;

  const ImageGalleryPage({super.key, required this.leadId}) : super(
    initialShowAppBar: true,
    wrapWithScroll: false,
  );

  @override
  ConsumerState<ImageGalleryPage> createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends BasePageState<ImageGalleryPage, ImageGalleryState> {
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  ProviderListenable<ImageGalleryState> get vmProvider =>
      imageGalleryViewModelProvider(widget.leadId);

  @override
  PreferredSizeWidget buildAppBar(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imageGalleryViewModelProvider(widget.leadId));
    return AppBar(
      title: Column(
        children: [
          Text(state.title),
          if (state.isNearLimit || state.isAtLimit)
            Text(
              state.limitStatusMessage,
              style: TextStyle(
                fontSize: 12,
                color: state.isAtLimit ? Colors.orange : Colors.white70,
              ),
            ),
        ],
      ),
      backgroundColor: state.isAtLimit
          ? Colors.orange.withValues(alpha: 0.3)
          : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
      centerTitle: true,
      actions: [
        if (!state.isAtLimit)
          IconButton(
            icon: const Icon(Icons.add_photo_alternate),
            onPressed: () => _showImageSourceDialog(context, ref),
          ),
      ],
    );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final state = ref.watch(imageGalleryViewModelProvider(widget.leadId));

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Image count and limit indicator
        _buildLimitIndicator(state),

        // Upload button or limit message
        if (state.isAtLimit)
          _buildLimitReachedCard(context)
        else
          _buildUploadSection(context, ref, state),

        // Images carousel or empty state
        Expanded(
          child: state.images.isEmpty
              ? _buildEmptyState(context, ref)
              : _buildImageCarousel(context, ref, state),
        ),

        // Bottom indicators
        if (state.images.isNotEmpty)
          _buildCarouselIndicators(context, state),
      ],
    );
  }

  Widget _buildLimitIndicator(ImageGalleryState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                state.imageStatusText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: state.isAtLimit ? Colors.orange : null,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: state.isAtLimit
                      ? Colors.orange.withValues(alpha: 0.2)
                      : Colors.green.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${state.capacityPercentage.toStringAsFixed(0)}% Used',
                  style: TextStyle(
                    color: state.isAtLimit ? Colors.orange : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: state.capacityPercentage / 100,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              state.isAtLimit
                  ? Colors.orange
                  : state.isNearLimit
                      ? Colors.yellow
                      : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitReachedCard(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.orange.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.warning, color: Colors.orange),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Image limit reached. Delete an existing image to upload new ones.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection(BuildContext context, WidgetRef ref, ImageGalleryState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: state.isUploading
                  ? null
                  : () => _pickImage(ImageSource.camera, ref),
              icon: const Icon(Icons.camera_alt),
              label: Text(state.isUploading ? 'Uploading...' : 'Take Photo'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: state.isUploading
                  ? null
                  : () => _pickImage(ImageSource.gallery, ref),
              icon: const Icon(Icons.photo_library),
              label: Text(state.isUploading ? 'Uploading...' : 'From Gallery'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No images yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first image to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(BuildContext context, WidgetRef ref, ImageGalleryState state) {
    return CarouselSlider.builder(
      carouselController: _carouselController,
      itemCount: state.images.length,
      options: CarouselOptions(
        height: double.infinity,
        viewportFraction: 0.85,
        enlargeCenterPage: true,
        onPageChanged: (index, reason) {
          ref.read(imageGalleryViewModelProvider(widget.leadId).notifier)
              .setSelectedIndex(index);
        },
      ),
      itemBuilder: (context, index, realIndex) {
        final image = state.images[index];
        return _buildImageCard(context, ref, image, index, state);
      },
    );
  }

  Widget _buildImageCard(
    BuildContext context,
    WidgetRef ref,
    LeadImageEntity image,
    int index,
    ImageGalleryState state,
  ) {
    final isSelected = index == state.selectedIndex;
    final isBeingReplaced = state.imageBeingReplaced?.id == image.id;

    return GestureDetector(
      onTap: () => _showImageOptions(context, ref, image),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isSelected ? 0.3 : 0.1),
              blurRadius: isSelected ? 10 : 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              Image.memory(
                base64Decode(image.base64Data.value),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 48),
                    ),
                  );
                },
              ),
              // Overlay for replacing image
              if (isBeingReplaced)
                Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              // Image info overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Image ${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${(image.metadata.sizeInBytes / 1024).toStringAsFixed(1)} KB',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselIndicators(BuildContext context, ImageGalleryState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          state.images.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: index == state.selectedIndex ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: index == state.selectedIndex
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImageOptions(BuildContext context, WidgetRef ref, LeadImageEntity image) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('Replace Image'),
              onTap: () {
                Navigator.pop(context);
                _showReplaceImageDialog(context, ref, image);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Image', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, ref, image);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showReplaceImageDialog(BuildContext context, WidgetRef ref, LeadImageEntity image) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Replace with new image from:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _replaceImage(ImageSource.camera, ref, image);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _replaceImage(ImageSource.gallery, ref, image);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, LeadImageEntity image) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Image?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(imageGalleryViewModelProvider(widget.leadId).notifier)
                  .deleteImage(image);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      ref.read(imageGalleryViewModelProvider(widget.leadId).notifier)
          .uploadImage(pickedFile);
    }
  }

  Future<void> _replaceImage(
    ImageSource source,
    WidgetRef ref,
    LeadImageEntity oldImage,
  ) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      ref.read(imageGalleryViewModelProvider(widget.leadId).notifier)
          .replaceImage(oldImage, pickedFile);
    }
  }
}
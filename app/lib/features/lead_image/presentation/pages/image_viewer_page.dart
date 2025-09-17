import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../organisms/image_viewer_organism.dart';
import '../providers/image_providers.dart';
import '../../domain/entities/lead_image_entity.dart';

/// Image viewer page showing "Image 3 of 7"
class ImageViewerPage extends ConsumerWidget {
  final String leadId;
  final String imageId;

  const ImageViewerPage({
    super.key,
    required this.leadId,
    required this.imageId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galleryState = ref.watch(imageGalleryViewModelProvider(leadId));
    final vm = ref.read(imageGalleryViewModelProvider(leadId).notifier);

    // Map gallery images to viewer model
    List<ViewerImage> viewerImages = galleryState.images
        .map((img) => _toViewerImage(img))
        .toList();

    final initialIndex = viewerImages.indexWhere((v) => v.id == imageId);
    final safeIndex = initialIndex >= 0 ? initialIndex : 0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ImageViewerOrganism(
        images: viewerImages,
        initialIndex: safeIndex,
        maxImages: galleryState.maxCount,
        onClose: () => Navigator.of(context).pop(),
        onDeleteImage: (id) async {
          final maybe = galleryState.images.where((e) => e.id == id);
          if (maybe.isEmpty) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Image not found in gallery')),
              );
            }
            return;
          }
          await vm.deleteImage(maybe.first);
          if (context.mounted) Navigator.of(context).pop();
        },
      ),
    );
  }

  ViewerImage _toViewerImage(LeadImageEntity e) {
    return ViewerImage(
      id: e.id,
      base64Data: e.base64Data.value,
      url: null,
      fileName: e.metadata.fileName,
      sizeInBytes: e.metadata.sizeInBytes,
      uploadedAt: e.metadata.uploadedAt,
      isMain: false,
    );
  }
}

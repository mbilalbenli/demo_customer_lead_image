import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../organisms/image_viewer_organism.dart';

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
    // Mock data - replace with actual state management
    final images = <ViewerImage>[];
    const currentIndex = 0;
    const maxImages = 10;

    return Scaffold(
      backgroundColor: Colors.black,
      body: ImageViewerOrganism(
        images: images,
        initialIndex: currentIndex,
        maxImages: maxImages,
        onClose: () => Navigator.of(context).pop(),
        onDeleteImage: (id) {
          // Handle delete
        },
      ),
    );
  }
}
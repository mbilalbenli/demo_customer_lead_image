import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../organisms/image_replacement_flow_organism.dart';

/// Image replacement page - dedicated 11th image flow
class ImageReplacementPage extends ConsumerWidget {
  final String leadId;
  final String? targetImageId;

  const ImageReplacementPage({
    super.key,
    required this.leadId,
    this.targetImageId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock data - replace with actual state management
    final existingImages = <ReplacementImage>[];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ImageReplacementFlowOrganism(
        existingImages: existingImages,
        onReplaceImage: (imageId) {
          // Handle replacement
          Navigator.of(context).pop();
        },
        onCancel: () => Navigator.of(context).pop(),
        onSelectNewImage: () {
          // Handle new image selection
        },
      ),
    );
  }
}
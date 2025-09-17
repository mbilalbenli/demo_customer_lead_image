import 'package:flutter/material.dart';
import '../../domain/entities/lead_image_entity.dart';
import '../atoms/image_slot_atom.dart';

class ImageSlotsGridOrganism extends StatelessWidget {
  final List<LeadImageEntity> images;
  final int maxImages;
  final Function(LeadImageEntity) onImageTap;
  final VoidCallback onEmptySlotTap;

  const ImageSlotsGridOrganism({
    super.key,
    required this.images,
    required this.maxImages,
    required this.onImageTap,
    required this.onEmptySlotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: maxImages,
        itemBuilder: (context, index) {
          if (index < images.length) {
            final image = images[index];
            return ImageSlotAtom(
              index: index,
              imageBase64: image.base64Data.value,
              onTap: () => onImageTap(image),
            );
          } else {
            return ImageSlotAtom(
              index: index,
              onTap: onEmptySlotTap,
            );
          }
        },
      ),
    );
  }
}
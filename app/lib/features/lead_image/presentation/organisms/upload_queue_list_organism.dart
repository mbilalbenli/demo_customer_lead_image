import 'package:flutter/material.dart';
import '../../domain/entities/upload_queue_item_entity.dart';
import '../molecules/upload_queue_item_molecule.dart';

class UploadQueueListOrganism extends StatelessWidget {
  final List<UploadQueueItemEntity> items;
  final void Function(String id) onRemove;
  const UploadQueueListOrganism({super.key, required this.items, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No items in queue'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => UploadQueueItemMolecule(
        item: items[index],
        onRemove: () => onRemove(items[index].id),
      ),
    );
  }
}


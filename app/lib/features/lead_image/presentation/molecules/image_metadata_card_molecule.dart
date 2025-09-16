import 'package:flutter/material.dart';

/// A molecule for displaying image metadata
/// Following atomic design principles - composed from atoms
class ImageMetadataCardMolecule extends StatelessWidget {
  final String fileName;
  final int fileSize;
  final DateTime uploadedAt;
  final String? dimensions;
  final bool isMain;
  final List<String> tags;

  const ImageMetadataCardMolecule({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.uploadedAt,
    this.dimensions,
    this.isMain = false,
    this.tags = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // File name
            Row(
              children: [
                const Icon(
                  Icons.image,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fileName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isMain)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'MAIN',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Metadata rows
            _buildMetadataRow(
              Icons.storage,
              'Size',
              _formatFileSize(fileSize),
              Colors.white70,
            ),
            if (dimensions != null)
              _buildMetadataRow(
                Icons.aspect_ratio,
                'Dimensions',
                dimensions!,
                Colors.white70,
              ),
            _buildMetadataRow(
              Icons.calendar_today,
              'Uploaded',
              _formatDate(uploadedAt),
              Colors.white70,
            ),
            // Tags
            if (tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: tags.map((tag) => Chip(
                  label: Text(
                    tag,
                    style: const TextStyle(fontSize: 11),
                  ),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: colorScheme.secondary.withValues(alpha: 0.3),
                  labelStyle: TextStyle(
                    color: colorScheme.onSecondary,
                  ),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
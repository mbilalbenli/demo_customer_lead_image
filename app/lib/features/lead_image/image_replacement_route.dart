import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'presentation/pages/image_upload_page.dart';

class ImageReplacementRoute {
  static GoRoute get route => GoRoute(
    path: '/replace-image',
    name: 'imageReplacementFlow',
    pageBuilder: (context, state) {
      final extra = state.extra as Map<String, dynamic>?;
      final leadId = extra?['leadId'] as String? ?? '';
      final oldImageId = extra?['oldImageId'] as String? ?? '';

      return MaterialPage<void>(
        key: state.pageKey,
        child: ImageReplacementFlow(
          leadId: leadId,
          oldImageId: oldImageId,
        ),
      );
    },
  );
}

class ImageReplacementFlow extends StatelessWidget {
  final String leadId;
  final String oldImageId;

  const ImageReplacementFlow({
    super.key,
    required this.leadId,
    required this.oldImageId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Replace Image'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Column(
        children: [
          // Information banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Image Limit Reached',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'You have reached the maximum of 10 images. Select a new image to replace the existing one.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          // Upload widget
          Expanded(
            child: ImageUploadPage(
              leadId: leadId,
            ),
          ),
        ],
      ),
    );
  }
}
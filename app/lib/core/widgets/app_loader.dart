import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  final bool isLoading;
  final GlobalKey? loadingKey;
  final String? loadingMessage;

  const AppLoader({
    super.key,
    required this.isLoading,
    this.loadingKey,
    this.loadingMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    // If we have a loading key, show loader at that position
    if (loadingKey != null) {
      return _buildPositionedLoader(context);
    }

    // Otherwise show fullscreen loader
    return _buildFullscreenLoader(context);
  }

  Widget _buildPositionedLoader(BuildContext context) {
    // Try to find the widget with the key
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox? renderBox = loadingKey?.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        // We could position the loader near the widget
        // For now, we'll just show a small loader overlay
      }
    });

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (loadingMessage != null && loadingMessage!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      loadingMessage!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFullscreenLoader(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (loadingMessage != null && loadingMessage!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      loadingMessage!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
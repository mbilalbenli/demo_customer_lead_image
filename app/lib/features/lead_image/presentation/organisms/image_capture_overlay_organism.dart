import 'package:flutter/material.dart';
import '../molecules/capture_controls_molecule.dart';
import '../molecules/capture_preview_molecule.dart';
import '../atoms/image_count_badge_atom.dart';
import '../../../../core/widgets/molecules/app_loading_overlay_molecule.dart';

/// An organism for camera capture overlay with limit awareness
/// Shows capture controls and limit warnings
/// Following atomic design principles - composed from molecules and atoms
class ImageCaptureOverlayOrganism extends StatefulWidget {
  final int currentImageCount;
  final int maxImages;
  final bool isCapturing;
  final bool isProcessing;
  final VoidCallback? onCapture;
  final VoidCallback? onGalleryPick;
  final VoidCallback? onFlashToggle;
  final VoidCallback? onCameraSwitch;
  final VoidCallback? onCancel;
  final ValueChanged<String>? onConfirmCapture;
  final VoidCallback? onRetakeCapture;
  final String? previewImageData;
  final bool flashEnabled;
  final bool frontCamera;
  final bool showPreview;

  const ImageCaptureOverlayOrganism({
    super.key,
    required this.currentImageCount,
    this.maxImages = 10,
    this.isCapturing = false,
    this.isProcessing = false,
    this.onCapture,
    this.onGalleryPick,
    this.onFlashToggle,
    this.onCameraSwitch,
    this.onCancel,
    this.onConfirmCapture,
    this.onRetakeCapture,
    this.previewImageData,
    this.flashEnabled = false,
    this.frontCamera = false,
    this.showPreview = false,
  });

  @override
  State<ImageCaptureOverlayOrganism> createState() =>
      _ImageCaptureOverlayOrganismState();
}

class _ImageCaptureOverlayOrganismState
    extends State<ImageCaptureOverlayOrganism>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  bool _showGridLines = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isAtLimit = widget.currentImageCount >= widget.maxImages;
    final isNearLimit = widget.currentImageCount >= widget.maxImages - 2;
    final slotsRemaining = widget.maxImages - widget.currentImageCount;

    if (widget.showPreview && widget.previewImageData != null) {
      return _buildPreviewMode(context);
    }

    return Stack(
      children: [
        // Camera viewfinder area (placeholder)
        Container(
          color: Colors.black,
          child: Stack(
            children: [
              // Grid overlay
              if (_showGridLines)
                _buildGridOverlay(),

              // Focus indicator (center)
              if (!widget.isCapturing && !widget.showPreview)
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Top controls overlay
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Cancel button
                    IconButton(
                      onPressed: widget.onCancel,
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                    // Image count indicator
                    ImageCountBadgeAtom.prominent(
                      count: widget.currentImageCount,
                      maxCount: widget.maxImages,
                    ),
                    // Settings
                    IconButton(
                      onPressed: () => setState(() => _showGridLines = !_showGridLines),
                      icon: Icon(
                        _showGridLines ? Icons.grid_on : Icons.grid_off,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Limit warning overlay
        if (isNearLimit || isAtLimit)
          Positioned(
            top: 100,
            left: 16,
            right: 16,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: isAtLimit ? _pulseAnimation.value : 1.0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (isAtLimit ? colorScheme.error : colorScheme.tertiary)
                          .withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: (isAtLimit ? colorScheme.error : colorScheme.tertiary)
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isAtLimit ? Icons.block : Icons.warning_amber_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            isAtLimit
                                ? 'Storage limit reached! Cannot add more images.'
                                : slotsRemaining == 1
                                    ? 'Last image slot available!'
                                    : 'Only $slotsRemaining slots remaining',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        // Bottom controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Camera controls
                  CaptureControlsMolecule(
                    isCapturing: widget.isCapturing,
                    isProcessing: widget.isProcessing,
                    isDisabled: isAtLimit,
                    flashEnabled: widget.flashEnabled,
                    frontCamera: widget.frontCamera,
                    onCapture: isAtLimit ? null : widget.onCapture,
                    onGalleryPick: isAtLimit ? null : widget.onGalleryPick,
                    onFlashToggle: widget.onFlashToggle,
                    onCameraSwitch: widget.onCameraSwitch,
                    currentCount: widget.currentImageCount,
                    maxCount: widget.maxImages,
                  ),
                  if (isAtLimit)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: Text(
                        'Delete existing images to add new ones',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // Processing overlay
        if (widget.isProcessing)
          Container(
            color: Colors.black54,
            child: const Center(
              child: AppFullScreenLoadingMolecule(
                message: 'Processing image...',
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPreviewMode(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLastSlot = widget.currentImageCount == widget.maxImages - 1;

    return Stack(
      children: [
        // Preview image
        Container(
          color: Colors.black,
          child: CapturePreviewMolecule(
            imageData: widget.previewImageData!,
            isProcessing: widget.isProcessing,
          ),
        ),

        // Top bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        isLastSlot
                            ? 'Last image slot!'
                            : '${widget.currentImageCount + 1} of ${widget.maxImages}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isLastSlot ? colorScheme.tertiary : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Bottom controls
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Retake button
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: widget.isProcessing ? null : widget.onRetakeCapture,
                          icon: const Icon(Icons.refresh),
                          color: Colors.white,
                          iconSize: 32,
                        ),
                        const Text(
                          'Retake',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    // Confirm button
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.primary,
                              width: 3,
                            ),
                          ),
                          child: IconButton(
                            onPressed: widget.isProcessing
                                ? null
                                : () => widget.onConfirmCapture?.call(
                                    widget.previewImageData!),
                            icon: const Icon(Icons.check),
                            color: colorScheme.primary,
                            iconSize: 36,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isLastSlot ? 'Use Last Slot' : 'Use Photo',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Cancel button
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: widget.isProcessing ? null : widget.onCancel,
                          icon: const Icon(Icons.close),
                          color: Colors.white,
                          iconSize: 32,
                        ),
                        const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Processing overlay
        if (widget.isProcessing)
          Container(
            color: Colors.black54,
            child: const Center(
              child: AppFullScreenLoadingMolecule(
                message: 'Saving image...',
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGridOverlay() {
    return CustomPaint(
      size: Size.infinite,
      painter: _GridPainter(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    // Draw vertical lines
    final verticalSpacing = size.width / 3;
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(verticalSpacing * i, 0),
        Offset(verticalSpacing * i, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    final horizontalSpacing = size.height / 3;
    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(0, horizontalSpacing * i),
        Offset(size.width, horizontalSpacing * i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
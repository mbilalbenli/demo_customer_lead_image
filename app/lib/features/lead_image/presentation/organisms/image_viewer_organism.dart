import 'package:flutter/material.dart';
import '../molecules/image_viewer_controls_molecule.dart';
import '../molecules/image_metadata_card_molecule.dart';
import '../atoms/image_position_indicator_atom.dart';
import '../atoms/zoom_controls_atom.dart';
import '../../../../core/widgets/molecules/app_loading_overlay_molecule.dart';

/// An organism for viewing images with position indicator
/// Shows position X of Y with navigation controls
/// Following atomic design principles - composed from molecules and atoms
class ImageViewerOrganism extends StatefulWidget {
  final List<ViewerImage> images;
  final int initialIndex;
  final int maxImages;
  final ValueChanged<int>? onPageChanged;
  final ValueChanged<String>? onDeleteImage;
  final ValueChanged<String>? onSetAsMain;
  final ValueChanged<String>? onDownloadImage;
  final ValueChanged<String>? onShareImage;
  final VoidCallback? onClose;
  final bool showControls;
  final bool showMetadata;
  final bool allowDeletion;
  final bool allowZoom;

  const ImageViewerOrganism({
    super.key,
    required this.images,
    this.initialIndex = 0,
    this.maxImages = 10,
    this.onPageChanged,
    this.onDeleteImage,
    this.onSetAsMain,
    this.onDownloadImage,
    this.onShareImage,
    this.onClose,
    this.showControls = true,
    this.showMetadata = false,
    this.allowDeletion = true,
    this.allowZoom = true,
  });

  @override
  State<ImageViewerOrganism> createState() => _ImageViewerOrganismState();
}

class _ImageViewerOrganismState extends State<ImageViewerOrganism>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late TransformationController _transformationController;
  late AnimationController _animationController;
  int _currentIndex = 0;
  bool _isZoomed = false;
  bool _showingControls = true;
  bool _showingMetadata = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _showingMetadata = widget.showMetadata;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (_isZoomed) {
      _animateResetZoom();
    } else {
      _animateZoomIn();
    }
  }

  void _animateZoomIn() {
    const double scale = 2.0;
    final scaledMatrix = Matrix4.identity();
    scaledMatrix.setEntry(0, 0, scale);
    scaledMatrix.setEntry(1, 1, scale);
    final animation = Matrix4Tween(
      begin: _transformationController.value,
      end: scaledMatrix,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    animation.addListener(() {
      _transformationController.value = animation.value;
    });

    _animationController.forward(from: 0).then((_) {
      setState(() => _isZoomed = true);
    });
  }

  void _animateResetZoom() {
    final animation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    animation.addListener(() {
      _transformationController.value = animation.value;
    });

    _animationController.forward(from: 0).then((_) {
      setState(() => _isZoomed = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentImage = widget.images[_currentIndex];
    final isAtLimit = widget.images.length >= widget.maxImages;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main image viewer
          GestureDetector(
            onTap: () {
              setState(() => _showingControls = !_showingControls);
            },
            onDoubleTap: widget.allowZoom ? _handleDoubleTap : null,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  if (_isZoomed) _animateResetZoom();
                });
                widget.onPageChanged?.call(index);
              },
              itemBuilder: (context, index) {
                final image = widget.images[index];
                return InteractiveViewer(
                  transformationController: index == _currentIndex
                      ? _transformationController
                      : TransformationController(),
                  maxScale: 4.0,
                  minScale: 0.5,
                  child: _buildImageView(image),
                );
              },
            ),
          ),

          // Top controls overlay
          AnimatedOpacity(
            opacity: _showingControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header bar
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Close button
                          IconButton(
                            onPressed: widget.onClose ?? () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close),
                            color: Colors.white,
                          ),
                          // Position indicator
                          ImagePositionIndicatorAtom(
                            current: _currentIndex + 1,
                            total: widget.images.length,
                            maxTotal: widget.maxImages,
                            showLimitWarning: isAtLimit,
                          ),
                          // More options
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: Colors.white),
                            color: colorScheme.surface,
                            itemBuilder: (context) => [
                              if (widget.onSetAsMain != null && !currentImage.isMain)
                                const PopupMenuItem(
                                  value: 'set_main',
                                  child: Row(
                                    children: [
                                      Icon(Icons.star),
                                      SizedBox(width: 8),
                                      Text('Set as Main'),
                                    ],
                                  ),
                                ),
                              if (widget.onDownloadImage != null)
                                const PopupMenuItem(
                                  value: 'download',
                                  child: Row(
                                    children: [
                                      Icon(Icons.download),
                                      SizedBox(width: 8),
                                      Text('Download'),
                                    ],
                                  ),
                                ),
                              if (widget.onShareImage != null)
                                const PopupMenuItem(
                                  value: 'share',
                                  child: Row(
                                    children: [
                                      Icon(Icons.share),
                                      SizedBox(width: 8),
                                      Text('Share'),
                                    ],
                                  ),
                                ),
                              if (widget.allowDeletion && widget.onDeleteImage != null)
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Delete', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                            ],
                            onSelected: (value) {
                              switch (value) {
                                case 'set_main':
                                  widget.onSetAsMain?.call(currentImage.id);
                                  break;
                                case 'download':
                                  widget.onDownloadImage?.call(currentImage.id);
                                  break;
                                case 'share':
                                  widget.onShareImage?.call(currentImage.id);
                                  break;
                                case 'delete':
                                  _showDeleteConfirmation(currentImage);
                                  break;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom controls overlay
          AnimatedOpacity(
            opacity: _showingControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image controls
                      ImageViewerControlsMolecule(
                        canGoPrevious: _currentIndex > 0,
                        canGoNext: _currentIndex < widget.images.length - 1,
                        isZoomed: _isZoomed,
                        showMetadata: _showingMetadata,
                        onPrevious: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        onNext: () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        onToggleMetadata: () {
                          setState(() => _showingMetadata = !_showingMetadata);
                        },
                        onResetZoom: _isZoomed ? _animateResetZoom : null,
                      ),
                      // Thumbnail strip
                      if (widget.images.length > 1)
                        _buildThumbnailStrip(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Zoom controls
          if (widget.allowZoom && _showingControls)
            Positioned(
              right: 16,
              top: MediaQuery.of(context).size.height / 2 - 60,
              child: ZoomControlsAtom(
                isZoomed: _isZoomed,
                onZoomIn: _animateZoomIn,
                onZoomOut: _animateResetZoom,
              ),
            ),

          // Metadata overlay
          if (_showingMetadata && _showingControls)
            Positioned(
              left: 16,
              right: 16,
              bottom: 100,
              child: ImageMetadataCardMolecule(
                fileName: currentImage.fileName,
                fileSize: currentImage.sizeInBytes,
                uploadedAt: currentImage.uploadedAt,
                dimensions: currentImage.dimensions,
                isMain: currentImage.isMain,
                tags: currentImage.tags,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageView(ViewerImage image) {
    if (image.isLoading) {
      return const Center(
        child: AppFullScreenLoadingMolecule(
          message: 'Loading image...',
          backgroundColor: Colors.transparent,
        ),
      );
    }

    if (image.base64Data != null) {
      // Base64 image display would go here
      return Container(
        color: Colors.grey[900],
        child: const Center(
          child: Icon(Icons.image, size: 100, color: Colors.white30),
        ),
      );
    }

    if (image.url != null) {
      return Image.network(
        image.url!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[900],
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 100, color: Colors.white30),
                SizedBox(height: 16),
                Text(
                  'Failed to load image',
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
          );
        },
      );
    }

    return Container(
      color: Colors.grey[900],
      child: const Center(
        child: Icon(Icons.image, size: 100, color: Colors.white30),
      ),
    );
  }

  Widget _buildThumbnailStrip() {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.images.length,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          final isSelected = index == _currentIndex;
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.white30,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Container(
                  color: Colors.grey[800],
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white54,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(ViewerImage image) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Image'),
        content: Text('Are you sure you want to delete "${image.fileName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDeleteImage?.call(image.id);
              if (_currentIndex > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

/// Data model for viewer images
class ViewerImage {
  final String id;
  final String? base64Data;
  final String? url;
  final String fileName;
  final int sizeInBytes;
  final DateTime uploadedAt;
  final String? dimensions;
  final bool isMain;
  final List<String> tags;
  final bool isLoading;

  const ViewerImage({
    required this.id,
    this.base64Data,
    this.url,
    required this.fileName,
    required this.sizeInBytes,
    required this.uploadedAt,
    this.dimensions,
    this.isMain = false,
    this.tags = const [],
    this.isLoading = false,
  });
}
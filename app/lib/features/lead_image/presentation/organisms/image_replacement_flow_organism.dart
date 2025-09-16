import 'package:flutter/material.dart';
import '../atoms/limit_warning_atom.dart';
import '../atoms/slot_indicator_atom.dart';

/// An organism that guides users through the replacement flow for the 11th image
/// Provides clear UI for selecting which image to replace
/// Following atomic design principles - composed from molecules and atoms
class ImageReplacementFlowOrganism extends StatefulWidget {
  final List<ReplacementImage> existingImages;
  final String? newImageData;
  final bool isProcessing;
  final ValueChanged<String>? onReplaceImage;
  final VoidCallback? onCancel;
  final VoidCallback? onSelectNewImage;
  final ValueChanged<String>? onPreviewImage;

  const ImageReplacementFlowOrganism({
    super.key,
    required this.existingImages,
    this.newImageData,
    this.isProcessing = false,
    this.onReplaceImage,
    this.onCancel,
    this.onSelectNewImage,
    this.onPreviewImage,
  });

  @override
  State<ImageReplacementFlowOrganism> createState() =>
      _ImageReplacementFlowOrganismState();
}

class _ImageReplacementFlowOrganismState
    extends State<ImageReplacementFlowOrganism>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String? _selectedImageId;
  int _currentStep = 0;
  bool _showConfirmation = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    _animationController.forward();

    // Determine current step based on state
    if (widget.newImageData != null) {
      _currentStep = 1; // Have new image, need to select replacement
    } else {
      _currentStep = 0; // Need to select new image first
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleImageSelection(String imageId) {
    setState(() {
      _selectedImageId = imageId;
      if (_currentStep == 1 && widget.newImageData != null) {
        _showConfirmation = true;
      }
    });
  }

  void _confirmReplacement() {
    if (_selectedImageId != null) {
      widget.onReplaceImage?.call(_selectedImageId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                _buildHeader(context),

                // Progress indicator
                _buildProgressIndicator(context),

                // Content area
                Expanded(
                  child: _currentStep == 0
                      ? _buildStepSelectNewImage(context)
                      : _buildStepSelectReplacement(context),
                ),

                // Bottom actions
                _buildBottomActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.error.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.swap_horiz,
                  color: colorScheme.onErrorContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Storage Limit Reached',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.error,
                      ),
                    ),
                    Text(
                      'Replace an existing image to add a new one',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: widget.onCancel,
                icon: const Icon(Icons.close),
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 12),
          SlotIndicatorAtom.bar(
            filled: 10,
            total: 10,
          ),
          const SizedBox(height: 8),
          AnimatedLimitWarningAtom(
            currentCount: 10,
            maxCount: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Step 1 indicator
          _buildStepIndicator(
            context,
            1,
            'Select New Image',
            _currentStep >= 0,
            _currentStep == 0,
          ),
          Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: _currentStep >= 1
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          // Step 2 indicator
          _buildStepIndicator(
            context,
            2,
            'Choose Replacement',
            _currentStep >= 1,
            _currentStep == 1,
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(
    BuildContext context,
    int stepNumber,
    String label,
    bool isComplete,
    bool isCurrent,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCurrent
                ? colorScheme.primary
                : isComplete
                    ? colorScheme.primary.withValues(alpha: 0.3)
                    : colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
            border: isCurrent
                ? Border.all(
                    color: colorScheme.primary,
                    width: 2,
                  )
                : null,
          ),
          child: Center(
            child: isComplete && !isCurrent
                ? Icon(
                    Icons.check,
                    size: 16,
                    color: colorScheme.onPrimary,
                  )
                : Text(
                    '$stepNumber',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCurrent || isComplete
                          ? Colors.white
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 10,
            color: isCurrent
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStepSelectNewImage(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.add_photo_alternate,
            size: 64,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'First, select a new image',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the image you want to add',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: widget.onSelectNewImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(width: 16),
            OutlinedButton.icon(
              onPressed: widget.onSelectNewImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Gallery'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStepSelectReplacement(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_showConfirmation && _selectedImageId != null) {
      return _buildConfirmationView(context);
    }

    return Column(
      children: [
        // Instructions
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Select which image to replace with your new one',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Image grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: widget.existingImages.length,
            itemBuilder: (context, index) {
              final image = widget.existingImages[index];
              final isSelected = _selectedImageId == image.id;

              return GestureDetector(
                onTap: () => _handleImageSelection(image.id),
                onLongPress: () => widget.onPreviewImage?.call(image.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : Colors.transparent,
                      width: isSelected ? 3 : 0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          isSelected ? 5 : 8,
                        ),
                        child: Container(
                          color: colorScheme.surfaceContainerHighest,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 32,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${index + 1}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      if (image.isMain)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'MAIN',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onTertiaryContainer,
                              ),
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

        // Selected image info
        if (_selectedImageId != null)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.swap_horiz,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Image ${widget.existingImages.indexWhere((img) => img.id == _selectedImageId) + 1} selected for replacement',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildConfirmationView(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedImage = widget.existingImages.firstWhere(
      (img) => img.id == _selectedImageId,
    );
    final selectedIndex = widget.existingImages.indexOf(selectedImage);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.swap_horiz,
            size: 64,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Confirm Replacement',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: theme.textTheme.bodyLarge,
              children: [
                const TextSpan(text: 'Replace '),
                TextSpan(
                  text: 'Image ${selectedIndex + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.error,
                  ),
                ),
                if (selectedImage.isMain) ...[
                  TextSpan(
                    text: ' (MAIN)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.tertiary,
                    ),
                  ),
                ],
                const TextSpan(text: ' with your new image?'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This action cannot be undone',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => setState(() => _showConfirmation = false),
                child: const Text('Back'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _confirmReplacement,
                icon: const Icon(Icons.check),
                label: const Text('Replace'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: widget.onCancel,
            child: const Text('Cancel'),
          ),
          const Spacer(),
          if (_currentStep == 1 && _selectedImageId != null && !_showConfirmation)
            ElevatedButton.icon(
              onPressed: () => setState(() => _showConfirmation = true),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Continue'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
        ],
      ),
    );
  }
}

/// Data model for replacement images
class ReplacementImage {
  final String id;
  final String? base64Data;
  final String? url;
  final String fileName;
  final int sizeInBytes;
  final bool isMain;
  final DateTime uploadedAt;

  const ReplacementImage({
    required this.id,
    this.base64Data,
    this.url,
    required this.fileName,
    required this.sizeInBytes,
    this.isMain = false,
    required this.uploadedAt,
  });
}
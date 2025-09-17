import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../../core/utils/app_logger.dart';
import '../states/image_gallery_state.dart';
import '../../application/use_cases/get_images_by_lead_use_case.dart';
import '../../application/use_cases/upload_image_use_case.dart';
import '../../application/use_cases/delete_image_use_case.dart';
import '../../application/use_cases/get_image_status_use_case.dart';
import '../../domain/entities/lead_image_entity.dart';

class ImageGalleryViewModel extends BaseViewModel<ImageGalleryState> {
  final GetImagesByLeadUseCase _getImagesByLeadUseCase;
  final UploadImageUseCase _uploadImageUseCase;
  final DeleteImageUseCase _deleteImageUseCase;
  final GetImageStatusUseCase _getImageStatusUseCase;
  final ImagePicker _imagePicker = ImagePicker();

  ImageGalleryViewModel(
    this._getImagesByLeadUseCase,
    this._uploadImageUseCase,
    this._deleteImageUseCase,
    this._getImageStatusUseCase,
    String leadId,
  ) : super(ImageGalleryState(leadId: leadId));

  @override
  void onInit() {
    AppLogger.info('ImageGalleryViewModel initialized for lead: ${state.leadId}');
    fetchImages();
    fetchImageStatus();
  }

  Future<void> fetchImages() async {
    await executeWithLoading(
      operation: () async {
        final result = await _getImagesByLeadUseCase.execute(
          state.leadId,
          pageSize: 10, // Get all 10 images at once
        );
        return result.fold(
          (error) => throw error,
          (images) => images,
        );
      },
      operationName: 'Loading images',
      onSuccess: (images) async {
        // Update images list; do not derive count from page-limited list
        state = state.copyWith(images: images);
        // Refresh authoritative counts from backend
        await fetchImageStatus();
        updateTitle();
        checkLimitWarning();
      },
      onError: (error) {
        state = state.copyWith(errorMessage: error.toString());
        AppLogger.error('Failed to fetch images', error);
      },
    );
  }

  Future<void> fetchImageStatus() async {
    final result = await _getImageStatusUseCase.execute(state.leadId);
    result.fold(
      (error) => AppLogger.error('Failed to fetch image status', error),
      (status) {
        state = state.copyWith(
          currentCount: status['currentCount'] ?? 0,
          maxCount: status['maxCount'] ?? 10,
        );
        checkLimitWarning();
      },
    );
  }

  Future<void> pickAndUploadImage(ImageSource source) async {
    // Check if at limit
    if (state.isAtLimit) {
      state = state.copyWith(
        errorMessage: 'Image limit reached. Delete an image to add more.',
        showLimitWarning: true,
      );
      return;
    }

    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        await uploadImage(pickedFile);
      }
    } catch (e) {
      AppLogger.error('Failed to pick image', e);
      state = state.copyWith(errorMessage: 'Failed to pick image');
    }
  }

  Future<void> uploadImage(XFile imageFile) async {
    state = state.copyWith(isUploading: true, uploadProgress: 0);

    try {
      // Convert to Base64
      final bytes = await imageFile.readAsBytes();
      final base64String = base64.encode(bytes);

      await executeWithLoading(
        operation: () async {
          final result = await _uploadImageUseCase.execute(
            leadId: state.leadId,
            base64Data: base64String,
            fileName: imageFile.name,
            contentType: _getMimeType(imageFile.name),
          );
          return result.fold(
            (error) => throw error,
            (image) => image,
          );
        },
        operationName: 'Uploading image',
        onSuccess: (uploadedImage) async {
          final updatedImages = [...state.images, uploadedImage];
          state = state.copyWith(
            images: updatedImages,
            isUploading: false,
            uploadProgress: null,
          );
          // Use backend to recalc count to avoid drift
          await fetchImageStatus();
          updateTitle();
          checkLimitWarning();
          showSuccessMessage();
        },
        onError: (error) {
          state = state.copyWith(
            isUploading: false,
            uploadProgress: null,
            errorMessage: error.toString(),
          );

          // Show specific message for limit reached
          if (error.toString().contains('limit')) {
            state = state.copyWith(showLimitWarning: true);
          }
        },
      );
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        uploadProgress: null,
        errorMessage: e.toString(),
      );
      AppLogger.error('Failed to upload image', e);
    }
  }

  Future<void> deleteImage(LeadImageEntity image) async {
    state = state.copyWith(isDeleting: true);

    await executeWithLoading(
      operation: () async {
        final result = await _deleteImageUseCase.execute(
          leadId: state.leadId,
          imageId: image.id,
        );
        return result.fold(
          (error) => throw error,
          (_) => null,
        );
      },
      operationName: 'Deleting image',
      onSuccess: (_) async {
        final updatedImages = state.images.where((img) => img.id != image.id).toList();
        state = state.copyWith(
          images: updatedImages,
          isDeleting: false,
          showLimitWarning: false, // Clear warning after delete
        );
        // Refresh authoritative counts from backend
        await fetchImageStatus();
        updateTitle();
        AppLogger.info('Image deleted successfully');
      },
      onError: (error) {
        state = state.copyWith(
          isDeleting: false,
          errorMessage: error.toString(),
        );
        AppLogger.error('Failed to delete image', error);
      },
    );
  }

  void setSelectedIndex(int index) {
    if (index >= 0 && index < state.images.length) {
      state = state.copyWith(selectedIndex: index);
    }
  }

  void updateTitle() {
    setTitle('${state.currentCount} of ${state.maxCount} Images');
  }

  void checkLimitWarning() {
    if (state.isNearLimit && !state.isAtLimit) {
      state = state.copyWith(showLimitWarning: true);
    } else if (!state.isNearLimit) {
      state = state.copyWith(showLimitWarning: false);
    }
  }

  void showSuccessMessage() {
    if (state.isAtLimit) {
      AppLogger.info('Image limit reached for lead: ${state.leadId}');
    } else if (state.slotsAvailable == 1) {
      AppLogger.warning('Only 1 slot remaining for lead: ${state.leadId}');
    }
  }

  String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  void handleLimitReached() {
    state = state.copyWith(
      errorMessage: 'You have reached the maximum of 10 images. Delete an existing image to upload a new one.',
      showLimitWarning: true,
    );
  }

  Future<void> replaceImage(LeadImageEntity oldImage, XFile newImageFile) async {
    // First delete the old image
    await deleteImage(oldImage);

    // Then upload the new one
    if (state.currentCount < state.maxCount) {
      await uploadImage(newImageFile);
    }
  }

  // New methods for simplified flow
  Future<void> pickFromGallery() async {
    await pickAndUploadImage(ImageSource.gallery);
  }

  Future<void> addImageFromPath(String path) async {
    if (state.isAtLimit) {
      state = state.copyWith(
        errorMessage: 'Image limit reached. Delete an image to add more.',
        showLimitWarning: true,
      );
      return;
    }

    final file = File(path);
    if (!file.existsSync()) {
      state = state.copyWith(errorMessage: 'Image file not found');
      return;
    }

    try {
      // Convert to base64
      final bytes = await file.readAsBytes();
      final base64String = base64.encode(bytes);
      final fileName = path.split('/').last;

      // Create temporary image entity for local storage
      final tempImage = LeadImageEntity.create(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        leadId: state.leadId,
        base64String: base64String,
        fileName: fileName,
        contentType: _getMimeType(fileName),
        orderIndex: state.images.length,
      );

      // Add to local state
      final updatedImages = [...state.images, tempImage];
      state = state.copyWith(
        images: updatedImages,
        currentCount: updatedImages.length,
      );

      updateTitle();
      checkLimitWarning();
    } catch (e) {
      AppLogger.error('Failed to add image from path', e);
      state = state.copyWith(errorMessage: 'Failed to add image');
    }
  }

  Future<void> uploadAllImages() async {
    if (state.images.isEmpty) {
      state = state.copyWith(errorMessage: 'No images to upload');
      return;
    }

    state = state.copyWith(isUploading: true, uploadProgress: 0);
    int uploadedCount = 0;

    try {
      for (final image in state.images) {
        // Extract base64 data
        final result = await _uploadImageUseCase.execute(
          leadId: state.leadId,
          base64Data: image.base64Data.value,
          fileName: image.metadata.fileName,
          contentType: image.metadata.contentType,
        );

        result.fold(
          (error) => throw error,
          (_) {
            uploadedCount++;
            state = state.copyWith(
              uploadProgress: uploadedCount / state.images.length,
            );
          },
        );
      }

      // Refresh images after upload
      await fetchImages();
      state = state.copyWith(
        isUploading: false,
        uploadProgress: null,
      );

      AppLogger.info('All images uploaded successfully');
    } catch (e) {
      state = state.copyWith(
        isUploading: false,
        uploadProgress: null,
        errorMessage: 'Failed to upload images: ${e.toString()}',
      );
      AppLogger.error('Failed to upload all images', e);
      rethrow;
    }
  }

  void clearAllImages() {
    state = state.copyWith(
      images: [],
      currentCount: 0,
      showLimitWarning: false,
    );
    updateTitle();
  }
}

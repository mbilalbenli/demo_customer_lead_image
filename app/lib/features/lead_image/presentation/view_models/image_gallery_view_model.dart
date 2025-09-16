import 'dart:convert';
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
      onSuccess: (images) {
        state = state.copyWith(
          images: images,
          currentCount: images.length,
        );
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
        onSuccess: (uploadedImage) {
          final updatedImages = [...state.images, uploadedImage];
          state = state.copyWith(
            images: updatedImages,
            currentCount: updatedImages.length,
            isUploading: false,
            uploadProgress: null,
          );
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
        final result = await _deleteImageUseCase.execute(image.id);
        return result.fold(
          (error) => throw error,
          (_) => null,
        );
      },
      operationName: 'Deleting image',
      onSuccess: (_) {
        final updatedImages = state.images.where((img) => img.id != image.id).toList();
        state = state.copyWith(
          images: updatedImages,
          currentCount: updatedImages.length,
          isDeleting: false,
          showLimitWarning: false, // Clear warning after delete
        );
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
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../domain/constants/image_constants.dart';
import '../../application/use_cases/get_image_status_use_case.dart';
import 'image_providers.dart';

final getIt = GetIt.instance;

// Image Status Provider - Returns current count and availability
final imageStatusProvider = FutureProvider.family<ImageStatus?, String>((ref, leadId) async {
  try {
    final useCase = getIt<GetImageStatusUseCase>();
    final result = await useCase.execute(leadId);

    return result.fold(
      (error) => null,
      (data) => ImageStatus(
        currentCount: data['currentCount'] as int? ?? 0,
        maxCount: data['maxCount'] as int? ?? ImageConstants.maxImagesPerLead,
        canAddMore: data['canAddMore'] as bool? ?? true,
        slotsAvailable: data['slotsAvailable'] as int? ?? ImageConstants.maxImagesPerLead,
      ),
    );
  } catch (e) {
    return null;
  }
});

// Slots Available Provider - Computed from image count
final slotsAvailableProvider = Provider.family<int, String>((ref, leadId) {
  final galleryState = ref.watch(imageGalleryViewModelProvider(leadId));
  final currentCount = galleryState.images.length;
  return ImageConstants.maxImagesPerLead - currentCount;
});

// Can Add Image Provider - Checks if more images can be added
final canAddImageProvider = Provider.family<bool, String>((ref, leadId) {
  final slotsAvailable = ref.watch(slotsAvailableProvider(leadId));
  return slotsAvailable > 0;
});

// Image Limit Reached Provider
final imageLimitReachedProvider = Provider.family<bool, String>((ref, leadId) {
  final slotsAvailable = ref.watch(slotsAvailableProvider(leadId));
  return slotsAvailable == 0;
});

// Near Limit Warning Provider (shows warning at 8+ images)
final nearLimitWarningProvider = Provider.family<bool, String>((ref, leadId) {
  final galleryState = ref.watch(imageGalleryViewModelProvider(leadId));
  final currentCount = galleryState.images.length;
  return currentCount >= 8 && currentCount < ImageConstants.maxImagesPerLead;
});

// Limit Message Provider - Returns appropriate message based on count
final limitMessageProvider = Provider.family<String, String>((ref, leadId) {
  final slotsAvailable = ref.watch(slotsAvailableProvider(leadId));
  final galleryState = ref.watch(imageGalleryViewModelProvider(leadId));
  final currentCount = galleryState.images.length;

  if (slotsAvailable == 0) {
    return 'Maximum ${ImageConstants.maxImagesPerLead} images reached. Delete an image to add more.';
  } else if (slotsAvailable == 1) {
    return 'You can add 1 more image';
  } else if (currentCount >= 8) {
    return 'You can add $slotsAvailable more images (approaching limit)';
  } else {
    return '$currentCount of ${ImageConstants.maxImagesPerLead} images';
  }
});

// Upload Button State Provider
final uploadButtonStateProvider = Provider.family<UploadButtonState, String>((ref, leadId) {
  final canAdd = ref.watch(canAddImageProvider(leadId));
  final limitReached = ref.watch(imageLimitReachedProvider(leadId));
  final galleryState = ref.watch(imageGalleryViewModelProvider(leadId));

  if (galleryState.isUploading) {
    return UploadButtonState.uploading;
  } else if (limitReached) {
    return UploadButtonState.disabled;
  } else if (!canAdd) {
    return UploadButtonState.replace;
  } else {
    return UploadButtonState.enabled;
  }
});

// Image Count Display Provider
final imageCountDisplayProvider = Provider.family<String, String>((ref, leadId) {
  final galleryState = ref.watch(imageGalleryViewModelProvider(leadId));
  final currentCount = galleryState.images.length;
  final maxCount = ImageConstants.maxImagesPerLead;
  return '$currentCount / $maxCount';
});

// Replacement Suggestion Provider
final shouldSuggestReplacementProvider = Provider.family<bool, String>((ref, leadId) {
  final limitReached = ref.watch(imageLimitReachedProvider(leadId));
  final galleryState = ref.watch(imageGalleryViewModelProvider(leadId));

  // Suggest replacement if limit reached and user attempted to add more
  return limitReached && galleryState.lastAction == ImageAction.attemptedUpload;
});

// Selected Images for Replacement Provider
final selectedForReplacementProvider = StateProvider<String?>((ref) => null);

// Batch Upload Availability Provider
final canBatchUploadProvider = Provider.family<int, String>((ref, leadId) {
  final slotsAvailable = ref.watch(slotsAvailableProvider(leadId));
  // Return how many images can be uploaded in batch
  return slotsAvailable;
});

// Upload Queue Provider
final uploadQueueProvider = StateProvider.family<List<UploadQueueItem>, String>(
  (ref, leadId) => [],
);

// Models
enum UploadButtonState {
  enabled,
  disabled,
  replace,
  uploading,
}

enum ImageAction {
  none,
  attemptedUpload,
  uploaded,
  deleted,
  replaced,
}

class UploadQueueItem {
  final String id;
  final String leadId;
  final String base64Data;
  final String? fileName;
  final DateTime addedAt;
  final UploadStatus status;
  final double? progress;
  final String? error;

  UploadQueueItem({
    required this.id,
    required this.leadId,
    required this.base64Data,
    this.fileName,
    required this.addedAt,
    this.status = UploadStatus.pending,
    this.progress,
    this.error,
  });

  UploadQueueItem copyWith({
    UploadStatus? status,
    double? progress,
    String? error,
  }) {
    return UploadQueueItem(
      id: id,
      leadId: leadId,
      base64Data: base64Data,
      fileName: fileName,
      addedAt: addedAt,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      error: error ?? this.error,
    );
  }
}

enum UploadStatus {
  pending,
  uploading,
  completed,
  failed,
}

class ImageStatus {
  final int currentCount;
  final int maxCount;
  final bool canAddMore;
  final int slotsAvailable;

  ImageStatus({
    required this.currentCount,
    required this.maxCount,
    required this.canAddMore,
    required this.slotsAvailable,
  });
}
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../states/image_gallery_state.dart';
import '../view_models/image_gallery_view_model.dart';
import '../../application/use_cases/get_images_by_lead_use_case.dart';
import '../../application/use_cases/upload_image_use_case.dart';
import '../../application/use_cases/delete_image_use_case.dart';
import '../../application/use_cases/get_image_status_use_case.dart';

final getIt = GetIt.instance;

// Image Gallery Provider - Family provider for different lead IDs
final imageGalleryViewModelProvider =
    StateNotifierProvider.family<ImageGalleryViewModel, ImageGalleryState, String>(
  (ref, leadId) => ImageGalleryViewModel(
    getIt<GetImagesByLeadUseCase>(),
    getIt<UploadImageUseCase>(),
    getIt<DeleteImageUseCase>(),
    getIt<GetImageStatusUseCase>(),
    leadId,
  ),
);

// Image Upload Progress Provider
final imageUploadProgressProvider = StateProvider<double?>((ref) => null);

// Image Limit Warning Provider
final imageLimitWarningProvider = StateProvider<bool>((ref) => false);
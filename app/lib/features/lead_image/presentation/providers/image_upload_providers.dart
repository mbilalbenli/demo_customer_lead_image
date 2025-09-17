import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import '../../application/use_cases/batch_upload_images_use_case.dart';
import '../../application/use_cases/validate_images_use_case.dart';
import '../../application/use_cases/compress_image_use_case.dart';
import '../states/image_upload_state.dart';
import '../view_models/image_upload_view_model.dart';

final imageUploadViewModelProvider = StateNotifierProvider.family<ImageUploadViewModel, ImageUploadState, String>((ref, leadId) {
  final sl = GetIt.I;
  return ImageUploadViewModel(
    leadId: leadId,
    batchUploadImages: sl<BatchUploadImagesUseCase>(),
    validateImages: sl<ValidateImagesUseCase>(),
    compressImage: sl<CompressImageUseCase>(),
  );
});


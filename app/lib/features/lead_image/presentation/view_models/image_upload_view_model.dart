import 'dart:math';
import 'package:uuid/uuid.dart';
import '../../../../core/base/base_view_model.dart';
import '../../../lead_image/domain/entities/upload_options_entity.dart';
import '../../../lead_image/domain/entities/upload_queue_item_entity.dart';
import '../../application/use_cases/batch_upload_images_use_case.dart';
import '../../application/use_cases/validate_images_use_case.dart';
import '../../application/use_cases/compress_image_use_case.dart';
import '../states/image_upload_state.dart';

class ImageUploadViewModel extends BaseViewModel<ImageUploadState> {
  final BatchUploadImagesUseCase batchUploadImages;
  final ValidateImagesUseCase validateImages;
  final CompressImageUseCase compressImage;
  final _uuid = const Uuid();

  ImageUploadViewModel({
    required String leadId,
    required this.batchUploadImages,
    required this.validateImages,
    required this.compressImage,
  }) : super(ImageUploadState(leadId: leadId));

  void addToQueue(List<Map<String, String>> files) async {
    final items = files.map((f) {
      final b64 = f['base64Data'] ?? '';
      final size = _calcSize(b64);
      return UploadQueueItemEntity(
        id: _uuid.v4(),
        leadId: state.leadId,
        fileName: f['fileName'] ?? 'image.jpg',
        base64Data: b64,
        contentType: f['contentType'] ?? 'image/jpeg',
        sizeBytes: size,
      );
    }).toList();

    state = state.copyWith(queue: [...state.queue, ...items]);
  }

  Future<void> startUpload() async {
    if (state.queue.isEmpty) return;
    state = state.copyWith(isUploading: true, totalProgress: 0);

    // validate first
    final payload = state.queue.map((i) => {
          'base64Data': i.base64Data,
          'fileName': i.fileName,
          'contentType': i.contentType,
        }).toList();
    final results = await validateImages.execute(payload);
    final invalid = results.where((r) => !r.isValid).toList();
    if (invalid.isNotEmpty) {
      state = state.copyWith(
        isUploading: false,
        errorMessage: 'Some images failed validation. Please review.',
      );
      return;
    }

    // upload in batch (repository may loop internally)
    await executeWithLoading(
      operation: () async {
        final res = await batchUploadImages.execute(leadId: state.leadId, images: payload);
        return res;
      },
      operationName: 'Uploading images',
      onSuccess: (_) {
        // mark complete
        final updated = state.queue
            .map((q) => q.copyWith(progress: 1.0, status: UploadStatus.complete))
            .toList();
        state = state.copyWith(queue: updated, isUploading: false, totalProgress: 1.0);
      },
      onError: (e) {
        state = state.copyWith(isUploading: false, errorMessage: e.toString());
      },
    );
  }

  void removeItem(String id) {
    state = state.copyWith(queue: state.queue.where((q) => q.id != id).toList());
  }

  void clearQueue() {
    state = state.copyWith(queue: []);
  }

  void updateOptions(UploadOptionsEntity options) {
    state = state.copyWith(options: options);
  }

  int _calcSize(String base64) {
    final padding = base64.endsWith('==') ? 2 : base64.endsWith('=') ? 1 : 0;
    return max(0, ((base64.length * 3) ~/ 4) - padding);
  }
}

import '../../../../core/utils/app_logger.dart';
import '../../data/services/base64_encoder_service.dart';

class ImageValidationResult {
  final String fileName;
  final String contentType;
  final int sizeBytes;
  final bool isValid;
  final bool exceedsLimit;
  final String? errorMessage;

  ImageValidationResult({
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
    required this.isValid,
    required this.exceedsLimit,
    this.errorMessage,
  });
}

class ValidateImagesUseCase {
  Future<List<ImageValidationResult>> execute(List<Map<String, String>> images, {int maxBytes = 5 * 1024 * 1024}) async {
    final results = <ImageValidationResult>[];
    for (final img in images) {
      try {
        final base64 = img['base64Data'] ?? '';
        final fileName = img['fileName'] ?? 'image.jpg';
        final contentType = img['contentType'] ?? Base64EncoderService.extractMimeType(base64);
        final size = Base64EncoderService.calculateBase64Size(base64);
        final valid = Base64EncoderService.isValidBase64Image(base64);
        final exceeds = size > maxBytes;
        results.add(ImageValidationResult(
          fileName: fileName,
          contentType: contentType,
          sizeBytes: size,
          isValid: valid && !exceeds,
          exceedsLimit: exceeds,
          errorMessage: valid ? null : 'Invalid base64 image',
        ));
      } catch (e) {
        AppLogger.error('Validation failed', e);
        results.add(ImageValidationResult(
          fileName: img['fileName'] ?? 'image.jpg',
          contentType: 'application/octet-stream',
          sizeBytes: 0,
          isValid: false,
          exceedsLimit: false,
          errorMessage: e.toString(),
        ));
      }
    }
    return results;
  }
}

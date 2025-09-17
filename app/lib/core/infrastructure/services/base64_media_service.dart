import 'dart:typed_data';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../utils/app_logger.dart';
import '../../../features/lead_image/data/services/base64_encoder_service.dart';
import '../../../features/lead_image/data/services/image_compressor_service.dart';
import '../../../features/lead_image/domain/constants/image_constants.dart';

class Base64MediaService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<String?> pickImageAsBase64({
    required ImageSource source,
    bool compress = true,
    int? maxWidth,
    int? maxHeight,
    int quality = ImageConstants.compressionQuality,
  }) async {
    try {
      AppLogger.info('Picking image from ${source.name}');

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: compress ? quality : 100,
      );

      if (pickedFile == null) {
        AppLogger.info('No image selected');
        return null;
      }

      final bytes = await pickedFile.readAsBytes();
      AppLogger.info('Image picked, size: ${bytes.length} bytes');

      // Compress if needed
      Uint8List finalBytes = bytes;
      if (compress && bytes.length > ImageConstants.compressionThreshold) {
        AppLogger.info('Compressing image before encoding');
        finalBytes = await ImageCompressorService.compressImage(
          bytes,
          quality: quality,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        );
      }

      // Convert to Base64
      final base64String = await Base64EncoderService.encodeImageToBase64(
        finalBytes,
        mimeType: _getMimeType(pickedFile.path),
        includeDataUri: true,
      );

      AppLogger.info('Image encoded to Base64, length: ${base64String.length}');
      return base64String;
    } catch (e) {
      AppLogger.error('Failed to pick image as Base64', e);
      return null;
    }
  }

  Future<List<String>?> pickMultipleImagesAsBase64({
    bool compress = true,
    int? maxWidth,
    int? maxHeight,
    int quality = ImageConstants.compressionQuality,
    int maxImages = ImageConstants.maxImagesPerLead,
  }) async {
    try {
      AppLogger.info('Picking multiple images, max: $maxImages');

      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: compress ? quality : 100,
      );

      if (pickedFiles.isEmpty) {
        AppLogger.info('No images selected');
        return null;
      }

      // Limit to maxImages
      final filesToProcess = pickedFiles.take(maxImages).toList();
      AppLogger.info('Processing ${filesToProcess.length} images');

      final List<String> base64Images = [];

      for (final file in filesToProcess) {
        final bytes = await file.readAsBytes();

        // Compress if needed
        Uint8List finalBytes = bytes;
        if (compress && bytes.length > ImageConstants.compressionThreshold) {
          finalBytes = await ImageCompressorService.compressImage(
            bytes,
            quality: quality,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
          );
        }

        // Convert to Base64
        final base64String = await Base64EncoderService.encodeImageToBase64(
          finalBytes,
          mimeType: _getMimeType(file.path),
          includeDataUri: true,
        );

        base64Images.add(base64String);
      }

      AppLogger.info('Encoded ${base64Images.length} images to Base64');
      return base64Images;
    } catch (e) {
      AppLogger.error('Failed to pick multiple images as Base64', e);
      return null;
    }
  }

  Future<File?> saveBase64ImageToFile(
    String base64String, {
    String? fileName,
  }) async {
    try {
      AppLogger.info('Saving Base64 image to file');

      final bytes = Base64EncoderService.decodeBase64ToImage(base64String);
      final tempDir = await getTemporaryDirectory();

      final String name = fileName ??
        'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File('${tempDir.path}/$name');

      await file.writeAsBytes(bytes);
      AppLogger.info('Image saved to: ${file.path}');

      return file;
    } catch (e) {
      AppLogger.error('Failed to save Base64 image to file', e);
      return null;
    }
  }

  Future<String?> captureImageAsBase64({
    bool compress = true,
    int? maxWidth,
    int? maxHeight,
    int quality = ImageConstants.compressionQuality,
    CameraDevice preferredCamera = CameraDevice.rear,
  }) async {
    try {
      AppLogger.info('Capturing image from camera');

      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: preferredCamera,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: compress ? quality : 100,
      );

      if (photo == null) {
        AppLogger.info('No photo captured');
        return null;
      }

      final bytes = await photo.readAsBytes();
      AppLogger.info('Photo captured, size: ${bytes.length} bytes');

      // Compress if needed
      Uint8List finalBytes = bytes;
      if (compress && bytes.length > ImageConstants.compressionThreshold) {
        AppLogger.info('Compressing photo before encoding');
        finalBytes = await ImageCompressorService.compressImage(
          bytes,
          quality: quality,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        );
      }

      // Convert to Base64
      final base64String = await Base64EncoderService.encodeImageToBase64(
        finalBytes,
        mimeType: 'image/jpeg',
        includeDataUri: true,
      );

      AppLogger.info('Photo encoded to Base64, length: ${base64String.length}');
      return base64String;
    } catch (e) {
      AppLogger.error('Failed to capture image as Base64', e);
      return null;
    }
  }

  Future<Uint8List?> createThumbnailFromBase64(
    String base64String, {
    int size = ImageConstants.thumbnailSize,
  }) async {
    try {
      AppLogger.info('Creating thumbnail from Base64');

      final bytes = Base64EncoderService.decodeBase64ToImage(base64String);
      final thumbnail = await Base64EncoderService.createThumbnail(
        bytes,
        size: size,
      );

      AppLogger.info('Thumbnail created, size: ${thumbnail.length} bytes');
      return thumbnail;
    } catch (e) {
      AppLogger.error('Failed to create thumbnail from Base64', e);
      return null;
    }
  }

  String _getMimeType(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'jpg':
      case 'jpeg':
      default:
        return 'image/jpeg';
    }
  }

  bool isBase64ImageValid(String base64String) {
    return Base64EncoderService.isValidBase64Image(base64String);
  }

  int getBase64ImageSize(String base64String) {
    return Base64EncoderService.calculateBase64Size(base64String);
  }

  String extractMimeType(String base64String) {
    return Base64EncoderService.extractMimeType(base64String);
  }
}
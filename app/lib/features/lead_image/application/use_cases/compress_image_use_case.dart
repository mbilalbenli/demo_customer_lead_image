import 'dart:typed_data';
import '../../data/services/image_compressor_service.dart';
import '../../data/services/base64_encoder_service.dart';

class CompressImageUseCase {
  Future<String> execute(Uint8List bytes, {String? mimeType, int quality = 85}) async {
    final compressed = await ImageCompressorService.compressImage(bytes, quality: quality);
    return Base64EncoderService.encodeImageToBase64(compressed, mimeType: mimeType, includeDataUri: true);
  }
}


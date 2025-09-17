import 'dart:typed_data';

class PickedFileData {
  final String fileName;
  final String contentType;
  final Uint8List bytes;
  PickedFileData({required this.fileName, required this.contentType, required this.bytes});
}

class FilePickerService {
  Future<List<PickedFileData>> pickMultipleImages() async {
    // Stub - integrate real picker per platform
    return [];
  }
}


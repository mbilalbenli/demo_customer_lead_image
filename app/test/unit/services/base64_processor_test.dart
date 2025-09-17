import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/core/security/base64_validator.dart';
import 'package:app/core/security/image_encryption.dart';
import 'package:app/features/lead_image/domain/constants/image_constants.dart';

void main() {
  group('Base64 Processor Tests', () {
    group('Base64 Validation', () {
      test('should validate correct Base64 string', () {
        // Arrange
        const validBase64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChAFtSUj7EQAAAABJRU5ErkJggg==';

        // Act
        final result = Base64Validator.validateBase64Image(validBase64);

        // Assert
        expect(result.isValid, true);
        expect(result.errorMessage, null);
        expect(result.cleanBase64, isNotNull);
      });

      test('should reject empty Base64 string', () {
        // Arrange
        const emptyBase64 = '';

        // Act
        final result = Base64Validator.validateBase64Image(emptyBase64);

        // Assert
        expect(result.isValid, false);
        expect(result.errorMessage, contains('empty'));
      });

      test('should reject invalid Base64 format', () {
        // Arrange
        const invalidBase64 = 'this-is-not-base64!@#\$%';

        // Act
        final result = Base64Validator.validateBase64Image(invalidBase64);

        // Assert
        expect(result.isValid, false);
        expect(result.errorMessage, contains('Invalid Base64 format'));
      });

      test('should handle data URL prefix correctly', () {
        // Arrange
        const dataUrl = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChAFtSUj7EQAAAABJRU5ErkJggg==';

        // Act
        final result = Base64Validator.validateBase64Image(dataUrl);

        // Assert
        expect(result.isValid, true);
        expect(result.cleanBase64, isNotNull);
        expect(result.cleanBase64, isNot(contains('data:')));
      });

      test('should reject oversized images', () {
        // Arrange - Create a large Base64 string
        final largeData = Uint8List(ImageConstants.maxImageSizeBytes + 1);
        largeData.fillRange(0, largeData.length, 65); // Fill with 'A'
        final largeBase64 = base64Encode(largeData);

        // Act
        final result = Base64Validator.validateBase64Image(largeBase64);

        // Assert
        expect(result.isValid, false);
        expect(result.errorMessage, contains('exceeds maximum'));
      });

      test('should detect suspicious content', () {
        // Arrange - Create Base64 with script content
        const suspiciousContent = '<script>alert("malicious")</script>';
        final suspiciousBase64 = base64Encode(utf8.encode(suspiciousContent));

        // Act
        final result = Base64Validator.validateBase64Image(suspiciousBase64);

        // Assert
        expect(result.isValid, false);
        expect(result.errorMessage, contains('Suspicious content'));
      });

      test('should validate JPEG file signature', () {
        // Arrange - Create minimal JPEG header
        final jpegBytes = Uint8List.fromList([
          0xFF, 0xD8, 0xFF, 0xE0, // JPEG SOI + APP0
          0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, 0x01, // JFIF header
          0xFF, 0xD9 // EOI
        ]);
        final jpegBase64 = base64Encode(jpegBytes);

        // Act
        final result = Base64Validator.validateBase64Image(jpegBase64);

        // Assert
        expect(result.isValid, true);
      });

      test('should validate PNG file signature', () {
        // Arrange - Create minimal PNG header
        final pngBytes = Uint8List.fromList([
          0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
          0x00, 0x00, 0x00, 0x0D, // IHDR length
          0x49, 0x48, 0x44, 0x52, // IHDR
          0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, // 1x1 image
          0x08, 0x02, 0x00, 0x00, 0x00 // bit depth, color type, etc.
        ]);
        final pngBase64 = base64Encode(pngBytes);

        // Act
        final result = Base64Validator.validateBase64Image(pngBase64);

        // Assert
        expect(result.isValid, true);
      });

      test('should reject unsupported file types', () {
        // Arrange - Create PDF header
        final pdfBytes = Uint8List.fromList([
          0x25, 0x50, 0x44, 0x46, 0x2D, // %PDF-
        ]);
        final pdfBase64 = base64Encode(pdfBytes);

        // Act
        final result = Base64Validator.validateBase64Image(pdfBase64);

        // Assert
        expect(result.isValid, false);
        expect(result.errorMessage, contains('Unsupported file type'));
      });
    });

    group('Image Encryption', () {
      test('should encrypt and decrypt Base64 data successfully', () {
        // Arrange
        const originalData = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChAFtSUj7EQAAAABJRU5ErkJggg==';

        // Act
        final encryptionResult = ImageEncryption.encryptBase64(base64Data: originalData);
        expect(encryptionResult.success, true);

        final decryptionResult = ImageEncryption.decryptBase64(
          encryptedBase64: encryptionResult.encryptedData!,
          keyBase64: encryptionResult.key!,
        );

        // Assert
        expect(decryptionResult.success, true);
        expect(decryptionResult.decryptedData, equals(originalData));
      });

      test('should fail decryption with wrong key', () {
        // Arrange
        const originalData = 'test-base64-data';
        final encryptionResult = ImageEncryption.encryptBase64(base64Data: originalData);
        final wrongKey = 'wrong-key-base64-encoded-data';

        // Act
        final decryptionResult = ImageEncryption.decryptBase64(
          encryptedBase64: encryptionResult.encryptedData!,
          keyBase64: wrongKey,
        );

        // Assert
        expect(decryptionResult.success, false);
        expect(decryptionResult.errorMessage, isNotNull);
      });

      test('should generate different keys for different users', () {
        // Arrange
        const userId1 = 'user-123';
        const userId2 = 'user-456';
        const leadId = 'lead-789';

        // Act
        final key1 = ImageEncryption.generateUserKey(userId1, leadId);
        final key2 = ImageEncryption.generateUserKey(userId2, leadId);

        // Assert
        expect(key1, isNot(equals(key2)));
      });

      test('should encrypt and decrypt metadata', () {
        // Arrange
        final originalMetadata = {
          'fileName': 'test.jpg',
          'contentType': 'image/jpeg',
          'uploadedAt': '2024-01-01T12:00:00Z',
          'sizeInBytes': 1024,
        };

        // Act
        final encryptedMetadata = ImageEncryption.encryptMetadata(originalMetadata);
        final decryptedMetadata = ImageEncryption.decryptMetadata(encryptedMetadata);

        // Assert
        expect(decryptedMetadata['fileName'], equals('test.jpg'));
        expect(decryptedMetadata['contentType'], equals('image/jpeg'));
        expect(decryptedMetadata['uploadedAt'], equals('2024-01-01T12:00:00Z'));
        expect(decryptedMetadata['sizeInBytes'], equals('1024'));
      });

      test('should handle encryption of empty data', () {
        // Arrange
        const emptyData = '';

        // Act
        final result = ImageEncryption.encryptBase64(base64Data: emptyData);

        // Assert
        expect(result.success, true);
        expect(result.encryptedData, isNotNull);
        expect(result.key, isNotNull);
      });

      test('should handle encryption of large data', () {
        // Arrange
        final largeData = 'A' * 10000; // Large Base64 string

        // Act
        final result = ImageEncryption.encryptBase64(base64Data: largeData);

        // Assert
        expect(result.success, true);
        expect(result.encryptedData, isNotNull);
        expect(result.key, isNotNull);
      });
    });

    group('Security Features', () {
      test('should sanitize Base64 string', () {
        // Arrange
        const dirtyBase64 = 'ABC123+/=\n\r\t\x00invalid-chars';

        // Act
        final sanitized = Base64Validator.sanitizeBase64(dirtyBase64);

        // Assert
        expect(sanitized, equals('ABC123+/='));
        expect(sanitized, isNot(contains('\n')));
        expect(sanitized, isNot(contains('\r')));
        expect(sanitized, isNot(contains('\t')));
        expect(sanitized, isNot(contains('invalid')));
      });

      test('should generate content hash for integrity', () {
        // Arrange
        const data1 = 'test-data-1';
        const data2 = 'test-data-2';
        final bytes1 = Uint8List.fromList(utf8.encode(data1));
        final bytes2 = Uint8List.fromList(utf8.encode(data2));

        // Act
        final hash1 = Base64Validator.generateContentHash(bytes1);
        final hash2 = Base64Validator.generateContentHash(bytes2);
        final hash1Duplicate = Base64Validator.generateContentHash(bytes1);

        // Assert
        expect(hash1, isNot(equals(hash2))); // Different data should have different hashes
        expect(hash1, equals(hash1Duplicate)); // Same data should have same hash
      });

      test('should verify data integrity', () {
        // Arrange
        const originalData = 'test-base64-data';
        const modifiedData = 'test-base64-data-modified';

        // Calculate original hash
        final originalBytes = Uint8List.fromList(utf8.encode(originalData));
        final originalHash = Base64Validator.generateContentHash(originalBytes);

        // Act & Assert
        expect(ImageEncryption.verifyIntegrity(
          originalHash: originalHash,
          decryptedData: originalData,
        ), true);

        expect(ImageEncryption.verifyIntegrity(
          originalHash: originalHash,
          decryptedData: modifiedData,
        ), false);
      });
    });

    group('Performance Tests', () {
      test('should handle validation of multiple images efficiently', () async {
        // Arrange
        final testImages = List.generate(100, (index) {
          final testData = 'test-image-data-$index';
          return base64Encode(utf8.encode(testData));
        });

        // Act
        final stopwatch = Stopwatch()..start();
        final results = testImages.map((image) =>
          Base64Validator.validateBase64Image(image)
        ).toList();
        stopwatch.stop();

        // Assert
        expect(results.length, equals(100));
        expect(stopwatch.elapsedMilliseconds, lessThan(1000)); // Should complete in under 1 second
      });

      test('should handle encryption/decryption of multiple images efficiently', () {
        // Arrange
        final testImages = List.generate(10, (index) => 'test-image-$index');

        // Act
        final stopwatch = Stopwatch()..start();
        final results = testImages.map((image) {
          final encrypted = ImageEncryption.encryptBase64(base64Data: image);
          final decrypted = ImageEncryption.decryptBase64(
            encryptedBase64: encrypted.encryptedData!,
            keyBase64: encrypted.key!,
          );
          return decrypted.success && decrypted.decryptedData == image;
        }).toList();
        stopwatch.stop();

        // Assert
        expect(results.every((result) => result), true);
        expect(stopwatch.elapsedMilliseconds, lessThan(500)); // Should complete efficiently
      });
    });
  });
}
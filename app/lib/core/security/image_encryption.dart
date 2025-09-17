import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

/// Simple encryption service for sensitive image data
/// Note: This is a basic implementation. For production, use proper crypto libraries
class ImageEncryption {
  static const int _keySize = 32; // 256-bit key
  static const int _ivSize = 16; // 128-bit IV

  /// Encrypt Base64 image data
  static EncryptionResult encryptBase64({
    required String base64Data,
    String? customKey,
  }) {
    try {
      // Generate or use provided key
      final key = customKey != null
          ? _padKey(customKey)
          : _generateKey();

      // Generate initialization vector
      final iv = _generateIV();

      // Convert base64 to bytes
      final dataBytes = utf8.encode(base64Data);

      // Simple XOR encryption (use proper AES in production)
      final encryptedBytes = _xorEncrypt(dataBytes, key, iv);

      // Combine IV + encrypted data
      final combined = Uint8List.fromList([...iv, ...encryptedBytes]);

      // Encode to base64
      final encryptedBase64 = base64Encode(combined);

      return EncryptionResult.success(
        encryptedData: encryptedBase64,
        key: base64Encode(key),
        metadata: EncryptionMetadata(
          algorithm: 'XOR-256',
          keySize: _keySize,
          ivSize: _ivSize,
          timestamp: DateTime.now(),
        ),
      );

    } catch (e) {
      return EncryptionResult.failure('Encryption failed: ${e.toString()}');
    }
  }

  /// Decrypt Base64 image data
  static DecryptionResult decryptBase64({
    required String encryptedBase64,
    required String keyBase64,
  }) {
    try {
      // Decode key
      final key = base64Decode(keyBase64);
      if (key.length != _keySize) {
        return DecryptionResult.failure('Invalid key size');
      }

      // Decode encrypted data
      final combined = base64Decode(encryptedBase64);
      if (combined.length < _ivSize) {
        return DecryptionResult.failure('Invalid encrypted data size');
      }

      // Extract IV and encrypted data
      final iv = combined.sublist(0, _ivSize);
      final encryptedBytes = combined.sublist(_ivSize);

      // Decrypt
      final decryptedBytes = _xorDecrypt(encryptedBytes, key, iv);

      // Convert back to string
      final decryptedBase64 = utf8.decode(decryptedBytes);

      return DecryptionResult.success(decryptedBase64);

    } catch (e) {
      return DecryptionResult.failure('Decryption failed: ${e.toString()}');
    }
  }

  /// Generate a secure random key
  static Uint8List _generateKey() {
    final random = Random.secure();
    final key = Uint8List(_keySize);
    for (int i = 0; i < _keySize; i++) {
      key[i] = random.nextInt(256);
    }
    return key;
  }

  /// Generate a secure random IV
  static Uint8List _generateIV() {
    final random = Random.secure();
    final iv = Uint8List(_ivSize);
    for (int i = 0; i < _ivSize; i++) {
      iv[i] = random.nextInt(256);
    }
    return iv;
  }

  /// Pad or truncate key to required size
  static Uint8List _padKey(String key) {
    final keyBytes = utf8.encode(key);
    final paddedKey = Uint8List(_keySize);

    if (keyBytes.length >= _keySize) {
      // Truncate if too long
      paddedKey.setRange(0, _keySize, keyBytes);
    } else {
      // Pad if too short
      paddedKey.setRange(0, keyBytes.length, keyBytes);
      // Fill remaining with hash of key
      final hash = _simpleHash(keyBytes);
      for (int i = keyBytes.length; i < _keySize; i++) {
        paddedKey[i] = hash[i % hash.length];
      }
    }

    return paddedKey;
  }

  /// Simple hash function (use proper crypto hash in production)
  static Uint8List _simpleHash(Uint8List data) {
    final hash = Uint8List(16);
    int acc = 0;

    for (int i = 0; i < data.length; i++) {
      acc = (acc + data[i] * (i + 1)) % 255;
      hash[i % 16] ^= acc;
    }

    return hash;
  }

  /// XOR encryption (simple implementation for demo)
  static Uint8List _xorEncrypt(Uint8List data, Uint8List key, Uint8List iv) {
    final encrypted = Uint8List(data.length);

    for (int i = 0; i < data.length; i++) {
      final keyByte = key[i % key.length];
      final ivByte = iv[i % iv.length];
      encrypted[i] = data[i] ^ keyByte ^ ivByte;
    }

    return encrypted;
  }

  /// XOR decryption
  static Uint8List _xorDecrypt(Uint8List encryptedData, Uint8List key, Uint8List iv) {
    // XOR is symmetric, so decryption is the same as encryption
    return _xorEncrypt(encryptedData, key, iv);
  }

  /// Encrypt image metadata
  static Map<String, String> encryptMetadata(Map<String, dynamic> metadata) {
    final encrypted = <String, String>{};

    for (final entry in metadata.entries) {
      final key = entry.key;
      final value = entry.value.toString();

      // Simple obfuscation for metadata
      final obfuscated = base64Encode(utf8.encode(value));
      encrypted[key] = obfuscated;
    }

    return encrypted;
  }

  /// Decrypt image metadata
  static Map<String, dynamic> decryptMetadata(Map<String, String> encryptedMetadata) {
    final decrypted = <String, dynamic>{};

    for (final entry in encryptedMetadata.entries) {
      final key = entry.key;
      final encryptedValue = entry.value;

      try {
        final decodedBytes = base64Decode(encryptedValue);
        final decryptedValue = utf8.decode(decodedBytes);
        decrypted[key] = decryptedValue;
      } catch (e) {
        // If decryption fails, keep original value
        decrypted[key] = encryptedValue;
      }
    }

    return decrypted;
  }

  /// Generate encryption key from user data (for consistent keys)
  static String generateUserKey(String userId, String leadId) {
    final combined = '$userId:$leadId:${DateTime.now().year}';
    final hash = _simpleHash(utf8.encode(combined));
    return base64Encode(hash);
  }

  /// Verify data integrity
  static bool verifyIntegrity({
    required String originalHash,
    required String decryptedData,
  }) {
    final currentHash = _calculateDataHash(decryptedData);
    return originalHash == currentHash;
  }

  /// Calculate data hash for integrity checking
  static String _calculateDataHash(String data) {
    final bytes = utf8.encode(data);
    final hash = _simpleHash(bytes);
    return base64Encode(hash);
  }
}

/// Result of encryption operation
class EncryptionResult {
  final bool success;
  final String? encryptedData;
  final String? key;
  final String? errorMessage;
  final EncryptionMetadata? metadata;

  const EncryptionResult._({
    required this.success,
    this.encryptedData,
    this.key,
    this.errorMessage,
    this.metadata,
  });

  factory EncryptionResult.success({
    required String encryptedData,
    required String key,
    EncryptionMetadata? metadata,
  }) {
    return EncryptionResult._(
      success: true,
      encryptedData: encryptedData,
      key: key,
      metadata: metadata,
    );
  }

  factory EncryptionResult.failure(String errorMessage) {
    return EncryptionResult._(
      success: false,
      errorMessage: errorMessage,
    );
  }
}

/// Result of decryption operation
class DecryptionResult {
  final bool success;
  final String? decryptedData;
  final String? errorMessage;

  const DecryptionResult._({
    required this.success,
    this.decryptedData,
    this.errorMessage,
  });

  factory DecryptionResult.success(String decryptedData) {
    return DecryptionResult._(
      success: true,
      decryptedData: decryptedData,
    );
  }

  factory DecryptionResult.failure(String errorMessage) {
    return DecryptionResult._(
      success: false,
      errorMessage: errorMessage,
    );
  }
}

/// Metadata about encryption
class EncryptionMetadata {
  final String algorithm;
  final int keySize;
  final int ivSize;
  final DateTime timestamp;

  const EncryptionMetadata({
    required this.algorithm,
    required this.keySize,
    required this.ivSize,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'algorithm': algorithm,
    'keySize': keySize,
    'ivSize': ivSize,
    'timestamp': timestamp.toIso8601String(),
  };

  factory EncryptionMetadata.fromJson(Map<String, dynamic> json) {
    return EncryptionMetadata(
      algorithm: json['algorithm'] as String,
      keySize: json['keySize'] as int,
      ivSize: json['ivSize'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
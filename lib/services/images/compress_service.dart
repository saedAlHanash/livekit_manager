import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class CompressedImage {
  const CompressedImage({
    required this.bytes,
    required this.extension,
  });

  final Uint8List bytes;
  final String extension;
}

class CompressService {
  static const Set<String> allowedImageExtensions = {
    'jpg',
    'jpeg',
    'png',
    'webp',
  };

  bool isAllowedImage(String extension, Uint8List bytes) {
    final normalizedExtension = _normalizeExtension(extension);
    return allowedImageExtensions.contains(normalizedExtension) && _hasImageSignature(bytes);
  }

  Future<CompressedImage> compressImage(
    Uint8List bytes, {
    String originalExtension = 'jpg',
    int quality = 60,
  }) async {
    if (!kIsWeb || bytes.isEmpty) {
      return CompressedImage(bytes: bytes, extension: _normalizeExtension(originalExtension));
    }

    try {
      final compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        quality: quality,
        keepExif: true,
        autoCorrectionAngle: true,
        format: CompressFormat.webp,
      );

      if (compressedBytes.isEmpty) {
        return CompressedImage(bytes: bytes, extension: _normalizeExtension(originalExtension));
      }

      return CompressedImage(bytes: compressedBytes, extension: 'webp');
    } catch (_) {
      return CompressedImage(bytes: bytes, extension: _normalizeExtension(originalExtension));
    }
  }

  String _normalizeExtension(String extension) {
    return extension.toLowerCase().replaceAll('.', '').trim();
  }

  bool _hasImageSignature(Uint8List bytes) {
    if (bytes.length < 4) return false;

    final isJpeg = bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF;
    final isPng =
        bytes.length >= 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47 &&
        bytes[4] == 0x0D &&
        bytes[5] == 0x0A &&
        bytes[6] == 0x1A &&
        bytes[7] == 0x0A;
    final isWebp =
        bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50;

    return isJpeg || isPng || isWebp;
  }
}

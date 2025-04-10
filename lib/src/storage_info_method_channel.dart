import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:storage_info/src/storage_info_platform_interface.dart';
import 'package:storage_info/storage_info.dart';

/// An implementation of [StorageInfoPlatform] that uses method channels.
class MethodChannelStorageInfo extends StorageInfoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.example.storage_info');

  @override
  Future<StorageInfoData> getStorageInfo() async {
    final result = await methodChannel
        .invokeMethod<Map<Object?, Object?>>('getStorageInfo');

    if (result == null) {
      throw PlatformException(
        code: 'null-result',
        message: 'Null result returned from the platform channel',
      );
    }

    final totalBytes = result['totalBytes'] as int? ?? 0;
    final freeBytes = result['freeBytes'] as int? ?? 0;
    final usedBytes = totalBytes - freeBytes;

    return StorageInfoData(
      totalBytes: totalBytes,
      freeBytes: freeBytes,
      usedBytes: usedBytes,
    );
  }
}

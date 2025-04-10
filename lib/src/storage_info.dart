/// {@template storage_info}
/// Get storage info on Android and iOS
/// {@endtemplate}
library;

import 'dart:async';
import 'dart:io';

import 'package:storage_info/src/storage_info_platform_interface.dart';

/// Storage information model
class StorageInfoData {
  /// Creates a new [StorageInfoData] instance
  const StorageInfoData({
    required this.totalBytes,
    required this.freeBytes,
    required this.usedBytes,
  });

  /// Total storage space in bytes
  final int totalBytes;

  /// Available/free storage space in bytes
  final int freeBytes;

  /// Used storage space in bytes
  final int usedBytes;

  /// Get percentage of used storage
  double get usedPercentage => totalBytes > 0 ? usedBytes / totalBytes : 0;

  /// Get percentage of free storage
  double get freePercentage => totalBytes > 0 ? freeBytes / totalBytes : 0;
}

/// {@macro storage_info}
class StorageInfo {
  /// {@macro storage_info}
  const StorageInfo();

  /// Get storage information for the device
  Future<StorageInfoData> getStorageInfo() {
    if (!Platform.isAndroid && !Platform.isIOS) {
      throw UnsupportedError(
        'StorageInfo is only supported on Android and iOS platforms.',
      );
    }

    return StorageInfoPlatform.instance.getStorageInfo();
  }
}

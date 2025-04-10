import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:storage_info/src/storage_info.dart';
import 'package:storage_info/src/storage_info_method_channel.dart';

/// The interface that implementations of storage_info must implement.
abstract class StorageInfoPlatform extends PlatformInterface {
  /// Constructs a StorageInfoPlatform.
  StorageInfoPlatform() : super(token: _token);

  static final Object _token = Object();

  static StorageInfoPlatform _instance = MethodChannelStorageInfo();

  /// The default instance of [StorageInfoPlatform] to use.
  static StorageInfoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [StorageInfoPlatform] when
  /// they register themselves.
  static set instance(StorageInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Gets storage information from the device.
  Future<StorageInfoData> getStorageInfo() {
    throw UnimplementedError('getStorageInfo() has not been implemented.');
  }
}

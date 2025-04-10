#import "StorageInfoPlugin.h"
#import <storage_info/storage_info-Swift.h>

@implementation StorageInfoPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  [SwiftStorageInfoPlugin registerWithRegistrar:registrar];
}

@end
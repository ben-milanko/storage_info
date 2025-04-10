#import "StorageInfoPlugin.h"
#import <storage_info/storage_info-Swift.h>

@implementation StorageInfoPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  [StorageInfoPlugin registerWithRegistrar:registrar];
}

@end
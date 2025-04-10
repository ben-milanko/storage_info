// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:storage_info/storage_info.dart';

void main() {
  group('StorageInfo', () {
    test('can be instantiated', () {
      expect(StorageInfo(), isNotNull);
    });
  });
}

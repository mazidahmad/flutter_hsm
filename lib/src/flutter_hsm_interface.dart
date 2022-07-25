import 'dart:typed_data';

import 'package:flutter_hsm/src/model/ios_options.dart';
import 'package:flutter_keystore/flutter_keystore.dart';

abstract class FlutterHsmInterface {
  Future<Uint8List?> encrypt(
      {required String message,
      IosOptions? iosOptions,
      AndroidOptions? androidOptions,
      String? publicKeyString});
  Future<String?> decrypt({
    required Uint8List message,
    IosOptions? iosOptions,
    AndroidOptions? androidOptions,
  });
  Future<void> reset({IosOptions? iosOptions, AndroidOptions? androidOptions});
}

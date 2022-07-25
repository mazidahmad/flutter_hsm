import 'dart:typed_data';

import 'package:flutter_hsm/src/flutter_hsm_interface.dart';
import 'package:flutter_hsm/src/model/ios_options.dart';
import 'package:flutter_keystore/flutter_keystore.dart';

class AndroidHsm extends FlutterHsmInterface {
  final FlutterKeystore _flutterKeystore = FlutterKeystore();

  @override
  Future<String?> decrypt(
      {required Uint8List message,
      IosOptions? iosOptions,
      AndroidOptions? androidOptions}) async {
    return await _flutterKeystore.decrypt(
        message: message, options: androidOptions!);
  }

  @override
  Future<Uint8List?> encrypt(
      {required String message,
      IosOptions? iosOptions,
      AndroidOptions? androidOptions,
      String? publicKeyString}) async {
    return await _flutterKeystore.encrypt(
      options: androidOptions!,
      message: message,
    );
  }

  @override
  Future<void> reset(
      {IosOptions? iosOptions, AndroidOptions? androidOptions}) async {
    await _flutterKeystore.resetConfiguration(options: androidOptions!);
  }
}

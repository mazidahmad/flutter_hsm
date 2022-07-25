import 'dart:typed_data';

import 'package:flutter_hsm/src/flutter_hsm_interface.dart';
import 'package:flutter_hsm/src/model/ios_options.dart';
import 'package:flutter_keystore/flutter_keystore.dart';
import 'package:secure_enclave/secure_enclave.dart';

class IosHsmImpl extends FlutterHsmInterface {
  final SecureEnclave _secureEnclave = SecureEnclave();
  @override
  Future<String?> decrypt(
      {required Uint8List message,
      IosOptions? iosOptions,
      AndroidOptions? androidOptions}) async {
    var result = await _secureEnclave.decrypt(
        message: message, accessControl: iosOptions!);
    return result.value;
  }

  @override
  Future<Uint8List?> encrypt(
      {required String message,
      IosOptions? iosOptions,
      AndroidOptions? androidOptions,
      String? publicKeyString}) async {
    if (publicKeyString != null) {
      var result = await _secureEnclave.encryptWithPublicKey(
          message: message, publicKeyString: publicKeyString);
      return result.value;
    } else {
      var result = await _secureEnclave.encrypt(
          message: message, accessControl: iosOptions!);
      return result.value;
    }
  }

  @override
  Future<void> reset(
      {IosOptions? iosOptions, AndroidOptions? androidOptions}) async {
    await _secureEnclave.removeKey(iosOptions!.tag);
  }
}

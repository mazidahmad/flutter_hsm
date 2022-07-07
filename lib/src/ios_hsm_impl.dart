import 'dart:typed_data';

import 'package:flutter_hsm/src/flutter_hsm_interface.dart';
import 'package:flutter_hsm/src/model/access_control_hsm.dart';
import 'package:secure_enclave/secure_enclave.dart';

class IosHsmImpl extends FlutterHsmInterface {
  final SecureEnclave _secureEnclave = SecureEnclave();
  @override
  Future<String?> decrypt({required Uint8List message, required AccessControlHsm accessControl}) async {
    var result = await _secureEnclave.decrypt(message: message, accessControl: accessControl);
    return result.value;
  }

  @override
  Future<Uint8List?> encrypt({required String message, required AccessControlHsm accessControl, String? publicKeyString}) async {
    if (publicKeyString != null){
      var result = await _secureEnclave.encryptWithPublicKey(message: message, publicKeyString: publicKeyString);
      return result.value;
    }else{
      var result = await _secureEnclave.encrypt(message: message, accessControl: accessControl);
      return result.value;
    }
  }
}
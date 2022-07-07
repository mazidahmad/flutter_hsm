library flutter_hsm;

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_hsm/src/flutter_hsm_interface.dart';
import 'package:flutter_hsm/src/model/access_control_hsm.dart';
import 'package:flutter_keystore/flutter_keystore.dart' as keystore;
import 'package:secure_enclave/secure_enclave.dart';

export 'package:flutter_hsm/src/model/access_control_hsm.dart';
export 'package:secure_enclave/src/model/access_control.dart';

class FlutterHardwareSecureModule extends FlutterHsmInterface {
  
  final SecureEnclave _secureEnclave = SecureEnclave();
  final keystore.FlutterKeystore _flutterKeystore = keystore.FlutterKeystore();
  
  @override
  Future<Uint8List?> encrypt({required String message, required AccessControlHsm accessControl, String? publicKeyString}) async{
    try {
      switch(Platform.localeName){
        case "ios":
        case "macos":
          if (publicKeyString != null){
            var result = await _secureEnclave.encryptWithPublicKey(message: message, publicKeyString: publicKeyString);
            return result.decoder((value) => value);
          }else{
            assert(accessControl != null);
            var result = await _secureEnclave.encrypt(message: message, accessControl: accessControl);
            return result.decoder((value) => value);
          }
        case "android":
          assert(accessControl != null);
          return await _flutterKeystore.encrypt(accessControl: keystore.AccessControl(tag: accessControl.tag, setUserAuthenticatedRequired: false), message: message);
        default: throw Exception("Platform not supported");
      }
    }catch(e){
      throw Exception("Platform Channel Error : ${e.toString()}");
    }
  }
  
  @override
  Future<String?> decrypt({required Uint8List message,required AccessControlHsm accessControl}) async{
    try {
      switch(Platform.localeName){
        case "ios":
        case "macos":
          var result = await _secureEnclave.decrypt(message: message, accessControl: accessControl);
            return result.decoder((value) => value);
        case "android":
          return await _flutterKeystore.decrypt(message: message, accessControl: keystore.AccessControl(tag: accessControl.tag, setUserAuthenticatedRequired: false));
        default: throw Exception("Platform not supported");
      }
    }catch(e){
      throw Exception("Platform Channel Error : ${e.toString()}");
    }
  }
}

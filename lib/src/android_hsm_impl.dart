import 'dart:typed_data';

import 'package:flutter_hsm/src/flutter_hsm_interface.dart';
import 'package:flutter_hsm/src/model/access_control_hsm.dart';
import 'package:flutter_keystore/flutter_keystore.dart';

class AndroidHsm extends FlutterHsmInterface {

  final FlutterKeystore _flutterKeystore = FlutterKeystore();

  @override
  Future<String?> decrypt({required Uint8List message, required AccessControlHsm accessControl}) async{
    return await _flutterKeystore.decrypt(message: message, accessControl: AccessControl(tag: accessControl.tag, setUserAuthenticatedRequired: false));
  }

  @override
  Future<Uint8List?> encrypt({required String message, required AccessControlHsm accessControl, String? publicKeyString}) async{
    return await _flutterKeystore.encrypt(accessControl: AccessControl(tag: accessControl.tag, setUserAuthenticatedRequired: false), message: message);
  }
}
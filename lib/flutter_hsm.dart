library flutter_hsm;

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_hsm/src/flutter_hsm_interface.dart';
import 'package:flutter_hsm/src/android_hsm_impl.dart';
import 'package:flutter_hsm/src/ios_hsm_impl.dart';
import 'package:flutter_hsm/src/model/access_control_hsm.dart';

export 'package:flutter_hsm/src/model/access_control_hsm.dart';
export 'package:secure_enclave/src/model/access_control.dart';
export 'package:flutter_keystore/src/model/android_prompt_info.dart';

class FlutterHardwareSecureModule extends FlutterHsmInterface {
  factory FlutterHardwareSecureModule() => _instance;

  late FlutterHsmInterface _package;

  FlutterHardwareSecureModule._() {
    switch (Platform.operatingSystem) {
      case 'ios':
      case 'macos':
        _package = IosHsmImpl();
        break;
      case 'android':
        _package = AndroidHsm();
        break;
      default:
        throw Exception("Platform not supported");
    }
  }

  static final FlutterHardwareSecureModule _instance =
      FlutterHardwareSecureModule._();

  @override
  Future<String?> decrypt(
      {required Uint8List message, required AccessControlHsm accessControl}) {
    return _package.decrypt(message: message, accessControl: accessControl);
  }

  @override
  Future<Uint8List?> encrypt(
      {required String message,
      required AccessControlHsm accessControl,
      String? publicKeyString}) {
    return _package.encrypt(message: message, accessControl: accessControl);
  }
}

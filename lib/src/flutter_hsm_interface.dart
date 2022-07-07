import 'dart:typed_data';

import 'package:flutter_hsm/src/model/access_control_hsm.dart';

abstract class FlutterHsmInterface {
  Future<Uint8List?> encrypt({required String message, required AccessControlHsm accessControl, String? publicKeyString});
  Future<String?> decrypt({required Uint8List message, required AccessControlHsm accessControl});
}
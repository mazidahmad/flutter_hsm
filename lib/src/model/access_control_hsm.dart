import 'package:secure_enclave/secure_enclave.dart';

class AccessControlHsm extends AccessControl {
  final bool authRequired;

  AccessControlHsm({required super.options, required super.tag, required this.authRequired});

}
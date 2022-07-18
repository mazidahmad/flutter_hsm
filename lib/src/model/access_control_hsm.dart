// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_hsm/flutter_hsm.dart';

class AccessControlHsm extends AccessControl {
  final bool authRequired;
  final AndroidPromptInfo? promptInfo;

  AccessControlHsm(
      {required super.options,
      required super.tag,
      required this.authRequired,
      this.promptInfo});

  AccessControlHsm copyWith({
    List<AccessControlOption>? options,
    String? tag,
    bool? authRequired,
    AndroidPromptInfo? promptInfo,
  }) {
    return AccessControlHsm(
      authRequired: authRequired ?? this.authRequired,
      options: options ?? super.options,
      tag: tag ?? super.tag,
      promptInfo: promptInfo ?? this.promptInfo,
    );
  }
}

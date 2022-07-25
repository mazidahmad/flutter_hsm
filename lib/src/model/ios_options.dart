// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_hsm/flutter_hsm.dart';

class IosOptions extends AccessControl {
  IosOptions({required super.options, required super.tag});

  IosOptions copyWith({
    List<AccessControlOption>? options,
    String? tag,
  }) {
    return IosOptions(
      options: options ?? super.options,
      tag: tag ?? super.tag,
    );
  }
}

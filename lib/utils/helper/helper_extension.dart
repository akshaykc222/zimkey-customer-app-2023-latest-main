import 'package:flutter/material.dart';

extension CustomBuildContextExtension on BuildContext {
  OverlayState get nonNullableOverlay => Overlay.of(this);
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
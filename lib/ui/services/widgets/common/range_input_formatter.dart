import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RangeInputFormatter extends TextInputFormatter {
  final int minValue;
  final int maxValue;

  RangeInputFormatter({required this.minValue, required this.maxValue})
      : assert(minValue <= maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new input is empty, allow it
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Parse the current input value as an integer (if it is not empty)
    int? newValueAsInt;
    try {
      newValueAsInt = int.parse(newValue.text);
    } catch (e) {
      newValueAsInt = null;
    }

    // Check if the value is within the allowed range
    if (newValueAsInt != null && newValueAsInt >= minValue && newValueAsInt <= maxValue) {
      return newValue;
    }

    // Return the old value if the new value is not within the allowed range
    return oldValue;
  }
}
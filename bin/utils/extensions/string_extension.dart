import 'package:mime/mime.dart';

/// Extends the [String] class with some useful methods.
extension StringExtension on String? {
  /// Checks if the string is null or empty.
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }

  /// Checks if the string is not null or empty.
  bool isNotNullOrEmpty() {
    return !isNullOrEmpty();
  }

  /// Parses the string to a double.
  double? toDoubleOrNull() {
    if (isNullOrEmpty()) return null;
    return double.tryParse(this!.replaceAll(',', '.'));
  }

  /// Checks if the string is EAN-13.
  bool isEan13() {
    if (isNullOrEmpty()) return false;
    return this!.length == 13 && RegExp(r'^\d{13}$').hasMatch(this!);
  }

  /// Checks if the string is a CSV file.
  bool isCsvFile() {
    if (isNullOrEmpty()) return false;
    return this!.endsWith('.csv') && lookupMimeType(this!) == 'text/csv';
  }
}

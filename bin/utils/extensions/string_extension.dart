/// Extends the [String] class with some useful methods.
extension StringExtension on String? {
  /// Checks if the string is null or empty.
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }

  /// Checks if the string is not null or empty.
  bool isNotNullOrEmpty() {
    return this != null && this!.isNotEmpty;
  }
}

import 'dart:io';

/// Read a text file and return as a list of lines.
List<String>? readReceiptFile(String fileName) {
  File file = File(fileName);
  try {
    return file.readAsLinesSync();
  } on FileSystemException catch (e) {
    print("File not found: $e");
  }
}

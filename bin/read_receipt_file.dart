import 'dart:io';

/// Read a text file and return as a list of lines.
List<String>? readReceiptFile(String filePath) {
  File file = File(filePath);
  try {
    return file.readAsLinesSync();
  } on FileSystemException catch (e) {
    print("File not found: $e");
  }
}

import 'dart:io';

import 'save_rps_as_csv.dart';
import 'strings_to_products.dart';

void readReceiptAndSaveAsCSV(String filePath, String csvFilePath) {
  var lines = readReceiptFile(filePath);
  var products = strings2Products(lines ?? []);
  receiptProducts2CSV(products, csvFilePath);
}

/// Read a text file and return as a list of lines.
List<String>? readReceiptFile(String filePath) {
  File file = File(filePath);
  try {
    return file.readAsLinesSync();
  } on FileSystemException {
    rethrow;
  }
}

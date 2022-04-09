import 'dart:io';

import 'save_rps_as_csv.dart';
import 'strings_to_products.dart';

void readReceiptAndSaveAsCSV(String filePath, String csvFilePath) async {
  var lines = await readReceiptFile(filePath);
  var products = strings2Products(lines ?? []);
  receiptProducts2CSV(products, csvFilePath);
}

/// Read a text file and return as a list of lines.
Future<List<String>?> readReceiptFile(String filePath) async {
  File file = File(filePath);
  try {
    return await file.readAsLines();
  } on FileSystemException {
    rethrow;
  }
}

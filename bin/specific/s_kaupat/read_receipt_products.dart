import 'dart:io';

import '../../models/receipt_product.dart';
import 'strings_to_receipt_products.dart';

Future<List<ReceiptProduct>> readReceiptProducts(
    String filePath, String csvFilePath) async {
  var lines = await readReceiptFile(filePath);
  return strings2ReceiptProducts(lines ?? []);
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

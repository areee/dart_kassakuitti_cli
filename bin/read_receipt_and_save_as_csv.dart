import 'read_receipt_file.dart';
import 'save_rps_as_csv.dart';
import 'strings_to_products.dart';

void readReceiptAndSaveAsCSV(String filePath, String csvFilePath) {
  var lines = readReceiptFile(filePath);
  var products = strings2Products(lines ?? []);
  receiptProducts2CSV(products, csvFilePath);
}

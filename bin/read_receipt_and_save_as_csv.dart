import 'read_receipt_file.dart';
import 'save_as_csv.dart';
import 'strings_to_products.dart';

void readReceiptAndSaveAsCSV(String filePath) {
  var lines = readReceiptFile(filePath);
  var products = strings2Products(lines ?? []);
  products2CSV(products);
}

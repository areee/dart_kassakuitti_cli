import 'read_receipt_file.dart';
import 'save_as_csv.dart';
import 'strings_to_products.dart';

void readReceiptAndSaveAsCSV() {
  var lines = readReceiptFile('assets/files/cashReceipt.txt');
  var products = strings2Products(lines ?? []);
  products2CSV(products);
}

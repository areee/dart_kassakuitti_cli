import 'load_html.dart';
import 'read_receipt_file.dart';
import 'save_to_csv.dart';
import 'strings_to_products.dart';

void main(List<String> arguments) {
  var lines = readReceiptFile('assets/files/cashReceipt.txt');
  var products = strings2Products(lines ?? []);
  products2CSV(products);

  // ^ TODO: Uncomment these lines to run the program.

  loadHtmlFromAssets();
}

import 'read_html_and_save_as_csv.dart';
import 'read_receipt_and_save_as_csv.dart';

void main(List<String> arguments) {
  readReceiptAndSaveAsCSV('assets/files/_cashReceipt.txt');
  readHtmlAndSaveAsCSV('assets/files/_orderedProducts.html');

  print('Done!');
}

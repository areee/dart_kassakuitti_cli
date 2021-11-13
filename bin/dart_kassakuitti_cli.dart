import 'load_html.dart';
import 'read_receipt_and_save_as_csv.dart';
import 'save_eps_as_csv.dart';

void main(List<String> arguments) async {
  readReceiptAndSaveAsCSV('assets/files/_cashReceipt.txt');

  var awaitedEANProductList =
      await loadHtmlFromAssets('assets/files/_orderedProducts.html');

  eanProductListToCSV(awaitedEANProductList);

  print('Done!');
}

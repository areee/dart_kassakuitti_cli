import 'load_html.dart';
import 'read_receipt_and_save_as_csv.dart';

void main(List<String> arguments) async {
  readReceiptAndSaveAsCSV('assets/files/cashReceipt.txt');

  var awaitedEANProductList =
      await loadHtmlFromAssets('assets/files/orderedProducts.html');

  // TODO: Instead of printing the list, write it to a CSV file.
  for (var item in awaitedEANProductList) {
    print(item);
  }
}

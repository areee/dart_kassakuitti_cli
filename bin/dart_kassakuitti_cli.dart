import 'dart:io';

import 'ean_product.dart';
import 'helper.dart';
import 'load_html.dart';
import 'read_receipt_and_save_as_csv.dart';

void main(List<String> arguments) async {
  readReceiptAndSaveAsCSV('assets/files/_cashReceipt.txt');

  var awaitedEANProductList =
      await loadHtmlFromAssets('assets/files/_orderedProducts.html');

  eanProductListToCSV(awaitedEANProductList);

  print('Done!');
}

void eanProductListToCSV(List<EANProduct> eanProductList) {
  var csv = StringBuffer();

  csv.write('ean;name;quantity;price\n');

  for (var item in eanProductList) {
    csv.write('${item.ean};${item.name};${item.quantity};${item.price}\n');
  }

  var date = formattedDateTime();

  var file = File('assets/files/ean_products_$date.csv');
  file.writeAsString(csv.toString());
}

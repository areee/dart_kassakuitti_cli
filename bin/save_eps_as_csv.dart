import 'dart:io';
import 'model/ean_product.dart';
import 'helper.dart';

void eanProductListToCSV(List<EANProduct> eanProductList, String csvFilePath) {
  var csv = StringBuffer();

  csv.write('EAN code;Name;Quantity;Price\n');

  for (var item in eanProductList) {
    csv.write('${item.ean};${item.name};${item.quantity};${item.price}\n');
  }

  var date = formattedDateTime();

  var file = File('$csvFilePath/ean_products_$date.csv');
  file.writeAsString(csv.toString());
}

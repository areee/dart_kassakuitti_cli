import 'dart:io';
import 'ean_product.dart';
import 'helper.dart';

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

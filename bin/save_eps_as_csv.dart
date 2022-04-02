import 'dart:io';
import 'models/ean_product.dart';
import 'utils/helper.dart';

void eanProductListToCSV(List<EANProduct> eanProductList, String csvFilePath) {
  var csv = StringBuffer();

  csv.write('EAN code;Name;Quantity;Price\n');

  for (var item in eanProductList) {
    csv.write('${item.ean};${item.name};${item.quantity};${item.price}\n');
  }

  var file = File('$csvFilePath/ean_products_${formattedDateTime()}.csv');
  file.writeAsString(csv.toString());
}

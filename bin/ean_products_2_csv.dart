import 'dart:io';

import 'package:path/path.dart' as p;

import 'models/ean_product.dart';
import 'utils/date_helper.dart';
import 'utils/home_directory_helper.dart';

void eanProducts2CSV(List<EANProduct> eanProductList, String exportFilePath,
    String shopSelector) {
  var csv = StringBuffer();

  csv.write('Name;Quantity;Price per unit;Total price;EAN code;More details\n');

  for (var item in eanProductList) {
    csv.write(
        '${item.name};${item.quantity};${item.pricePerUnit};${item.totalPrice};${item.eanCode};${item.moreDetails}\n');
  }

  var file = File(p.join(replaceTildeWithHomeDirectory(exportFilePath),
      '${shopSelector}_ean_products_${formattedDateTime()}.csv'));
  file.writeAsString(csv.toString());
}

import 'dart:io';
import 'models/ean_product.dart';
import 'utils/date_helper.dart';

void eanProducts2CSV(
    List<EANProduct> eanProductList, String csvFilePath, String shopSelector) {
  var csv = StringBuffer();

  csv.write('Name;Quantity;Price per unit;Total price;EAN code;More details\n');

  for (var item in eanProductList) {
    csv.write(
        '${item.name};${item.quantity};${item.pricePerUnit};${item.totalPrice};${item.ean};${item.moreDetails}\n');
  }

  var file = File(
      '$csvFilePath/${shopSelector}_ean_products_${formattedDateTime()}.csv');
  file.writeAsString(csv.toString());
}

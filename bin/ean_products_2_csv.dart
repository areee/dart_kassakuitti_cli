import 'dart:io';
import 'models/ean_product.dart';
import 'utils/date_helper.dart';

void eanProducts2CSV(
    List<EANProduct> eanProductList, String csvFilePath, String shopSelector) {
  var csv = StringBuffer();

  csv.write('EAN code;Name;Quantity;Total price;Price per unit;More details\n');

  for (var item in eanProductList) {
    csv.write(
        '${item.ean};${item.name};${item.quantity};${item.totalPrice};${item.pricePerUnit};${item.moreDetails}\n');
  }

  var file = File(
      '$csvFilePath/${shopSelector}_ean_products_${formattedDateTime()}.csv');
  file.writeAsString(csv.toString());
}

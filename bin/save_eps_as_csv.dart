import 'dart:io';
import 'models/ean_product.dart';
import 'utils/helper.dart';
import 'utils/shop_selector_helper.dart';

void eanProductListToCSV(List<EANProduct> eanProductList, String csvFilePath,
    ShopSelector shopSelector) {
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

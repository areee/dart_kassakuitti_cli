import 'dart:io';

import 'package:path/path.dart' as p;

import '../../utils/date_helper.dart';
import '../../models/receipt_product.dart';
import '../../utils/home_directory_helper.dart';

/// Saves receipt products as a CSV file.
void receiptProducts2CSV(List<ReceiptProduct> products, String exportFilePath) {
  var csv = StringBuffer();
  var header = '';
  var discountCounted = false;

  // If there aren't any discountCounted products, don't add it to the CSV file.
  if (products.every((product) => product.discountCounted.isEmpty)) {
    header = 'Name;Quantity;Price per unit;Total price;EAN code\n';
  } else {
    discountCounted = true;
    header =
        'Name;Quantity;Price per unit;Total price;Discount counted;EAN code\n';
  }

  // Write the header
  csv.write(header);

  // Write the products
  for (var product in products) {
    csv.write(
        '${product.name};${product.quantity};${product.pricePerUnit};${product.totalPrice}${discountCounted ? ';${product.discountCounted}' : ''};${product.eanCode}\n');
  }

  var file = File(p.join(replaceTildeWithHomeDirectory(exportFilePath),
      'receipt_products_${formattedDateTime()}.csv'));
  file.writeAsString(csv.toString());
}

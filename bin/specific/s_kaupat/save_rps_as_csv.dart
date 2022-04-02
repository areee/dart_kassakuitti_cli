import 'dart:io';
import '../../utils/date_helper.dart';
import '../../models/receipt_product.dart';

/// Saves receipt products as a CSV file.
void receiptProducts2CSV(List<ReceiptProduct> products, String csvFilePath) {
  var csv = StringBuffer();
  var header = '';
  var discountCounted = false;

  // If there aren't any discountCounted products, don't add it to the CSV file.
  if (products.any((product) => product.discountCounted.isEmpty)) {
    header =
        'Name;Quantity;Price per unit;Total price;EAN code (add manually)\n';
  } else {
    discountCounted = true;
    header =
        'Name;Quantity;Price per unit;Total price;EAN code (add manually);Discount counted\n';
  }

  // Write the header
  csv.write(header);

  // Write the products
  for (var product in products) {
    csv.write(
        '${product.name};${product.quantity};${product.pricePerUnit};${product.totalPrice};${product.eanCode}${discountCounted ? ';${product.discountCounted}' : ''}\n');
  }

  var file = File('$csvFilePath/receipt_products_${formattedDateTime()}.csv');
  file.writeAsString(csv.toString());
}

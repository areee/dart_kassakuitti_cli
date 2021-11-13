import 'dart:io';
import 'helper.dart';
import 'receipt_product.dart';

/// Saves products into a CSV file.
void products2CSV(List<Product> products) {
  var csv = StringBuffer();

  csv.write('name;quantity;pricePerUnit;totalPrice\n');

  for (var product in products) {
    csv.write(
        '${product.name};${product.quantity};${product.pricePerUnit};${product.totalPrice}\n');
  }

  var date = formattedDateTime();

  var file = File('assets/files/receipt_products_$date.csv');
  file.writeAsString(csv.toString());
}

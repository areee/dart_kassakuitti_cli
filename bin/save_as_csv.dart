import 'dart:io';
import 'package:intl/intl.dart';
import 'receipt_product.dart';

/// Saves products into a CSV file.
void products2CSV(List<Product> products) {
  var csv = StringBuffer();

  csv.write('name;quantity;pricePerUnit;totalPrice\n');

  for (var product in products) {
    csv.write(
        '${product.name};${product.quantity};${product.pricePerUnit};${product.totalPrice}\n');
  }

  var date = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

  var file = File('assets/files/products_$date.csv');
  file.writeAsString(csv.toString());
}

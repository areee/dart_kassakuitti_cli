import 'dart:io';
import 'helper.dart';
import 'receipt_product.dart';

/// Saves receipt products as a CSV file.
void receiptProducts2CSV(List<ReceiptProduct> products) {
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

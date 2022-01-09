import 'dart:io';
import 'helper.dart';
import 'receipt_product.dart';

/// Saves receipt products as a CSV file.
void receiptProducts2CSV(List<ReceiptProduct> products, String csvFilePath) {
  var csv = StringBuffer();

  csv.write('Name;Quantity;Price per unit;Total price;Discount counted\n');

  for (var product in products) {
    csv.write(
        '${product.name};${product.quantity};${product.pricePerUnit};${product.totalPrice};${product.discountCounted}\n');
  }

  var date = formattedDateTime();

  var file = File('$csvFilePath/receipt_products_$date.csv');
  file.writeAsString(csv.toString());
}

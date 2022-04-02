import 'dart:io';
import '../../utils/helper.dart';
import '../../models/receipt_product.dart';

/// Saves receipt products as a CSV file.
void receiptProducts2CSV(List<ReceiptProduct> products, String csvFilePath) {
  var csv = StringBuffer();

  csv.write('Name;Quantity;Price per unit;Total price;Discount counted\n');

  for (var product in products) {
    csv.write(
        '${product.name};${product.quantity};${product.pricePerUnit};${product.totalPrice};${product.discountCounted}\n');
  }

  var file = File('$csvFilePath/receipt_products_${formattedDateTime()}.csv');
  file.writeAsString(csv.toString());
}

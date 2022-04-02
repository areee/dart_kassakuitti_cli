import 'dart:io';
import '../../utils/helper.dart';
import '../../models/receipt_product.dart';

/// Saves receipt products as a CSV file.
void receiptProducts2CSV(List<ReceiptProduct> products, String csvFilePath) {
  var csv = StringBuffer();

  // If there aren't any discountCounted products, don't add it to the CSV file.
  if (products.any((element) => element.discountCounted.isEmpty)) {
    csv.write('Name;Quantity;Price per unit;Total price\n');

    for (var product in products) {
      csv.write(
          '${product.name};${product.quantity};${product.pricePerUnit};${product.totalPrice}\n');
    }
  } else {
    csv.write('Name;Quantity;Price per unit;Total price;Discount counted\n');

    for (var product in products) {
      csv.write(
          '${product.name};${product.quantity};${product.pricePerUnit};${product.totalPrice};${product.discountCounted}\n');
    }
  }

  var file = File('$csvFilePath/receipt_products_${formattedDateTime()}.csv');
  file.writeAsString(csv.toString());
}

import 'dart:io';
import 'package:intl/intl.dart';
import 'helper.dart';
import 'product.dart';

void main(List<String> arguments) {
  var lines = readFile('cashReceipt.txt');
  var products = strings2Products(lines ?? []);

  // Save products into CSV file
  saveProducts(products);
}

/// Read a text file and return as a list of lines.
List<String>? readFile(String fileName) {
  File file = File(fileName);
  try {
    return file.readAsLinesSync();
  } on FileSystemException catch (e) {
    print("File not found: $e");
  }
}

/// Goes through the list of lines and returns a list of products.
List<Product> strings2Products(List<String> lines) {
  var helper = Helper();
  List<Product> products = [];

  for (var item in lines) {
    item = item.trim();
    item = item.toLowerCase();

    // Do not handle sum lines (after a row of strokes):
    if (item.contains('----------')) {
      break;
    }
    // Refund line:
    else if (item.contains('palautus')) {
      helper.previousLine = PreviousLine.refund;
    }
    // When previous line was a refund line, skip next two lines:
    else if (helper.previousLine == PreviousLine.refund) {
      if (helper.calcLines != 1) {
        helper.calcLines++;
      } else {
        helper.calcLines = 0;
        helper.previousLine = PreviousLine.notSet;
      }
    }
    // If a line starts with a digit, it is a quantity and price per unit row:
    else if (item.contains(RegExp(r'^\d'))) {
      var items = item.split(RegExp(r'\s{6,7}'));
      var quantity = items[0].substring(0, 2).trim();
      var pricePerUnit = items[1].substring(0, 5).trim();

      var lastProduct = products.last;
      lastProduct.quantity = int.parse(quantity);
      lastProduct.pricePerUnit = pricePerUnit;
    }

    // A "normal" line:
    else {
      var items = item.split(RegExp(r'\s{12,33}'));

      var name = items[0];
      var price = items[1];

      var product = Product(name: name, totalPrice: price);
      products.add(product);
    }
  }

  return products;
}

void saveProducts(List<Product> products) {
  var csv = StringBuffer();

  csv.write('name;quantity;pricePerUnit;totalPrice\n');

  for (var product in products) {
    csv.write(
        '${product.name};${product.quantity};${product.pricePerUnit};${product.totalPrice}\n');
  }

  var date = DateFormat('yyyyMMddHHmmss').format(DateTime.now());

  var file = File('products_$date.csv');
  file.writeAsString(csv.toString());
}

import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path/path.dart';

import 'models/hive_product.dart';
import 'utils/date_helper.dart';
import 'utils/extensions/string_extension.dart';
import 'utils/home_directory_helper.dart';

/// Hive handling (CRUD for storage handling).
Future<Box<HiveProduct>> hiveHandling(Box<HiveProduct> hiveProducts) async {
  while (true) {
    print('''

    *** Hive handling ***
    1. Create
    2. Read all
    3. Search by keyword
    4. Update
    5. Delete
    6. Count
    7. Export to CSV
    Empty command or something else to exit.
    ''');

    var input = stdin.readLineSync();

    switch (input) {
      case '1':
        await _addProduct(hiveProducts);
        break;
      case '2':
        _readAllProducts(hiveProducts);
        break;
      case '3':
        _searchByKeyword(hiveProducts);
        break;
      case '4':
        await _updateProduct(hiveProducts);
        break;
      case '5':
        await _deleteProduct(hiveProducts);
        break;
      case '6':
        _countProducts(hiveProducts);
        break;
      case '7':
        await _exportToCsv(hiveProducts);
        break;
      default:
        print('Exiting...');
        return hiveProducts;
    }
  }
}

/// Adds a product to the storage.
Future<void> _addProduct(Box<HiveProduct> hiveProducts) async {
  print('Enter the receipt name of the product:');
  var name = stdin.readLineSync();

  print('Enter the EAN name of the product:');
  var eanName = stdin.readLineSync();

  if (name.isNotNullOrEmpty() && eanName.isNotNullOrEmpty()) {
    print('You entered: $name, $eanName');
    print('Do you want to add this product? (y/n)');
    var input = stdin.readLineSync();

    if (input == 'y') {
      await hiveProducts
          .add(HiveProduct(receiptName: name!, eanName: eanName!));
      print('Product added!');
      _countProducts(hiveProducts);
    } else {
      print('Product not added!');
    }
  }
}

/// Reads all products from the storage.
void _readAllProducts(Box<HiveProduct> hiveProducts) {
  _countProducts(hiveProducts);
  print('All products:');
  _printProducts(products: hiveProducts);
}

/// Prints Hive products.
void _printProducts(
    {required Box<HiveProduct> products, Iterable<dynamic>? filteredProducts}) {
  if (filteredProducts == null) {
    for (var product in products.keys) {
      _printSingleProduct(products: products, product: product);
    }
  } else {
    for (var product in filteredProducts) {
      _printSingleProduct(products: products, product: product);
    }
  }
}

/// Prints single Hive product.
void _printSingleProduct(
    {required Box<HiveProduct> products, required dynamic product}) {
  print('\t#$product: ${products.get(product)}');
}

/// Search by keyword in the storage.
void _searchByKeyword(Box<HiveProduct> hiveProducts) {
  print('Enter a keyword:');
  var keyword = stdin.readLineSync();

  if (keyword.isNotNullOrEmpty()) {
    print('You entered: $keyword');

    var filteredProducts = hiveProducts.keys.where((key) => hiveProducts
        .get(key)!
        .receiptName
        .toLowerCase()
        .contains(keyword!.toLowerCase()));

    var amount = filteredProducts.length;

    print('Found $amount ${amount == 1 ? 'product' : 'products'}:');

    _printProducts(products: hiveProducts, filteredProducts: filteredProducts);
  }
}

/// Updates a product in the storage.
Future<void> _updateProduct(Box<HiveProduct> hiveProducts) async {
  var orderNumber = _getOrderNumberAndPrintProduct(hiveProducts);
  if (orderNumber == -1) return;

  print('Enter the new receipt name of the product:');
  var name = stdin.readLineSync();

  print('Enter the new EAN name of the product:');
  var eanName = stdin.readLineSync();

  if (name.isNotNullOrEmpty() && eanName.isNotNullOrEmpty()) {
    print('You entered: $name, $eanName');
    print('Do you want to update this product? (y/n)');
    var input = stdin.readLineSync();

    if (input == 'y') {
      await hiveProducts.put(
          orderNumber, HiveProduct(receiptName: name!, eanName: eanName!));
      print('Product updated!');
    } else {
      print('Product not updated!');
    }
  }
}

/// Delete a product from the storage.
Future<void> _deleteProduct(Box<HiveProduct> hiveProducts) async {
  var orderNumber = _getOrderNumberAndPrintProduct(hiveProducts);
  if (orderNumber == -1) return;

  print('Do you want to delete this product? (y/n)');
  var input = stdin.readLineSync();

  if (input == 'y') {
    await hiveProducts.delete(orderNumber);
    print('Product deleted!');
    _countProducts(hiveProducts);
  } else {
    print('Product not deleted!');
  }
}

/// Asks the user to give an order number.
int? _askUserToGiveOrderNumber() {
  print('Enter the order number of the product:');
  var orderNumber = stdin.readLineSync();

  if (orderNumber.isNotNullOrEmpty()) {
    return int.tryParse(orderNumber!);
  }
  return null;
}

/// Checks if an order number is valid.
bool _isValidOrderNumber(int? orderNumber) {
  return orderNumber != null && orderNumber >= 0;
}

/// Handles an order number.
int _handleOrderNumber() {
  var orderNumber = _askUserToGiveOrderNumber();

  if (!_isValidOrderNumber(orderNumber)) {
    print('Invalid order number!');
    return -1;
  }
  return orderNumber!;
}

/// Gets a product.
HiveProduct? _getProduct(Box<HiveProduct> hiveProducts, int orderNumber) {
  var product = hiveProducts.get(orderNumber);

  if (product == null) {
    print('Product not found!');
    return null;
  }

  print('Product: $product');
  return product;
}

/// Gets an order number (and gives a product information).
int _getOrderNumberAndPrintProduct(Box<HiveProduct> hiveProducts) {
  var orderNumber = _handleOrderNumber();
  if (orderNumber == -1) return -1;

  var product = _getProduct(hiveProducts, orderNumber);
  if (product == null) return -1;

  return orderNumber;
}

/// Counts the products in the storage.
void _countProducts(Box<HiveProduct> hiveProducts) {
  print('Amount of products: ${hiveProducts.length}');
}

/// Exports the products to a CSV file.
Future<void> _exportToCsv(Box<HiveProduct> hiveProducts) async {
  print('Do you want to export all Hive products to a CSV file? (y/n)');
  var input = stdin.readLineSync();

  if (input == 'y') {
    var csv = StringBuffer();

    // Write the header:
    var header = ['Receipt name', 'EAN name'];
    csv.write('${header.join(';')}\n');

    // Write the products:
    for (var key in hiveProducts.keys) {
      var hiveProduct = hiveProducts.get(key)!;
      var productDataList = [
        hiveProduct.receiptName,
        hiveProduct.eanName,
      ];
      csv.write('${productDataList.join(';')}\n');
    }

    // Currently saves the CSV file in the Downloads folder:
    var filePath = join(getUserHomeDirectory(), 'Downloads',
        'hiveProducts_${formattedDateTime()}.csv');
    var file = File(filePath);
    await file.writeAsString(csv.toString());
    print('CSV file exported!');
  } else {
    print('CSV file not exported!');
  }
}

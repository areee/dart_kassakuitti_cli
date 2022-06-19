import 'dart:io';

import 'package:hive/hive.dart';

import 'models/hive_product.dart';
import 'utils/extensions/string_extension.dart';

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
  print('Enter the order number of the product:');

  var orderNumber = stdin.readLineSync();

  if (orderNumber.isNotNullOrEmpty()) {
    var orderNumberAsInt = int.tryParse(orderNumber!);

    var product = hiveProducts.get(orderNumberAsInt!);

    if (product != null) {
      print('Product: $product');

      print('Enter the new receipt name of the product:');
      var name = stdin.readLineSync();

      print('Enter the new EAN name of the product:');
      var eanName = stdin.readLineSync();

      if (name.isNotNullOrEmpty() && eanName.isNotNullOrEmpty()) {
        print('You entered: $name, $eanName');
        print('Do you want to update this product? (y/n)');
        var input = stdin.readLineSync();

        if (input == 'y') {
          await hiveProducts.put(orderNumberAsInt,
              HiveProduct(receiptName: name!, eanName: eanName!));
          print('Product updated!');
        } else {
          print('Product not updated!');
        }
      }
    } else {
      print('Product not found!');
    }
  }
}

/// Delete a product from the storage.
Future<void> _deleteProduct(Box<HiveProduct> hiveProducts) async {
  print('Enter the order number of the product:');

  var orderNumber = stdin.readLineSync();

  if (orderNumber.isNotNullOrEmpty()) {
    var orderNumberAsInt = int.tryParse(orderNumber!);

    var product = hiveProducts.get(orderNumberAsInt!);
    if (product != null) {
      print('Product: $product');

      print('Do you want to delete this product? (y/n)');
      var input = stdin.readLineSync();

      if (input == 'y') {
        await hiveProducts.delete(orderNumberAsInt);
        print('Product deleted!');
        _countProducts(hiveProducts);
      } else {
        print('Product not deleted!');
      }
    } else {
      print('Product not found!');
    }
  }
}

/// Counts the products in the storage.
void _countProducts(Box<HiveProduct> hiveProducts) {
  print('Amount of products: ${hiveProducts.length}');
}

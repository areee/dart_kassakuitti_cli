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

  for (var product in hiveProducts.keys) {
    print('\t#$product: ${hiveProducts.get(product)}');
  }
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

    for (var product in filteredProducts) {
      print('\t#$product: ${hiveProducts.get(product)}');
    }
  }
}

/// Updates a product in the storage. FIX ME: This is not working yet correctly.
Future<void> _updateProduct(Box<HiveProduct> hiveProducts) async {
  print('Enter the receipt name of the product:');
  var name = stdin.readLineSync();

  if (name.isNotNullOrEmpty()) {
    print('You entered: $name');

    var product = hiveProducts.get(name!);
    if (product != null) {
      print('Product: $product');

      print('Enter the new receipt name of the product:');
      var newName = stdin.readLineSync();

      print('Enter the new EAN name of the product:');
      var newEanName = stdin.readLineSync();

      if (newName.isNotNullOrEmpty() && newEanName.isNotNullOrEmpty()) {
        print('You entered: $newName, $newEanName');
        print('Do you want to update this product? (y/n)');
        var input = stdin.readLineSync();

        if (input == 'y') {
          await hiveProducts.put(newName,
              HiveProduct(receiptName: newName!, eanName: newEanName!));
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

/// Delete a product from the storage. FIX ME: This is not working yet correctly.
Future<void> _deleteProduct(Box<HiveProduct> hiveProducts) async {
  print('Enter the receipt name of the product:');
  var name = stdin.readLineSync();

  if (name.isNotNullOrEmpty()) {
    print('You entered: $name');

    var product = hiveProducts.get(name!);
    if (product != null) {
      print('Product: $product');

      print('Do you want to delete this product? (y/n)');
      var input = stdin.readLineSync();

      if (input == 'y') {
        await hiveProducts.delete(name);
        print('Product deleted!');
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

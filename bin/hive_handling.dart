import 'dart:io';

import 'package:hive/hive.dart';

import 'models/hive_product.dart';
import 'utils/extensions/string_extension.dart';

/// Hive handling (CRUD for storage handling).
void hiveHandling(Box<HiveProduct> hiveProducts) {
  while (true) {
    print('''

    *** Hive handling ***
    1. Create
    2. Read all
    3. Read one
    4. Update
    5. Delete
    6. Count
    Empty command or something else to exit.
    ''');

    var input = stdin.readLineSync();

    switch (input) {
      case '1':
        _addProduct(hiveProducts);
        break;
      case '2':
        _readAllProducts(hiveProducts);
        break;
      case '3':
        _readOneProduct(hiveProducts);
        break;
      case '4':
        _updateProduct(hiveProducts);
        break;
      case '5':
        _deleteProduct(hiveProducts);
        break;
      case '6':
        _countProducts(hiveProducts);
        break;
      default:
        _exit();
    }
  }
}

/// Counts the products in the storage.
void _countProducts(Box<HiveProduct> hiveProducts) {
  print('Amount of products: ${hiveProducts.length}');
}

/// Adds a product to the storage.
void _addProduct(Box<HiveProduct> hiveProducts) {
  print('Enter the receipt name of the product:');
  var name = stdin.readLineSync();

  print('Enter the EAN name of the product:');
  var eanName = stdin.readLineSync();

  if (!name.isNullOrEmpty() && !eanName.isNullOrEmpty()) {
    print('You entered: $name, $eanName');
    print('Do you want to add this product? (y/n)');
    var input = stdin.readLineSync();

    if (input == 'y') {
      hiveProducts.add(HiveProduct(receiptName: name!, eanName: eanName!));
      print('Product added!');
    } else {
      print('Product not added!');
    }
  }
}

/// Reads all products from the storage.
void _readAllProducts(Box<HiveProduct> hiveProducts) {
  print('All products:');
  for (var product in hiveProducts.values) {
    print('\t$product');
  }
}

/// Read a product from the storage.
void _readOneProduct(Box<HiveProduct> hiveProducts) {
  print('Enter the receipt name of the product:');
  var name = stdin.readLineSync();

  if (!name.isNullOrEmpty()) {
    print('You entered: $name');

    var product = hiveProducts.get(name!);
    if (product != null) {
      print('Product: $product');
    } else {
      print('Product not found!');
    }
  }
}

/// Updates a product in the storage.
void _updateProduct(Box<HiveProduct> hiveProducts) {
  print('Enter the receipt name of the product:');
  var name = stdin.readLineSync();

  if (!name.isNullOrEmpty()) {
    print('You entered: $name');

    var product = hiveProducts.get(name!);
    if (product != null) {
      print('Product: $product');

      print('Enter the new receipt name of the product:');
      var newName = stdin.readLineSync();

      print('Enter the new EAN name of the product:');
      var newEanName = stdin.readLineSync();

      if (!newName.isNullOrEmpty() && !newEanName.isNullOrEmpty()) {
        print('You entered: $newName, $newEanName');
        print('Do you want to update this product? (y/n)');
        var input = stdin.readLineSync();

        if (input == 'y') {
          hiveProducts.put(newName,
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

/// Delete a product from the storage.
void _deleteProduct(Box<HiveProduct> hiveProducts) {
  print('Enter the receipt name of the product:');
  var name = stdin.readLineSync();

  if (!name.isNullOrEmpty()) {
    print('You entered: $name');

    var product = hiveProducts.get(name!);
    if (product != null) {
      print('Product: $product');

      print('Do you want to delete this product? (y/n)');
      var input = stdin.readLineSync();

      if (input == 'y') {
        hiveProducts.delete(name);
        print('Product deleted!');
      } else {
        print('Product not deleted!');
      }
    } else {
      print('Product not found!');
    }
  }
}

/// Exits the program.
void _exit() {
  print('Bye!');
  exit(0);
}

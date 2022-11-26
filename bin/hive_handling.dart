import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path/path.dart';

import 'models/hive_product.dart';
import 'utils/date_helper.dart';
import 'utils/extensions/box_hive_product_extension.dart';
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
    8. Import from CSV
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
        hiveProducts.countProducts();
        break;
      case '7':
        await _exportToCsv(hiveProducts);
        break;
      case '8':
        await _importFromCsv(hiveProducts);
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
  var receiptName = stdin.readLineSync();

  print('Enter the EAN name of the product:');
  var eanName = stdin.readLineSync();

  print('(Optional) Enter the unit price of the product:');
  var priceStr = stdin.readLineSync();
  var price = priceStr.toDoubleOrNull();

  print('(Optional) Enter the EAN code of the product:');
  var eanCode = stdin.readLineSync();
  eanCode = eanCode.isEan13() ? eanCode : null;

  if (receiptName.isNotNullOrEmpty() && eanName.isNotNullOrEmpty()) {
    print('''You entered:
    Receipt name: $receiptName
    EAN name: $eanName
    Price: ${price ?? 'not set'}
    EAN code: ${eanCode.isNullOrEmpty() ? 'not set' : eanCode}
    ''');
    print('Do you want to add this product? (y/n)');
    var input = stdin.readLineSync();

    if (input == 'y') {
      await hiveProducts.add(HiveProduct(
        receiptName: receiptName!,
        eanName: eanName!,
        price: price,
        eanCode: eanCode,
      ));
      print('Product added!');
      hiveProducts.countProducts();
    } else {
      print('Product not added!');
    }
  }
}

/// Reads all products from the storage.
void _readAllProducts(Box<HiveProduct> hiveProducts) {
  hiveProducts.countProducts();
  print('All products:');
  // _printProducts(products: hiveProducts);
  hiveProducts.readAllProducts();
}

/// Search by keyword in the storage.
void _searchByKeyword(Box<HiveProduct> hiveProducts) {
  print('Enter a keyword:');
  var keyword = stdin.readLineSync();

  if (keyword.isNotNullOrEmpty()) {
    print('You entered: $keyword');

    hiveProducts.searchByKeyword(keyword!);
  }
}

/// Updates a product in the storage.
Future<void> _updateProduct(Box<HiveProduct> hiveProducts) async {
  print('Enter search term of the product:');
  var searchTerm = stdin.readLineSync();

  if (searchTerm.isNotNullOrEmpty()) {
    print('You entered: $searchTerm');
    var orderNumber =
        hiveProducts.getOrderNumberOfProductBySearchTerm(searchTerm!);
    if (orderNumber == null) {
      print('Product not found!');
      return;
    }

    print('Enter the new receipt name of the product '
        '(keep empty to not change):');
    var receiptNameInput = stdin.readLineSync();
    var receiptName = receiptNameInput.isNullOrEmpty()
        ? hiveProducts.get(orderNumber)!.receiptName
        : receiptNameInput;

    print('Enter the new EAN name of the product '
        '(keep empty to not change):');
    var eanNameInput = stdin.readLineSync();
    var eanName = eanNameInput.isNullOrEmpty()
        ? hiveProducts.get(orderNumber)!.eanName
        : eanNameInput;

    print('(Optional) Enter the new unit price of the product '
        '(keep empty to not change):');
    var priceStr = stdin.readLineSync();
    var price = priceStr.isNullOrEmpty()
        ? hiveProducts.get(orderNumber)!.price
        : priceStr.toDoubleOrNull();

    print('(Optional) Enter the new EAN code of the product '
        '(keep empty to not change):');
    var eanCode = stdin.readLineSync();
    eanCode = eanCode.isNullOrEmpty()
        ? hiveProducts.get(orderNumber)!.eanCode
        : eanCode.isEan13()
            ? eanCode
            : null;

    if (receiptName.isNotNullOrEmpty() && eanName.isNotNullOrEmpty()) {
      print('''You entered:
    Receipt name: $receiptName
    EAN name: $eanName
    Price: ${price ?? 'not set'}
    EAN code: ${eanCode.isNullOrEmpty() ? 'not set' : eanCode}
    ''');
      print('Do you want to update this product? (y/n)');
      var input = stdin.readLineSync();

      if (input == 'y') {
        await hiveProducts.put(
            orderNumber,
            HiveProduct(
              receiptName: receiptName!,
              eanName: eanName!,
              price: price,
              eanCode: eanCode,
            ));
        print('Product updated!');
      } else {
        print('Product not updated!');
      }
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
    hiveProducts.countProducts();
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

/// Exports the products to a CSV file.
Future<void> _exportToCsv(Box<HiveProduct> hiveProducts) async {
  print('Do you want to export all Hive products '
      '(${hiveProducts.length} pcs.) to a CSV file? (y/n)');
  var input = stdin.readLineSync();

  if (input == 'y') {
    var csv = StringBuffer();

    // Write the header:
    var header = ['Receipt name', 'EAN name', 'Unit price', 'EAN code'];
    csv.write('${header.join(';')}\n');

    // Write the products:
    for (var product in hiveProducts.values) {
      var row = [
        product.receiptName,
        product.eanName,
        product.price ?? '',
        product.eanCode ?? '',
      ];
      csv.write('${row.join(';')}\n');
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

/// Imports products from a CSV file.
Future<void> _importFromCsv(Box<HiveProduct> hiveProducts) async {
  print('Do you want to import and replace all current Hive products '
      '(${hiveProducts.length} pcs.) with products from a CSV file? (y/n)');
  var input = stdin.readLineSync();

  if (input == 'y') {
    print('Enter the path to the CSV file:');
    var filePath = stdin.readLineSync();

    if (filePath.isNotNullOrEmpty()) {
      var file = File(filePath!);
      if (await file.exists()) {
        var csv = await file.readAsString();
        var lines = csv.split('\n');

        if (lines.isNotEmpty) {
          print('Enter the separator:');
          var separator = stdin.readLineSync();

          if (separator.isNotNullOrEmpty()) {
            var header = lines[0].split(separator!);
            var productIndex = header.indexOf('Receipt name');
            var eanNameIndex = header.indexOf('EAN name');
            var priceIndex = header.indexOf('Unit price');
            var eanCodeIndex = header.indexOf('EAN code');

            if (productIndex != -1 &&
                eanNameIndex != -1 &&
                priceIndex != -1 &&
                eanCodeIndex != -1) {
              // Delete all current products:
              await hiveProducts.deleteAll(hiveProducts.keys);

              // Add the new products:
              for (var i = 1; i < lines.length; i++) {
                var line = lines[i];
                var productDataList = line.split(separator);

                var product = HiveProduct(
                  receiptName: productDataList[productIndex],
                  eanName: productDataList[eanNameIndex],
                  price: productDataList[priceIndex].isNotEmpty
                      ? double.tryParse(productDataList[priceIndex])
                      : null,
                  eanCode: productDataList[eanCodeIndex].isNotEmpty
                      ? productDataList[eanCodeIndex]
                      : null,
                );

                await hiveProducts.add(product);
              }
              print('Products imported!');
            } else {
              print('Invalid CSV file!');
            }
          }
        }
      }
    }
  } else {
    print('Products not imported!');
  }
}

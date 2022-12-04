import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path/path.dart';

import 'models/hive_product.dart';
import 'utils/ansipen_helper.dart';
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

  if (receiptName.isNullOrEmpty() || eanName.isNullOrEmpty()) {
    print('Receipt name and EAN name are required.');
    return;
  }
  var hiveProduct = HiveProduct(
    receiptName: receiptName!,
    eanName: eanName!,
    price: price,
    eanCode: eanCode,
  );
  print('You entered:');
  print(hiveProduct);
  print('Do you want to add this product? (y/n)');
  var input = stdin.readLineSync();
  if (input != 'y') {
    print('Product not added!');
    return;
  }
  await hiveProducts.add(hiveProduct);
  print('Product added!');
  hiveProducts.countProducts();
}

/// Reads all products from the storage.
void _readAllProducts(Box<HiveProduct> hiveProducts) {
  hiveProducts.countProducts();
  print('All products:');
  hiveProducts.readAllProducts();
}

/// Search by keyword in the storage.
void _searchByKeyword(Box<HiveProduct> hiveProducts) {
  print('Enter a keyword:');
  var keyword = stdin.readLineSync();
  if (keyword.isNullOrEmpty()) {
    return;
  }
  print('You entered: $keyword');
  hiveProducts.searchByKeyword(keyword!);
}

/// Updates a product in the storage.
Future<void> _updateProduct(Box<HiveProduct> hiveProducts) async {
  print('Enter search term of the product:');
  var searchTerm = stdin.readLineSync();
  if (searchTerm.isNullOrEmpty()) return;

  print('You entered: $searchTerm');
  var orderNumber = hiveProducts.getOrderNumberOfProductByKeyword(searchTerm!);
  if (orderNumber == null) {
    print('Product not found!');
    return;
  }

  print(hiveProducts.getProductByKey(orderNumber));

  print('\nEnter the new receipt name of the product '
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

  if (receiptName.isNullOrEmpty() || eanName.isNullOrEmpty()) {
    print('Receipt name and EAN name are required.');
    return;
  }
  var hiveProduct = HiveProduct(
    receiptName: receiptName!,
    eanName: eanName!,
    price: price,
    eanCode: eanCode,
  );
  print('You entered:');
  print(hiveProduct);
  print('Do you want to update this product? (y/n)');
  var input = stdin.readLineSync();
  if (input != 'y') {
    print('Product not updated!');
    return;
  }
  await hiveProducts.put(orderNumber, hiveProduct);
  print('Product updated!');
}

/// Delete a product from the storage.
Future<void> _deleteProduct(Box<HiveProduct> hiveProducts) async {
  print('Enter search term of the product:');
  var searchTerm = stdin.readLineSync();
  if (searchTerm.isNullOrEmpty()) return;

  print('You entered: $searchTerm');
  var orderNumber = hiveProducts.getOrderNumberOfProductByKeyword(searchTerm!);
  if (orderNumber == null) {
    print('Product not found!');
    return;
  }
  print(hiveProducts.getProductByKey(orderNumber));
  print('Do you want to delete this product? (y/n)');
  var input = stdin.readLineSync();

  if (input != 'y') {
    print('Product not deleted!');
    return;
  }
  await hiveProducts.delete(orderNumber);
  print('Product deleted!');
  hiveProducts.countProducts();
}

/// Exports the products to a CSV file.
Future<void> _exportToCsv(Box<HiveProduct> hiveProducts) async {
  print('Do you want to export all Hive products '
      '(${hiveProducts.length} pcs.) to a CSV file? (y/n)');
  var input = stdin.readLineSync();

  if (input != 'y') {
    print('CSV file not exported!');
    return;
  }
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
}

/// Imports products from a CSV file.
Future<void> _importFromCsv(Box<HiveProduct> hiveProducts) async {
  print('Do you want to import and replace all current Hive products '
      '(${hiveProducts.length} pcs.) with products from a CSV file? (y/n)');
  print(redPen()
      .write('WARNING: This will overwrite the existing Hive database!'));
  var input = stdin.readLineSync();
  if (input != 'y') {
    print('Products not imported!');
    return;
  }
  print('Enter the path to the CSV file:');
  var filePath = stdin.readLineSync();
  if (!filePath.isCsvFile()) {
    print('Invalid file path!');
    return;
  }
  var file = File(filePath!);
  if (!await file.exists()) {
    print('File does not exist!');
    return;
  }
  var csv = await file.readAsString();
  // Split lines with \r\n (Windows), \n (Linux) or \r (Mac):
  var lines = csv.split(RegExp(r'\r\n|\n|\r'));
  if (lines.isEmpty) {
    print('CSV file is empty!');
    return;
  }
  print('(Optional) Enter the separator (the default is ";"):');
  var separator = stdin.readLineSync();
  if (separator.isNullOrEmpty()) separator = ';';

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
      if (line.isEmpty) continue;
      var productDataList = line.split(separator);

      await hiveProducts.add(HiveProduct(
        receiptName: productDataList[productIndex],
        eanName: productDataList[eanNameIndex],
        price: productDataList[priceIndex].toDoubleOrNull(),
        eanCode: productDataList[eanCodeIndex].isEan13()
            ? productDataList[eanCodeIndex]
            : null,
      ));
    }
    print('${hiveProducts.length} products imported!');
  } else {
    print('''
Invalid CSV file!
The CSV file must contain the following columns:
Receipt name, EAN name, Unit price, EAN code
Current columns: ${header.join(', ')}''');
  }
}

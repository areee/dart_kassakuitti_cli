import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:hive/hive.dart';

import '../../models/ean_product.dart';
import '../../models/hive_product.dart';
import '../../models/receipt_product.dart';

const _kHiveBoxName = 'hiveProducts';

/// Handles the EAN products.
Future<void> eanHandler(
    List<ReceiptProduct> receiptProducts, List<EANProduct> eanProducts) async {
  Hive.init(Directory.current.path);
  Hive.registerAdapter(HiveProductAdapter());

  var hiveProducts = await Hive.openBox<HiveProduct>(_kHiveBoxName);

  print('\nThe first round begins!');
  print('Statistics:');
  print('Amount of hive products: ${hiveProducts.length}');
  print('${receiptProducts.length} receiptProducts, '
      '${eanProducts.length} eanProducts\n');
  List<ReceiptProduct> nonFoundReceiptProducts = [];

  for (var receiptProduct in receiptProducts) {
    print(receiptProduct);

    var filteredEanProducts =
        _filterEANProducts(receiptProduct.name, eanProducts);

    _handleFoundCases(
        receiptProduct, filteredEanProducts, eanProducts, hiveProducts);

    if (filteredEanProducts.isEmpty) {
      print('\tNo product found for the 1st round.');
      nonFoundReceiptProducts.add(receiptProduct);
    }
  }

  print('\nThe second round begins!');
  print(
      'Statistics: ${nonFoundReceiptProducts.length} nonFoundReceiptProducts, '
      '${eanProducts.length} eanProducts\n');

  for (var nonFoundReceiptProduct in nonFoundReceiptProducts) {
    print(nonFoundReceiptProduct);

    var splittedReceiptProcuctNames = nonFoundReceiptProduct.name.split(' ');

    if (splittedReceiptProcuctNames.isEmpty) {
      print('\tNo product found for the 2nd round.');
      continue;
    }

    var filteredEanProducts =
        _filterEANProducts(splittedReceiptProcuctNames[0], eanProducts);

    // if (filteredEanProducts.length > 2 &&
    //     splittedReceiptProcuctNames.length > 1) {
    //   filteredEanProducts =
    //       _filterEANProducts(splittedReceiptProcuctNames[1], eanProducts);
    // }

    _handleFoundCases(
        nonFoundReceiptProduct, filteredEanProducts, eanProducts, hiveProducts);

    if (filteredEanProducts.isEmpty) {
      print('\tNo product found for the 2nd round.');
    }
  }

  print('\nFinished!');
  // print('Only ${eanProducts.length} unknown eanProducts left.');
  print('Amount of hive products: ${hiveProducts.length}');

  hiveProducts.close();
}

List<EANProduct> _filterEANProducts(
    String receiptProductName, List<EANProduct> eanProducts) {
  return eanProducts
      .where((eanProduct) =>
          eanProduct.name.toLowerCase().contains(receiptProductName))
      .toList();
}

void _handleFoundCases(
    ReceiptProduct receiptProduct,
    List<EANProduct> filteredEanProducts,
    List<EANProduct> origEanProducts,
    Box<HiveProduct> hiveProducts) {
  if (filteredEanProducts.length == 1) {
    AnsiPen pen = _greenPen();

    print(pen('\tFound one product:'));
    print('\t\t${filteredEanProducts[0]}');

    receiptProduct.eanCode = filteredEanProducts[0].ean;
    // origEanProducts.remove(filteredEanProducts[0]);
  } else if (filteredEanProducts.length > 1) {
    AnsiPen pen = _redPen();
    print(pen('\tFound multiple products (${filteredEanProducts.length}'
        ' possible choices):'));

    for (var i = 0; i < filteredEanProducts.length; i++) {
      print('\t\t${i + 1}. ${filteredEanProducts[i]}');
    }
    print('\nPlease enter the number of the product you want to select: ');
    var answer = stdin.readLineSync();

    if (answer!.isNotEmpty &&
        int.parse(answer) <= filteredEanProducts.length &&
        int.parse(answer) > 0) {
      var selectedEanProduct = filteredEanProducts[int.parse(answer) - 1];

      AnsiPen pen = _greenPen();
      print(pen('\tYou selected: $selectedEanProduct'));

      receiptProduct.eanCode = selectedEanProduct.ean;

      hiveProducts.add(HiveProduct(
          receiptName: receiptProduct.name, eanName: selectedEanProduct.name));
      // origEanProducts.remove(selectedEanProduct);
    } else {
      print('\tNo product selected.');
    }
  }
}

AnsiPen _greenPen() {
  return AnsiPen()
    ..black(bold: true)
    ..green(bold: true);
}

AnsiPen _redPen() {
  return AnsiPen()
    ..black(bold: true)
    ..red(bold: true);
}

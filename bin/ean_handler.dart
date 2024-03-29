import 'dart:io';

import 'package:hive/hive.dart';
import 'package:kassakuitti/kassakuitti.dart';

import 'models/hive_product.dart';
import 'utils/ansipen_helper.dart';

/// Handles the EAN products using Hive storage.
Future<Box<HiveProduct>> eanHandler(List<ReceiptProduct> receiptProducts,
    List<EANProduct> eanProducts, Box<HiveProduct> hiveProducts) async {
  List<ReceiptProduct> nonFoundReceiptProducts = [];
  List<ReceiptProduct> nonFoundReceiptProducts2 = [];

  print('\nThe first round begins!');
  print('Statistics:');
  print(peachPen().write('Amount of hive products: ${hiveProducts.length}'));
  print('${receiptProducts.length} receiptProducts, '
      '${eanProducts.length} eanProducts\n');

  for (var receiptProduct in receiptProducts) {
    print(receiptProduct);

    String? eanProductName =
        _filterHiveProducts(hiveProducts.values, receiptProduct);
    print(peachPen().write('EAN product name: $eanProductName'));

    var filteredEanProducts =
        _filterEANProducts(receiptProduct.name, eanProducts, eanProductName);

    await _handleFoundCases(
        receiptProduct, filteredEanProducts, eanProducts, hiveProducts);

    print(peachPen().write('Amount of hive products: ${hiveProducts.length}'));

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

    String? eanProductName =
        _filterHiveProducts(hiveProducts.values, nonFoundReceiptProduct);
    print(peachPen().write('EAN product name: $eanProductName'));

    var filteredEanProducts = _filterEANProducts(
        splittedReceiptProcuctNames[0], eanProducts, eanProductName);

    await _handleFoundCases(
        nonFoundReceiptProduct, filteredEanProducts, eanProducts, hiveProducts);

    if (filteredEanProducts.isEmpty) {
      print('\tNo product found for the 2nd round.');
      nonFoundReceiptProducts2.add(nonFoundReceiptProduct);
    }
  }

  print('\nFinished!');
  print('${nonFoundReceiptProducts2.length < 10 ? 'Only ' : ''}'
      '${nonFoundReceiptProducts2.length} unknown receipt '
      '${nonFoundReceiptProducts2.length == 1 ? 'product' : 'products'} '
      'left.');
  print(peachPen().write('Amount of hive products: ${hiveProducts.length}'));

  return hiveProducts;
}

String? _filterHiveProducts(
    Iterable<HiveProduct> hiveProductsValues, ReceiptProduct receiptProduct) {
  String? eanProductName;

  var filterPrice = receiptProduct.quantity == 1
      ? receiptProduct.totalPrice
      : receiptProduct.pricePerUnit;

  var filteredHiveProducts = hiveProductsValues.where((hiveProduct) =>
      hiveProduct.receiptName == receiptProduct.name &&
      (hiveProduct.price == null || hiveProduct.price == filterPrice));
  /*
  If the receipt product is already in the hive products,
  get the ean product name from the hive product.
  */
  if (filteredHiveProducts.isNotEmpty) {
    print(greenPen().write(
        '\tFound ${filteredHiveProducts.length} pcs in the hive products!'));
    eanProductName = filteredHiveProducts.first.eanName;
    print('\tEAN product name in Hive: $eanProductName');
  }
  return eanProductName;
}

List<EANProduct> _filterEANProducts(String receiptProductName,
    List<EANProduct> eanProducts, String? eanProductName) {
  /*
  If eanProductName is not null,
  filter the ean products by the ean product name.
  */
  if (eanProductName != null) {
    return eanProducts
        .where((eanProduct) =>
            eanProduct.name.toLowerCase() == eanProductName.toLowerCase())
        .toList();
  }
  return eanProducts
      .where((eanProduct) => eanProduct.name
          .toLowerCase()
          .contains(receiptProductName.toLowerCase()))
      .toList();
}

Future<void> _handleFoundCases(
    ReceiptProduct receiptProduct,
    List<EANProduct> filteredEanProducts,
    List<EANProduct> origEanProducts,
    Box<HiveProduct> hiveProducts) async {
  if (filteredEanProducts.length == 1) {
    print(greenPen().write('\tFound one product:'));
    print('\t\t${filteredEanProducts.first}');

    receiptProduct.eanCode = filteredEanProducts.first.eanCode;
  } else if (filteredEanProducts.length > 1) {
    print(redPen()
        .write('\tFound multiple products (${filteredEanProducts.length}'
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

      print(greenPen().write('\tYou selected: $selectedEanProduct'));

      receiptProduct.eanCode = selectedEanProduct.eanCode;

      await hiveProducts.add(HiveProduct(
        receiptName: receiptProduct.name,
        eanName: selectedEanProduct.name,
        price: receiptProduct.quantity == 1
            ? receiptProduct.totalPrice
            : receiptProduct.pricePerUnit,
        eanCode: selectedEanProduct.eanCode,
      ));
      print(
          peachPen().write('Amount of hive products: ${hiveProducts.length}'));
    } else {
      print('\tNo product selected.');
    }
  }
}

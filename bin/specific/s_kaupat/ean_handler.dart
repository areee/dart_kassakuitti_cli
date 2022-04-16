import 'dart:io';

import '../../models/ean_product.dart';
import '../../models/receipt_product.dart';

void eanHandler(
    List<ReceiptProduct> receiptProducts, List<EANProduct> eanProducts) {
  print('\nThe first round begins!');
  print('Statistics: ${receiptProducts.length} receiptProducts, '
      '${eanProducts.length} eanProducts\n');
  List<ReceiptProduct> nonFoundReceiptProducts = [];

  for (var receiptProduct in receiptProducts) {
    print(receiptProduct);

    var filteredEanProducts =
        _filterEANProducts(receiptProduct.name, eanProducts);

    _handleFoundCases(receiptProduct, filteredEanProducts, eanProducts);

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

    if (filteredEanProducts.length > 2 &&
        splittedReceiptProcuctNames.length > 1) {
      filteredEanProducts =
          _filterEANProducts(splittedReceiptProcuctNames[1], eanProducts);
    }

    _handleFoundCases(nonFoundReceiptProduct, filteredEanProducts, eanProducts);

    if (filteredEanProducts.isEmpty) {
      print('\tNo product found for the 2nd round.');
    }
  }

  print('\nFinished!');
  print('Only ${eanProducts.length} unknown eanProducts left.');
}

List<EANProduct> _filterEANProducts(
    String receiptProductName, List<EANProduct> eanProducts) {
  return eanProducts
      .where((eanProduct) =>
          eanProduct.name.toLowerCase().contains(receiptProductName))
      .toList();
}

void _handleFoundCases(ReceiptProduct receiptProduct,
    List<EANProduct> filteredEanProducts, List<EANProduct> origEanProducts) {
  if (filteredEanProducts.length == 1) {
    print('\tFound one product:');
    print('\t\t${filteredEanProducts[0]}');

    receiptProduct.eanCode = filteredEanProducts[0].ean;
    origEanProducts.remove(filteredEanProducts[0]);
  } else if (filteredEanProducts.length > 1) {
    print(
        '\tFound multiple products (${filteredEanProducts.length} possible choices):');

    for (var filteredReceiptProduct in filteredEanProducts) {
      print('\t\t$filteredReceiptProduct');
      print('\t\tIs this the right product? (y/n)');
      var answer = stdin.readLineSync();
      if (answer?.toLowerCase() == 'y') {
        receiptProduct.eanCode = filteredReceiptProduct.ean;
        origEanProducts.remove(filteredReceiptProduct);
        break;
      }
    }
  }
}

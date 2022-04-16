import 'dart:io';

import '../../models/ean_product.dart';
import '../../models/receipt_product.dart';

void eanHandler(
    List<ReceiptProduct> receiptProducts, List<EANProduct> eanProducts) {
  for (var receiptProduct in receiptProducts) {
    print(receiptProduct);

    var filteredEanProducts =
        filterEANProducts(receiptProduct.name, eanProducts);

    handleFoundCases(receiptProduct, filteredEanProducts);

    if (filteredEanProducts.isEmpty) {
      print('\tNo product found for the 1st round.');
      var splittedReceiptProcuctNames = receiptProduct.name.split(' ');

      var filteredEanProducts =
          filterEANProducts(splittedReceiptProcuctNames[0], eanProducts);

      handleFoundCases(receiptProduct, filteredEanProducts);

      if (filteredEanProducts.isEmpty) {
        print('\tNo product found for the 2nd round.');
      }
    }
  }
}

List<EANProduct> filterEANProducts(
    String receiptProductName, List<EANProduct> eanProducts) {
  return eanProducts
      .where((eanProduct) =>
          eanProduct.name.toLowerCase().contains(receiptProductName))
      .toList();
}

void handleFoundCases(
    ReceiptProduct receiptProduct, List<EANProduct> filteredEanProducts) {
  if (filteredEanProducts.length == 1) {
    print('\tFound one product:');
    print('\t\t${filteredEanProducts[0]}');

    receiptProduct.eanCode = filteredEanProducts[0].ean;
  } else if (filteredEanProducts.length > 1) {
    print('\tFound multiple products:');

    for (var filteredReceiptProduct in filteredEanProducts) {
      print('\t\t$filteredReceiptProduct');
      print('\t\tIs this the right product? (y/n)');
      var answer = stdin.readLineSync();
      if (answer?.toLowerCase() == 'y') {
        receiptProduct.eanCode = filteredReceiptProduct.ean;
        break;
      }
    }
  }
}

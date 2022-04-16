import 'dart:io';

import '../../models/ean_product.dart';
import '../../models/receipt_product.dart';

void eanHandler(
    List<ReceiptProduct> receiptProducts, List<EANProduct> eanProducts) {
  for (var receiptProduct in receiptProducts) {
    print(receiptProduct);

    var filteredEanProducts = eanProducts
        .where((eanProduct) =>
            eanProduct.name.toLowerCase().contains(receiptProduct.name))
        .toList();

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
    } else {
      print('\tNo product found for the 1st round.');
      // var splittedReceiptProcuctNames = receiptProcuctName.split(' ');
      // var filteredEanProducts2 = eanProducts
      //     .where((eanProduct) =>
      //         eanProduct.name.contains(splittedReceiptProcuctNames[0]))
      //     .toList();

      // if (filteredEanProducts2.length == 1) {
      //   print('\tFound one product:');

      //   var filteredEanProduct = filteredEanProducts2[0];
      //   receiptProduct.eanCode = filteredEanProduct.ean;
      //   print('\t\t$filteredEanProduct');

      //   // print('\tLength of ean products 1: ${eanProducts.length}');
      //   // eanProducts.remove(filteredEanProduct);
      //   // print('\tLength of ean products 2: ${eanProducts.length}');
      // } else if (filteredEanProducts2.length > 1) {
      //   print('\tFound multiple products:');

      //   for (var filteredReceiptProduct in filteredEanProducts2) {
      //     print('\t\t$filteredReceiptProduct');
      //     print('Did you mean this? (y/n)');
      //     var answer = stdin.readLineSync();
      //     if (answer?.toLowerCase() == 'y') {
      //       receiptProduct.eanCode = filteredReceiptProduct.ean;
      //       // print('\tLength of ean products 1: ${eanProducts.length}');
      //       // eanProducts.remove(filteredReceiptProduct);
      //       // print('\tLength of ean products 2: ${eanProducts.length}');
      //       break;
      //     }
      //   }
      // } else {
      //   print('\tNo product found for the 2nd round.');
      // }
    }
  }
}

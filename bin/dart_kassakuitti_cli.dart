import 'dart:io';

import 'read_ean_products.dart';
import 'ean_products_2_csv.dart';
import 'specific/s_kaupat/read_receipt_products.dart';
import 'specific/s_kaupat/receipt_products_2_csv.dart';
import 'utils/arg_selector_helper.dart';
import 'utils/parse_kassakuitti_arguments.dart';
import 'utils/printing_helper.dart';
import 'utils/shop_selector_helper.dart';

void main(List<String> arguments) async {
  exitCode = 0; // presume success

  var parser = getParser();
  var argResults = parser.parse(arguments);

  if (argResults.command?.name == ArgSelector.help.value!) {
    print('Help:\n${parser.usage}');
    return;
  } else if (argResults.command?.name == ArgSelector.run.value!) {
    print('\nRunning...\n');

    var selectedTextFile = argResults[ArgSelector.textFile.value!] as String;
    var selectedHtmlFile = argResults[ArgSelector.htmlFile.value!] as String;
    var selectedStore =
        argResults[ArgSelector.foodOnlineStore.value!] as String;
    var csvFilesPath = argResults[ArgSelector.csvPath.value!] as String;

    printSelectedValues(
        selectedTextFile, selectedHtmlFile, selectedStore, csvFilesPath);

    try {
      if (ShopSelector.sKaupat.isEqual(selectedStore)) {
        var receiptProducts =
            await readReceiptProducts(selectedTextFile, csvFilesPath);
        var eanProducts = await readEANProducts(
            selectedHtmlFile, ShopSelector.sKaupat, csvFilesPath);

        // print('\nWould you like to go through receipt products? (y/n)');
        // var answer = stdin.readLineSync();

        // if (answer?.toLowerCase() == 'y') {
        for (var receiptProduct in receiptProducts) {
          print(receiptProduct);

          var receiptProcuctName = receiptProduct.name;
          var filteredEanProducts = eanProducts
              .where(
                  (eanProduct) => eanProduct.name.contains(receiptProcuctName))
              .toList();

          if (filteredEanProducts.length == 1) {
            print('\tFound one product:');

            var filteredEanProduct = filteredEanProducts[0];
            receiptProduct.eanCode = filteredEanProduct.ean;
            print('\t\t$filteredEanProduct');

            print('\tLength of ean products 1: ${eanProducts.length}');
            eanProducts.remove(filteredEanProduct);
            print('\tLength of ean products 2: ${eanProducts.length}');
          } else if (filteredEanProducts.length > 1) {
            print('\tFound multiple products:');

            for (var filteredReceiptProduct in filteredEanProducts) {
              print('\t\t$filteredReceiptProduct');
              print('Did you mean this? (y/n)');
              var answer = stdin.readLineSync();
              if (answer?.toLowerCase() == 'y') {
                receiptProduct.eanCode = filteredReceiptProduct.ean;
                print('\tLength of ean products 1: ${eanProducts.length}');
                eanProducts.remove(filteredReceiptProduct);
                print('\tLength of ean products 2: ${eanProducts.length}');
                break;
              }
            }
          } else {
            print('\tNo product found for the 1st round.');
            var splittedReceiptProcuctNames = receiptProcuctName.split(' ');
            var filteredEanProducts2 = eanProducts
                .where((eanProduct) =>
                    eanProduct.name.contains(splittedReceiptProcuctNames[0]))
                .toList();

            if (filteredEanProducts2.length == 1) {
              print('\tFound one product:');

              var filteredEanProduct = filteredEanProducts2[0];
              receiptProduct.eanCode = filteredEanProduct.ean;
              print('\t\t$filteredEanProduct');

              print('\tLength of ean products 1: ${eanProducts.length}');
              eanProducts.remove(filteredEanProduct);
              print('\tLength of ean products 2: ${eanProducts.length}');
            } else if (filteredEanProducts2.length > 1) {
              print('\tFound multiple products:');

              for (var filteredReceiptProduct in filteredEanProducts2) {
                print('\t\t$filteredReceiptProduct');
                print('Did you mean this? (y/n)');
                var answer = stdin.readLineSync();
                if (answer?.toLowerCase() == 'y') {
                  receiptProduct.eanCode = filteredReceiptProduct.ean;
                  print('\tLength of ean products 1: ${eanProducts.length}');
                  eanProducts.remove(filteredReceiptProduct);
                  print('\tLength of ean products 2: ${eanProducts.length}');
                  break;
                }
              }
            } else {
              print('\tNo product found for the 2nd round.');
            }
          }
        }
        // }

        receiptProducts2CSV(receiptProducts, csvFilesPath);
        eanProducts2CSV(eanProducts, csvFilesPath, ShopSelector.sKaupat.name);
      } else if (ShopSelector.kRuoka.isEqual(selectedStore)) {
        var eanProducts = await readEANProducts(
            selectedHtmlFile, ShopSelector.kRuoka, csvFilesPath);

        eanProducts2CSV(eanProducts, csvFilesPath, ShopSelector.kRuoka.name);
      } else {
        print('Unknown store: $selectedStore');
        exitCode = 1;
      }
    } on Exception catch (e) {
      print('Error: $e');
      exitCode = 1;
    }

    print('\nDone!');
  } else {
    await printBasicInfo();
  }
}

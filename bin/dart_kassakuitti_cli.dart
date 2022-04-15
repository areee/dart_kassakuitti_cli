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
          var filteredReceiptProducts = eanProducts
              .where(
                  (eanProduct) => eanProduct.name.contains(receiptProcuctName))
              .toList();

          if (filteredReceiptProducts.length == 1) {
            print('\tFound one product:');

            var filteredReceiptProduct = filteredReceiptProducts[0];
            receiptProduct.eanCode = filteredReceiptProduct.ean;

            print('\t\t$filteredReceiptProduct');
          } else if (filteredReceiptProducts.length > 1) {
            print('\tFound multiple products:');
            for (var filteredReceiptProduct in filteredReceiptProducts) {
              print('\t\t$filteredReceiptProduct');
            }
          } else {
            print('\tNo product found.');
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

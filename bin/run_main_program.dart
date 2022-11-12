import 'dart:io';

import 'package:args/args.dart';
import 'package:hive/hive.dart';
import 'package:kassakuitti/kassakuitti.dart';

import 'ean_handler.dart';
import 'models/hive_product.dart';
import 'utils/arg_selector_helper.dart';

Future<Box<HiveProduct>> runMainProgram(
    ArgResults argResults, Box<HiveProduct> hiveProducts) async {
  print('\nRunning...\n');

  var selectedTextFile = argResults[ArgSelector.textFile.value] as String?;
  var selectedHtmlFile = argResults[ArgSelector.htmlFile.value] as String;
  var selectedStore = argResults[ArgSelector.foodOnlineStore.value] as String;
  // TODO: Implement this to Kassakuitti package:
  // var exportFilesPath = argResults[ArgSelector.exportPath.value] as String;
  var exportFilesFormat = argResults[ArgSelector.exportFormat.value] as String;
  /*
      Check the HTML file name (it should contain k-ruoka or s-kaupat)
      (By default, selectedStore is s-kaupat)
  */
  selectedStore = selectedHtmlFile.contains('k-ruoka.fi')
      ? SelectedShop.kRuoka.shopName
      : selectedStore;

  var selectedShop = selectedStore == SelectedShop.sKaupat.shopName
      ? SelectedShop.sKaupat
      : SelectedShop.kRuoka;
  var selectedFileFormat = exportFilesFormat == SelectedFileFormat.xlsx.name
      ? SelectedFileFormat.xlsx
      : SelectedFileFormat.csv;

  var kassakuitti = Kassakuitti(selectedTextFile, selectedHtmlFile,
      selectedShop: selectedShop, selectedFileFormat: selectedFileFormat);

  print(kassakuitti);

  try {
    if (selectedShop == SelectedShop.sKaupat) {
      var receiptProducts = await kassakuitti.readReceiptProducts();
      var eanProducts = await kassakuitti.readEANProducts();

      await eanHandler(receiptProducts, eanProducts.toList(), hiveProducts);

      await kassakuitti.export(receiptProducts, eanProducts);
    } else if (selectedShop == SelectedShop.kRuoka) {
      var eanProducts = await kassakuitti.readEANProducts();
      await kassakuitti.export(null, eanProducts);
    } else {
      print('Unknown shop: $selectedShop');
      exitCode = 1;
    }
  } on Exception catch (e) {
    print('Error: $e');
    exitCode = 1;
  }

  print('\nDone!');

  return hiveProducts;
}

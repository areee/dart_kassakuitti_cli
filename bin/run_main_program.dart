import 'dart:io';

import 'package:args/args.dart';
import 'package:hive/hive.dart';

import 'ean_products_2_csv.dart';
import 'models/hive_product.dart';
import 'read_ean_products.dart';
import 'specific/s_kaupat/ean_handler.dart';
import 'specific/s_kaupat/read_receipt_products.dart';
import 'specific/s_kaupat/receipt_products_2_csv.dart';
import 'utils/arg_selector_helper.dart';
import 'utils/printing_helper.dart';
import 'utils/shop_selector_helper.dart';

Future<void> runMainProgram(
    ArgResults argResults, Box<HiveProduct> hiveProducts) async {
  print('\nRunning...\n');

  var selectedTextFile = argResults[ArgSelector.textFile.value] as String?;
  var selectedHtmlFile = argResults[ArgSelector.htmlFile.value] as String;
  var selectedStore = argResults[ArgSelector.foodOnlineStore.value] as String;
  var csvFilesPath = argResults[ArgSelector.csvPath.value] as String;

  printSelectedValues(
      selectedTextFile, selectedHtmlFile, selectedStore, csvFilesPath);

  try {
    if (ShopSelector.sKaupat.value == selectedStore) {
      var receiptProducts =
          await readReceiptProducts(selectedTextFile!, csvFilesPath);
      var eanProducts = await readEANProducts(
          selectedHtmlFile, ShopSelector.sKaupat, csvFilesPath);

      await eanHandler(receiptProducts, eanProducts.toList(), hiveProducts);

      receiptProducts2CSV(receiptProducts, csvFilesPath);
      eanProducts2CSV(eanProducts, csvFilesPath, ShopSelector.sKaupat.name);
    } else if (ShopSelector.kRuoka.value == selectedStore) {
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
}

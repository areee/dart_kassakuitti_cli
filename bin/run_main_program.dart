import 'dart:io';

import 'package:args/args.dart';
import 'package:hive/hive.dart';

import 'ean_products_2_csv.dart';
import 'ean_products_2_xlsx.dart';
import 'models/hive_product.dart';
import 'read_ean_products.dart';
import 'specific/s_kaupat/ean_handler.dart';
import 'specific/s_kaupat/read_receipt_products.dart';
import 'specific/s_kaupat/receipt_products_2_csv.dart';
import 'specific/s_kaupat/receipt_products_2_xlsx.dart';
import 'utils/arg_selector_helper.dart';
import 'utils/export_format_helper.dart';
import 'utils/printing_helper.dart';
import 'utils/shop_selector_helper.dart';

Future<Box<HiveProduct>> runMainProgram(
    ArgResults argResults, Box<HiveProduct> hiveProducts) async {
  print('\nRunning...\n');

  var selectedTextFile = argResults[ArgSelector.textFile.value] as String?;
  var selectedHtmlFile = argResults[ArgSelector.htmlFile.value] as String;
  var selectedStore = argResults[ArgSelector.foodOnlineStore.value] as String;
  var exportFilesPath = argResults[ArgSelector.exportPath.value] as String;
  var exportFilesFormat = argResults[ArgSelector.exportFormat.value] as String;

  printSelectedValues(selectedTextFile, selectedHtmlFile, selectedStore,
      exportFilesPath, exportFilesFormat);

  try {
    if (ShopSelector.sKaupat.value == selectedStore) {
      var receiptProducts = await readReceiptProducts(selectedTextFile!);
      var eanProducts =
          await readEANProducts(selectedHtmlFile, ShopSelector.sKaupat);

      await eanHandler(receiptProducts, eanProducts.toList(), hiveProducts);

      // Export products to csv files
      if (exportFilesFormat == ExportFormat.csv.name) {
        receiptProducts2CSV(receiptProducts, exportFilesPath);
        eanProducts2CSV(
            eanProducts, exportFilesPath, ShopSelector.sKaupat.name);
      }
      // Export products to Excel (xlsx) files
      else if (exportFilesFormat == ExportFormat.excel.name) {
        receiptProducts2Excel(receiptProducts, exportFilesPath);
        eanProducts2Excel(
            eanProducts, exportFilesPath, ShopSelector.sKaupat.name);
      } else {
        print('Unknow export format');
        exitCode = 1;
      }
    } else if (ShopSelector.kRuoka.value == selectedStore) {
      var eanProducts =
          await readEANProducts(selectedHtmlFile, ShopSelector.kRuoka);

      // Export products to csv file
      if (exportFilesFormat == ExportFormat.csv.name) {
        eanProducts2CSV(eanProducts, exportFilesPath, ShopSelector.kRuoka.name);
      }
      // Export products to Excel (xlsx) file
      else if (exportFilesFormat == ExportFormat.excel.name) {
        eanProducts2Excel(
            eanProducts, exportFilesPath, ShopSelector.kRuoka.name);
      } else {
        print('Unknow export format');
        exitCode = 1;
      }
    } else {
      print('Unknown store: $selectedStore');
      exitCode = 1;
    }
  } on Exception catch (e) {
    print('Error: $e');
    exitCode = 1;
  }

  print('\nDone!');

  return hiveProducts;
}

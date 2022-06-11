import 'dart:io';

import 'package:args/args.dart';

import 'ean_products_2_csv.dart';
import 'read_ean_products.dart';
import 'specific/s_kaupat/ean_handler.dart';
import 'specific/s_kaupat/read_receipt_products.dart';
import 'specific/s_kaupat/receipt_products_2_csv.dart';
import 'utils/arg_selector_helper.dart';
import 'utils/printing_helper.dart';
import 'utils/shop_selector_helper.dart';

/// Handles the commands in the arguments.
Future<void> handleArgCommands(ArgResults argResults, ArgParser parser) async {
  // Run command
  if (argResults.command?.name == ArgSelector.run.value) {
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

        await eanHandler(receiptProducts, eanProducts.toList());

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
  // Help command
  else if (argResults.command?.name == ArgSelector.help.value) {
    print('Available commands:');
    parser.commands.forEach((name, command) {
      print('  $name');
    });

    print('\n----\n');

    print('Run usages:\n${parser.usage}');
  }
  // Hive (storage) command
  else if (argResults.command?.name == ArgSelector.hive.value) {
    print('AY TODO');
  }
  // Empty command (or other commands, e.g. 'moro' / 'hello')
  else {
    await printBasicInfo(parser);
  }
}
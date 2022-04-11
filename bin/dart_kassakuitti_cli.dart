import 'dart:io';

import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

import 'read_ean_products.dart';
import 'ean_products_2_csv.dart';
import 'specific/s_kaupat/read_receipt_products.dart';
import 'specific/s_kaupat/receipt_products_2_csv.dart';
import 'utils/arg_selector_helper.dart';
import 'utils/parse_kassakuitti_arguments.dart';
import 'utils/shop_selector_helper.dart';

void main(List<String> arguments) async {
  exitCode = 0; // presume success

  var parser = getParser();
  var argResults = parser.parse(arguments);

  if (argResults.command?.name == ArgSelector.help.value!) {
    print('Help:\n${parser.usage}');
    return;
  } else if (argResults.command?.name == ArgSelector.run.value!) {
    print('Running...');

    var selectedTextFile = argResults[ArgSelector.textFile.value!] as String;
    var selectedHtmlFile = argResults[ArgSelector.htmlFile.value!] as String;
    var selectedStore =
        argResults[ArgSelector.foodOnlineStore.value!] as String;
    var csvFilesPath = argResults[ArgSelector.csvPath.value!] as String;

    _printSelectedValues(
        selectedTextFile, selectedHtmlFile, selectedStore, csvFilesPath);

    try {
      if (ShopSelector.sKaupat.isEqual(selectedStore)) {
        var receiptProducts =
            await readReceiptProducts(selectedTextFile, csvFilesPath);

        receiptProducts2CSV(receiptProducts, csvFilesPath);

        var eanProducts = await readEANProducts(
            selectedHtmlFile, ShopSelector.sKaupat, csvFilesPath);

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

    print('Done!');
  } else {
    await _printBasicInfo();
  }
}

Future<void> _printBasicInfo() async {
  String pathToYaml =
      join(dirname(Platform.script.toFilePath()), '../pubspec.yaml');
  var file = File(pathToYaml);
  var fileAsString = await file.readAsString();

  Map yaml = loadYaml(fileAsString);
  print(yaml['name']);
  print(yaml['description']);
  print('Version: ${yaml['version']}');
  print('Homepage: ${yaml['homepage']}');

  print('''\nTo get help, run:
  
    dart run bin/dart_kassakuitti_cli.dart help
    
  or when using alias:
    
    kassakuitti help\n''');
}

void _printSelectedValues(String selectedTextFile, String selectedHtmlFile,
    String selectedStore, String csvFilesPath) {
  print('''Selected values:
    - Path to the cash receipt:\t\t$selectedTextFile
    - Path to the EAN products file:\t$selectedHtmlFile
    - Selected store:\t\t\t$selectedStore
    - Path where to save CSV files:\t$csvFilesPath''');
}

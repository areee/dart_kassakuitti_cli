import 'dart:io';

import 'read_html_and_save_as_csv.dart';
import 'specific/s_kaupat/read_receipt_and_save_as_csv.dart';
import 'utils/arg_selector_helper.dart';
import 'utils/parse_kassakuitti_arguments.dart';
import 'utils/shop_selector_helper.dart';

void main(List<String> arguments) {
  exitCode = 0; // presume success

  var parser = getParser();

  var argResults = parser.parse(arguments);

  if (argResults.command?.name == ArgSelector.help.value!) {
    print('Help:\n${parser.usage}');
    return;
  } else {
    var selectedTextFile = argResults[ArgSelector.textFile.value!] as String;
    var selectedHtmlFile = argResults[ArgSelector.htmlFile.value!] as String;
    var selectedStore =
        argResults[ArgSelector.foodOnlineStore.value!] as String;
    var csvFilesPath = argResults[ArgSelector.csvPath.value!] as String;

    printSelectedValues(
        selectedTextFile, selectedHtmlFile, selectedStore, csvFilesPath);

    try {
      if (ShopSelector.sKaupat.isEqual(selectedStore)) {
        readReceiptAndSaveAsCSV(selectedTextFile, csvFilesPath);
        readHtmlAndSaveAsCSV(
            selectedHtmlFile, ShopSelector.sKaupat, csvFilesPath);
      } else if (ShopSelector.kRuoka.isEqual(selectedStore)) {
        readHtmlAndSaveAsCSV(
            selectedHtmlFile, ShopSelector.kRuoka, csvFilesPath);
      } else {
        print('Unknown store: $selectedStore');
        exitCode = 1;
      }
    } on Exception catch (e) {
      print('Error: $e');
      exitCode = 1;
    }

    print('Done!');
  }
}

void printSelectedValues(String selectedTextFile, String selectedHtmlFile,
    String selectedStore, String csvFilesPath) {
  print('''Selected values:
    - Path to the cash receipt:\t\t$selectedTextFile
    - Path to the EAN products file:\t$selectedHtmlFile
    - Selected store:\t\t\t$selectedStore
    - Path where to save CSV files:\t$csvFilesPath''');
}

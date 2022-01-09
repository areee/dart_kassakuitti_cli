import 'dart:io';
import 'package:args/args.dart';

import 'read_html_and_save_as_csv.dart';
import 'read_receipt_and_save_as_csv.dart';
import 'shop_selector_helper.dart';

const textFile = 'text';
const htmlFile = 'html';
const foodOnlineStore = 'store';
const csvPath = 'csv';
const helpCommand = 'help';

void main(List<String> arguments) {
  exitCode = 0; // presume success

  final parser = ArgParser()
    ..addOption(
      textFile,
      abbr: 't',
      help: 'Text file (cash receipt) to read',
      defaultsTo: 'assets/files/_cashReceipt.txt',
    )
    ..addOption(
      htmlFile,
      abbr: 'h',
      help: 'HTML (EAN products) file to read',
      defaultsTo: 'assets/files/_orderedProducts_S-kaupat.html',
    )
    ..addOption(
      foodOnlineStore,
      abbr: 's',
      help: 'Food online store',
      defaultsTo: 'S-kaupat',
      allowed: ['S-kaupat', 'K-ruoka'],
    )
    ..addOption(
      csvPath,
      abbr: 'c',
      help: 'Path for output CSV files',
      defaultsTo: 'assets/files',
    )
    ..addCommand(helpCommand);

  var argResults = parser.parse(arguments);

  if (argResults.command?.name == helpCommand) {
    print('Help:\n${parser.usage}');
    return;
  } else {
    var selectedTextFile = argResults[textFile] as String;
    var selectedHtmlFile = argResults[htmlFile] as String;
    var selectedStore = argResults[foodOnlineStore] as String;
    var csvFilesPath = argResults[csvPath] as String;

    print('''Selected values:
    - Path to the cash receipt:\t\t$selectedTextFile
    - Path to the EAN products file:\t$selectedHtmlFile
    - Selected store:\t\t\t$selectedStore
    - Path where to save CSV files:\t$csvFilesPath''');

    if (ShopSelector.sKaupat.isEqual(selectedStore)) {
      readReceiptAndSaveAsCSV(selectedTextFile, csvFilesPath);
      readHtmlAndSaveAsCSV(
          selectedHtmlFile, ShopSelector.sKaupat, csvFilesPath);
    } else if (ShopSelector.kRuoka.isEqual(selectedStore)) {
      readHtmlAndSaveAsCSV(selectedHtmlFile, ShopSelector.kRuoka, csvFilesPath);
    } else {
      print('Unknown store: $selectedStore');
      exitCode = 1;
    }

    print('Done!');
  }
}

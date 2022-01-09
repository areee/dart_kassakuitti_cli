import 'dart:io';
import 'package:args/args.dart';

import 'read_html_and_save_as_csv.dart';
import 'read_receipt_and_save_as_csv.dart';
import 'shop_selector_helper.dart';

const textFile = 'text';
const htmlFile = 'html';
const foodOnlineStore = 'store';
const helpCommand = 'help';

void main(List<String> arguments) {
  exitCode = 0; // presume success

  final parser = ArgParser()
    ..addOption(
      textFile,
      abbr: 't',
      help: 'Text file (cash receipt) to read',
      defaultsTo: 'assets/files/_cashReceipt.txt',
      callback: (text) => print('- Path to the cash receipt:\t\t$text'),
    )
    ..addOption(
      htmlFile,
      abbr: 'h',
      help: 'HTML (EAN products) file to read',
      defaultsTo: 'assets/files/_orderedProducts_S-kaupat.html',
      callback: (html) => print('- Path to the EAN products file:\t$html'),
    )
    ..addOption(
      foodOnlineStore,
      abbr: 's',
      help:
          'Food online store. Allowed values: ${ShopSelector.values.join(', ')}',
      defaultsTo: 'S-kaupat',
      allowed: ['S-kaupat', 'K-ruoka'],
      callback: (store) => print('- Selected store:\t\t\t$store'),
    )
    ..addCommand(helpCommand);
  print('Selected values:');

  var argResults = parser.parse(arguments);

  if (argResults.command?.name == helpCommand) {
    print('\nHelp:');
    print(parser.usage);
    return;
  } else {
    var selectedStore = argResults[foodOnlineStore] as String;

    print(selectedStore);
    print(selectedStore.runtimeType);

    // const shopSelector =
    //     ShopSelector.sKaupat; // TODO: make this a command line argument

    // switch (shopSelector) {
    //   case ShopSelector.sKaupat:
    //     readReceiptAndSaveAsCSV(argResults[textFile] as String);
    //     readHtmlAndSaveAsCSV(argResults[htmlFile] as String, shopSelector);
    //     break;
    //   case ShopSelector.kRuoka:
    //     readHtmlAndSaveAsCSV(argResults[htmlFile] as String, shopSelector);
    //     break;
    //   default:
    //     throw 'Unknown shop selector: $shopSelector';
    // }

    // print('Done!');
  }
}

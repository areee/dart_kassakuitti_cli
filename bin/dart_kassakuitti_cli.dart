import 'dart:io';
import 'package:args/args.dart';

import 'read_html_and_save_as_csv.dart';
import 'read_receipt_and_save_as_csv.dart';
import 'shop_selector_helper.dart';

const textFile = 'text-file';
const htmlFile = 'html-file';
const foodOnlineStore = 'food-online-store';

void main(List<String> arguments) {
  exitCode = 0; // presume success
  final parser = ArgParser()
    ..addFlag(textFile, negatable: false, abbr: 't')
    ..addFlag(htmlFile, negatable: false, abbr: 'h')
    ..addFlag(foodOnlineStore, negatable: false, abbr: 's');

  var argResults = parser.parse(arguments);
  final paths = argResults.rest;

  print(argResults[textFile]);
  print(argResults[htmlFile]);
  print(argResults[foodOnlineStore]);
  print(paths);

  // const shopSelector =
  //     ShopSelector.sKaupat; // TODO: make this a command line argument

  // if (shopSelector == ShopSelector.sKaupat) {
  //   readReceiptAndSaveAsCSV('assets/files/_cashReceipt.txt');
  //   readHtmlAndSaveAsCSV(
  //       'assets/files/_orderedProducts_S-kaupat.html', shopSelector);
  // } else {
  //   // K-ruoka
  //   readHtmlAndSaveAsCSV(
  //       'assets/files/_orderedProducts_K-ruoka.html', shopSelector);
  // }

  // print('Done!');
}

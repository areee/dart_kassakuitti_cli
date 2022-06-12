import 'dart:io';

import 'package:args/args.dart';
import 'package:hive/hive.dart';

import 'constants.dart';
import 'hive_handling.dart';
import 'models/hive_product.dart';
import 'run_main_program.dart';
import 'utils/arg_selector_helper.dart';
import 'utils/parse_kassakuitti_arguments.dart';
import 'utils/printing_helper.dart';

void main(List<String> arguments) async {
  exitCode = 0; // presume success
  var hiveProducts = await _initializeHiveProducts();

  var parser = getParser();
  var argResults = parser.parse(arguments);

  await _handleArgCommands(argResults, parser, hiveProducts);

  hiveProducts.close();
}

/// Handles the commands in the arguments.
Future<void> _handleArgCommands(ArgResults argResults, ArgParser parser,
    Box<HiveProduct> hiveProducts) async {
  // Run command
  if (argResults.command?.name == ArgSelector.run.value) {
    await runMainProgram(argResults, hiveProducts);
  }
  // Help command
  else if (argResults.command?.name == ArgSelector.help.value) {
    printHelpers(parser);
  }
  // Hive (storage) command
  else if (argResults.command?.name == ArgSelector.hive.value) {
    hiveHandling(hiveProducts);
  }
  // Empty command (or other commands, e.g. 'moro' / 'hello')
  else {
    await printBasicInfo(parser);
  }
}

/// Initializes the Hive products.
Future<Box<HiveProduct>> _initializeHiveProducts() async {
  Hive.init(Directory.current.path);
  Hive.registerAdapter(HiveProductAdapter());
  return await Hive.openBox<HiveProduct>(kHiveBoxName);
}

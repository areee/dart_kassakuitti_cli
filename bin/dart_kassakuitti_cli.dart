import 'dart:io';

import 'package:args/args.dart';

import 'hive_handling.dart';
import 'run_main_program.dart';
import 'utils/arg_selector_helper.dart';
import 'utils/parse_kassakuitti_arguments.dart';
import 'utils/printing_helper.dart';

void main(List<String> arguments) async {
  exitCode = 0; // presume success

  var parser = getParser();
  var argResults = parser.parse(arguments);

  await handleArgCommands(argResults, parser);
}

/// Handles the commands in the arguments.
Future<void> handleArgCommands(ArgResults argResults, ArgParser parser) async {
  // Run command
  if (argResults.command?.name == ArgSelector.run.value) {
    await runMainProgram(argResults);
  }
  // Help command
  else if (argResults.command?.name == ArgSelector.help.value) {
    printHelpers(parser);
  }
  // Hive (storage) command
  else if (argResults.command?.name == ArgSelector.hive.value) {
    hiveHandling();
  }
  // Empty command (or other commands, e.g. 'moro' / 'hello')
  else {
    await printBasicInfo(parser);
  }
}

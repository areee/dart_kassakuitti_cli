import 'dart:io';

import 'handle_arg_commands.dart';
import 'utils/parse_kassakuitti_arguments.dart';

void main(List<String> arguments) async {
  exitCode = 0; // presume success

  var parser = getParser();
  var argResults = parser.parse(arguments);

  await handleArgCommands(argResults, parser);
}

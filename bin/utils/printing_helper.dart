import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

/// Prints some basic info.
Future<void> printBasicInfo(ArgParser parser) async {
  String pathToYaml =
      join(dirname(Platform.script.toFilePath()), '../pubspec.yaml');
  var file = File(pathToYaml);
  var fileAsString = await file.readAsString();

  Map yaml = loadYaml(fileAsString);
  print(yaml['name']);
  print(yaml['description']);
  print('Version: ${yaml['version']}');
  print('Homepage: ${yaml['homepage']}\n');

  printHelpers(parser);
}

/// Prints helpers.
void printHelpers(ArgParser parser) {
  print('Available commands:');
  parser.commands.forEach((name, command) {
    print('  $name');
  });

  print('\n----\n');

  print('Run usages:\n${parser.usage}');
}

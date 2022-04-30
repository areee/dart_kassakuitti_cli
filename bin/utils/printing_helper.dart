import 'dart:io';

import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

void printSelectedValues(String? selectedTextFile, String selectedHtmlFile,
    String selectedStore, String csvFilesPath) {
  print('Selected values:'
      '${selectedTextFile != null ? '\n- Path to the cash receipt:\t\t$selectedTextFile' : ''}'
      '\n- Path to the EAN products file:\t$selectedHtmlFile'
      '\n- Selected store:\t\t\t$selectedStore'
      '\n- Path where to save CSV files:\t\t$csvFilesPath\n');
}

Future<void> printBasicInfo() async {
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

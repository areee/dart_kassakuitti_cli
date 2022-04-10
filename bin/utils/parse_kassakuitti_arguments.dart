import 'package:args/args.dart';

import 'arg_selector_helper.dart';
import 'shop_selector_helper.dart';

ArgParser getParser() {
  final parser = ArgParser()
    ..addCommand(ArgSelector.run.value!)
    ..addOption(
      ArgSelector.textFile.value!,
      abbr: ArgSelector.textFile.value!.substring(0, 1),
      help: 'Text file (cash receipt) to read',
    )
    ..addOption(
      ArgSelector.htmlFile.value!,
      abbr: ArgSelector.htmlFile.value!.substring(0, 1),
      help: 'HTML (EAN products) file to read',
    )
    ..addOption(
      ArgSelector.foodOnlineStore.value!,
      abbr: ArgSelector.foodOnlineStore.value!.substring(0, 1),
      help: 'Food online store',
      defaultsTo: ShopSelector.sKaupat.value,
      allowed: [ShopSelector.sKaupat.value!, ShopSelector.kRuoka.value!],
    )
    ..addOption(
      ArgSelector.csvPath.value!,
      abbr: ArgSelector.csvPath.value!.substring(0, 1),
      help: 'Path for output CSV files',
    )
    ..addCommand(ArgSelector.help.value!);

  return parser;
}

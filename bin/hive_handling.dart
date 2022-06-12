import 'dart:io';

import 'package:hive/hive.dart';

import 'models/hive_product.dart';

/// Hive handling (CRUD for storage handling).
void hiveHandling(Box<HiveProduct> hiveProducts) {
  while (true) {
    print('''

    *** Hive handling ***
    1. Create
    2. Read
    3. Update
    4. Delete
    5. Count
    Empty command or something else to exit.
    ''');

    var input = stdin.readLineSync();

    switch (input) {
      case '1':
        print('AY TODO 1');
        break;
      case '2':
        print('AY TODO 2');
        break;
      case '3':
        print('AY TODO 3');
        break;
      case '4':
        print('AY TODO 4');
        break;
      case '5':
        print('Amount of products: ${hiveProducts.length}');
        break;
      default:
        print('Bye!');
        exit(0);
    }
  }
}

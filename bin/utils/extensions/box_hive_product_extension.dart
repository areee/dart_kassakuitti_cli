import 'dart:io';

import 'package:hive/hive.dart';

import '../../models/hive_product.dart';

extension BoxHiveProductExtension on Box<HiveProduct> {
  /// Reads all products from the storage.
  void readAllProducts() {
    if (isEmpty) {
      print('No products found.');
      return;
    }

    for (var i = 0; i < length; i++) {
      print(getAt(i));
    }
  }

  /// Searches for products by keyword.
  void searchByKeyword(String keyword) {
    if (isEmpty) {
      print('No products found.');
      return;
    }

    var foundProducts = values.where((product) =>
        product.receiptName.contains(keyword) ||
        product.eanName.contains(keyword));

    if (foundProducts.isEmpty) {
      print('No products found.');
      return;
    }

    var amount = foundProducts.length;
    print('Found $amount ${amount == 1 ? 'product' : 'products'}:');

    for (var product in foundProducts) {
      var index = keys.firstWhere((key) => get(key) == product);
      print('\t$index: $product');
    }
  }

  /// Counts the products in the storage.
  void countProducts() {
    print('Number of products: $length');
  }

  /// Returns the products by given search term.
  /// If the products are not found, returns null.
  Iterable<HiveProduct>? getProductsBySearchTerm(String searchTerm) {
    if (isEmpty) {
      return null;
    }

    var foundProducts = values.where((product) =>
        product.receiptName.contains(searchTerm) ||
        product.eanName.contains(searchTerm));

    if (foundProducts.isEmpty) {
      return null;
    }

    return foundProducts;
  }

  /// Returns order number of the product by given search term.
  /// If the products are not found, returns null.
  int? getOrderNumberOfProductBySearchTerm(String searchTerm) {
    var foundProducts = getProductsBySearchTerm(searchTerm);

    if (foundProducts == null) return null;

    var amount = foundProducts.length;
    print('Found $amount ${amount == 1 ? 'product' : 'products'}:');

    for (var product in foundProducts) {
      var index = keys.firstWhere((key) => get(key) == product);
      print('\t$index: $product');
    }

    print('\nPlease enter the number of the product you want to select: ');
    var input = stdin.readLineSync();
    if (input == null) return null;
    return int.tryParse(input);
  }

  /// Returns the product by the key number.
  /// If the product is not found, returns null.
  HiveProduct? getProductByKey(int key) {
    if (isEmpty) {
      return null;
    }
    return get(key);
  }
}

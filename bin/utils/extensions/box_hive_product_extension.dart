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
    var foundProducts = getProductsBySearchTerm(keyword);
    if (foundProducts == null || foundProducts.isEmpty) {
      print('No products found.');
      return;
    }
    _countFoundProducts(foundProducts.length);
    _printFoundProducts(foundProducts);
  }

  /// Prints found products.
  void _printFoundProducts(Iterable<HiveProduct> foundProducts) {
    for (var product in foundProducts) {
      var index = keys.firstWhere((key) => get(key) == product);
      print('\t$index: $product');
    }
  }

  /// Prints found product amount.
  void _countFoundProducts(int amount) {
    print('Found $amount '
        '${amount == 1 ? 'product' : 'products'}');
  }

  /// Counts the products in the storage.
  void countProducts() {
    print('Number of products: $length');
  }

  /// Returns the products by given search term.
  /// If the products are not found, returns null.
  Iterable<HiveProduct>? getProductsBySearchTerm(String searchTerm) {
    if (isEmpty) return null;
    var foundProducts = values.where((product) =>
        product.receiptName.toLowerCase().contains(searchTerm.toLowerCase()) ||
        product.eanName.toLowerCase().contains(searchTerm.toLowerCase()));
    if (foundProducts.isEmpty) return null;
    return foundProducts;
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

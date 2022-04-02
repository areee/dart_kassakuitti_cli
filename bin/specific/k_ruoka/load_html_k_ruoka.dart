import 'dart:io';
import 'package:html/parser.dart';

import '../../models/ean_product.dart';

/// Loads the HTML file from assets and parses it. Then, it returns a list of EANProduct objects.
Future<List<EANProduct>> loadHtmlFromAssets(String filePath) async {
  List<EANProduct> eanProducts = [];

  var file = File(filePath);
  var html = await file.readAsString();
  var document = parse(html);

  var substitutedProducts =
      document.getElementsByClassName('old-order-substituted-products-list')[0];

  for (var product in substitutedProducts.children) {
    var productInfo = product.children[1].children[0];

    var productEan = productInfo.id.replaceAll('department-product-item-', '');

    var productName = productInfo
        .children[0].children[2].children[0].children[0].text
        .trim()
        .replaceAll('\n', '')
        .replaceAll(RegExp(r'\s{40,50}'), ' ');

    var productQuantity = productInfo.children[0].children[3].children[0].text
        .replaceAll('kpl', '')
        .replaceAll('kg', '');

    var priceElement =
        productInfo.children[0].children[3].children[1].children[0];

    var finalPrice = StringBuffer();

    for (var i = 0; i < priceElement.children.length; i++) {
      if (i != 3) {
        finalPrice.write(priceElement.children[i].text);
      }
    }
    var productPrice = finalPrice.toString();
    var quantity = double.parse(productQuantity).round();

    eanProducts.add(EANProduct(
      ean: productEan,
      name: productName,
      quantity: quantity,
      totalPrice: productPrice,
      pricePerUnit: countPricePerUnit(productPrice, quantity),
    ));
  }

  var pickedProducts =
      document.getElementsByClassName('old-order-departments')[0];

  for (var department in pickedProducts.children) {
    var itemListing = department.children[1];

    for (var productRow in itemListing.children) {
      var productItem = productRow.children[0];

      var productEan =
          productItem.id.replaceAll('department-product-item-', '');

      var productName = productItem
          .children[0].children[1].children[0].children[0].text
          .trim()
          .replaceAll('\n', '')
          .replaceAll(RegExp(r'\s{40,50}'), ' ');

      var productQuantity = productItem.children[0].children[2].children[0].text
          .replaceAll('kpl', '')
          .replaceAll('kg', '')
          .replaceAll(',', '.');

      var priceElement =
          productItem.children[0].children[2].children[1].children[0];

      var finalPrice = StringBuffer();

      for (var i = 0; i < priceElement.children.length; i++) {
        if (i != 3) {
          finalPrice.write(priceElement.children[i].text);
        }
      }
      var productPrice = finalPrice.toString();
      var quantity = double.parse(productQuantity).round();

      eanProducts.add(EANProduct(
        ean: productEan,
        name: productName,
        quantity: quantity,
        totalPrice: productPrice,
        pricePerUnit: countPricePerUnit(productPrice, quantity),
      ));
    }
  }

  // TODO: Add an own section for home delivery price
  return eanProducts;
}

String countPricePerUnit(String productPrice, int quantity) {
  var productPriceAsDouble =
      double.parse(productPrice.replaceAll(RegExp(r','), '.'));
  var pricePerUnit = productPriceAsDouble / quantity;

  return pricePerUnit.toStringAsFixed(2).replaceAll(RegExp(r'\.'), ',');
}

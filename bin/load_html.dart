import 'dart:io';
import 'package:html/parser.dart';

import 'ean_product.dart';

/// Loads the HTML file from assets and parses it. Then, it returns a list of EANProduct objects.
Future<List<EANProduct>> loadHtmlFromAssets() async {
  List<EANProduct> eanProducts = [];

  var file = File('assets/files/orderedProducts.html');
  var html = await file.readAsString();
  var document = parse(html);

  var responseString = document.getElementsByClassName(
      'styled-order-page__StyledOrderItemContainer-sc-qzridm-1')[0];

  var children = responseString.children;

  for (var i = 0; i < responseString.children.length; i++) {
    if (i > 0) {
      var product = children[i];

      var eanCode = product.attributes['data-product-id'] ?? '';

      var productName = product
          .children[0].children[0].children[1].children[0].children[0].text
          .trim();
      productName = productName.replaceAll('\n', '');
      productName = productName.replaceAll(RegExp(r'\s{30}'), ' ');

      var productQuantity = product.children[0].children[0].children[1]
          .children[1].children[1].children[0].children[0].text;

      eanProducts.add(EANProduct(
          ean: eanCode,
          name: productName,
          quantity: int.parse(productQuantity)));
    }
  }
  return eanProducts;
}

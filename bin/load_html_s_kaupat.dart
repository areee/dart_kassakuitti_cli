import 'dart:io';
import 'package:html/parser.dart';

import 'ean_product.dart';

/// Loads the HTML file from assets and parses it. Then, it returns a list of EANProduct objects.
Future<List<EANProduct>> loadHtmlFromAssets(String filePath) async {
  List<EANProduct> eanProducts = [];

  var file = File(filePath);
  var html = await file.readAsString();
  var document = parse(html);

  var responseString = document.getElementsByClassName('sc-qzridm-1 hxbyQZ')[0];

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

      var productPrice = product.children[0].children[0].children[1].children[1]
          .children[1].children[1].text
          .trim();
      productPrice = productPrice.replaceAll(' €', '');

      eanProducts.add(
        EANProduct(
          ean: eanCode,
          name: productName,
          quantity: double.parse(productQuantity)
              .ceil(), // e.g. 0.2 -> 1 (round up) or 0.5 -> 1 (round up)
          price: productPrice,
        ),
      );
    }
  }
  return eanProducts;
}

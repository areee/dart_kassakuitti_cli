import 'dart:io';
import 'package:html/parser.dart';

import '../../models/ean_product.dart';
import '../../utils/price_helper.dart';

/// Loads the HTML file from assets and parses it. Then, it returns a list of EANProduct objects.
Future<List<EANProduct>> loadHtmlFromAssets(String filePath) async {
  List<EANProduct> eanProducts = [];

  var file = File(filePath);
  var html = await file.readAsString();
  var document = parse(html);

  var allProductsDiv = document.body!.children[1].children[1].children[1]
      .children[0].children[0].children[0].children[5];

  for (var i = 0; i < allProductsDiv.children.length; i++) {
    if (i > 0) {
      var product = allProductsDiv.children[i];

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

      var quantity = double.parse(productQuantity)
          .ceil(); // e.g. 0.2 -> 1 (round up) or 0.5 -> 1 (round up)

      eanProducts.add(
        EANProduct(
          eanCode: eanCode,
          name: productName,
          quantity: quantity,
          totalPrice: productPrice,
          pricePerUnit: countPricePerUnit(productPrice, quantity),
        ),
      );
    }
  }
  return eanProducts;
}

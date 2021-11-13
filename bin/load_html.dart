import 'dart:io';
import 'package:html/parser.dart';

/// Loads the HTML file from assets and parses it.
void loadHtmlFromAssets() async {
  var file = File('assets/files/orderedProducts.html');
  var html = await file.readAsString();
  var document = parse(html);

  // print(document.outerHtml);

  var responseString = document.getElementsByClassName(
      'styled-order-page__StyledOrderItemContainer-sc-qzridm-1')[0];

  var children = responseString.children;

  for (var i = 0; i < responseString.children.length; i++) {
    if (i > 0) {
      var attributes = children[i].attributes;
      print(attributes['data-product-id']);
    }
  }
}

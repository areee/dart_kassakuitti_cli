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

  var listOfSubstitutedElements =
      document.getElementsByClassName('old-order-substituted-products-list');

  // If list of substituted elements is empty, skip this section.
  if (listOfSubstitutedElements.isNotEmpty) {
    var substitutedProducts = listOfSubstitutedElements.first;

    for (var product in substitutedProducts.children) {
      var productInfo = product.children[1].children[0];

      var productEan =
          productInfo.id.replaceAll('department-product-item-', '');

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
      var quantity = double.parse(productQuantity)
          .ceil(); // e.g. 0.2 -> 1 (round up) or 0.5 -> 1 (round up)

      eanProducts.add(EANProduct(
        eanCode: productEan,
        name: productName,
        quantity: quantity,
        totalPrice: productPrice,
        pricePerUnit: countPricePerUnit(productPrice, quantity),
      ));
    }
  }

  var pickedProducts =
      document.getElementsByClassName('old-order-departments')[0];

  for (var department in pickedProducts.children) {
    var itemListing = department.children[1];

    for (var productRow in itemListing.children) {
      var productItem = productRow.children[0];

      var eanCode = productItem.id.replaceAll('department-product-item-', '');

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
      var quantity = double.parse(productQuantity)
          .ceil(); // e.g. 0.2 -> 1 (round up) or 0.5 -> 1 (round up)

      eanProducts.add(EANProduct(
        eanCode: eanCode,
        name: productName,
        quantity: quantity,
        totalPrice: productPrice,
        pricePerUnit: countPricePerUnit(productPrice, quantity),
      ));
    }
  }

  // Get home delivery details

  var orderDetailsSection =
      document.getElementsByClassName('old-order-details')[0];

  var homeDeliveryPriceSection = orderDetailsSection.children[0];
  var homeDeliveryText = homeDeliveryPriceSection.children[0].text;
  var homeDeliveryPrice = homeDeliveryPriceSection.children[1].text;

  eanProducts.add(EANProduct(
    eanCode: '',
    name: homeDeliveryText,
    quantity: 1,
    totalPrice: homeDeliveryPrice,
    pricePerUnit: '',
  ));

  // Get packaging material costs

  var packagingMaterialTexts = orderDetailsSection.children[1].children[0].text;

  // Get packaging material term:
  var packagingMaterialTerm = packagingMaterialTexts
      .substring(0, packagingMaterialTexts.indexOf(':'))
      .trim();

  /**
   * Get packaging material price.
   * - Start where the price starts, e.g. 0,75
   * - End before unit (euros per box)
   */
  var packagingMaterialPrice = packagingMaterialTexts
      .substring(packagingMaterialTexts.indexOf(RegExp(r'\d+\,\d+')),
          packagingMaterialTexts.indexOf('€/ltk'))
      .trim();

  eanProducts.add(EANProduct(
    eanCode: '',
    name: packagingMaterialTerm,
    quantity: -1,
    totalPrice: '',
    pricePerUnit: packagingMaterialPrice,
    moreDetails:
        'TODO: fill in the amount of packaging material and the total price.',
  ));

  return eanProducts;
}

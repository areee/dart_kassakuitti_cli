/// Count price per unit based on a product price and a quantity.
String countPricePerUnit(String productPrice, int quantity) {
  var productPriceAsDouble =
      double.parse(productPrice.replaceAll(RegExp(r','), '.'));
  var pricePerUnit = productPriceAsDouble / quantity;

  return pricePerUnit.toStringAsFixed(2).replaceAll(RegExp(r'\.'), ',');
}

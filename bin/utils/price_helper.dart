/// Count price per unit based on a product price and a quantity.
String countPricePerUnit(String productPrice, int quantity) {
  // In case the product price is empty (e.g. the last rows), return an empty string.
  if (productPrice.isEmpty) {
    return '';
  }

  // In case the quantity is 1, return an empty string (produces a cleaner CSV file).
  if (quantity == 1) {
    return '';
  }

  var productPriceAsDouble =
      double.parse(productPrice.replaceAll(RegExp(r','), '.'));
  var pricePerUnit = productPriceAsDouble / quantity;

  return pricePerUnit.toStringAsFixed(2).replaceAll(RegExp(r'\.'), ',');
}

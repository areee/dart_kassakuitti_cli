import '../../utils/extensions/double_extension.dart';
import '../../utils/line_helper.dart';
import '../../models/receipt_product.dart';

/// Goes through the list of lines and returns a list of products.
List<ReceiptProduct> strings2ReceiptProducts(List<String> lines) {
  var helper = LineHelper();
  List<ReceiptProduct> products = [];

  for (var item in lines) {
    item = item.trim();
    item = item.toLowerCase();

    // Do not handle sum lines (after a row of strokes):
    if (item.contains('----------')) {
      break;
    }
    // Refund line:
    else if (item.contains('palautus')) {
      helper.previousLine = PreviousLine.refund;
    }
    // When previous line was a refund line, skip next two lines:
    else if (helper.previousLine == PreviousLine.refund) {
      if (helper.calcLines != 1) {
        helper.calcLines++;
      } else {
        helper.calcLines = 0;
        helper.previousLine = PreviousLine.notSet;
      }
    }
    // A discount line:
    else if (item.contains('alennus')) {
      var items = item.split(RegExp(r'\s{12,33}'));
      var discountPrice =
          items[1].replaceAll(RegExp(r'\-'), '').replaceAll(RegExp(r','), '.');
      var discountPriceAsDouble = double.parse(discountPrice);

      var lastProduct = products.last;
      var origTotalPrice = lastProduct.totalPrice.replaceAll(RegExp(r','), '.');
      var origTotalPriceAsDouble = double.parse(origTotalPrice);

      var discountedPrice =
          (origTotalPriceAsDouble - discountPriceAsDouble).toPrecision(2);
      var discountedPriceAsString =
          discountedPrice.toStringAsFixed(2).replaceAll(RegExp(r'\.'), ',');

      if (lastProduct.quantity > 1) {
        var discountedPricePerUnit = (discountedPrice / lastProduct.quantity)
            .toPrecision(2)
            .toString()
            .replaceAll(RegExp(r'\.'), ',');

        lastProduct.pricePerUnit = discountedPricePerUnit;
      }
      lastProduct.totalPrice = discountedPriceAsString;
      lastProduct.discountCounted = 'yes';
    }
    // If a line starts with a digit, it is a quantity and price per unit row:
    else if (item.contains(RegExp(r'^\d'))) {
      var items = item.split(RegExp(r'\s{6,7}'));
      var quantity =
          items[0].substring(0, 2).trim().replaceAll(RegExp(r','), '.');
      var pricePerUnit = items[1].substring(0, 5).trim();

      var lastProduct = products.last;
      lastProduct.quantity = double.parse(quantity)
          .ceil(); // e.g. 0.2 -> 1 (round up) or 0.5 -> 1 (round up)
      lastProduct.pricePerUnit = pricePerUnit;
    }

    // A "normal" line:
    else {
      var items = item.split(RegExp(r'\s{11,33}'));

      var name = items[0];
      var price = items[1];

      var product = ReceiptProduct(name: name, totalPrice: price);
      products.add(product);
    }
  }
  return products;
}
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;

import 'models/ean_product.dart';
import 'utils/date_helper.dart';
import 'utils/home_directory_helper.dart';
import 'utils/extensions/sheet_extension.dart';

/// Saves EAN products as an Excel (xlsx) file.
void eanProducts2Excel(
    List<EANProduct> products, String exportFilePath, String shopSelector) {
  var excel = Excel.createExcel();
  var sheetObject = excel.sheets[excel.getDefaultSheet()];

  // Write the header.
  var headerDataList = [
    "Name",
    "Quantity",
    "Price per unit",
    "Total price",
    "EAN code",
    "More details"
  ];
  sheetObject?.insertRowIterables(headerDataList, 0);
  sheetObject?.updateSelectedRowStyle(0, CellStyle(bold: true));

  // Write the products.
  for (var product in products) {
    var productDataList = [
      product.name,
      product.quantity,
      product.pricePerUnit,
      product.totalPrice,
      product.eanCode,
      product.moreDetails
    ];
    sheetObject?.insertRowIterables(
        productDataList, products.indexOf(product) + 1);

    // If the product is a fruit or vegetable, change the background color to green.
    if (product.eanCode.startsWith("2") || product.eanCode.startsWith("02")) {
      sheetObject?.updateSelectedRowStyle(products.indexOf(product) + 1,
          CellStyle(backgroundColorHex: "#1AFF1A"));
    }
    // If the product is a packaging material,
    // change the font color to red and the background color to green.
    if (product.name == 'Pakkausmateriaalikustannukset') {
      sheetObject?.updateSelectedRowStyle(products.indexOf(product) + 1,
          CellStyle(fontColorHex: "#FF0000", backgroundColorHex: "#1AFF1A"));
    }

    // If the product is a home delivery, change the background color to green.
    if (product.name == 'Kotiinkuljetus') {
      sheetObject?.updateSelectedRowStyle(products.indexOf(product) + 1,
          CellStyle(backgroundColorHex: "#1AFF1A"));
    }
  }

  // Save to the Excel (xlsx) file:
  var fileBytes = excel.save();

  File(p.join(replaceTildeWithHomeDirectory(exportFilePath),
      '${shopSelector}_ean_products_${formattedDateTime()}.xlsx'))
    ..createSync(recursive: true)
    ..writeAsBytesSync(fileBytes!);
}

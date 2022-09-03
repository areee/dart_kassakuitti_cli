import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;

import 'models/ean_product.dart';
import 'utils/date_helper.dart';
import 'utils/home_directory_helper.dart';

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
  CellStyle headerStyle = CellStyle(bold: true);
  sheetObject?.insertRowIterables(headerDataList, 0);

  // Change the header style to bold.
  var rowDatas = sheetObject?.row(0);
  for (var rowData in rowDatas!) {
    sheetObject?.updateCell(rowData!.cellIndex, rowData.value,
        cellStyle: headerStyle);
  }

  // Write the products.
  CellStyle fruitVegetableStyle = CellStyle(backgroundColorHex: "#1AFF1A");
  CellStyle packagingMaterialStyle = CellStyle(fontColorHex: "#FF0000");

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
      var rowDatas = sheetObject?.row(products.indexOf(product) + 1);

      for (var rowData in rowDatas!) {
        sheetObject?.updateCell(rowData!.cellIndex, rowData.value,
            cellStyle: fruitVegetableStyle);
      }
    }

    // If the product is a packaging material, change the font color to red.
    if (product.quantity == -1) {
      var rowDatas = sheetObject?.row(products.indexOf(product) + 1);

      for (var rowData in rowDatas!) {
        sheetObject?.updateCell(rowData!.cellIndex, rowData.value,
            cellStyle: packagingMaterialStyle);
      }
    }
  }

  // Save to the Excel (xlsx) file:
  var fileBytes = excel.save();

  File(p.join(replaceTildeWithHomeDirectory(exportFilePath),
      '${shopSelector}_ean_products_${formattedDateTime()}.xlsx'))
    ..createSync(recursive: true)
    ..writeAsBytesSync(fileBytes!);
}

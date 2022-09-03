import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;

import '../../models/receipt_product.dart';
import '../../utils/date_helper.dart';
import '../../utils/home_directory_helper.dart';

/// Saves receipt products as an Excel (xlsx) file.
void receiptProducts2Excel(
    List<ReceiptProduct> products, String exportFilePath) {
  var excel = Excel.createExcel();
  var sheetObject = excel.sheets[excel.getDefaultSheet()];

  // Write the header.
  var headerDataList = [
    "Name",
    "Quantity",
    "Price per unit",
    "Total price",
    "EAN code"
  ];
  var discountCounted = false;
  CellStyle headerStyle = CellStyle(bold: true);

  // If there aren't any discountCounted products, don't add it to the Excel file.
  if (products.every((product) => product.discountCounted.isEmpty)) {
    sheetObject?.insertRowIterables(headerDataList, 0);

    // Change the header style to bold.
    var rowDatas = sheetObject?.row(0);
    for (var rowData in rowDatas!) {
      sheetObject?.updateCell(rowData!.cellIndex, rowData.value,
          cellStyle: headerStyle);
    }
  } else {
    discountCounted = true;
    headerDataList.add("Discount counted");
    sheetObject?.insertRowIterables(headerDataList, 0);

    // Change the header style to bold.
    var rowDatas = sheetObject?.row(0);
    for (var rowData in rowDatas!) {
      sheetObject?.updateCell(rowData!.cellIndex, rowData.value,
          cellStyle: headerStyle);
    }
  }

  // Write the products.
  CellStyle fruitVegetableStyle = CellStyle(backgroundColorHex: "#1AFF1A");

  for (var product in products) {
    var productDataList = [
      product.name,
      product.quantity,
      product.pricePerUnit,
      product.totalPrice,
      product.eanCode
    ];

    if (discountCounted) {
      productDataList.add(product.discountCounted);
    }

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
  }

  // Save to the Excel (xlsx) file:
  var fileBytes = excel.save();

  File(p.join(replaceTildeWithHomeDirectory(exportFilePath),
      'receipt_products_${formattedDateTime()}.xlsx'))
    ..createSync(recursive: true)
    ..writeAsBytesSync(fileBytes!);
}

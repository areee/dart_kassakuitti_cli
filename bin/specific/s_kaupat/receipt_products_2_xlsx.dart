import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;

import '../../models/receipt_product.dart';
import '../../utils/date_helper.dart';
import '../../utils/home_directory_helper.dart';
import '../../utils/extensions/sheet_extension.dart';

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

  // If there aren't any discountCounted products, don't add it to the Excel file.
  if (products.every((product) => product.discountCounted.isEmpty)) {
    sheetObject?.insertRowIterables(headerDataList, 0);
    sheetObject?.updateSelectedRowStyle(0, CellStyle(bold: true));
  } else {
    discountCounted = true;
    headerDataList.add("Discount counted");
    sheetObject?.insertRowIterables(headerDataList, 0);
    sheetObject?.updateSelectedRowStyle(0, CellStyle(bold: true));
  }

  // Write the products.
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
      sheetObject?.updateSelectedRowStyle(products.indexOf(product) + 1,
          CellStyle(backgroundColorHex: "#1AFF1A"));
    }
  }

  // Save to the Excel (xlsx) file:
  var fileBytes = excel.save();

  File(p.join(replaceTildeWithHomeDirectory(exportFilePath),
      'receipt_products_${formattedDateTime()}.xlsx'))
    ..createSync(recursive: true)
    ..writeAsBytesSync(fileBytes!);
}

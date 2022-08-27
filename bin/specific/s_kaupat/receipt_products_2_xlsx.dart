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

  /*
    Write the header.
    If there aren't any discountCounted products, don't add it to the Excel file.
  */
  List<String> dataList = [
    "Name",
    "Quantity",
    "Price per unit",
    "Total price",
    "EAN code"
  ];
  var discountCounted = false;

  if (products.every((product) => product.discountCounted.isEmpty)) {
    sheetObject?.insertRowIterables(dataList, 0);
  } else {
    discountCounted = true;
    dataList.add("Discount counted");
    sheetObject?.insertRowIterables(dataList, 0);
  }

  /*
    Write the products.
  */
  for (var product in products) {
    List<dynamic> dataList = [
      product.name,
      product.quantity,
      product.pricePerUnit,
      product.totalPrice,
      product.eanCode
    ];

    if (discountCounted) {
      dataList.add(product.discountCounted);
    }

    sheetObject?.insertRowIterables(dataList, products.indexOf(product) + 1);
  }

  // Save to the Excel (xlsx) file:
  var fileBytes = excel.save();

  File(p.join(replaceTildeWithHomeDirectory(exportFilePath),
      'receipt_products_${formattedDateTime()}.xlsx'))
    ..createSync(recursive: true)
    ..writeAsBytesSync(fileBytes!);
}

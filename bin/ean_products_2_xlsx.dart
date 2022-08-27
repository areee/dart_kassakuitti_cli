import 'dart:io';

import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;

import 'models/ean_product.dart';
import 'utils/date_helper.dart';
import 'utils/home_directory_helper.dart';

void eanProducts2Excel(List<EANProduct> eanProductList, String exportFilePath,
    String shopSelector) {
  var excel = Excel.createExcel();
  var sheetObject = excel.sheets[excel.getDefaultSheet()];
  var header = [
    "Name",
    "Quantity",
    "Price per unit",
    "Total price",
    "EAN code",
    "More details"
  ];
  sheetObject?.insertRowIterables(header, 0);
  for (var item in eanProductList) {
    var dataList = [
      item.name,
      item.quantity,
      item.pricePerUnit,
      item.totalPrice,
      item.ean,
      item.moreDetails
    ];
    sheetObject?.insertRowIterables(dataList, eanProductList.indexOf(item) + 1);
  }

  // Save to the Excel (xlsx) file:
  var fileBytes = excel.save();

  File(p.join(replaceTildeWithHomeDirectory(exportFilePath),
      '${shopSelector}_ean_products_${formattedDateTime()}.xlsx'))
    ..createSync(recursive: true)
    ..writeAsBytesSync(fileBytes!);
}

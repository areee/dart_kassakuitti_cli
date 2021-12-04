import 'read_html_and_save_as_csv.dart';
import 'read_receipt_and_save_as_csv.dart';
import 'shop_selector_helper.dart';

void main(List<String> arguments) {
  const shopSelector =
      ShopSelector.kRuoka; // TODO: make this a command line argument

  if (shopSelector == ShopSelector.sKaupat) {
    readReceiptAndSaveAsCSV('assets/files/_cashReceipt.txt');
    readHtmlAndSaveAsCSV(
        'assets/files/_orderedProducts_S-kaupat.html', shopSelector);
  } else {
    // K-ruoka
    readHtmlAndSaveAsCSV(
        'assets/files/_orderedProducts_K-ruoka.html', shopSelector);
  }

  print('Done!');
}

import 'ean_product.dart';
import 'load_html_s_kaupat.dart' as s_kaupat;
import 'load_html_k_ruoka.dart' as k_ruoka;
import 'save_eps_as_csv.dart';
import 'shop_selector_helper.dart';

void readHtmlAndSaveAsCSV(String filePath, ShopSelector shopSelector) async {
  List<EANProduct> awaitedEANProductList = [];

  if (shopSelector == ShopSelector.sKaupat) {
    awaitedEANProductList = await s_kaupat.loadHtmlFromAssets(filePath);
  } else {
    // K-ruoka
    awaitedEANProductList = await k_ruoka.loadHtmlFromAssets(filePath);
  }

  eanProductListToCSV(awaitedEANProductList);
}

import 'ean_product.dart';
import 'load_html_s_kaupat.dart' as s_kaupat;
import 'load_html_k_ruoka.dart' as k_ruoka;
import 'save_eps_as_csv.dart';
import 'shop_selector_helper.dart';

void readHtmlAndSaveAsCSV(String filePath, ShopSelector shopSelector) async {
  List<EANProduct> awaitedEANProductList = [];

  switch (shopSelector) {
    case ShopSelector.sKaupat:
      awaitedEANProductList = await s_kaupat.loadHtmlFromAssets(filePath);
      break;
    case ShopSelector.kRuoka:
      awaitedEANProductList = await k_ruoka.loadHtmlFromAssets(filePath);
      break;
  }

  eanProductListToCSV(awaitedEANProductList);
}

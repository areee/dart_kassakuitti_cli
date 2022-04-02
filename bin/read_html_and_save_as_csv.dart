import 'models/ean_product.dart';
import 'specific/s_kaupat/load_html_s_kaupat.dart' as s_kaupat;
import 'specific/k_ruoka/load_html_k_ruoka.dart' as k_ruoka;
import 'save_eps_as_csv.dart';
import 'utils/shop_selector_helper.dart';

void readHtmlAndSaveAsCSV(
    String filePath, ShopSelector shopSelector, String csvFilePath) async {
  List<EANProduct> awaitedEANProductList = [];

  switch (shopSelector) {
    case ShopSelector.sKaupat:
      awaitedEANProductList = await s_kaupat.loadHtmlFromAssets(filePath);
      break;
    case ShopSelector.kRuoka:
      awaitedEANProductList = await k_ruoka.loadHtmlFromAssets(filePath);
      break;
  }

  eanProductListToCSV(awaitedEANProductList, csvFilePath, shopSelector);
}

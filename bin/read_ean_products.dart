import 'models/ean_product.dart';
import 'specific/s_kaupat/load_html_s_kaupat.dart' as s_kaupat;
import 'specific/k_ruoka/load_html_k_ruoka.dart' as k_ruoka;
import 'utils/shop_selector_helper.dart';

Future<List<EANProduct>> readEANProducts(
    String filePath, ShopSelector shopSelector) async {
  switch (shopSelector) {
    case ShopSelector.sKaupat:
      return await s_kaupat.loadHtmlFromAssets(filePath);
    case ShopSelector.kRuoka:
      return await k_ruoka.loadHtmlFromAssets(filePath);
  }
}

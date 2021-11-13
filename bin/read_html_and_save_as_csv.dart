import 'load_html.dart';
import 'save_eps_as_csv.dart';

void readHtmlAndSaveAsCSV(String filePath) async {
  var awaitedEANProductList = await loadHtmlFromAssets(filePath);

  eanProductListToCSV(awaitedEANProductList);
}

/// ArgSelector (textFile, htmlFile, foodOnlineStore, csvPath, help)
enum ArgSelector {
  textFile,
  htmlFile,
  foodOnlineStore,
  csvPath,
  help,
}

extension ArgSelectorExtension on ArgSelector {
  static const values = {
    ArgSelector.textFile: 'text',
    ArgSelector.htmlFile: 'html',
    ArgSelector.foodOnlineStore: 'store',
    ArgSelector.csvPath: 'csv',
    ArgSelector.help: 'help',
  };

  String? get value => values[this];

  bool isEqual(dynamic value) {
    if (value is String) {
      return toString() == value || this.value == value;
    } else {
      return false;
    }
  }
}

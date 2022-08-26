/// ArgSelector (textFile, htmlFile, foodOnlineStore, 
/// exportPath, exportFormat, help, run, hive)
enum ArgSelector {
  textFile('text'),
  htmlFile('html'),
  foodOnlineStore('store'),
  exportPath('path'),
  exportFormat('format'),
  help('help'),
  run('run'),
  hive('hive');

  final String term;
  const ArgSelector(this.term);

  String get value => term;
}

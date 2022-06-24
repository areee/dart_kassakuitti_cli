/// ArgSelector (textFile, htmlFile, foodOnlineStore, csvPath, help, run)
enum ArgSelector {
  textFile('text'),
  htmlFile('html'),
  foodOnlineStore('store'),
  csvPath('csv'),
  help('help'),
  run('run'),
  hive('hive');

  final String term;
  const ArgSelector(this.term);

  String get value => term;
}

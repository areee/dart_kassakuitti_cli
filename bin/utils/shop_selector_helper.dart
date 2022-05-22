/// Shop selector (sKaupat, kRuoka)
enum ShopSelector {
  sKaupat('S-kaupat'),
  kRuoka('K-ruoka');

  final String term;
  const ShopSelector(this.term);

  String get value => term;
}
